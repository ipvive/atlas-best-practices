template {
  source = "/opt/consul_template/nginx.ctmpl"
  destination = "/etc/nginx/nginx.conf"
  command = "service nginx restart"
}
