heroku login
wait

heroku container:login --verbose
wait

app_url_arg=`heroku info -a dynkin-backend-strapi -s | grep web_url | cut -d= -f2`
database_url_arg=`heroku config:get DATABASE_URL -a dynkin-backend-strapi`
database_host_arg=$(node parse-pg-connection-string.js $database_url_arg host)
database_name_arg=$(node parse-pg-connection-string.js $database_url_arg database)
database_user_arg=$(node parse-pg-connection-string.js $database_url_arg user)
database_password_arg=$(node parse-pg-connection-string.js $database_url_arg password)
database_port_arg=$(node parse-pg-connection-string.js $database_url_arg port)

echo "DATABASE HOST: ${database_host_arg}"
echo "DATABASE NAME: ${database_name_arg}"
echo "DATABASE USERNAME: ${database_user_arg}"
echo "DATABASE PASSWORD: ${database_password_arg}"
echo "DATABASE PORT: ${database_port_arg}"

docker build -t registry.heroku.com/dynkin-backend-strapi/web \
  -f Dockerfile.production \
  --build-arg DATABASE_URL_ARG=$database_url_arg \
  --build-arg APP_URL_ARG=$app_url_arg \
  --build-arg DATABASE_HOST_ARG=$database_host_arg \
  --build-arg DATABASE_NAME_ARG=$database_name_arg \
  --build-arg DATABASE_USERNAME_ARG=$database_user_arg \
  --build-arg DATABASE_PASSWORD_ARG=$database_password_arg \
  --build-arg DATABASE_PORT_ARG=$database_port_arg \
  .

docker push registry.heroku.com/dynkin-backend-strapi/web
wait

heroku container:release web -a dynkin-backend-strapi --verbose