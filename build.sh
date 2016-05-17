
set -ev

if [ "$1" = "all" -o "$BUILD_ALL" = "true" ]
then
    docker build -t yglukhov/falcon-pre-nim falcon-pre-nim
    docker push yglukhov/falcon-pre-nim
fi

docker build -t yglukhov/falcon falcon
docker push yglukhov/falcon
