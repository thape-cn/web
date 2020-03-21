[![CircleCI](https://circleci.com/gh/thape-cn/web.svg?style=svg)](https://circleci.com/gh/thape-cn/web)

# README

## Steps to build the local dev.

### Generate dummy settings

```
bundle install
yarn install
RAILS_ENV=production bin/webpack
bin/webpack-dev-server
bin/rails s # run in seperate console
```
