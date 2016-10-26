# NBA Fantasy Prediction

* Ruby version: 2.3.0
* Rails version: 5.0.0

* Configuration
Run..
$ bundle install
$ bundle update

* Database creation
Run..
$ rails db:migrate

* Database initialization
There are three parts to the db/seeds.rb file
 - seed players model with initial players data (from espn & pbbr)
 - seed playergames model (from pbbr)
 - finish seeding players (from data in playergames model)

# nba_fantasy
