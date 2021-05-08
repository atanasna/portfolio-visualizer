resource "null_resource" "shared_zip" {
    triggers = {
        req_sha = filebase64sha256("../src/version")
    }
    provisioner "local-exec" {
        interpreter = ["/bin/bash" ,"-c"]
        command = <<-EOT
            mkdir /tmp/libs
            mkdir /tmp/libs/python
            cp -r ../src/* /tmp/libs/python
            cd /tmp/libs
            zip -r ${local.lambda_shared_zip_location} ./python/
            cd -
            rm -rf /tmp/libs/python
            rm -rf /tmp/libs
        EOT
    }
}

# The null_data_source is a small hack that makes the aws_lambda_layer wait for the src_zip to be created
data "null_data_source" "wait_shared_zip" {
  inputs = {
    build_id   = null_resource.shared_zip.id
    zip_dir = local.lambda_shared_zip_location
  }
}

resource "aws_lambda_layer_version" "pfv_shared" {
    filename   = data.null_data_source.wait_shared_zip.outputs.zip_dir
    layer_name = local.lambda_shared_name
    compatible_runtimes = ["python3.6"]
    source_code_hash = fileexists(data.null_data_source.wait_shared_zip.outputs.zip_dir) ? filebase64sha256(data.null_data_source.wait_shared_zip.outputs.zip_dir) : null
}