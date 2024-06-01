

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
    "Name"                                      = "k8s-demo-subnet-${count.index}"
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
