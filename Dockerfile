FROM debian:buster

MAINTAINER lusehair <lusehair@student.42.fr> 

# UP TO DATE DEBIAN AND INSTALL NGINX/PHP/MARIADB 
RUN apt-get update \
	&& apt-get install -y php7.3-fpm php7.3-common php7.3-mysql php7.3-gmp php7.3-curl php7.3-intl php7.3-mbstring \
	php7.3-xmlrpc php7.3-gd php7.3-xml php7.3-cli php7.3-zip php7.3-soap php7.3-imap nginx mariadb-server wget
#INSTALL WORDPRESS 
RUN mkdir /var/www/site
RUN	wget https://wordpress.org/latest.tar.gz
RUN tar xzvf latest.tar.gz
RUN mv wordpress /var/www/site
RUN chown -R www-data:www-data /var/www/*
RUN chmod -R 755 /var/www/*
COPY srcs/wp-config.php var/www/site/wordpress 
RUN rm -rf /etc/nginx/sites-enabled/default
#INSTALL PHPMYADMIN
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-all-languages.tar.xz
RUN mkdir /var/www/site/phpmyadmin
RUN tar -xvf phpMyAdmin-4.9.5-all-languages.tar.xz --strip-components 1 -C /var/www/site/phpmyadmin
COPY srcs/config.inc.php /var/www/site/phpmyadmin 
RUN touch /var/www/site/index.php
RUN echo "<?php phpinfo(); ?>" > var/www/site/index.php
#CONFIG DB 
COPY srcs/configdb.sh ./ 
RUN chmod 777 ./configdb.sh
RUN sh ./configdb.sh 
COPY srcs/nginx-conf /etc/nginx/sites-available/site
RUN ln -s /etc/nginx/sites-available/site /etc/nginx/sites-enabled/site
#CREATE SSL KEY 
RUN 	mkdir /etc/nginx/ssl
RUN	openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/site.pem -keyout /etc/nginx/ssl/site.key -subj "/C=FR/ST=Paris/CN=lusehair"
#GROOVY BABY 
COPY srcs/init.sh ./
RUN chmod 777 init.sh 
CMD ["bash", "./init.sh"]


