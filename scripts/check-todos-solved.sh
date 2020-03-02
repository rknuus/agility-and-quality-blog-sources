#!/bin/bash

set -e

fail() {
    echo "found unresolved TODO, will fail build"
    exit 1
}

cd "$( dirname "${BASH_SOURCE[0]}" )/.."

STATIC_FILES="404.html about.adoc index.html"
! grep -q "TODO" ${STATIC_FILES} || fail

! grep -q "TODO" $(find _posts -name "*.adoc") || fail
! grep -q "TODO" $(find _layouts -name "*.html") || fail