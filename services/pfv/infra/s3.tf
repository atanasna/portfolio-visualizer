resource "aws_s3_bucket" "pfv" {
    bucket = "${var.prefix}-hosting"
    acl    = "public-read"
    #policy = file("policy.json")

    website {
        index_document = "index.html"
        error_document = "error.html"
    }
    #cors_rule {
    #    allowed_headers = ["*"]
    #    allowed_methods = ["PUT", "POST", "GET"]
    #    allowed_origins = ["*"]
    #    expose_headers  = ["ETag"]
    #    max_age_seconds = 3000
    #}
}

resource "aws_s3_bucket_object" "web_index" {
    key                    = "index.html"
    bucket                 = aws_s3_bucket.pfv.id
    source                 = "../src/index.html"
    server_side_encryption = "AES256"
    acl = "public-read"
    content_type = "text/html"
    etag = filemd5("../src/index.html")
}

# CSS
resource "aws_s3_bucket_object" "css_bootstrap" {
    key                    = "/styles/bootstrap.min.css"
    bucket                 = aws_s3_bucket.pfv.id
    source                 = "../src/styles/bootstrap.min.css"
    server_side_encryption = "AES256"
    acl = "public-read"
    content_type = "text/css"
    etag = filemd5("../src/styles/bootstrap.min.css")
}
resource "aws_s3_bucket_object" "css_cover" {
    key                    = "/styles/cover.css"
    bucket                 = aws_s3_bucket.pfv.id
    source                 = "../src/styles/cover.css"
    server_side_encryption = "AES256"
    acl = "public-read"
    content_type = "text/css"
    etag = filemd5("../src/styles/cover.css")
}
resource "aws_s3_bucket_object" "css_loader" {
    key                    = "/styles/loader.css"
    bucket                 = aws_s3_bucket.pfv.id
    source                 = "../src/styles/loader.css"
    server_side_encryption = "AES256"
    acl = "public-read"
    content_type = "text/css"
    etag = filemd5("../src/styles/loader.css")
}

# Javascript Objects
resource "aws_s3_bucket_object" "js_main" {
    key                    = "/js/main.js"
    bucket                 = aws_s3_bucket.pfv.id
    source                 = "../src/js/main.js"
    server_side_encryption = "AES256"
    acl = "public-read"
    content_type = "application/javascript"
    etag = filemd5("../src/js/main.js")
}
resource "aws_s3_bucket_object" "js_bootstrap" {
    key                    = "/js/bootstrap.utils.js"
    bucket                 = aws_s3_bucket.pfv.id
    source                 = "../src/js/bootstrap.utils.js"
    server_side_encryption = "AES256"
    acl = "public-read"
    content_type = "application/javascript"
    etag = filemd5("../src/js/bootstrap.utils.js")
}

#Image Objects
resource "aws_s3_bucket_object" "image_loading" {
    key                    = "/resources/loading.gif"
    bucket                 = aws_s3_bucket.pfv.id
    source                 = "../src/resources/loading.gif"
    server_side_encryption = "AES256"
    acl = "public-read"
    content_type = "image/gif"
    etag = filemd5("../src/resources/loading.gif")
}
