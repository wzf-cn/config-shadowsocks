#!/bin/bash
# usage:
# ./config-shadowsocks.sh <password_of_shadowsocks>
# ./config-shadowsocks.sh 12345678
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install python-pip
pip install shadowsocks
server_ip=$(ifconfig eth0|grep "inet "|awk '{print $2}')
cat>/etc/shadowsocks.json<<EOF
{
	"server":"${server_ip}",
	"server_port":8388,
	"local_address":"127.0.0.1",
	"local_port":1080,
	"password":"$1",
	"timeout":300,
	"method":"aes-256-cfb",
	"fast_open":false
}
EOF
# debug error:"undefined symbol:EVP_CIPHER_CTX_cleanup"
# reference: https://blog.csdn.net/blackfrog_unique/article/details/60320737
sed -i "s/cleanup/reset/g" /usr/local/lib/python2.7/dist-packages/shadowsocks/crypto/openssl.py
ssserver -c /etc/shadowsocks.json -d start
