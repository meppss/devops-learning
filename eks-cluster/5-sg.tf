resource "aws_security_group" "k8s-demo-sg" {
    name = "k8s-demo-sg"
    vpc_id = aws_vpc.k8s-demo-vpc.id

    tags = merge(var.tags, {
        Name = "k8s-demo-sg"
    })    
    # SSH access to the VPC
    ingress {
        from_port   = 22
        to_port     = 22
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

