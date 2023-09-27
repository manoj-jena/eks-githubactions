terraform {
  backend "s3" {
    bucket         = "${var.bucket}"
    dynamodb_table = "${var.dynamodb_table}"
    key            = "terraform-eks-asset.tfstate"
    region         = "${var.region}"
    encrypt        = true
   
  }
}
