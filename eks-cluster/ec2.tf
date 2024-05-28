resource "tls_private_key" "rsa_private_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}
resource "aws_key_pair" "tf_keypair" {
  key_name = var.key_pair_name
  public_key = tls_private_key.rsa_private_key.public_key_openssh
}

resource "local_file" "tf_key" {
    content = tls_private_key.rsa_private_key.private_key_pem
    filename = "mongodb-instance.pem"
  
}

resource "aws_instance" "mongodb_server" {
    # AMI specified below maps to: ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20230830 | ami-059261ff7474f56fe
    ami = "ami-059261ff7474f56fe"
    instance_type = "t2.micro"
    key_name = aws_key_pair.tf_keypair.key_name
    subnet_id = aws_subnet.k8s-demo-subnet[0].id
    vpc_security_group_ids = [aws_security_group.k8s-demo-sg.id]
    associate_public_ip_address = true
    user_data = data.template_file.user_data.rendered
    iam_instance_profile = aws_iam_instance_profile.mongodb_instance_profile.name

    tags = merge(var.tags,
    {
        "Tier" = "Database Tier",
        "Name" = "MongoDB_Server"
    })
}
