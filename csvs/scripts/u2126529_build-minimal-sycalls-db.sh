#!/bin/bash
# find minimal syscalls by removing from default syscalls

rm list-of-min-syscalls
while read s
do
  echo "$s  being removed from moby-default.json"
  grep -v "\"${s}\"" ./moby-default.json > tmp.json

  docker run -d --rm --net u2126529/csvs2023_n --ip 203.0.113.201 --hostname db.cyber23.test -e MYSQL_ROOT_PASSWORD="CorrectHorseBatteryStaple" -e MYSQL_DATABASE="csvs23db" --name u2126529_csvs2023-db_c \
--security-opt label:type:u2126529_db_t \
--security-opt seccomp:tmp.json u2126529/csvs2023-db_i  

  # Wait for container to start
  sleep 10s
  echo "sleep"
  
  # prepare for database
  timeout 3 docker exec -i u2126529_csvs2023-db_c mysql -uroot -pCorrectHorseBatteryStaple < sqlconfig/csvs23db.sql

  # Send POST request
  value=$RANDOM
  echo $value
  Post_response=$(curl --write-out "%{http_code}" --silent --output /dev/null --max-time 3 -X POST -d "fullname=$value&suggestion=$value" http://localhost/action.php)
  echo $Post_response

  # Send GET request
  Get_response=$(curl --write-out "%{http_code}" --silent --output /dev/null --max-time 3 http://localhost/index.php)
  echo $Get_response

  # Send value request
  Get_value=$(curl --silent --max-time 3 http://localhost/index.php | grep -o "$value")
  echo $Get_value
  


  if [[ $Get_response -eq 200 && $Get_value == *"$value"* && $Post_response -eq 302 ]]; then
    echo "$s is running properly, do nothing"
	
  else 
    echo "$s is not success, adding to list-of-min-syscalls"
    echo $s >> list-of-min-syscalls

  fi
  # kill docker
  docker kill u2126529_csvs2023-db_c

done < ./moby-syscalls



