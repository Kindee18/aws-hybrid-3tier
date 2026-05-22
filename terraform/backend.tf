# --- PRODUCTION-READY REMOTE BACKEND ---
# To enable, create the S3 bucket and DynamoDB table first,
# then uncomment this block and run 'terraform init'.

/*
terraform {
  backend "s3" {
    bucket         = "kindson-terraform-state-us-east-1" # Replace with your bucket
    key            = "hybrid-3tier/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"             # Enables State Locking
  }
}
*/

# For this portfolio demonstration, we use local state for simplicity/cost safety.
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
