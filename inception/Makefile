name = simple_nginx_html

all:
	@printf "make ${name}...\n"
	@mkdir -p $(HOME)/data/wordpress
	@mkdir -p $(HOME)/data/db
	@docker-compose -f ./srcs/docker-compose.yml up --build

build:
	@printf "build ${name}...\n"
	@docker-compose -f ./srcs/docker-compose.yml up -d --build

down:
	@printf "down ${name}...\n"
	@docker-compose -f ./srcs/docker-compose.yml down

clean: down
	@printf "cleaning ${name}...\n"
	@docker system prune -a

fclean:
	@sudo rm -rf $(HOME)/data/wordpress
	@sudo rm -rf $(HOME)/data/db
	@printf "clean all docker\n"
	@docker stop $$(docker ps -qa)
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force

re:
	@printf "re build ${name}...\n"
	@docker-compose -f ./srcs/docker-compose.yml up -d --build