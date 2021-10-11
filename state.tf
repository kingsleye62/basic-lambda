//The first part, aws_kms_key, creates the KMS key setting deletion_window_in_days to 10 and turning on key rotation
resource "aws_kms_key" "terraform_bucket_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}


/*The second part, aws_kms_alias, provides an alias for the generated key. 
This alias will later be referenced in the backend resource to come. */
resource "aws_kms_alias" "key_alias" {
  name          = "alias/terraform-bucket-key"
  target_key_id = aws_kms_key.terraform_bucket_key.id
}


/*Create s3 Bucket to hold state and also add KMS encryption
The first resource, aws_s3_bucket, creates the required bucket with a few essential security features. 
We turn versioning on and server-side encryption using the KMS key we generated previously.
The second resource, aws_s3_bucket_policy_access_block, guarantees that the bucket is not publicly accessible.
*/
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.state_bucket
  acl    = var.bucket_state_acl

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.terraform_bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  tags = {
    Name        = "s3-lambda-state-bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "block_s3" {

  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}


//To prevent two team members from writing to the state file at the same time, we will implement a DynamoDB table lock.
resource "aws_dynamodb_table" "terraform_state" {
  name           = var.terraform_state
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
