# gemstrapper
[![Build Status](https://travis-ci.org/thoiberg/gemstrapper.svg?branch=master)](https://travis-ci.org/thoiberg/gemstrapper)

gemstrapper is a small gem that can create directories and common files for building gems.

## Installing

To install gemstrapper use the following command:

    $ gem install gemstrapper

## Usage

To use gemstrapper run the `init <gem_name>` command, which will generate the folders and files in the
current working directory

    $ gemstrapper init my-gem
    my-gem/Gemfile created
    my-gem/my-gem.gemspec created
    my-gem/lib/my-gem/version.rb created

The application will generate the basic scaffolding for a gem as well as common files, such as the gemspec 
and Gemfile. The top level module is created by converting the gem name into valid Ruby syntax for constants,
eg `my-gem` will become `MyGem`

To configure the gem to have an executable component you can add the `-e` or `--executable` argument to the `init`
subcommand

    $ gemstrapper init my-gem -e
    ...
    my-gem/bin/my_gem created

## License

gemstrapper is licensed under the [MIT license](LICENSE)