Mconf-Web Caphub
================

Use [CapHub](https://github.com/railsware/caphub) to deploy Mconf-Web (and any other application you might wish to add) using [Capistrano](https://github.com/capistrano/capistrano).

If you know what Capistrano is and how it works, it should be straightforward to learn how to deploy Mconf-Web with it.

If you don't now what Capistrano is or have never used it before, this repository might not be the best option for you.
You can either take some time to learn Capistrano or proceed to install Mconf-Web without Capistrano (see how to in [our wiki](https://github.com/mconf/mconf-web/wiki)).

How to deploy Mconf-Web
-----------------------

Capistano is responsible for deploying the application, its dependencies and ensuring the database is up-to-date. It will not
install neither update other components you need in your server (e.g. Apache, monit, etc). These extra components have to
be installed and maintained by yourself without using Capistrano.

To install the extra components, you can follow the guides in [our wiki](https://github.com/mconf/mconf-web/wiki). Make sure you
pick the correct guide for the version of Mconf-Web you're installing.

In general, these are the steps you should follow:

1. Install system packages;
2. Install ruby;
3. Configure the database;
4. **Use Capistrano to deploy the application**. Read below how;
5. Install a web server (Apache) and an application server (Passenger);
6. Install and configure some other system-wide applications (Monit, logrotate, and possibly others).


### Using this repository

Having concluded the steps above up to the point where you should use Capistrano to deploy the application,
you can proceed to setting up this repository in your local machine.

This repository has file pre-configured to deploy the latest version of Mconf-Web (v0.8) and also the newer
version (from the master branch). Pick the one you want and edit the configuration files for it.

The steps you should follow to set up this repository:

* Fork this repository so you can edit the files and add your own configurations. It might be useful to make a private repository, so you can store sensitive data in it.
* Install ruby. We recommend using [rbenv](https://github.com/sstephenson/rbenv). See `.ruby-version` for the version you should use.
* Install Capistrano and other dependencies with `bundle install`.
* There are two stages prepared in this repository: `v0.8` and `master`. You can edit them as much as you want and also add new stages if needed.
* Configure the files that will be used to configure your application, they are at (if you need help configuring these files check the appropriate pages in [our wiki](https://github.com/mconf/mconf-web/wiki)):
  * `config_files/mconf-web/v0.8/*`
  * `config_files/mconf-web/master/*`
* Configure the environment to point to your server, the files to be edit are:
  * `config/deploy/mconf-web/v0.8.rb`
  * `config/deploy/mconf-web/master.rb`
* Start using it! The syntax for the Capistrano commands is:
  * `cap mconf-web:stage task`, where `stage` is replaced by `v0.8` or `master` and `task` is replaced by the Capistrano task to be executed.

When setting up a new server, these are the tasks you should run:

    cap mconf-web:staging deploy:setup
    cap mconf-web:staging deploy:update
    cap mconf-web:staging deploy:secret
    cap mconf-web:staging deploy:db:reset
    cap mconf-web:staging deploy:migrations
    cap mconf-web:staging deploy:restart
