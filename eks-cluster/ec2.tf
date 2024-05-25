resource "aws_instance" "mongodb_server" {
    ami = data.aws_ami.amazon_linux
    instance_type = "t2.micro"
    subnet_id = aws_subnet.k8s-demo-subnet[0].id
    vpc_security_group_ids = [aws_security_group.k8s-demo-sg.id]
    associate_public_ip_address = true
    user_data = data.template_file.user_data.rendered

    tags = merge(var.tags,
    {
        "Tier" = "Database Tier",
        "Name" = "MongoDB_Server"
    })
}