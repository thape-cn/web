[![CircleCI](https://circleci.com/gh/thape-cn/web.svg?style=svg)](https://circleci.com/gh/thape-cn/web)

# README


## Introduce video (Chinese)

[![Watch the video](https://i.ytimg.com/vi/eJvLOpA4NtM/hqdefault.jpg)](https://www.youtube.com/watch?v=eJvLOpA4NtM&t=59s)

## Slide

[rubyconf2020-tailwind-css-rails6-alpinejs](https://www.thape.com/uploads/rubyconf2020-tailwind-css-rails6-alpinejs.key)

## Steps to build the local dev.

### Generate dummy settings

```
bundle install
yarn install
RAILS_ENV=production bin/webpack
bin/webpack-dev-server
bin/rails s # run in seperate console
```

## Import to dev DB.

```bash
unzip thape_web_prod.zip
psql -d postgres
DROP DATABASE thape_web_dev;
CREATE DATABASE thape_web_dev WITH ENCODING='UTF8';
\q
psql -d thape_web_dev -f thape_web_prod.sql
```

## Import to dev DB in WSL2 Ubuntu

```bash
sudo service postgresql start
sudo -u postgres createuser yxh
sudo -u postgres createdb thape_web_dev
psql -d thape_web_dev -f thape_web_prod.sql
```

## Export production DB

```bash
/usr/pgsql-13/bin/pg_dump thape_web_prod -O -x > thape_web_prod.sql
zip thape_web_prod.zip thape_web_prod.sql
```
