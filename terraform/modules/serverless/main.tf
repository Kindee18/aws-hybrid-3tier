data "archive_file" "lambda" {
  type        = "zip"
  output_path = "${path.module}/lambda_function.zip"
  source {
    content  = "def handler(event, context): return {'statusCode': 200, 'body': 'Hello from Lambda!'}"
    filename = "index.py"
  }
}

resource "aws_iam_role" "lambda" {
  name = "${var.project_name}-lambda-role"

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

resource "aws_iam_policy" "lambda_basic" {
  name        = "${var.project_name}-lambda-basic"
  description = "Basic execution policy for Lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
  })

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = aws_iam_policy.lambda_basic.arn
  role       = aws_iam_role.lambda.name
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.project_name}-function"
  retention_in_days = 7
  tags              = var.common_tags
}

resource "aws_lambda_function" "main" {
  filename         = data.archive_file.lambda.output_path
  function_name    = "${var.project_name}-function"
  role             = aws_iam_role.lambda.arn
  handler          = "index.handler"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.lambda.output_base64sha256

  depends_on = [aws_cloudwatch_log_group.lambda]

  tags = var.common_tags
}

resource "aws_apigatewayv2_api" "main" {
  name          = "${var.project_name}-api"
  protocol_type = "HTTP"
  tags          = var.common_tags
}

resource "aws_apigatewayv2_stage" "main" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = "$default"
  auto_deploy = true
  tags        = var.common_tags
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id           = aws_apigatewayv2_api.main.id
  integration_type = "AWS_PROXY"

  integration_uri        = aws_lambda_function.main.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "lambda" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.main.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:${aws_apigatewayv2_api.main.id}/*/*"
}
