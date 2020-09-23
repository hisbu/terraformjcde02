# resource "aws_s3_bucket" "mybucket" {
#   bucket = "hisbu-terrabucket"
#   acl    = "private"

#   tags = {
#     Name        = "My bucket"
#     Environment = "Dev"
#   }
# }

# output "Bucket_name" {
#   value = aws_s3_bucket.mybucket.bucket
# }