FROM debian:bullseye

RUN apt-get update
RUN apt-get install -y mariadb-server

COPY conf/my.cnf /etc/mysql/my.cnf
COPY conf/setup.sh /setup.sh

RUN chmod +x /setup.sh

EXPOSE 3306

CMD ["/setup.sh"]