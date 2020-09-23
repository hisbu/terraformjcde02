# # Create a new load balancer
# resource "aws_elb" "myclb" {
#   name               = "terraform-clb"
#   subnets            = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
#   security_groups    = [aws_security_group.loadbalancer-sg.id]

#   listener {
#     instance_port     = 80
#     instance_protocol = "http"
#     lb_port           = 80
#     lb_protocol       = "http"
#   }

#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     target              = "HTTP:80/"
#     interval            = 10
#   }

#   instances                   = [aws_instance.web.id, aws_instance.web2.id]
#   cross_zone_load_balancing   = true
#   idle_timeout                = 60
#   connection_draining         = true
#   connection_draining_timeout = 60

#   tags = {
#     Name = "terraform-clb"
#   }
# }

# output "dns_clb" {
#     value = aws_elb.myclb.dns_name
# }