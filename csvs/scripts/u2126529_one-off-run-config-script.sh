#Network create
docker network create --subnet=203.0.113.0/24 u2126529/csvs2023_n

#db persistent
#Create volume for mysql
docker volume create mysql_volume


#Run dbserver and insert database and use volume
cd ../builds/dbserver
docker run -d --rm --net u2126529/csvs2023_n --ip 203.0.113.201 --hostname db.cyber23.test -e MYSQL_ROOT_PASSWORD="CorrectHorseBatteryStaple" -e MYSQL_DATABASE="csvs23db" --name u2126529_csvs2023-db_c \
-v mysql_volume:/var/lib/mysql \
u2126529/csvs2023-db_i

#Wait for container up
sleep 10s

#Insert database
docker exec -i u2126529_csvs2023-db_c mysql -uroot -pCorrectHorseBatteryStaple < sqlconfig/csvs23db.sql

#Wait for container insert
sleep 5s

#Kill container
docker kill u2126529_csvs2023-db_c


#web SElinux:
cd ../webserver
sudo make -f /usr/share/selinux/devel/Makefile u2126529_web.pp
#sudo csc
sudo semodule -i u2126529_web.pp
#sudo semodule -l | grep u2126529_web


#db SElinux 
cd ../dbserver
sudo make -f /usr/share/selinux/devel/Makefile u2126529_db.pp
sudo semodule -i u2126529_db.pp
#sudo semodule -l | grep u2126529_db



