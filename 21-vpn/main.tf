resource "aws_instance" "open_vpn" {
  ami                     = local.ami_id #mandatory
  instance_type           = "t3.micro" #mandatory
  vpc_security_group_ids  = [local.open_vpn_sg_id] #mandatory
  subnet_id               = local.public_subnet_id
  user_data = file("vpn.sh") #file is a funtn which reads vpn.sh and execute the script when bastion server is being started.
  
  tags = merge (
        local.common_tags,
        {
        Name = "${var.project_name}-${var.environment}-openvpn"
        }
    )
}

resource "aws_route53_record" "open_vpn" {
  zone_id = var.zone_id
  name    = "openvpn.${var.domain_name}" # openvpn.prav4cloud.online
  type    = "A"
  ttl     = 1
  records = [aws_instance.open_vpn.public_ip]
  allow_overwrite = true
}