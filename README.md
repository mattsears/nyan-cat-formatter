Nyan Cat RSpec Formatter [![Build Status](https://secure.travis-ci.org/mattsears/nyan-cat-formatter.png)](http://travis-ci.org/mattsears/nyan-cat-formatter)
========

```
-_-_-_-_-_-_-_,------,
_-_-_-_-_-_-_-|   /\_/\
-_-_-_-_-_-_-~|__( ^ .^)
_-_-_-_-_-_-_-""  ""
```

This is my take on the Nyan Cat RSpec Formatter. It simply creates a rainbow trail of test results. It also counts the number of examples as they execute and highlights failed and pending specs.

The rainbow changes colors as it runs. See it in action [here](http://vimeo.com/32424001).

Works with RSpec 1.3 and RSpec 2.

Using  Nyan Cat
---------------

You can either specify the formatting when using the `rspec` command:

    rspec --format NyanCatFormatter

Or add `--format NyanCatFormatter` to a `.rspec` file placed in your project's root directory,
so that you won't have to specify the `--format` option everytime you run the command.

###Using with Bundler

To use Nyan Cat with a project that uses Bundler (Rails or Sinatra f.e.) you need to add Nyan Cat dependecy to your Gemfile:

    group :test do
      gem "nyan-cat-formatter"
    end

And then run `bundle install`.

Installing it
-------------

```
$ gem install nyan-cat-formatter
```

If you want to use Nyan Cat as your default formatter, simply put the options in your .rspec file:

```
--format NyanCatFormatter
```

Contributing
----------

Once you've made your great commits:

1. Fork Nyan Cat
2. Create a topic branch - git checkout -b my_branch
3. Push to your branch - git push origin my_branch
4. Create a Pull Request from your branch
5. That's it!

Author
----------
[Matt Sears](https://wwww.mattsears.com) :: @mattsears

