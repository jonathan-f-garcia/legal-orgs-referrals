// This block tells Terraform that we're going to provision AWS resources.
provider "aws" {
  region = "us-east-1"
  version = "~> 2.18"
}

// Create a variable for our version and domain name because we'll be using it a lot.
variable "app_version" {
}

variable "domain_name" {
}

// Define the DynamoDB table that will store all of the clinic metadata
resource "aws_dynamodb_table" "jpfg" {
  // Tag our project for cost-allocation purposes
  tags = {
    Project = "${var.domain_name}"
    Version = "${var.app_version}"
    Environment = "Development"
  }

  name = "${var.domain_name}.${var.app_version}.clinics-table"
  billing_mode = "PROVISIONED"
  read_capacity = 15  // TODO: what's a good value here?
  write_capacity = 15 // TODO: what's a good value here?
  hash_key = "ClinicId"
  range_key = "IncomeCutoff"

  attribute {
    name = "ClinicId"
    type = "S"
  }

  attribute {
    name = "IncomeCutoff"
    type = "N"
  }
}