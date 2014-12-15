#!/bin/bash

# jenins build step to publish p2 repo to bintray
# p2 url: http://dl.bintray.com/pulse00/pdt-extensions/nightly/0.0.1/

$USER=<user>
$API_KEY=<key>
$REPO=pdt-extensions
$PACKAGE=nightly
$VERSION=0.0.1

# upload artifacts.jar/content.jar
curl -T $WORKSPACE/org.pex.p2-mirror.mirror/mirror/final/artifacts.jar -u$USER:$API_KEY https://api.bintray.com/content/$USER/$REPO/$PACKAGE/$VERSION/artifacts.jar
curl -T $WORKSPACE/org.pex.p2-mirror.mirror/mirror/final/content.jar -u$USER:$API_KEY https://api.bintray.com/content/$USER/$REPO/$PACKAGE/$VERSION/content.jar

# upload features
FILES=$WORKSPACE/org.pex.p2-mirror.mirror/mirror/final/features/*
for f in $FILES
do
  name=eval basename $f
  echo $f
  curl -T $f -u$USER:$API_KEY https://api.bintray.com/content/$USER/$REPO/$PACKAGE/$VERSION/features/$name
done

# upload plugins
FILES=$WORKSPACE/org.pex.p2-mirror.mirror/mirror/final/plugins/*
for f in $FILES
do
  name=eval basename $f
  curl -T $f -u$USER:$API_KEY https://api.bintray.com/content/$USER/$REPO/$PACKAGE/$VERSION/plugins/$name
done

# publish package
curl -vvf -u$USER:$API_KEY -H "Content-Type: application/json" -X POST https://api.bintray.com/content/$USER/$REPO/$PACKAGE/$VERSION/publish --data "{ \"discard\": \"false\" }"

