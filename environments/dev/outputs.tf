// environment/dev/outputs.tf


// openvpn 모듈의 정보 출력

# output "ovpn_file" {
#   value = templatefile("${path.module}/../../templates/client.ovpn.tpl", {
#     server_ip   = module.openvpn.openvpn_eip  # EIP 주소 전달
#     ca_cert     = file("${path.module}/../../certs/ca.crt")
#     client_cert = file("${path.module}/../../certs/client1.crt")
#     client_key  = file("${path.module}/../../certs/client1.key")
#     ta_key      = file("${path.module}/../../certs/ta.key")
#   })
# }

# output "openvpn_eip" {
#   value = module.openvpn.openvpn_eip # OpenVPN 서버의 고정 IP 출력
# }
