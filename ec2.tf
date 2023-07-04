
resource "aws_instance" "Krishna" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = var.instance-type
  subnet_id = aws_subnet.subnet01.id
  key_name  = var.instance-key-name

  tags = {
    Name = "Ram"
  }
}