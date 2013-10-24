[![Build Status](https://travis-ci.org/aslong/word-frequency-analyzer.png?branch=master)](https://travis-ci.org/aslong/word-frequency-analyzer)
[![Node Dependencies](https://david-dm.org/aslong/word-frequency-analyzer.png)](https://david-dm.org/aslong/word-frequency-analyzer.png)
[![Node devDependency Status](https://david-dm.org/aslong/word-frequency-analyzer/dev-status.png)](https://david-dm.org/aslong/word-frequency-analyzer#info=devDependencies)

# Word Frequency Analyzer
  
The word frequency analyzer takes a string of text, parses it into words, and returns a sorted list by frequency of the words in the text.  

The analyzer was written using [Coffeescript](http://coffeescript.org/) and [Node.js](http://nodejs.org/). [Grunt](http://gruntjs.com/) is used for management of compilation, starting/restarting of service, running of test suites using [Mocha](http://visionmedia.github.io/mocha/) and [Should.js](https://github.com/visionmedia/should.js/). [YUIDoc](http://yui.github.io/yuidoc/) is used for documentation generation.

Provisioning for the service is done using [Chef](http://www.opscode.com/chef/). [Vagrant](http://www.vagrantup.com/) is used with [Chef](http://www.opscode.com/chef/) for creating an isolated and replicatable working environment. [Berkshelf](http://berkshelf.com/) is used for iterating on the cookbook and can
be re-enabled in the [Vagrantfile](https://github.com/aslong/word-frequency-analyzer/blob/master/Vagrantfile).

[Travis CI](https://travis-ci.org/) is used for continuous integration, currently for running test suites for latest build. [David-dm](https://david-dm.org/) is used for npm modules, both dev dependencies, and core dependencies.

### Installation

The word frequency analyzer uses [Vagrant](http://www.vagrantup.com/) for building an isolated environment necessary for usage and development.
Vagrant uses [VirtualBox](https://www.virtualbox.org/) to create VMs programmatically.

```
$ vagrant up
```

### Usage

After installation is complete, ssh into our created vm and cd to the directory for the analyzer.

```
$ vagrant ssh
$ cd word_frequency_analyzer
```

#### Running Tests

All Test Suites:  

```
$ grunt test
```

All Test Suites (re-run on changes):  

```
$ grunt watch:tdd
```

Unit Test Suite:  

```
$ grunt test:unit
```

Unit Test Suite (re-run on changes):  

```
$ grunt watch:unit
```

Perf Test Suite:  

```
$ grunt test:perf
```

Perf Test Suite (re-run on changes):  

```
$ grunt watch:perf
```

#### Running Service

Starting:  

```
$ grunt start
```

Restarting:  

```
$ grunt restart
```

#### Building Documentation

Generate and start documentation server:  

```
$ grunt docs
```

Watch and generate new docs on change:  

```
$ grunt watch:docs
```
