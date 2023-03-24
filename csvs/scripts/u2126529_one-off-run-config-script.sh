#Network create
docker network create --subnet=203.0.113.0/24 u2126529/csvs2023_n

#db persistent
#Create volume for mysql
docker volume create mysql_vol

#Insert database
cd ../builds/dbserver
#Run dbserver
docker run -d --rm --net u2126529/csvs2023_n --ip 203.0.113.201 --hostname db.cyber23.test -e MYSQL_ROOT_PASSWORD="CorrectHorseBatteryStaple" -e MYSQL_DATABASE="csvs23db" --name u2126529_csvs2023-db_c \
-v mysql_vol:/var/lib/mysql \
u2126529/csvs2023-db_i

#wait for container up
sleep 10s

docker exec -i u2126529_csvs2023-db_c mysql -uroot -pCorrectHorseBatteryStaple < sqlconfig/csvs23db.sql


docker kill u2126529_csvs2023-db_c
#web:
cd ../webserver

#web SElinux:
sudo make -f /usr/share/selinux/devel/Makefile u2126529_web.pp
#sudo csc
sudo semodule -i u2126529_web.pp
#sudo semodule -l | grep u2126529_web

#db
cd ../dbserver
#db SElinux
sudo make -f /usr/share/selinux/devel/Makefile u2126529_db.pp
sudo semodule -i u2126529_db.pp
#sudo semodule -l | grep u2126529_db



