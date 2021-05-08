output "dynamodb_app_table" {
    value = {
        "name" = aws_dynamodb_table.app_store.name
    }
}