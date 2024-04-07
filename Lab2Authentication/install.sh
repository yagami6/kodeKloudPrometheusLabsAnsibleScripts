echo hello from $(hostname)
rm  -r /etc/node_exporter
mkdir /etc/node_exporter/
touch /etc/node_exporter/config.yml
chmod 700 /etc/node_exporter
chmod 600 /etc/node_exporter/config.yml
chown -R nodeusr:nodeusr /etc/node_exporter
sed -i 's:ExecStart=/usr/local/bin/node_exporter:ExecStart=/usr/local/bin/node_exporter --web.config=/etc/node_exporter/config.yml:' /etc/systemd/system/node_exporter.service
systemctl daemon-reload
systemctl restart node_exporter
apt -qq update
apt -qq install apache2-utils -y

password=$(echo "DevOps" | htpasswd -inBC 10 "" | tr -d ':\n'; echo)
echo "basic_auth_users:\n   prometheus: $password" > /etc/node_exporter/config.yml
systemctl restart node_exporter