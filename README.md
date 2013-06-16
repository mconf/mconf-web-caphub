Mconf-Web Caphub
================

[Caphub](https://github.com/railsware/caphub) repository to deploy Mconf-Web (and any other application you might wish to add) using [Capistrano](https://github.com/capistrano/capistrano).
First learn how Capistrano and Caphub work and you will understand how to use the files in this repository.

How to deploy Mconf-Web
-----------------------

Part of the setup is made manually (using instructions in a wiki), part is made using the scripts in this repository.
The manual part is made only once, while the scripts here are used to update and maintain the server.

In your **target server**:

1. [Install system packages](https://github.com/mconf/mconf-web/wiki/Mconf-Web-Deployment-Manual#1-system-packages)
2. [Install ruby](https://github.com/mconf/mconf-web/wiki/Mconf-Web-Deployment-Manual#2-ruby) _(TODO: only RVM might be enough, now Capistrano installs ruby)_
3. [Configure the DB](https://github.com/mconf/mconf-web/wiki/Mconf-Web-Deployment-Manual#41-database-user)
4. **Use Capistrano to deploy the application!** Read below how.
5. [Install a web server](https://github.com/mconf/mconf-web/wiki/Mconf-Web-Deployment-Manual#6-web-server)
6. [Install some other system-wide applications](https://github.com/mconf/mconf-web/wiki/Mconf-Web-Deployment-Manual#7-system-wide-configurations)

### Using this repository

General steps to run in your **development machine**:

* Install ruby. We recommend [rbenv](https://github.com/sstephenson/rbenv).
* Install Capistrano and other dependencies: `bundle install`
* Fork this repository so you can edit the files and add your own configurations. It might be useful to make a private repository, so you can store passwords in it.
* There are two environments prepared in this repository: `staging` and `production` (but you can add as many as you want).
  * `staging` is supposed to be your test server.
  * `production` is supposed to be your production server.
* Configure the files that will be used to configure your application, they are at (if you need help configuring these files see [this page](https://github.com/mconf/mconf-web/wiki/Mconf-Web-Configuration-Files)):
  * `config_files/mconf-web/staging/*`
  * `config_files/mconf-web/production/*`
* Configure the environment to point to your server, the files to be edit are:
  * `config/deploy/mconf-web/staging.rb`
  * `config/deploy/mconf-web/production.rb`
* Start using it! The syntax for the Capistrano commands is:
  * `cap mconf-web:stage task`, where `stage` is replaced by `staging` or `production` and `task` is replaced by the Capistrano task to be executed.

First setup:

    cap mconf-web:staging deploy:setup
    cap mconf-web:staging deploy:update
    cap mconf-web:staging setup:basic
