resource "null_resource" "requirments_zip" {
    triggers = {
        req_sha = filebase64sha256("../src/requirments.txt")
    }
    provisioner "local-exec" {
        
        interpreter = ["/bin/bash" ,"-c"]
        command = <<-EOT
            python3.8 -m venv /tmp/requirments
            source /tmp/requirments/bin/activate
            pip3 install -r ../src/requirments.txt -t /tmp/requirments/python
            cd /tmp/requirments
            zip -r ${local.lambda_req_zip_location} ./python/
            cd - 
        EOT
    }
}

# The null_data_source is a small hack that makes the aws_lambda_layer wait for the src_zip to be created
data "null_data_source" "wait_requirments_zip" {
  inputs = {
    build_id   = null_resource.requirments_zip.id
    zip_dir = local.lambda_req_zip_location
  }
}

resource "aws_lambda_layer_version" "api_req" {
    filename   = data.null_data_source.wait_requirments_zip.outputs.zip_dir
    layer_name = local.lambda_req_name
    compatible_runtimes = ["python3.6"]
    source_code_hash = fileexists(data.null_data_source.wait_requirments_zip.outputs.zip_dir) ? filebase64sha256(data.null_data_source.wait_requirments_zip.outputs.zip_dir) : null
}