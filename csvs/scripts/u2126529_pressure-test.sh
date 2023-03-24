# Test script

proper_count=0

for (( i=1; i<=100; i++))
do

# Send POST request
  value=$RANDOM
  #echo $value
  Post_response=$(curl --write-out "%{http_code}" --silent --output /dev/null --max-time 3 -X POST -d "fullname=$value&suggestion=$value" http://localhost/action.php)
  echo $Post_response

  # Send GET request
  Get_response=$(curl --write-out "%{http_code}" --silent --output /dev/null --max-time 3 http://localhost/index.php)
  echo $Get_response

  # Send value request
  Get_value=$(curl --silent --max-time 3 http://localhost/index.php | grep -o "$value")
  #echo $Get_value
  

  # Send error request
  Get_error=$(curl -s --max-time 3 http://localhost/index.php/12345 | grep -o "error")
  #echo $Get_error


  if [[ $Get_response -eq 200 && $Get_value == *"$value"* && $Post_response -eq 302 && $Get_error == *"error"* ]]; then
    echo "Running properly"
    ((proper_count++))

  else 
    echo "Not success"

  fi

done

echo "Proper count: $proper_count"
