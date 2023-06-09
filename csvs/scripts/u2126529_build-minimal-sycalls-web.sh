#!/bin/bash
# find minimal syscalls by removing from default syscalls

rm list-of-min-syscalls
while read s
do
  echo "$s  being removed from moby-default.json"
  grep -v "\"${s}\"" ./moby-default.json > tmp.json

  docker run -d --rm --net u2126529/csvs2023_n --ip 203.0.113.200 --hostname www.cyber23.test --add-host db.cyber23.test:203.0.113.201 -p 80:80 --name u2126529_csvs2023-web_c \
--security-opt label:type:u2126529_web_t \
--security-opt seccomp:tmp.json u2126529/csvs2023-web_i


  # Wait for container to start
  sleep 5s
  
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
  

  # Send error request
  Get_error=$(curl -s --max-time 3 http://localhost/index.php/12345 | grep -o "error")
  echo $Get_error


  if [[ $Get_response -eq 200 && $Get_value == *"$value"* && $Post_response -eq 302 && $Get_error == *"error"* ]]; then
    echo "$s is running properly, do nothing"
	
  else 
    echo "$s is not success, adding to list-of-min-syscalls"
    echo $s >> list-of-min-syscalls

  fi

  # kill docker
  docker kill u2126529_csvs2023-web_c

done < ./moby-syscalls



