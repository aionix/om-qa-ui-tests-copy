# BCA QA Automation project with Cucumber


We do cool QA automation stuff here


### Setting up Ruby for OS X

You may use RBEnv or RVM tools to manage different Ruby versions on your machine.

Here is [an excellent guide for RBEnv](http://misheska.com/blog/2013/06/15/using-rbenv-to-manage-multiple-versions-of-ruby/)

Install [bundler](http://bundler.io/) and use it to install all required gems:

```
gem install bundler
cd <PROJECT_FOLDER>
bundle install
```

**Note**: if you are using RubyMine, it will automatically suggest you to install bundler and dependencies if they're missing.

**Update chromedriver**: 

```
cd <PROJECT_FOLDER>
$ chromedriver-update
```

**Run tests:** 
Run tests in one thread use this commands:
```
cd <PROJECT_FOLDER>
$ cucumber -p implemented_qa
```
Run tests in multi-threads(parallel test runner) use this commands:
```
cd <PROJECT_FOLDER>
$ bundle parallel_cucumber features/  -o "-p parallel_smoke_cross_environment_qa"
```

**Note**: if you are using RubyMine, you can use runner configurations to run tests. All runners profiles are situated in <PROJECT_FOLDER>/config/cucumber.yml

### Setting up Ruby for Windows

Required software:

* [Ruby for Windows](http://rubyinstaller.org/downloads/). Download and install version 2.0.0p647 (exactly 2.0.0p647)
* [Chromedriver](http://chromedriver.storage.googleapis.com/index.html?path=2.9). Download and copy `chromedriver.exe` file to Ruby installation folder i.e `C:\Ruby21\bin`
* [RubyMine](https://www.jetbrains.com/ruby/download/)
* [RubyDevKit](http://rubyinstaller.org/downloads/)
	- extract RubyDevKit to `C:\RubyDevKit\`
	- open Command-Line and do the following:

```
cd C:\RubyDevKit
ruby dk.rb init
ruby dk.rb install
```

1. Launch "Start Command Prompt with Ruby" and execute following command

```
gem install bundler
cd <PROJECT_FOLDER>
bundle install
```

2. Launch RubyMine and navigate to File -> Settings -> Languages & Frameworks -> Ruby SDK and Gems
3. Press + on SDK section and choose Ruby2.0.exe

### RubyMine IDE

[RubyMine](https://www.jetbrains.com/ruby/download/) is suggested IDE