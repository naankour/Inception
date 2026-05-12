NAME = inception

all: 
	cd srcs && sudo docker compose up -d

build: 
	sudo mkdir -p /home/naankour/data/wp_data
	sudo mkdir -p /home/naankour/data/mariadb_data
	cd srcs &&	sudo docker compose up --build -d

down:
	cd srcs && sudo docker compose down

clean: 
	cd srcs && sudo docker compose down -v

fclean: clean
	sudo rm -rf /home/naankour/data/wp_data/*
	sudo rm -rf /home/naankour/data/mariadb_data/*
	sudo rm -rf /home/naankour/data/
	sudo mkdir -p /home/naankour/data/wp_data
	sudo mkdir -p /home/naankour/data/mariadb_data

re: fclean build

.PHONY: all build down clean fclean re