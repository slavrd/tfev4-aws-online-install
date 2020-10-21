output "tfe_asg_name" {
  description = "The name of the TFE Auto Scaling group."
  value       = aws_autoscaling_group.tfe.name
}