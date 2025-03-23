#!/bin/bash
set -e

# 1. 기본 패키지 설치
dnf update -y
dnf install -y git openvpn iproute procps tar

# 2. Easy-RSA 다운로드 및 초기화
mkdir -p /etc/openvpn/easy-rsa
git clone https://github.com/OpenVPN/easy-rsa.git /etc/openvpn/easy-rsa

cd /etc/openvpn/easy-rsa/easyrsa3
chmod +x easyrsa

./easyrsa init-pki
echo | ./easyrsa build-ca nopass
./easyrsa gen-req server nopass
echo yes | ./easyrsa sign-req server server
./easyrsa gen-dh
openvpn --genkey --secret ta.key

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
