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

1. [Install](https://www.virtualbox.org/wiki/Downloads) VirtualBox for your OS.
1. [Install](http://downloads.vagrantup.com/) Vagrant for your OS.

```
$ git clone git@github.com:aslong/word-frequency-analyzer.git
$ cd word-frequency-analyzer
$ vagrant up
```

### Usage

After installation is complete, ssh into our created vm and cd to the directory for the analyzer.

```
$ vagrant ssh
$ cd word_frequency_analyzer
```

#### Running Tests

```grunt``` is the primary command to use when running the various test suites. The suites are made up of unit and performance tests.
You can run any suite in isolation or all together. There is also a watch mode that can be used to re-run the tests on file updates.

**All Test Suites:**  

```
$ grunt test
```

**All Test Suites (re-run on file updates):**  

```
$ grunt watch:tdd
```

**Unit Test Suite:**  

```
$ grunt test:unit
```

**Unit Test Suite (re-run on file updates):**  

```
$ grunt watch:unit
```

**Perf Test Suite:**  

```
$ grunt test:perf
```

**Perf Test Suite (re-run on file updates):**  

```
$ grunt watch:perf
```

#### Running Service

**Starting:**  

```
$ grunt start
```
Compiles the source, and starts the node.js service.

**Restarting:**  

```
$ grunt restart
```
Cleans the bin directory, compiles the source, and starts the node.js service.

#### Building Documentation

**Generate documentation and start doc server:**  

```
$ grunt docs
```
After running, visit [here](http://localhost:9000) to view the documentation.  

**Watch and generate new docs on change:**  

```
$ grunt watch:docs
```
Anytime a source file is updated the docs for it will be regenerated. You should only have to refresh your browser if you have ```grunt docs``` also running.
