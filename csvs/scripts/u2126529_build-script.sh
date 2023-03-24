#Build web images
cd ../builds/webserver
docker build . --tag u2126529/csvs2023-web_i
#Build db images
cd ../dbserver
docker build . --tag u2126529/csvs2023-db_i


#Strip
#Docker slim
curl -sL https://raw.githubusercontent.com/slimtoolkit/slim/master/scripts/install-slim.sh | sudo -E bash -

#sudo csc

#Enter in docker slim
slim
#Build webslim images
build --target u2126529/csvs2023-web_i:latest --include-path '/var/lib/nginx/tmp/client_body' --include-path '/usr/share/nginx/html' --tag u2126529/csvs2023-web_i.slim
exit

slim
#Build dbslim images
build --target u2126529/csvs2023-db_i:latest --http-probe-off --include-path '/etc/mysql/conf.d' --include-path '/run/mysqld/' --tag u2126529/csvs2023-db_i.slim
#Press enter

exit

#list images
docker images
