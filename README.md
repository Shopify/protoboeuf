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

`protoboeuf` expects a compiled binary protobuf file.  These can be generated with the `protoc` command line tool that
comes with the protobuf library.

```
$ protoc -I examples test.proto -o test.bproto
$ protoboeuf test.bproto > test.rb
```

The above will produce a `.rb` file with Ruby classes representing each message type.

You can also generate Ruby that contains Sorbet types by using the `-t` flag like this:

```
$ protoboeuf -t test.bproto > test.rb
```

## Generating Code with ProtoBoeuf AST

The `protoc` command line tool can parse a `.proto` file and output a binary representation of the `.proto` file's abstract syntax tree.
ProtoBoeuf ships with classes built for loading these binary files.
This means you can combine `protoc` and ProtoBoeuf to write any kind of code generator you'd like based on what's inside the `.proto` file.

Given an input `.proto` file like this:

```
syntax = "proto3";

package test_app;

message HelloReq {
  string name = 1;
}

message HelloResp {
  string name = 1;
}

service HelloWorld {
  rpc Hello(HelloReq) returns (HelloResp);
}
```

We can write code to process the AST and produce a very basic client:

```ruby
require "protoboeuf/google/protobuf/descriptor"

fds = ProtoBoeuf::Google::Protobuf::FileDescriptorSet.decode(File.binread(ARGV[0]))
fds.file.each do |file|
  file.service.each do |service|
    puts "class #{service.name}"
    service.method.each do |method|
      input_klass = method.input_type.split(".").last
      output_klass = method.output_type.split(".").last

      puts <<-EORB
  # expects #{input_klass}
  def #{method.name.downcase}(input)
    http = Net::HTTP.new(\"example.com\")
    request = Net::HTTP::Post.new(\"/#{service.name}\")
    req.content_type = 'application/protobuf'
    data = #{input_klass}.encode(input)
    request.body = data
    response = http.request(request)
    #{output_klass}.decode response.body
  end
      EORB

    end
    puts "end"
    puts
  end
end
```

First we convert the `.proto` file to a binary version like this (assuming the file name is `server.proto`):

```
$ protoc -I . server.proto -o server.bproto
```

Then we can use our program to load the binary version of the proto file and produce a simple client:

```
$ ruby -I lib test.rb server.bproto
class HelloWorld
  # expects HelloReq
  def hello(input)
    http = Net::HTTP.new("example.com")
    request = Net::HTTP::Post.new("/HelloWorld")
    req.content_type = 'application/protobuf'
    data = HelloReq.encode(input)
    request.body = data
    response = http.request(request)
    HelloResp.decode response.body
  end
end
```

The code you can generate is only limited by your imagination!

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

Ruby files under `lib/protoboeuf/google` are generated from the `.proto` files in any subdirectories.
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
