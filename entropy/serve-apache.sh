#!/usr/bin/env bash

declare -A params=$6     # Create an associative array
paramsTXT=""
if [ -n "$6" ]; then
    for element in "${!params[@]}"
    do
        paramsTXT="${paramsTXT}
        SetEnv ${element} \"${params[$element]}\""
    done
fi

php_version=${5/.}

sudo systemctl stop nginx

block="<VirtualHost *:$3>
    ServerAdmin webmaster@localhost
    ServerName $1
    ServerAlias www.$1
    DocumentRoot "$2"
    $paramsTXT

    # Handle Authorization Header
    <IfModule mod_rewrite.c>
    RewriteEngine on
    RewriteCond %{HTTP:Authorization} .
    RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
    </IfModule>

    <Directory "$2">
        AllowOverride All
        Require all granted
    </Directory>
    <IfModule mod_fastcgi.c>
        AddHandler php"$php_version"-fcgi .php
        Action php"$php_version"-fcgi /php"$php_version"-fcgi
        Alias /php"$php_version"-fcgi /usr/lib/cgi-bin/php"$php_version"
        FastCgiExternalServer /usr/lib/cgi-bin/php"$php_version" -socket /var/opt/remi/php"$php_version"/run/php-fpm/php"$php_version"-fpm.sock -pass-header Authorization
    </IfModule>
    <IfModule !mod_fastcgi.c>
        <IfModule mod_proxy_fcgi.c>
            <FilesMatch \".+\.ph(ar|p|tml)$\">
                SetHandler \"proxy:unix:/var/opt/remi/php"$php_version"/run/php-fpm/php"$php_version"-fpm.sock|fcgi://localhost/\"
            </FilesMatch>
        </IfModule>
    </IfModule>
    #LogLevel info ssl:warn

    ErrorLog logs/$1-error.log
    CustomLog logs/$1-access.log combined

    #Include conf-available/serve-cgi-bin.conf
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
"

echo "$block" > "/etc/httpd/sites-available/$1.conf"
ln -fs "/etc/httpd/sites-available/$1.conf" "/etc/httpd/sites-enabled/$1.conf"

blockssl="<IfModule mod_ssl.c>
    <VirtualHost *:$4>

        ServerAdmin webmaster@localhost
        ServerName $1
        ServerAlias www.$1
        DocumentRoot "$2"
        $paramsTXT

        # Handle Authorization Header
        <IfModule mod_rewrite.c>
        RewriteEngine on
        RewriteCond %{HTTP:Authorization} .
        RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
        </IfModule>

        <Directory "$2">
            AllowOverride All
            Require all granted
        </Directory>

        #LogLevel info ssl:warn

        ErrorLog logs/$1-error.log
        CustomLog logs/$1-access.log combined

        #Include conf-available/serve-cgi-bin.conf

        #   SSL Engine Switch:
        #   Enable/Disable SSL for this virtual host.
        SSLEngine on

        #SSLCertificateFile  /etc/ssl/certs/ssl-cert-snakeoil.pem
        #SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key

        SSLCertificateFile      /etc/nginx/ssl/$1.crt
        SSLCertificateKeyFile   /etc/nginx/ssl/$1.key


        #SSLCertificateChainFile /etc/apache2/ssl.crt/server-ca.crt

        #SSLCACertificatePath /etc/ssl/certs/
        #SSLCACertificateFile /etc/apache2/ssl.crt/ca-bundle.crt

        #SSLCARevocationPath /etc/apache2/ssl.crl/
        #SSLCARevocationFile /etc/apache2/ssl.crl/ca-bundle.crl

        #SSLVerifyClient require
        #SSLVerifyDepth  10

        <FilesMatch \"\.(cgi|shtml|phtml|php)$\">
            SSLOptions +StdEnvVars
        </FilesMatch>
        <Directory /usr/lib/cgi-bin>
            SSLOptions +StdEnvVars
        </Directory>

        <IfModule mod_fastcgi.c>
            AddHandler php"$php_version"-fcgi .php
            Action php"$php_version"-fcgi /php"$php_version"-fcgi
            Alias /php"$php_version"-fcgi /usr/lib/cgi-bin/php"$php_version"
            FastCgiExternalServer /usr/lib/cgi-bin/php"$php_version" -socket /var/opt/remi/php"$php_version"/run/php-fpm/php"$php_version"-fpm.sock -pass-header Authorization
        </IfModule>
        <IfModule !mod_fastcgi.c>
            <IfModule mod_proxy_fcgi.c>
                <FilesMatch \".+\.ph(ar|p|tml)$\">
                    SetHandler \"proxy:unix:/var/opt/remi/php"$php_version"/run/php-fpm/php"$php_version"-fpm.sock|fcgi://localhost/\"
                </FilesMatch>
            </IfModule>
        </IfModule>
        BrowserMatch \"MSIE [2-6]\" \
            nokeepalive ssl-unclean-shutdown \
            downgrade-1.0 force-response-1.0
        # MSIE 7 and newer should be able to use keepalive
        BrowserMatch \"MSIE [17-9]\" ssl-unclean-shutdown

    </VirtualHost>
</IfModule>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
"

echo "$blockssl" > "/etc/httpd/sites-available/$1-ssl.conf"
ln -fs "/etc/httpd/sites-available/$1-ssl.conf" "/etc/httpd/sites-enabled/$1-ssl.conf"

sudo systemctl restart httpd
sudo systemctl restart php"$php_version"-php-fpm

if [ $? == 0 ]
then
    sudo systemctl reload httpd
fi
