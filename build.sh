
set -ev

TAG=$(date "+%Y%m%d%H%M")

echo "The falcon image will be tagged as $TAG"

if [ "$1" = "all" -o "$BUILD_ALL" = "true" ]
then
    docker build -t yglukhov/falcon-pre-nim falcon-pre-nim
    docker push yglukhov/falcon-pre-nim
fi

docker build -t yglukhov/falcon:$TAG falcon
docker push yglukhov/falcon:$TAG
