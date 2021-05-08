resource "aws_dynamodb_table" "app_store" {
    name           = local.dynamodb_table
    billing_mode   = "PAY_PER_REQUEST"
    hash_key       = "time"
    range_key      = "ticker"

    attribute {
        name = "time"
        type = "N"
    }

    attribute {
        name = "ticker"
        type = "S"
    }
    
    tags = {
        Name        = local.dynamodb_table
        Environment = "production"
    }

    global_secondary_index {
        name = "TickerIndex"
        hash_key = "ticker"
        range_key = "time"
        projection_type = "ALL" 
    }
}