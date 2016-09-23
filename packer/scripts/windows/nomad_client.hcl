bind_addr    = "0.0.0.0"
data_dir     = "C:\\opt\\nomad\\data"
datacenter   = "{{ datacenter }}"
name         = "nemesysco"
log_level    = "INFO"
region       = "{{ region }}"

advertise {
  http = "{{ local_ip }}:4646"
  rpc  = "{{ local_ip }}:4647"
  serf = "{{ local_ip }}:4648"
}

client {
  enabled    = true

  client_max_port = 15000

  options {
    "driver.raw_exec.enable" = "1"
  }

  meta {
    region       = "{{ region }}"
  }
}
