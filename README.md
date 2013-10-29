[![Build Status](https://travis-ci.org/aslong/word-frequency-analyzer.png?branch=master)](https://travis-ci.org/aslong/word-frequency-analyzer)
[![Node Dependencies](https://david-dm.org/aslong/word-frequency-analyzer.png)](https://david-dm.org/aslong/word-frequency-analyzer.png)
[![Node devDependency Status](https://david-dm.org/aslong/word-frequency-analyzer/dev-status.png)](https://david-dm.org/aslong/word-frequency-analyzer#info=devDependencies)

# Word Frequency Analyzer
  
The word frequency analyzer takes a string of text, parses it into words, and returns a list of words sorted by their frequency in the text. It can support multiple languages, and has several options that can be toggled for determining word matches. Currently the parser only supports english. Additional character sets can be added to enable other languages. 

You can alter how words are determined to be the same or significant by the parser. Currently there is support for these modes:

* Case sensitivity
* Filter stop words
* Use root of the word

Multiple modes can be enabled at the same time. This allows for several different possible analyzers depending on your specific needs.

**There are several ways to interface with the analyzer:**  

- Include the npm lib in your project
- HTTP API (uses [cluster api](http://nodejs.org/api/cluster.html) to make n workers for n cores)

### Programming Interface

Documentation can be viewed [here](http://coffeedoc.info/github/aslong/word-frequency-analyzer/master/).

Can also be built locally using [these steps](https://github.com/aslong/word-frequency-analyzer#building-documentation). The docs define the classes and modules available in the project.

### Tools Used
The analyzer was written using [Coffeescript](http://coffeescript.org/) and [Node.js](http://nodejs.org/). [Grunt](http://gruntjs.com/) is used for the management of compilation, starting/restarting of services, running of test suites using [Mocha](http://visionmedia.github.io/mocha/) and [Should.js](https://github.com/visionmedia/should.js/), and documentation building. [Codo](https://github.com/netzpirat/codo) is the underlying generator used for documentation.

Provisioning for the service is done using [Chef](http://www.opscode.com/chef/). [Vagrant](http://www.vagrantup.com/) is used with [Chef](http://www.opscode.com/chef/) for creating an isolated and replicable working environment. [Berkshelf](http://berkshelf.com/) is used for iterating on the chef cookbook and can
be re-enabled in the [Vagrantfile](https://github.com/aslong/word-frequency-analyzer/blob/master/Vagrantfile) if needed.

[Travis CI](https://travis-ci.org/) is used for continuous integration. It's currently configured for running test suites on new git commits. [David-dm](https://david-dm.org/) is used for version tracking of latest npm modules used in the project. This includes both dev dependencies, and core dependencies.

## Installation

The word frequency analyzer uses [Vagrant](http://www.vagrantup.com/) for building an isolated environment with everything necessary for usage or development.
Vagrant uses [VirtualBox](https://www.virtualbox.org/) to create VMs programmatically.

1. [Install](https://www.virtualbox.org/wiki/Downloads) VirtualBox for your OS.
1. [Install](http://downloads.vagrantup.com/) Vagrant for your OS.

```
$ git clone git@github.com:aslong/word-frequency-analyzer.git
$ cd word-frequency-analyzer
$ vagrant up
```
At this point you may want to grab a coffee. First run of ```vagrant up``` will need to download a base vm image, and provision the vm with our software dependencies.

## Usage

After installation is complete, ssh into our created vm and cd to the directory for the analyzer.

```
$ vagrant ssh
$ cd word_frequency_analyzer
```

### Running Tests

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

### Running Service

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

### Building Documentation

**Generate documentation and start doc server:**  

```
$ grunt docs
```
After running, visit [here](http://localhost:9000) to view the documentation.  

**Watch and generate new docs on change:**  

```
$ grunt watch:docs
```
Anytime a source file is updated the docs for it will be regenerated. You should only have to refresh your browser to see the updates, assuming you have ```grunt docs``` also running.


## Cleaning up VM resources

**Pause the VM**

```
$ vagrant suspend
```

**Shutdown the VM**

```
$ vagrant halt
```

**Shutdown and Delete the VM image**

```
$ vagrant destroy
```


## Contributing

If there are any changes or improvements you want to this project, [create an issue](https://github.com/aslong/word-frequency-analyzer/issues) or fork the project and submit a [pull request](https://github.com/aslong/word-frequency-analyzer/pulls) with the intended change. Please include a description of the feature. Pull requests should have accompanying tests. Thank you for your help with improving this tool for others. 


## License
(The MIT License)

Copyright (c) 2013 Andrew Long <aslong87@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
