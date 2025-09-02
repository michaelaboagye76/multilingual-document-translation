
# VPC resource
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "main-vpc" }
}

# internet GW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "main-igw" }
}

# public subnet
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = { Name = "public-subnet-1" }
}

# rout-table setup
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "public-rt" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public_rt.id
}


# security group for the EC2
resource "aws_security_group" "flask_sg" {
  name        = "flask-ec2-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 + user data
resource "aws_instance" "flask_ec2" {
  ami           = "ami-00ca32bbc84273381" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public1.id
  vpc_security_group_ids = [aws_security_group.flask_sg.id]
  key_name      = "keypair1" 

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras enable python3.8
              yum install -y python3.8 python3-pip git
              pip3 install flask boto3 gunicorn
              cd /home/ec2-user
              git clone https://github.com/michaelaboagye76/multilingual-document-translation.git
              cd multilingual-document-translation/flask-app
              nohup gunicorn -w 4 -b 0.0.0.0:80 app:app &
              EOF

  tags = {
    Name = "Flask-Frontend"
  }
}
