
resource "aws_instance" "test-instance" {
  ami                    = var.instance_ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  security_groups        = var.sg
  subnet_id              = var.subnet_id
  count                  = var.instance_count
  user_data              = file("modules/webserver/scripts/webserver.sh")

  tags = {
    Name = var.instance_name
  }
}



output "test-instance_id" {
  value = aws_instance.test-instance.*.id
}
