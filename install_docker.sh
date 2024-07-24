#!/bin/bash
set -e

# Atualiza pacotes e instalar dependências
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Adiciona a chave GPG do Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Adiciona repositório Docker
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Atualiza novamente e instalar Docker
sudo apt-get update
sudo apt-get install -y docker-ce

# Adiciona o usuário atual ao grupo docker
sudo usermod -aG docker $(whoami)

# Instala Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verifica a versão do Docker e Docker Compose
docker --version
docker-compose --version

# Cria diretório para o docker-compose.yml
mkdir -p /home/igorbeltrao/docker
cd /home/igorbeltrao/docker

# Cria o arquivo docker-compose.yml
cat <<EOF > docker-compose.yml
version: '3.8'

services:
  wordpress:
    image: wordpress:latest
    container_name: wordpress
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: mysql
      WORDPRESS_DB_USER: igorminsaiter
      WORDPRESS_DB_PASSWORD: minsait123
      WORDPRESS_DB_NAME: minsaitdatabase
    depends_on:
      - mysql
    volumes:
      - wordpress_data:/var/www/html
    networks:
      - wordpress-net

  mysql:
    image: mysql:5.7
    container_name: mysql
    ports:
      - "3306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: GAud4mZby8F3SD6P
      MYSQL_DATABASE: minsaitdatabase
      MYSQL_USER: igorminsaiter
      MYSQL_PASSWORD: minsait123
    volumes:
      - mysql_data:/var/lib/mysql
    networks:
      - wordpress-net

networks:
  wordpress-net:
    driver: bridge

volumes:
  wordpress_data:
  mysql_data:
EOF

# Sobe os containers do Docker Compose
sudo docker-compose up -d
