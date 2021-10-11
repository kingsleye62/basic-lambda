provider "aws" {
  region = var.provider_region
}

provider "aws" {
  alias  = "east_region_2"
  region = "us-east-2"
}

output "test_values" {
  value = "${var.folder_name}/${var.state_name}"
}
