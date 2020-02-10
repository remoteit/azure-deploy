#!/bin/bash
apt-get -y update

#install redis

#install openresty

# install the LAMP stack
apt-get -y install node

# write some PHP
echo \<center\>\<h1\>My Demo App\</h1\>\<br/\>\</center\> > /var/www/html/phpinfo.php
echo \<\?php phpinfo\(\)\; \?\> >> /var/www/html/phpinfo.php

