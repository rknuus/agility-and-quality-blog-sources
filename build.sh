#!/bin/bash -x

# only proceed script when started not by pull request (PR)
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "this is a PR, exiting"
  exit 0
fi

# enable error reporting to the console
set -e

build_blog() {
  bundle exec jekyll build
  # copying Jekyll configuration triggers Jekyll, again, in the blog repo,
  # but otherwise the pages apparently don't get hosted
  cp _config.yml _site/
}

setup_git() {
  git config --global user.email "rknuus@gmail.com"
  git config --global user.name "rknuus"
}

clone_host_repo() {
  rm -rf blog || true
  git clone -b master https://${GH_TOKEN}@github.com/rknuus/rknuus.github.io.git blog
}

commit_website_files() {
  pushd blog
  # clean old content first
  find . ! -path . -name "*" | grep -v ".git" | xargs rm -rf
  cp -r ../_site/* ./
  git add .
  git commit --message "Travis build: $TRAVIS_BUILD_NUMBER"
  popd
}

publish_blog() {
  pushd blog
  git remote add origin-site https://${GH_TOKEN}@github.com/rknuus/rknuus.github.io.git
  git push --quiet --set-upstream origin-site master
  popd
}

build_blog
setup_git
clone_host_repo
commit_website_files
publish_blog