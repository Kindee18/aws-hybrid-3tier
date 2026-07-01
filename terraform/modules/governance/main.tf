# --- IAM Role for Lambda Remediation ---
resource "aws_iam_role" "remediation" {
  name = "${var.project_name}-remediation-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  tags = var.common_tags
}

resource "aws_iam_role_policy" "remediation" {
  name = "${var.project_name}-remediation-policy"
  role = aws_iam_role.remediation.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:RevokeSecurityGroupIngress",
          "ec2:DescribeSecurityGroups"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# --- Lambda Function (The Auditor) ---
data "archive_file" "remediator" {
  type        = "zip"
  output_path = "${path.module}/remediator.zip"
  source {
    content  = <<-EOF
import boto3
import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    ec2 = boto3.client('ec2')
    
    try:
        # 1. Parse violation details
        detail = event.get('detail', {})
        sg_id = detail.get('resourceId')
        
        if not sg_id:
            logger.error("Event received without resourceId. Event: " + json.dumps(event))
            return

        logger.info(f"AUDIT TRIGGERED: Violation detected in Security Group: {sg_id}")
        
        # 2. Remediation: Forcefully remove SSH (Port 22) if opened to 0.0.0.0/0
        response = ec2.revoke_security_group_ingress(
            GroupId=sg_id,
            IpPermissions=[
                {
                    'IpProtocol': 'tcp',
                    'FromPort': 22,
                    'ToPort': 22,
                    'IpRanges': [{'CidrIp': '0.0.0.0/0'}]
                }
            ]
        )
        
        logger.info(f"SUCCESS: Remediated {sg_id}. Closed Port 22 to the world. Response: " + str(response))
        
    except ec2.exceptions.ClientError as e:
        if e.response['Error']['Code'] == 'InvalidPermission.NotFound':
            logger.warning(f"Rule already removed or not found in {sg_id}.")
        else:
            logger.error(f"AWS API ERROR during remediation of {sg_id}: {str(e)}")
            raise e
    except Exception as e:
        logger.error(f"UNEXPECTED ERROR during remediation: {str(e)}")
        raise e
EOF
    filename = "index.py"
  }
}

resource "aws_lambda_function" "remediator" {
  filename         = data.archive_file.remediator.output_path
  function_name    = "${var.project_name}-sg-remediator"
  role             = aws_iam_role.remediation.arn
  handler          = "index.handler"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.remediator.output_base64sha256

  tags = var.common_tags
}

# --- AWS Config Rule: Restricted Ports ---
resource "aws_config_config_rule" "restricted_common_ports" {
  name = "${var.project_name}-restricted-ssh"

  source {
    owner             = "AWS"
    source_identifier = "RESTRICTED_INCOMING_TRAFFIC"
  }

  input_parameters = jsonencode({
    blockedPort1 = "22"
  })

  tags = var.common_tags
}

# --- AWS Config Rule: Tagging Enforcement ---
resource "aws_config_config_rule" "required_tags" {
  name = "${var.project_name}-required-tags"

  source {
    owner             = "AWS"
    source_identifier = "REQUIRED_TAGS"
  }

  input_parameters = jsonencode({
    tag1Key = "Project"
    tag2Key = "Environment"
    tag3Key = "Owner"
  })

  tags = var.common_tags
}

# --- EventBridge Rule (Triggers Lambda when Config finds a violation) ---
resource "aws_cloudwatch_event_rule" "config_violation" {
  name        = "${var.project_name}-config-violation"
  description = "Trigger Lambda on AWS Config compliance changes"

  event_pattern = jsonencode({
    source      = ["aws.config"]
    detail-type = ["Config Rules Compliance Change"]
    detail = {
      messageType       = ["ComplianceChangeNotification"]
      configRuleName    = [aws_config_config_rule.restricted_common_ports.name]
      newComplianceType = ["NON_COMPLIANT"]
    }
  })

  tags = var.common_tags
}

resource "aws_cloudwatch_event_target" "remediate" {
  rule      = aws_cloudwatch_event_rule.config_violation.name
  target_id = "RemediateSG"
  arn       = aws_lambda_function.remediator.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.remediator.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.config_violation.arn
}
