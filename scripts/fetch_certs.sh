#!/bin/bash
set -e

# 설정 값
EC2_IP="43.200.118.179"
EC2_DNS="ec2-43-200-118-179.ap-northeast-2.compute.amazonaws.com"
PEM_KEY_PATH="$HOME/my_terraform/my-terraform-key.pem"
REMOTE_USER="ec2-user"
LOCAL_CERTS_DIR="$HOME/my_terraform/certs"

# ✅ known_hosts에서 해당 호스트 키 삭제 (호스트 키 충돌 방지)
ssh-keygen -R "$EC2_IP" # IP 주소 기반으로 ~/.ssh/known_hosts에서 삭제
ssh-keygen -R "$EC2_DNS" # 도메인 이름(DNS) 기반으로 삭제

# 인증서 파일 목록
FILES=("client1.crt" "client1.key" "ta.key" "ca.crt")

# 복사
for file in "${FILES[@]}"; do
  scp -i "$PEM_KEY_PATH" "${REMOTE_USER}@${EC2_IP}:/home/${REMOTE_USER}/${file}" "${LOCAL_CERTS_DIR}/"
done

echo "✅ 인증서 파일 복사 완료"
