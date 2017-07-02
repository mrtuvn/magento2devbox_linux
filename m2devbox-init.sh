#!/bin/bash
touch /home/mrtuvn/devbox/src/sync-wait
echo 'Build docker images'
docker-compose up --build -d
web_port=$(docker-compose port web 80)
web_port=${web_port#*:}

echo 'Copy Webroot'
cp -rf /home/mrtuvn/devbox/src ./magento2
docker cp magento2 magento2devbox_web_7724b23a46e9e2fe1d189c4c5ac0b5ea:/var/www
rm -rf magento2
rm -rf /home/mrtuvn/devbox/src/sync-wait
sleep 5

echo 'Install Magento'
varnish_port=$(docker-compose port varnish 6081)
varnish_port=${varnish_port#*:}
docker-compose exec --user magento2 web m2init magento:install --no-interaction --webserver-home-port=$web_port --varnish-home-port=$varnish_port