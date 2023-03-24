#web
cd ../builds/webserver

docker run -d --rm --net u2126529/csvs2023_n --ip 203.0.113.200 --hostname www.cyber23.test --add-host db.cyber23.test:203.0.113.201 -p 80:80 --name u2126529_csvs2023-web_c \
--security-opt label:type:u2126529_web_t \
--security-opt seccomp:u2126529_web.json \
--cap-drop=ALL \
--cap-add=chown \
--cap-add=net_bind_service \
--cap-add=dac_override \
--cap-add=setgid \
--cap-add=setuid \
u2126529/csvs2023-web_i.slim



#db
cd ../dbserver
docker run -d --rm --net u2126529/csvs2023_n --ip 203.0.113.201 --hostname db.cyber23.test -e MYSQL_ROOT_PASSWORD="CorrectHorseBatteryStaple" -e MYSQL_DATABASE="csvs23db" --name u2126529_csvs2023-db_c \
--security-opt label:type:u2126529_db_t \
--security-opt seccomp:u2126529_db.json \
--cap-drop=ALL \
-v mysql_volume:/var/lib/mysql \
u2126529/csvs2023-db_i.slim
