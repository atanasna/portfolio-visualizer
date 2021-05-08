data "terraform_remote_state" "shared" {
    backend = "local"

    config = {
        path = "../../shared/infra/terraform.tfstate"
    }
}

data "terraform_remote_state" "app" {
    backend = "local"

    config = {
        path = "../../app/infra/terraform.tfstate"
    }
}