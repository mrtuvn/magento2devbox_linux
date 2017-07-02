#!/bin/bash

echo 'Reset Magento'
web_port=$(docker-compose port web 80)
web_port=${web_port#*:}
varnish_port=$(docker-compose port varnish 6081)
varnish_port=${varnish_port#*:}

docker-compose exec --user magento2 web m2init magento:reset --no-interaction --webserver-home-port=$varnish_port