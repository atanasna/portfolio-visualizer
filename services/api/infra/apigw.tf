resource "aws_api_gateway_rest_api" "api" {
    name = "${var.prefix}_api"
    endpoint_configuration {
        types = ["REGIONAL"]
    }
}

resource "aws_api_gateway_resource" "v1" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    parent_id   = aws_api_gateway_rest_api.api.root_resource_id
    path_part   = "v1"
}

# Http Method
resource "aws_api_gateway_request_validator" "validator" {
    name                        = "validator"
    rest_api_id                 = aws_api_gateway_rest_api.api.id
    validate_request_body       = true
    validate_request_parameters = true
}

resource "aws_api_gateway_method" "get_portfolio" {
    rest_api_id   = aws_api_gateway_rest_api.api.id
    resource_id   = aws_api_gateway_resource.v1.id
    http_method   = "GET"
    authorization = "NONE"
    request_validator_id = aws_api_gateway_request_validator.validator.id

    request_parameters = {
        "method.request.querystring.name" = true
    }
}
resource "aws_api_gateway_method_response" "response_200" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_resource.v1.id
    http_method = aws_api_gateway_method.get_portfolio.http_method
    status_code = "200"
    response_models = {
        "application/json" = "Empty"
    }
    response_parameters = { 
        "method.response.header.Access-Control-Allow-Headers" = true,
        "method.response.header.Access-Control-Allow-Methods" = true,
        "method.response.header.Access-Control-Allow-Origin" = true,
    }
}

# Integration
data "template_file" "integration_request" {
  template = file("./templates/integration_request.txt")
}

resource "aws_api_gateway_integration" "attach_get_lambda" {
    rest_api_id             = aws_api_gateway_rest_api.api.id
    resource_id             = aws_api_gateway_resource.v1.id
    http_method             = aws_api_gateway_method.get_portfolio.http_method
    integration_http_method = "POST"
    type                    = "AWS"
    uri                     = aws_lambda_function.api.invoke_arn
    request_templates       = {
        "application/json" = data.template_file.integration_request.rendered
    }
}
    
    
resource "aws_api_gateway_integration_response" "api_integration_response" {
    depends_on  = [aws_api_gateway_integration.attach_get_lambda]

    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_resource.v1.id
    http_method = aws_api_gateway_method.get_portfolio.http_method
    status_code = aws_api_gateway_method_response.response_200.status_code

    # Transforms the backend JSON response to XML
    response_templates = {
        "application/json" = ""
    }
    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
        "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST,GET'"
        "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    }
}

# Deployment
resource "aws_api_gateway_deployment" "prod" {
  depends_on  = [aws_api_gateway_integration.attach_get_lambda]
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_stage" "prod" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.prod.id
}

resource "aws_lambda_permission" "allow_apigateway_to_call_check_foo" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api.function_name
  principal     = "apigateway.amazonaws.com"

  #source_arn    = "arn:aws:execute-api:us-east-2:415099068017:siigphtt5m/prod/GET/v1" 
  source_arn    = "${aws_api_gateway_stage.prod.execution_arn}/${aws_api_gateway_method.get_portfolio.http_method}/${aws_api_gateway_resource.v1.path_part}"

}