resource "aws_lambda_function" "notification" {
  filename = "lambda.zip" # placeholder
  function_name = "${var.environment}-notification"
  handler = "lambda.handler"
  runtime = "python3.12"
  role = "arn:aws:iam::123:role/lambda-role" # placeholder
}
