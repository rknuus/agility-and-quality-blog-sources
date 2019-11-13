#!/bin/bash

rm -rf _site
bundle exec jekyll build
pushd ../agile-and-quality-blog/
find . ! -path . -name "*" | grep -v ".git" | xargs rm -rf
popd
cp _config.yml ../agile-and-quality-blog/
cp -r _site/* ../agile-and-quality-blog/