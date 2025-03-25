client
dev tun
proto udp
remote ${server_ip} 1194
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
cipher AES-256-CBC
auth SHA256
key-direction 1
verb 3

<ca>
${ca_cert}
</ca>
<cert>
${client_cert}
</cert>
<key>
${client_key}
</key>
<tls-auth>
${ta_key}
</tls-auth>
