#!/bin/bash

# 인증서 복사
bash ~/my_terraform/scripts/fetch_certs.sh

# ovpn 파일 생성
terraform -chdir=./environments/dev output -raw ovpn_file > client1.ovpn

echo "✅ .ovpn 파일 생성 완료: client1.ovpn"