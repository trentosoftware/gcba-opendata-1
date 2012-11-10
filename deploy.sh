#!/bin/bash
rake assets:clean
git pull
rake db:migrate
rake assets:precompile
sudo service nginx restart
