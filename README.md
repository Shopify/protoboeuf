# protoboeuf

Repository for an *experimental* version of a pure-Ruby protobuf encoder / decoder supporting `proto3`.
This Ruby gem is aimed at Shopify-internal use cases, and currently comes with limited support.
Protoboeuf is a work in progress. This software is not in a mature state, and is likely to contain
bugs, lack certain features, and not be fully conformant to the protobuf specification. We currently
are not looking for open source contributors.

## Getting started

Make sure you have protobuf installed. On macOS it's like this:

<img align="right" height="200" src="media/image.jpg">

```
brew install protobuf
```

Then run `bundle` to install dependencies:

```
$ bundle
```

## Compiling .proto Files

You can compile your own `.proto` files to generate importable `.rb` files:

```
bin/protoboeuf test.proto >> test.rb
```

The above will produce a `.rb` file with Ruby classes representing each message type.

## Running tests

Run all tests like this:

```
bundle exec rake test
```

Run one test file like this:

```
bundle exec ruby -I lib:test test/message_test.rb
```

Run one test within a file like this:

```
bundle exec ruby -I lib:test test/message_test.rb -n test_decoding
```

## Generated files

Ruby files under `lib/protoboeuf/protobuf/` are generated from the `.proto` files in the same directory.
The same is true for `test/fixtures`.

For example, currently `test/fixtures/test_pb.rb`
is generated from the file `test/fixtures/test.proto`

Running `rake test` will automatically regenerate the `.rb` files if the
`.proto` files ever change.

If you would like to forcibly delete the generated `.rb` files run this:

```
bundle exec rake clobber
```

If you would like to regenerate the `.rb` files without running any tests, do
this:

```
bundle exec rake gen_proto well_known_types
```

## Benchmarks

Run benchmarks like this:

```
$ rake bench
```

Benchmark protobuf files are in `bench/fixtures`, and the benchmarks themselves live in `bench/benchmark.rb`.

## Development Tips

To view the protobuf encoding for a given message:

```
bundle exec ruby -I lib -r ./test/fixtures/test_pb -e 'p TestSigned.new(a: -123).to_proto'
"\b\xF5\x01"
```
