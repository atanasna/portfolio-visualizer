data "terraform_remote_state" "shared" {
    backend = "local"

    config = {
        path = "../../shared/infra/terraform.tfstate"
    }
}