resource "null_resource" "src_zip" {
    triggers = {
        src_sha = filebase64sha256("../src/version")
    }
    provisioner "local-exec" {
        interpreter = ["/bin/bash" ,"-c"]
        command = <<-EOT
            cd ../src
            zip -r ${local.lambda_fnc_zip_location} .
            cd - 
        EOT
    }
}

data "null_data_source" "wait_src_zip" {
  inputs = {
    build_id   = null_resource.src_zip.id
    zip_dir = local.lambda_fnc_zip_location
  }
}

resource "aws_lambda_function" "asset_prices_poller" {
    filename      = data.null_data_source.wait_src_zip.outputs.zip_dir
    function_name = local.lambda_fnc_name
    role          = aws_iam_role.app_lambda_iar.arn
    handler       = "main.main"
    source_code_hash = fileexists(data.null_data_source.wait_src_zip.outputs.zip_dir) ? filebase64sha256(data.null_data_source.wait_src_zip.outputs.zip_dir) : null

    runtime = "python3.6"
    timeout = 10
    layers = [
        aws_lambda_layer_version.assets_poller_requirments.arn,
        data.terraform_remote_state.shared.outputs.lambda_layer_shared_arn
    ]
    environment {
        variables = {
            dynamodb_table = local.dynamodb_table
        }
    }
}