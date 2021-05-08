output "api_url" {
    value = {
        "name" = aws_api_gateway_stage.prod.invoke_url
    }
}