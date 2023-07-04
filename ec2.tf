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
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  

  tags = {
    Name = "Ram_Yadav"
  }
}