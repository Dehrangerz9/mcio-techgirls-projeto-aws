#!/bin/bash

# Atualizar pacotes
sudo yum update -y
sudo yum install -y wget

# Instalar Grafana
sudo tee /etc/yum.repos.d/grafana.repo <<EOF
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
EOF

sudo yum install -y grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Criar um usuário para o Prometheus
sudo useradd --no-create-home --shell /bin/false prometheus

# Criar diretórios para configuração e dados do Prometheus
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus

# Alterar a propriedade do diretório de dados
sudo chown prometheus:prometheus /var/lib/prometheus

# Mudar para o diretório /tmp
cd /tmp/

# Baixar o Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.31.1/prometheus-2.31.1.linux-amd64.tar.gz

# Extrair os arquivos
tar -xvf prometheus-2.31.1.linux-amd64.tar.gz

# Mudar para o diretório extraído
cd prometheus-2.31.1.linux-amd64

# Mover arquivos de configuração e alterar propriedade
sudo mv console* /etc/prometheus
sudo mv prometheus.yml /etc/prometheus
sudo chown -R prometheus:prometheus /etc/prometheus

# Mover os binários e alterar propriedade
sudo mv prometheus /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/prometheus

# Criar o arquivo de serviço do Prometheus
sudo tee /etc/systemd/system/prometheus.service <<EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \\
    --config.file /etc/prometheus/prometheus.yml \\
    --storage.tsdb.path /var/lib/prometheus/ \\
    --web.console.templates=/etc/prometheus/consoles \\
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF

# Recarregar o systemd
sudo systemctl daemon-reload

# Habilitar e iniciar o serviço do Prometheus
sudo systemctl enable prometheus
sudo systemctl start prometheus

# Configurar o firewall
sudo firewall-cmd --add-service=prometheus --permanent
sudo firewall-cmd --reload
