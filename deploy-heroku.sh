heroku login
wait

heroku container:login --verbose
wait

app_url_arg=`heroku info -s | grep web_url | cut -d= -f2`
database_url_arg=`heroku config:get DATABASE_URL`
app_keys_arg=`cat .env | grep APP_KEYS | cut -d= -f2-`
api_token_salt_arg=`cat .env | grep API_TOKEN_SALT | cut -d= -f2`
admin_jwt_secret_arg=`cat .env | grep ADMIN_JWT_SECRET | cut -d= -f2`
jwt_secret_arg=`cat .env | grep -w JWT_SECRET | cut -d= -f2`

docker build -t registry.heroku.com/dynkin-backend-strapi/web \
  -f Dockerfile.production \
  --build-arg DATABASE_URL_ARG="$database_url_arg" \
  --build-arg APP_URL_ARG="$app_url_arg" \
  --build-arg APP_KEYS_ARG="$app_keys_arg" \
  --build-arg API_TOKEN_SALT_ARG="$api_token_salt_arg" \
  --build-arg ADMIN_JWT_SECRET_ARG="$admin_jwt_secret_arg" \
  --build-arg JWT_SECRET_ARG="$jwt_secret_arg" \
  .

docker push registry.heroku.com/dynkin-backend-strapi/web
wait

heroku container:release web --verbose