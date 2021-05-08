data "terraform_remote_state" "shared" {
    backend = "local"

    config = {
        path = "../../shared/infra/terraform.tfstate"
    }
}

data "terraform_remote_state" "api" {
    backend = "local"

    config = {
        path = "../../api/infra/terraform.tfstate"
    }
}