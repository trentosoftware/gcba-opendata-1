#!/bin/bash
sudo service nginx stop
rake assets:clean
git pull
rake db:drop RAILS_ENV=production
rake db:create RAILS_ENV=production
rake db:migrate RAILS_ENV=production
rake import:data RAILS_ENV=production
rake assets:precompile
sudo service nginx start
