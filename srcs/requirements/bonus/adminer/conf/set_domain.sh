#!/bin/bash

echo "ServerName $DOMAIN_NAME" >> /etc/apache2/apache2.conf
exec apachectl -D FOREGROUND