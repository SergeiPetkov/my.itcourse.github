
---
- name: Install Apache and Upload my Web Page
  hosts: CENTOS
  become: yes

  vars:
    WP_HOSTNAME: wordpress1.com
    WP_APP_NAME: wordpress1
    WP_USER_NAME: usr1
    WP_PASSWORD: 12345

  tasks:
    - name: Ping test
      ping:
        
    - name: Install all packages to WP
      shell:
        "yum install httpd \
                     ghostscript \
                     libapache2-mod-php \
                     mariadb-server \
                     php \
                     php-bcmath \
                     php-curl \
                     php-imagick \
                     php-intl \
                     php-json \
                     php-mbstring \
                     php-mysql \
                     php-xml \
                     php-zip -y"

    - name: httpd firewall
      shell: |
        systemctl start httpd
        systemctl enable httpd.service
        firewall-cmd --add-service=http --permanent
        firewall-cmd --reload
        sudo systemctl start mariadb

    - name: Create and load wordpress
      shell: 
        mkdir -p /srv/www/"{{ WP_APP_NAME }}"
    - name: Change owner to usr1
      shell:  
        chown -R "{{ WP_USER_NAME }}"":""{{ WP_USER_NAME }}" /srv/www/"{{ WP_APP_NAME }}"
    - name: Install and load WP 
      shell: 
        curl https://wordpress.org/latest.tar.gz | sudo -u "{{ WP_USER_NAME }}" tar zx -C /srv/www/"{{ WP_APP_NAME }}"           
 
    - name: create sites-avaible
      shell: |
        mkdir /etc/httpd/sites-available
        mkdir /etc/httpd/sites-enabled
        sudo sed -i '/IncludeOptional conf\.d\/\*\.conf/a IncludeOptional sites-enabled\/\*\.conf' /etc/httpd/conf/httpd.conf
     # sudo sed -i 's/IncludeOptional conf\.d\/\*\.conf/IncludeOptional sites-enabled\/\*\.conf/' /etc/httpd/conf/httpd.conf
        

    - name: Create "{{ WP_APP_NAME }}".conf apache2
      shell: |
        echo '<VirtualHost *:80>
            ServerName {{ WP_HOSTNAME }}
            DocumentRoot /srv/www/{{ WP_APP_NAME }}/wordpress
            <Directory /srv/www/{{ WP_APP_NAME }}/wordpress>
                Options FollowSymLinks
                AllowOverride Limit Options FileInfo
                DirectoryIndex index.php
                Require all granted
            </Directory>
            <Directory /srv/www/{{ WP_APP_NAME }}/wordpress/wp-content>
                Options FollowSymLinks
                Require all granted
            </Directory>
        </VirtualHost>' > /etc/httpd/sites-available/"{{ WP_APP_NAME }}".conf
    

    - name: symbolic link for each virtual host
      shell: |
        sudo ln -s /etc/httpd/sites-available/"{{ WP_APP_NAME }}".conf /etc/httpd/sites-enabled/"{{ WP_APP_NAME }}".conf


    - name: Setting up Apache2
      shell: |
        sudo a2enmod rewrite
        sudo systemctl reload httpd
        sudo systemctl restart httpd

    - name: Setting up mySQL 
      shell:
        sudo mysql -u root -e "CREATE DATABASE {{ WP_APP_NAME }}";
        sudo mysql -u root -e "CREATE USER '{{ WP_USER_NAME }}'@'%' IDENTIFIED BY '{{ WP_PASSWORD }}'";
        sudo mysql -u root -e "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER ON "{{ WP_APP_NAME }}".* TO '{{ WP_USER_NAME }}'@'%'";
        sudo mysql -u root -e "FLUSH PRIVILEGES;"
    
    - name: Setting up mySQL 
      shell:
        sudo service mariadb start

    - name: copy wp-config.php 
      shell:
        cp /srv/www/"{{ WP_APP_NAME }}"/wordpress/wp-config-sample.php /srv/www/"{{ WP_APP_NAME }}"/wordpress/wp-config.php 

    - name: Change line wp-config1
      shell: |     
        sed -i "s/'database_name_here'/'"{{ WP_APP_NAME }}"'/g" /srv/www/"{{ WP_APP_NAME }}"/wordpress/wp-config.php
        sed -i "s/'username_here'/'"{{ WP_USER_NAME }}"'/g" /srv/www/"{{ WP_APP_NAME }}"/wordpress/wp-config.php
        sed -i "s/'password_here'/'"{{ WP_PASSWORD }}"'/g" /srv/www/"{{ WP_APP_NAME }}"/wordpress/wp-config.php
   
        
    - name: Change line wp-config2
      shell: |
        SALT=$(curl -L https://api.wordpress.org/secret-key/1.1/salt/)
        STRING='put your unique phrase here'
        printf '%s\n' "g/$STRING/d" a "$SALT" . w | ed -s /srv/www/"{{ WP_APP_NAME }}"/wordpress/wp-config.php
 