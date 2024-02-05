# protobuff

Repository for an experimental version of a protobuf encoder / decoder.

## Getting started

Make sure you have protobuf installed. On macOS it's like this:

```
$ brew install protobuf
```

Then run `bundle` to install dependencies:

```
$ bundle
```

## Running tests

Run all tests like this:

```
$ bundle exec rake test
```

Run one test file like this:

```
$ bundle exec ruby -I lib:test test/message_test.rb
```

Run one test within a file like this:

```
$ bundle exec ruby -I lib:test test/message_test.rb -n test_decoding
```

## Generated files

Files under `lib/proto` are generated from the `.proto` files in 
`test/fixtures`. For example, currently `lib/proto/test/fixtures/test_pb.rb`
is generated from the file `test/fixtures/test.proto`

Running `rake test` will automatically regenerate the `.rb` files if the
`.proto` files ever change.

If you would like to forcibly delete the generated `.rb` files run this:

```
$ bundle exec rake clobber
```

If you would like to regenerate the `.rb` files without running any tests, do
this:

```
$ bundle exec rake gen_proto
```
