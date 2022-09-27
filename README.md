# Request::History

This gem introduces the Request History pattern and should be used with Rails applications running in [Puma](https://puma.io/).

The `Request History` pattern aims for traceability, on specific controllers' actions, in order to
understand how the state of the system changes over time.

The gem is built to ensure that the request response time doesn't change by the history management,
since it is, in general, a non functional requirement. In order to achieve that, the gem uses
[Puma after_reply](https://github.com/puma/puma/blob/e9f09ba1fe6b168bed7fff59d0bdbfd65351cf9d/lib/puma/request.rb#L69)
feature.

## Table of contents

- [Getting started](#getting-started)
- [Usage](#usage)
  - [Including the ability to record to a controller](#including-the-ability-to-record-to-a-controller)
  - [Defining the rules for the controller record management](#defining-the-rules-for-the-controller-record-management)
  - [Creating a storage](#creating-a-storage)
- [Documentation](#documentation)
- [Development](#development)
  - [Style guide](#style-guide)
  - [Running tests](#running-tests)
  - [Generating documentation](#generating-documentation)
- [Release](#release)
  - [Releasing a new version of the gem](#releasing-a-new-version-of-the-gem)
  - [Releasing changes in the documentation](#releasing-changes-in-the-documentation)

## Getting started

Add this line to your application's Gemfile:

```ruby
gem 'request-history', git:  'https://github.com/marcelorxaviers/request-history.git'
```

And then execute:

```shell
bundle
```

## Usage

### Including the ability to record to a controller
```ruby
    class SomeController < ApplicationController
      include Request::History::Recording
      ...
    end
```

### Defining the rules for the controller record management
Check the possible callback parameter options at rails
[docs](https://api.rubyonrails.org/v7.0.3.1/classes/AbstractController/Callbacks/ClassMethods.html).

The record definition works as any other rails' action callback:
```ruby
    class SomeController < ApplicationController
      include Request::History::Recording
        recording except: :show, if: -> { params["name"].present? }
        ...
    end
```
**The instance `record` method is used by the callback.**


There are three other parameters to added to it, `storage` (required), `params` (optional) and
`async` (optional) :
```ruby
    class SomeController < ApplicationController
      include Request::History::Recording

      recording async: true, params: :say, storages: FileStorage
      ...
    end

```

The `storages` argument is defined per controller and can be as many classes as one wants, but at
least one is required:
```ruby
    class SomeController < ApplicationController
      include Request::History::Recording
        recording storages: [DefaultStorage, AnotherStorage, FileStorage, ...], ...
        ...
    end
```
Check the [creating a storage](#creating-a-storage) section for detailed information
about storages.

The `params` argument is defined per controller and will attempt to find it in any action.
One needs, therefore, to add all of the possible parameters for all covered actions, even if one
specific action do not need or have it. Let's say that, for example, on a given controller the index
action allows for `age` parameter and the create action allows for `name` parameter, then the
following would be the record definition:
```ruby
    ...
    class SomeController < ApplicationController
      include Request::History::Recording
        recording params: %i(age, name), ...
        ...
    end
```
**If the params argument is missing, then no parameters are going to be saved. This is due to the
fact that we want to avoid storing sensitive information accidentally, such as passwords or tokens.**


The `async` argument is defined per controller and it defaults to `true`:
```ruby
    ...
    class SomeController < ApplicationController
      include Request::History::Recording
        recording async: false, ...
        ...
    end
```

### Creating a storage
In order to save the request history record, it is necessary to create a storage. A storage can be
any object that implements the `store` method:
```ruby
    class Request::History::FileStorage
      def self.store(**record)
        `echo "#{record}" > ~/record.txt`
      end
    end
```

## Documentation

At this moment, `Request::History` does not have documentation.

## Development

Before submitting a patch, please make sure:

- the code honors the [style guide](#style-guide).
- [the test suite passes](#running-tests).

### Style guide

Before submitting a patch, please make sure that the code is formatted executing this command:

```shell
$ rubocop -A
```

### Running tests
The test suite can be executed with the following command:

```shell
$ rake test
```

### Generating documentation

At this moment, `Request::History` does not have documentation.

## Release

### Releasing a new version of the gem

These are the steps to release a new version of the package:

1. Edit the `Request::History::VERSION` constant in the `lib/request/history/version.rb`
    file. Please, use [Semantic Versioning](https://semver.org/).
2. Set the version header and date in the `CHANGELOG.md` file.
3. Update the installation instructions in the `README.md` file (if needed).
4. Commit the changes directly to the `master` branch using the message `v<version>`
    (for example `v0.1.0`), and push your changes `git push`.
5. Tag the previous commit with the version number `git tag v<version>`
    (for example `git tag v0.1.0`), and push the tag `git push --tags`.

Once the gem is released, please notify the users about the new version so they can update all the
gems and projects that depend on this gem.

### Releasing changes in the documentation

At this moment, `Request::History` does not have documentation.
