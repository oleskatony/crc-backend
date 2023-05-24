provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_function" "visitor_counter_lambda" {
  filename      = "visitor_counter_lambda.zip"
  function_name = "visitor_counter_lambda"
  role          = var.iam_role_arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  timeout       = 5
  memory_size   = 128

  source_code_hash = filebase64sha256("visitor_counter_lambda.zip")

  environment {
    variables = {
      dynamodb_table_name = aws_dynamodb_table.visitor_counter.name
    }
  }
}

output "visitor_counter_lambda" {
  value = module.lambda_function.visitor_counter_lambda
}

output "visitor_counter_table" {
  value = module.lambda_function.dynamodb_table_name
}
