rm  -r /etc/node_exporter
mkdir /etc/node_exporter/
touch /etc/node_exporter/config.yml
chmod 700 /etc/node_exporter
chmod 600 /etc/node_exporter/config.yml
chown -R nodeusr:nodeusr /etc/node_exporter
sed -i 's:ExecStart=/usr/local/bin/node_exporter:ExecStart=/usr/local/bin/node_exporter --web.config=/etc/node_exporter/config.yml:' /etc/systemd/system/node_exporter.service
apt -qq update
apt -qq install apache2-utils -y
password=$(echo "DevOps" | htpasswd -inBC 10 "" | tr -d ':\n'; echo)
echo "basic_auth_users:\n   prometheus: $password" >> /etc/node_exporter/config.yml
openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout node_exporter.key -out node_exporter.crt -subj "/C=US/ST=California/L=Oakland/O=MyOrg/CN=localhost" -addext "subjectAltName = DNS:localhost"
mv node_exporter.crt node_exporter.key /etc/node_exporter/
chown nodeusr.nodeusr /etc/node_exporter/node_exporter.key
chown nodeusr.nodeusr /etc/node_exporter/node_exporter.crt
echo "tls_server_config:\n   cert_file: node_exporter.crt\n   key_file: node_exporter.key" >> /etc/node_exporter/config.yml
systemctl daemon-reload
systemctl restart node_exporter
