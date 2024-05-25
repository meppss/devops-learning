

resource "aws_vpc" "k8s-demo-vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.tags, {
    "Name"                                      = "k8s-demo-vpc"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  })
}

resource "aws_subnet" "k8s-demo-subnet" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  vpc_id                  = aws_vpc.k8s-demo-vpc.id
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    "Name"                                      = "k8s-demo-subnet"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = 1
  })
}

resource "aws_internet_gateway" "k8s-demo-igw" {
  vpc_id = aws_vpc.k8s-demo-vpc.id

  tags = merge(var.tags, {
    Name = "k8s-demo-igw"
  })
}

resource "aws_route_table" "k8s-demo-rtb" {
  vpc_id = aws_vpc.k8s-demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s-demo-igw.id
  }
}

resource "aws_route_table_association" "k8s-demo-rtb_association" {
  count = 2

  subnet_id      = aws_subnet.k8s-demo-subnet[count.index].id
  route_table_id = aws_route_table.k8s-demo-rtb.id
}

resource "aws_security_group" "k8s-demo-sg" {
    name = "k8s-demo-sg"
    vpc_id = aws_vpc.k8s-demo-vpc.id

    tags = merge(var.tags, {
        Name = "k8s-demo-sg"
    })    
    # SSH access from the VPC
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
        from_port   = 8080
        to_port     = 8080
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
