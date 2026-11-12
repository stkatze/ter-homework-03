locals {
  webservers = [
    for i, vm in yandex_compute_instance.web : {
      name   = vm.name
      nat_ip = vm.network_interface[0].nat_ip_address
      fqdn   = vm.fqdn
    }
  ]

  databases = [
    for name, vm in yandex_compute_instance.db : {
      name   = vm.name
      nat_ip = vm.network_interface[0].nat_ip_address
      fqdn   = vm.fqdn
    }
  ]

  storage = [
    for vm in [yandex_compute_instance.storage] : {
      name   = vm.name
      nat_ip = vm.network_interface[0].nat_ip_address
      fqdn   = vm.fqdn
    }
  ]
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/ansible.tftpl", {
    webservers = local.webservers
    databases  = local.databases
    storage    = local.storage
  })
  filename = "${path.module}/hosts.ini"
}