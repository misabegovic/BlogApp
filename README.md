# Dependencies

You must have redis installed and running on the default port:6379 (or configure it in config/redis/cable.yml).
You must have mysql installed and running.

# Installing Redis

# On Linux
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make
make install

# On Mac
brew install redis

# Steps to run:
- make sure you have mysql setup properly
- run redis on your machine
- rvm use 2.7.0 (set ruby version to 2.7.0)
- bundle install
- rails db:create
- rails db:migrate
- rails s

# For running tests, execute:
- rspec
