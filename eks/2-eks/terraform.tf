terraform {
  required_version = ">=0.12"

  # Necessario para quando queremos salvar o estado do tf no s3 por seguranca
  backend "s3" {
    bucket = "lxp-terraform-states"
    key    = "rodolfos/dev/learningeks/eks/terraform.tfstate"
    region = "us-east-1"
  }
}
