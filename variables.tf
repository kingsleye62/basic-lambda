variable "state_bucket" {
  type = string
  description = "this will hold the buck name"
}

variable "folder_name" {
  type = string
  description = " this will hold the folder name"
}

variable "state_name" {
  type = string
  description = "this will hold the state file name"
}

variable "state_region" {
  type = string
  description = "this will hold the regoin name"
}

variable "provider_region" {
  type = string
  description = "This will hold the provider default region"
}

variable "bucket_state_acl" {
  type = string
  description = "this will hold the bucket acl"
  default = "private"
}

variable "terraform_state" {
  type = string
  description = "this will hold the dynamodb table name"
}
