resource "aws_key_pair" "terraformKey" {
  key_name    = "terraformKey2"
  public_key  = file(var.PATH_TO_PUBLIC_KEY)
}

#==> ubuntu vm
resource "aws_instance" "web" {
  # ami                   = "ami-0f158b0f26f18e619"
  ami                     = var.AWS_AMIS[var.AWS_REGION]
  instance_type           = var.AWS_INSTANCE_TYPE
  subnet_id               = aws_subnet.main-public-1.id
  vpc_security_group_ids  = [aws_security_group.allow_ssh.id, aws_security_group.allow_http.id]
  key_name                = aws_key_pair.terraformKey.key_name

  tags = {
    Name = "HelloWorld"
  }

  provisioner "file" {
    source        = "script.sh"
    destination   = "/tmp/script.sh" 
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh",
    ]
  }

  connection {
    host      = coalesce(self.public_ip, self.private_ip)
    type      = "ssh"
    user      = "ubuntu"
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }
}

#==> aws-linux
resource "aws_instance" "web2" {
  # ami                   = "ami-0f158b0f26f18e619"
  ami                     = var.AWS_AMIS_AWSLINUX[var.AWS_REGION]
  instance_type           = var.AWS_INSTANCE_TYPE
  subnet_id               = aws_subnet.main-public-2.id
  vpc_security_group_ids  = [aws_security_group.allow_ssh.id, aws_security_group.allow_http.id]
  key_name                = aws_key_pair.terraformKey.key_name

  tags = {
    Name = "aws-linux"
  }

  provisioner "file" {
    source        = "script-awslinux.sh"
    destination   = "/tmp/script-awslinux.sh" 
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script-awslinux.sh",
      "sudo /tmp/script-awslinux.sh",
    ]
  }

  connection {
    host      = coalesce(self.public_ip, self.private_ip)
    type      = "ssh"
    user      = "ec2-user"
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }
}

output "public_ip_ubuntu" {
  value = aws_instance.web.public_ip
}
output "public_ip_awslinux" {
  value = aws_instance.web2.public_ip
}

output "public_DNS_ubuntu" {
  value = aws_instance.web.public_dns
}

output "public_DNS_awslinux" {
  value = aws_instance.web2.public_dns
}

output "key_name" {
  value = aws_instance.web.key_name
}
