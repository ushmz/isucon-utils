// ref: https://sue445.hatenablog.com/entry/2021/08/22/213634#%E9%81%8E%E5%8E%BB%E5%95%8F%E7%B4%A0%E6%8C%AF%E3%82%8A%E7%94%A8%E3%81%AETerraform

resource "aws_vpc" "isucon" {
  cidr_block = "172.31.0.0/16"

  tags = {
    Name = "isucon VPC"
  }
}

resource "aws_subnet" "isucon_public_a" {
  vpc_id                  = aws_vpc.isucon.id
  cidr_block              = "172.31.0.0/20"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "isucon Public a"
  }
}

resource "aws_subnet" "isucon_public_c" {
  vpc_id                  = aws_vpc.isucon.id
  cidr_block              = "172.31.16.0/20"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "isucon Public c"
  }
}

resource "aws_subnet" "isucon_public_d" {
  vpc_id            = aws_vpc.isucon.id
  cidr_block        = "172.31.32.0/20"
  availability_zone = "ap-northeast-1d"

  map_public_ip_on_launch = true

  tags = {
    Name = "isucon Public d"
  }
}

resource "aws_internet_gateway" "isucon_igw" {
  vpc_id = aws_vpc.isucon.id
  tags = {
    Name = "isucon IGW"
  }
}

resource "aws_route_table" "isucon_public" {
  vpc_id = aws_vpc.isucon.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.isucon_igw.id
  }

  tags = {
    Name = "isucon Public"
  }
}

resource "aws_route_table_association" "isucon_public_a" {
  subnet_id      = aws_subnet.isucon_public_a.id
  route_table_id = aws_route_table.isucon_public.id
}

resource "aws_route_table_association" "isucon_public_c" {
  subnet_id      = aws_subnet.isucon_public_c.id
  route_table_id = aws_route_table.isucon_public.id
}

resource "aws_route_table_association" "isucon_public_d" {
  subnet_id      = aws_subnet.isucon_public_d.id
  route_table_id = aws_route_table.isucon_public.id
}

# NOTE. https://ip-ranges.amazonaws.com/ip-ranges.json で公開されているAWSのCIDRをTerraformから取得する
data "aws_ip_ranges" "ec2_instance_connect" {
  regions  = ["ap-northeast-1"]
  services = ["ec2_instance_connect"]
}

resource "aws_security_group" "isucon" {
  vpc_id      = aws_vpc.isucon.id
  name        = "isucon"
  description = "isucon"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["172.31.0.0/16"]
  }

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = data.aws_ip_ranges.ec2_instance_connect.cidr_blocks
    ipv6_cidr_blocks = data.aws_ip_ranges.ec2_instance_connect.ipv6_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "isucon"
  }
}