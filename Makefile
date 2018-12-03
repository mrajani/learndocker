.PHONY: up down start stop cleanContainers clean

up:
	docker-compose up $(opts)

down:
	docker-compose down $(opts)

start:
	docker-compose up -d $(opts)

cc:
	docker-compose rm --force

cv:
	rm -rf volumes

clean: cc cv

