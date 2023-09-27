variable "bucket" {
  description = "s3 bucket name"
  type        = string
}

variable "dynamodb_table" {
  description = "dynamodb table "
  type        = string
}
variable "region" {
  description = "The aws region. https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html"
  type        = string
}