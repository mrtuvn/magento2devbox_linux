#!/bin/bash

ssh_port=$(docker port magento2devbox_web_7724b23a46e9e2fe1d189c4c5ac0b5ea 22)
ssh_port=${ssh_port#*:}

ssh -N -p $ssh_port -R 9000:localhost:9000 magento2@127.0.0.1