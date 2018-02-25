.PHONY: *

all: init 

build-base:
	docker build -t build-env -f Dockerfile.build .

init:
	chown -R www-data:www-data /project	
	composer install
	git clone https://github.com/joomlatools/joomlatools-console.git
	composer install -d joomlatools-console
	
reset:
	docker exec joomla sh -c 'joomlatools-console/bin/joomla site:install --www=/var/www -Lroot:mariaSql -Hmariadb --overwrite --drop --projects-dir=/var/www/html --mysql-database=joomla -- html'
	docker exec joomla sh -c 'chown -R www-data:www-data /var/www/'	
	docker exec joomla sh -c 'curl -O https://dev.virtuemart.net/attachments/download/1111/com_virtuemart.3.2.12.9708_extract_first.zip'
	docker exec joomla sh -c 'unzip com_virtuemart.3.2.12.9708_extract_first.zip'
	docker exec joomla sh -c 'joomlatools-console/bin/joomla --www=/var/www extension:installfile html com_virtuemart.3.2.12.9708.zip'
	docker exec joomla sh -c 'joomlatools-console/bin/joomla --www=/var/www extension:installfile html com_virtuemart.3.2.12.9708_ext_aio.zip'
	docker exec joomla sh -c 'joomlatools-console/bin/joomla --www=/var/www extension:installfile html com_tcpdf_1.0.4.zip'

up:
	docker-compose up -d

down:
	docker-compose down
