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
