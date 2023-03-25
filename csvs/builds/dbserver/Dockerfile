# Database Dockerfile

FROM mariadb:10

COPY configfiles/mysqld.cnf  /mysql/mysql.conf.d/mysqld.cnf

# assign user
USER mysql

EXPOSE 3306
