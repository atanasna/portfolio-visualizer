locals {
    lambda_req_zip_location = "/tmp/${var.prefix}_req.zip"
    lambda_fnc_zip_location = "/tmp/${var.prefix}_src.zip"
    lambda_req_name = "${var.prefix}_requirments"
    lambda_fnc_name = var.prefix
    dynamodb_table = var.prefix
}