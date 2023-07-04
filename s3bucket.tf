resource "aws_s3_bucket" "mybucket1" {
  bucket     = var.mybucket1
  depends_on = [aws_vpc.myvpc]

}


resource "aws_s3_bucket" "mybucket2" {
  bucket = var.mybucket2

}