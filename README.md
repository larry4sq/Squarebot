Squarebot!
=====

He's a Foursquare aware campfire bot that tells you where your friends are when you ask him!

### Getting started

* bootstrap:

> gem install activesupport json yajl-ruby daemons

* create a config.yml file in the project root (see config.yml.example) with campfire + foursquare api information
> ./script/console (to test locally)
> ./script/run (to run in the foreground)
> ./script/daemon (to start him in the background)
Basic commands:
----

> @squarebot where is frank? #firstname!
>
> @squarebot where is DW #initials!


(@squarebot can also be the campfire Squarebot: syntax too)



PLUGINS
----
He's built with a plugin system so that you can make him do more things. (see lib/plugins/example.rb)
add options to the config file and have them passed to your plugin when you register it (see lib/plugins/where_is.rb as an example)

