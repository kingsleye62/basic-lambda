data "aws_s3_bucket" "s3_bucket_state" {
  bucket = "king-aws-cicd-pipiline"
}

data "aws_dynamodb_table" "dynamodb_state" {
  name = "terraform-state"
}


terraform {
 backend "s3" {
   bucket         = "king-aws-cicd-pipiline"
   key            = "state/terraform.tfstate"
   region         = "us-east-1"
   encrypt        = true
   kms_key_id     = "alias/terraform-bucket-key"
   dynamodb_table = "terraform-state"
 }
}

output "get_aws_s3_bucket" {
  value = data.aws_s3_bucket.s3_bucket_state.bucket
}

output "get_aws_dynamodb" {
  value = data.aws_dynamodb_table.dynamodb_state.name
}