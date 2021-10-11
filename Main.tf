provider "aws" {
  region = var.provider_region
  assume_role {
    role_arn = "arn:aws:iam::409592171686:role/EC2-Admin"
  }
}

provider "aws" {
  alias  = "east_region_2"
  region = "us-east-2"
}

output "test_values" {
  value = "${var.folder_name}/${var.state_name}"
}
