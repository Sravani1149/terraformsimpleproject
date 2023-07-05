data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230516"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "Krishna" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = var.instance-type
  subnet_id = aws_subnet.subnet01.id
  key_name  = var.instance-key-name

  tags = {
    Name = "Ram"
  }
}