openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout node_exporter.key -out node_exporter.crt -subj "/C=US/ST=California/L=Oakland/O=MyOrg/CN=localhost" -addext "subjectAltName = DNS:localhost"
mv node_exporter.crt node_exporter.key /etc/node_exporter/
chown nodeusr.nodeusr /etc/node_exporter/node_exporter.key
chown nodeusr.nodeusr /etc/node_exporter/node_exporter.crt
echo "tls_server_config::\n   cert_file: node_exporter.crt\n"   key_file: node_exporter.key > /etc/node_exporter/config.yml
systemctl restart node_exporter
