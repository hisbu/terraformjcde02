resource "aws_launch_template" "tf-ec2template" {
  name = "tf-ec2template"
  image_id = var.AWS_AMIS[var.AWS_REGION]
  instance_type = var.AWS_INSTANCE_TYPE
  key_name = aws_key_pair.terraformKey.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_http.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "tf-ec2template"
    }
  }

  user_data = filebase64("script.sh")
}

resource "aws_autoscaling_group" "tf-Scalinggroup" {
#   availability_zones = ["us-west-1a", "us-west-1c"]
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1
  health_check_grace_period = 60
  health_check_type         = "ELB"
  force_delete              = true
  vpc_zone_identifier       = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  target_group_arns         = [aws_lb_target_group.appTargetGroup.arn]

  launch_template {
    id      = aws_launch_template.tf-ec2template.id
    version = "$Latest"
  }
}

#scaleout policy
resource "aws_autoscaling_policy" "scaleout" {
  name                   = "scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.tf-Scalinggroup.name
}

resource "aws_cloudwatch_metric_alarm" "scaleout_alarm" {
  alarm_name          = "scaleout_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "40"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.tf-Scalinggroup.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.scaleout.arn]
}

#Scalein Policy
resource "aws_autoscaling_policy" "scalein" {
  name                   = "scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.tf-Scalinggroup.name
}

resource "aws_cloudwatch_metric_alarm" "scalein_alarm" {
  alarm_name          = "scalein_alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "20"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.tf-Scalinggroup.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.scalein.arn]
}

resource "aws_autoscaling_schedule" "scheduleScale" {
  scheduled_action_name  = "scheduleScale"
  min_size               = 2
  max_size               = 4
  desired_capacity       = 3
  start_time             = "2020-09-22T08:35:00Z"
  end_time               = "2020-09-22T08:37:00Z"
  autoscaling_group_name = aws_autoscaling_group.tf-Scalinggroup.name
}