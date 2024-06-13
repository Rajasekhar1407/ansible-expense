resource "aws_instance" "ansible_practice" {
  count = 4
  ami = data.aws_ami.ansible_practice.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.aws_security_group.sg_id.id]
  tags = {
    Name = "ansible-practice-${count.index}"
  }
  user_data = count.index == 0 ? file("user_data.sh") : ""
}

resource "aws_route53_record" "ansible_practice_db" {
  zone_id = data.aws_route53_zone.zone_id.zone_id
  name    = "db.rajasekhar.online"
  type    = "A"
  ttl     = 1
  records = [aws_instance.ansible_practice.1.private_ip]
}

resource "aws_route53_record" "ansible_practice_backend" {
  zone_id = data.aws_route53_zone.zone_id.zone_id
  name    = "backend.rajasekhar.online"
  type    = "A"
  ttl     = 1
  records = [aws_instance.ansible_practice.2.private_ip]
}

resource "aws_route53_record" "ansible_practice_frontend" {
  zone_id = data.aws_route53_zone.zone_id.zone_id
  name    = "rajasekhar.online"
  type    = "A"
  ttl     = 1
  records = [aws_instance.ansible_practice.3.public_ip]
}