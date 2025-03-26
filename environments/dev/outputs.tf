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

output "s3_bucket_name" {
  description = "배포 아티팩트를 저장할 S3 버킷 이름"
  value       = module.github_s3.bucket_name
}

output "codedeploy_service_role_arn" {
  description = "CodeDeploy에 연결된 IAM 역할 ARN"
  value       = module.codedeploy.codedeploy_service_role_arn
}

output "github_iam_arn" {
  description = "GitHub에서 사용할 IAM ARN"
  value       = module.iam_github.github_iam_arn
}

output "github_access_key_id" {
  description = "GitHub Actions에서 사용할 AWS Access Key ID"
  value       = module.iam_github.access_key_id
  sensitive   = true
}

output "github_secret_access_key" {
  description = "GitHub Actions에서 사용할 AWS Secret Access Key"
  value       = module.iam_github.secret_access_key
  sensitive   = true
}

