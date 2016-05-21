################
# General Jobs #
################

default: config-mongodb deploy queries sample-data

configure: config-docker config-mongodb

queries: query-importer


###################
# Individual jobs #
###################

deploy:
	@	which docker-compose || make config-docker
	@	[ -s ./dev/dev.yml ] || sudo cp ./dev/dev.yml-sample ./dev/dev.yml
	@	sudo TAG=$(TAG) VOLS=${VOLS} docker-compose $(YML) pull
	@	sudo TAG=$(TAG) VOLS=${VOLS} docker-compose $(YML) build
	@	sudo TAG=$(TAG) VOLS=${VOLS} docker-compose $(YML) up -d

config-docker:
	@	wget -qO- https://raw.githubusercontent.com/PDCbc/devops/master/docker_setup.sh | sh

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

query-importer:
	sudo docker pull healthdatacoalition/queryimporter:latest
	sudo docker run --rm --name=queryimporter -h queryimporter --link composerdb:composerdb healthdatacoalition/queryimporter:latest

export:
	sudo docker pull healthdatacoalition/analyticbridge:latest
	sudo docker run --rm --name=bridge -h bridge --link composerdb:database -v /hdc/config/bridge:/app/config -v /hdc/private/bridge:/app/scorecards healthdatacoalition/analyticbridge:latest

sample-data:
	sudo docker exec endpoint /gateway/util/sample10/import.sh || true



################
# Runtime prep #
################

# Default tag and volume path
#
TAG  ?= latest
VOLS ?= /hdc


# Default YML is base.yml
#
YML ?= -f ./docker-compose.yml
ifeq ($(MODE),dev)
	YML += -f ./dev/dev.yml
endif
