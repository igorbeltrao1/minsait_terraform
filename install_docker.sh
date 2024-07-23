# Remover versões antigas do Docker
sudo apt-get -y remove docker docker-engine docker.io

# Atualizar pacotes e instalar dependências
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates wget software-properties-common

# Adicionar chave GPG do Docker
wget https://download.docker.com/linux/debian/gpg
sudo apt-key add gpg

# Adicionar repositório Docker
echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee -a /etc/apt/sources.list.d/docker.list

# Atualizar novamente e instalar Docker
sudo apt-get update
sudo apt-cache policy docker-ce
sudo apt-get install -y docker-ce

# Verificar status do Docker
sudo systemctl status docker

# Adicionar o usuário atual ao grupo docker
sudo usermod -aG docker $(whoami)

# Docker Compose
sudo curl -o /usr/local/bin/docker-compose -L "https://github.com/docker/compose/releases/download/1.17.1/docker-compose-$(uname -s)-$(uname -m)"
sudo chmod +x /usr/local/bin/docker-compose

# Verificar a versão do Docker Compose
docker-compose -v

# Subir o container do MySQL
sudo docker run --name mysql \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=minsaitdatabase \
  -e MYSQL_USER=igorminsaiter \
  -e MYSQL_PASSWORD=minsait123 \
  -p 3306:3306 \
  -d mysql:5.7

# Esperar até que o MySQL esteja pronto
echo "Esperando o MySQL inicializar..."
until sudo docker exec mysql mysqladmin ping --silent; do
  sleep 5
done

# Subir o container do WordPress
sudo docker run --name wordpress \
  --link mysql:mysql \
  -e WORDPRESS_DB_HOST=mysql \
  -e WORDPRESS_DB_USER=igorminsaiter \
  -e WORDPRESS_DB_PASSWORD=minsait123 \
  -e WORDPRESS_DB_NAME=minsaitdatabase \
  -p 80:80 \
  -d wordpress
