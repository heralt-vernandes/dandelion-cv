# 1. Setup IP Address
/ip address
add address=192.168.100.1/24 interface=ether2 comment="IP_Ether2"
add address=192.168.9.1/29 interface=ether3 comment="IP_Ether3"
add address=192.168.65.1/24 interface=wlan1 comment="IP_WLAN"

# 2. Setup DNS & Allow Remote Requests
/ip dns
set servers=8.8.8.8,1.1.1.1,9.9.9.9 allow-remote-requests=yes

# 3. Setup Firewall NAT (Masquerade)
/ip firewall nat
add chain=srcnat out-interface=ether1 action=masquerade comment="Akses_Internet_Client"

# 4. Setup DHCP Server untuk Ether2
/ip pool
add name=pool_ether2 ranges=192.168.100.2-192.168.100.254
/ip dhcp-server
add name=dhcp_ether2 interface=ether2 address-pool=pool_ether2 disabled=no
/ip dhcp-server network
add address=192.168.100.0/24 gateway=192.168.100.1 dns-server=8.8.8.8,1.1.1.1

# 5. Setup DHCP Server untuk WLAN
/ip pool
add name=pool_wlan ranges=192.168.65.2-192.168.65.254
/ip dhcp-server
add name=dhcp_wlan interface=wlan1 address-pool=pool_wlan disabled=no
/ip dhcp-server network
add address=192.168.65.0/24 gateway=192.168.65.1 dns-server=8.8.8.8,1.1.1.1

# 6. Setup Interface WLAN (Nyalakan, AP Bridge, SSID fatih)
/interface wireless
set [ find default-name=wlan1 ] disabled=no mode=ap-bridge ssid="fatih"

/log info "Script Setup Dasar Berhasil Diinstall!"
