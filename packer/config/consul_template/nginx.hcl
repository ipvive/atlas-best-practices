template {
  source = "/opt/consul_template/nginx.ctmpl"
  destination = "/etc/nginx/nginx.cfg"
  command = "service nginx restart"
}
