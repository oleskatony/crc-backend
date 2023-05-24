provider "aws" {
  region = "us-east-1"
}

module "iam_role" {
  source = "./iam-role"
}

resource "aws_dynamodb_table" "visitor_counter" {
  name         = "VisitorCounter"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "visit_counter"
  attribute {
    name = "visit_counter"
    type = "S"
  }
}

resource "aws_lambda_function" "visitor_lambda" {
  function_name    = "VisitorLambda"
  handler          = "main.lambda_handler"
  runtime          = "python3.8"
  role             = module.iam_role.iam_role_arn
  filename         = "${path.module}/custom_lambda/visitor_counter_lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/custom_lambda/visitor_counter_lambda.zip")

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.visitor_counter.name
    }
  }
}

resource "aws_lambda_permission" "s3_permission" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.visitor_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::awsresumebucket"
}


resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = "VisitorCounterAPI"
  description = "API Gateway for Visitor Counter"
}

resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "visitors"
}

resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.api_resource.id
  http_method             = aws_api_gateway_method.api_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.visitor_lambda.invoke_arn
}


resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name  = "prod"
}
