output "ec2_public_ips" {
  # Using a 'for' loop to extract values (Exam Topic)
  value = [for instance in aws_instance.app_servers : instance.public_ip]
}

output "db_endpoint" {
  value = aws_db_instance.database.endpoint
}

output "db_connect_string" {
  # Using format() function
  value = format("mysql -h %s -u %s", aws_db_instance.database.address, aws_db_instance.database.username)
}