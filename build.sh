
set -ev

docker build -t yglukhov/falcon falcon
docker push yglukhov/falcon
