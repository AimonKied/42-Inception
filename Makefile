DATA_DIR = /home/swied/data

all: $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress
	docker compose -f srcs/docker-compose.yml up --build -d

$(DATA_DIR)/mariadb:
	mkdir -p $(DATA_DIR)/mariadb

$(DATA_DIR)/wordpress:
	mkdir -p $(DATA_DIR)/wordpress

down:
	docker compose -f srcs/docker-compose.yml down

clean: down
	docker system prune -af

fclean: clean
	rm -rf $(DATA_DIR)
	docker volume prune -f

re: fclean all

.PHONY: all down clean fclean re
