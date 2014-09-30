[![Build Status](https://api.shippable.com/projects/540e37e425952a0313800557/badge/master)](https://www.shippable.com/projects/540e37e425952a0313800557/builds/history)
![Build status](https://badge.buildbox.io/8055270c60a8aa399f33691ce7f6c02f2c60040a9c692f9b97.svg)

# The Date Challenge

## Requirements

- Ruby v2.1.2
- Bundler gem

## Setup

    > bundle install

## Usage

The `bin/run_challenge` script accepts input from either a file or STDIN:

    > ./bin/run_challenge data/sample_input_data.txt

...or...

    > cat ./data/sample_input_data.txt | ./bin/run_challenge

- All output will be sent to STDOUT.
- Input line errors are handled and output (with line numbers) to STDERR.
