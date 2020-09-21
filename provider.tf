# provider "aws" {
#     access_key      = "AKIA5FF6D6KJ3YWCMIXI"
#     secret_key      = "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"
#     region          = "ap-southeast-2"
# }

provider "aws" {
    # access_key      = var.AWS_ACCESS_KEY
    # secret_key      = var.AWS_SECRET_KEY
    region          = var.AWS_REGION
}