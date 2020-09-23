resource "aws_lb" "applb" {
  name               = "applb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.loadbalancer-sg.id]
  subnets            = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]

  enable_deletion_protection = true

  tags = {
    Environment = "staging"
  }
}

resource "aws_lb_target_group" "appTargetGroup" {
  name     = "appTargetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.applb.arn
  port              = "80"
  protocol          = "HTTP"
 
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.appTargetGroup.arn
  }
}

resource "aws_lb_target_group_attachment" "web1" {
  target_group_arn = aws_lb_target_group.appTargetGroup.arn
  target_id        = aws_instance.web.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web2" {
  target_group_arn = aws_lb_target_group.appTargetGroup.arn
  target_id        = aws_instance.web2.id
  port             = 80
}

output "public_DNS_AppLoadBalancer" {
  value = aws_lb.applb.dns_name
}