
output "mysql_conn" {
  value       = module.mysql.instance_connection_name
  description = "The connection name of the master instance to be used in connection strings"
}
