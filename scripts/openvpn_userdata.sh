#!/bin/bash
set -e

# 1. 기본 패키지 설치
dnf update -y
dnf install -y git openvpn iproute procps tar

# 2. Easy-RSA 다운로드 및 초기화
mkdir -p /etc/openvpn/easy-rsa
git clone https://github.com/OpenVPN/easy-rsa.git /etc/openvpn/easy-rsa

cd /etc/openvpn/easy-rsa/easyrsa3 || exit 1
chmod +x easyrsa

# 비대화 모드로 PKI 초기화 및 인증서 생성
./easyrsa init-pki
echo | ./easyrsa --batch build-ca nopass
./easyrsa --batch gen-req server nopass
./easyrsa --batch sign-req server server
./easyrsa gen-dh
openvpn --genkey --secret ta.key

# ✅ 클라이언트 인증서/키 추가 생성
echo "[INFO] Generating client1 cert/key..."

./easyrsa --batch gen-req client1 nopass || { echo "[ERROR] client1 key generation failed"; exit 1; }
./easyrsa --batch sign-req client client1 || { echo "[ERROR] client1 cert sign failed"; exit 1; }

EASYRSA_DIR="/etc/openvpn/easy-rsa/easyrsa3"

# 클라이언트 인증서/키 복사 (scp로 가져오기 위한 위치)
echo "[INFO] Copying certs to /home/ec2-user/"

cp "$EASYRSA_DIR/pki/issued/client1.crt" "$EASYRSA_DIR/pki/private/client1.key" /home/ec2-user/
cp "$EASYRSA_DIR/pki/ca.crt" "$EASYRSA_DIR/ta.key" /home/ec2-user/

# ✅ 퍼미션 설정 (ec2-user가 복사 가능하게)
echo "[INFO] Setting permissions..."

chown ec2-user:ec2-user /home/ec2-user/client1.*
chown ec2-user:ec2-user /home/ec2-user/ta.key
chmod 644 /home/ec2-user/*.crt
chmod 600 /home/ec2-user/*.key
chmod 644 /home/ec2-user/ta.key

# 3. 인증서/키 복사
mkdir -p /etc/openvpn/server
cp pki/ca.crt pki/issued/server.crt pki/private/server.key pki/dh.pem ta.key /etc/openvpn/server/

# 4. OpenVPN 설정파일 생성
cat <<EOF > /etc/openvpn/server/server.conf
port 1194
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
auth SHA256
tls-auth ta.key 0
topology subnet
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 10 120
persist-key
persist-tun
user nobody
group nobody
status openvpn-status.log
verb 3
explicit-exit-notify 1
EOF

# 5. IP forwarding 활성화
echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf
sysctl -p

# 6. 서비스 활성화
systemctl enable openvpn-server@server
systemctl start openvpn-server@server

# 7. 설치 완료
log "🎉 모든 OpenVPN 설정이 완료되었습니다!"
echo "🎉 모든 OpenVPN 설정이 완료되었습니다!"