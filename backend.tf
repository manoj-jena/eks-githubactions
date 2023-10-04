terraform {
  backend "s3" {
    bucket         = "s3-manoj2"
    dynamodb_table = "terraform-db-table"
    key            = "terraform-eks-asset.tfstate"
    region         = "eu-central-1"
    encrypt        = true
   
  }
}
