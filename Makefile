################
# General Jobs #
################

default: configure deploy

configure: config-docker config-mongodb

queries: query_importer


###################
# Individual jobs #
###################

deploy:
	@	sudo TAG=$(TAG) docker-compose $(YML) pull
	@	sudo TAG=$(TAG) docker-compose $(YML) build
	@	sudo TAG=$(TAG) docker-compose $(YML) up -d

config-docker:
	@ wget -qO- https://raw.githubusercontent.com/PDCbc/devops/master/docker_setup.sh | sh

config-mongodb:
	@	( echo never | sudo tee /sys/kernel/mm/transparent_hugepage/enabled )> /dev/null
	@	( echo never | sudo tee /sys/kernel/mm/transparent_hugepage/defrag )> /dev/null
	@	if(! grep --quiet 'never > /sys/kernel/mm/transparent_hugepage/enabled' /etc/rc.local ); \
		then \
			sudo sed -i '/exit 0/d' /etc/rc.local; \
			( \
				echo ''; \
				echo '# Disable Transparent Hugepage, for Mongo'; \
				echo '#'; \
				echo 'echo never > /sys/kernel/mm/transparent_hugepage/enabled'; \
				echo 'echo never > /sys/kernel/mm/transparent_hugepage/defrag'; \
				echo ''; \
				echo 'exit 0'; \
			) | sudo tee -a /etc/rc.local; \
		fi; \
		sudo chmod 755 /etc/rc.local

query_importer:
	sudo docker pull pdcbc/hapi:latest
	sudo docker run -d --name query_importer --link hubdb:hubdb pdcbc/hapi:latest
	sudo docker exec query_importer /app/queryImporter/import_queries.sh
	sudo docker rm -fv query_importer
	

################
# Runtime prep #
################

# Default tag is latest
#
TAG ?= latest


# Default YML is base.yml
#
YML ?= -f ./docker-compose.yml
ifeq ($(MODE),dev)
	YML += -f ./dev/dev.yml
endif
