#!/bin/bash
set -e

# 현재 내 공인 IP 가져오기
MY_IP=$(curl -s ifconfig.me)
echo "🔍 현재 내 IP: $MY_IP"

# 수정할 보안 그룹 ID (필요 시 하드코딩 or Terraform output에서 가져오기)
SG_ID="sg-0123456789abcdef0"  # <=== 여기에 본인의 Security Group ID 입력

# 기존 동일 포트 규칙 제거 (옵션)
echo "🧹 기존 인바운드 규칙 제거..."
aws ec2 revoke-security-group-ingress \
  --group-id "$SG_ID" \
  --protocol udp \
  --port 1194 \
  --cidr "$MY_IP/32" 2>/dev/null || true

aws ec2 revoke-security-group-ingress \
  --group-id "$SG_ID" \
  --protocol tcp \
  --port 22 \
  --cidr "$MY_IP/32" 2>/dev/null || true

# 현재 IP로 다시 추가
echo "➕ 현재 IP로 1194/UDP 및 22/TCP 허용 추가..."
aws ec2 authorize-security-group-ingress \
  --group-id "$SG_ID" \
  --protocol udp \
  --port 1194 \
  --cidr "$MY_IP/32"

aws ec2 authorize-security-group-ingress \
  --group-id "$SG_ID" \
  --protocol tcp \
  --port 22 \
  --cidr "$MY_IP/32"

echo "✅ 완료: 현재 IP ($MY_IP) 등록 완료"