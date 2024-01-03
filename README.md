# Wordpress Docker

This project sets up Wordpress inside a docker-compose stack to promote infra-as-code, consistency and portability.

It utilizes LetsEncrypt and Certbot to manage digital (SSL/TLS) certificates for the website.


# Quick Set Up

* Replace all instances of 'mydomain.test' in all files with a real domain.
* Export relevant environment variables
```bash
export TF_VAR_DoToken=token
export WORDPRESS_DB_PASSWORD=$(random password)
export MYSQL_ROOT_PASSWORD=$(random password)
```
* Run ```terraform apply``` to set up the server
* Download a fresh copy of wordpress to the webroot directory on the host
* Copy this repo to the host
* Run ```docker-compose up -d``` to start the stack. Use ```docker-compose logs -f``` to monitor logs
* Get a certificate with:
```bash
certbot certonly -d mydomain.test --webroot -w /path/to/wordpress/webroot/
```
* Set up cert auto renewal with a crontab
```bash
certbot renew
docker restart wordpress_web_1
```

A more detailed setup is available on 