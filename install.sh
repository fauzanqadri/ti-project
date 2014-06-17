apt-get update -y
apt-get install -y wget vim libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev git
cp ./install/pgdg.list /etc/apt/sources.list.d/pgdg.list
cp ./install/nginx.list /etc/apt/sources.list.d/nginx.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
wget --quiet -O - http://nginx.org/keys/nginx_signing.key | apt-key add -
apt-get update -y
apt-get install -y nginx
apt-get install -y postgresql-9.3 libpq-dev postgresql-client-9.3
