#!/bin/bash

set -x

BRANCH=$1
echo "Deploying to production (fetch the latest isucon-qualify)..."


cd /home/isucon && \
git stash && \
git checkout $BRANCH && \
git pull origin $BRANCH

# TODO: 必要ならrestart処理・集計処理などを追記


