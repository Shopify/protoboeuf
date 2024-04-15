require "rake/testtask"
require "rake/clean"

BASE_DIR = File.dirname __FILE__
proto_files = Rake::FileList[File.join(BASE_DIR, "test/fixtures/*.proto")]
sig_proto_files = File.join(BASE_DIR, "test/fixtures/sigstore/*.proto")
proto_files.add(sig_proto_files)

rb_files = proto_files.pathmap("#{BASE_DIR}/lib/proto/test/fixtures/%n_pb.rb")

BENCHMARK_UPSTREAM_PB = "bench/lib/upstream/benchmark_pb.rb"
BENCHMARK_PROTOBOEUF_PB = "bench/lib/protoboeuf/benchmark_pb.rb"

well_known_types = Rake::FileList[File.join(BASE_DIR, "lib/protoboeuf/protobuf/*.proto")]

# Clobber/clean rules
rb_files.each { |x| CLOBBER.append x }
CLOBBER.append BENCHMARK_UPSTREAM_PB
CLOBBER.append BENCHMARK_PROTOBOEUF_PB

rule ".rb" => "%X.proto" do |t|
  require_relative "lib/protoboeuf/codegen"
  require_relative "lib/protoboeuf/parser"

  unit = ProtoBoeuf.parse_file t.source

  puts "writing #{t.name}"
  File.binwrite t.name, unit.to_ruby
end

task :well_known_types => well_known_types.pathmap("%X.rb")

# Makefile-like rule to generate "_pb.rb"
rule "_pb.rb" => "test/fixtures/%{_pb,}n.proto" do |task|
  mkdir_p "lib/proto"
  begin
    sh "protoc #{task.source} --ruby_out=lib/proto"
  rescue
    $stderr.puts "#" * 80
    $stderr.puts "Make sure protobuf is installed"
    $stderr.puts "#" * 90
    raise
  end
end

file BENCHMARK_UPSTREAM_PB => "bench/fixtures/benchmark.proto" do
  mkdir_p "bench/lib/upstream"
  Dir.chdir "bench/fixtures" do
    sh "protoc benchmark.proto --ruby_out=../lib/upstream"
  end
end

# This is a file task to generate an rb file from benchmark.proto
file BENCHMARK_PROTOBOEUF_PB => "bench/fixtures/benchmark.proto" do |t|
  mkdir_p "bench/lib/protoboeuf"
  require_relative "lib/protoboeuf/codegen"
  require_relative "lib/protoboeuf/parser"

  unit = ProtoBoeuf.parse_file t.source
  unit.package = "proto_boeuf"
  gen = ProtoBoeuf::CodeGen.new unit

  File.binwrite t.name, gen.to_ruby
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

desc "Regenerate protobuf files"
task :gen_proto => rb_files

task :test => [:gen_proto, :well_known_types]
task :default => :test

task :bench => [BENCHMARK_UPSTREAM_PB, BENCHMARK_PROTOBOEUF_PB] do
  puts "###### INTERPRETER ######"
  ruby "-I lib:bench/lib bench/benchmark.rb"

  puts
  puts "###### YJIT ######"
  ruby "--yjit -I lib:bench/lib bench/benchmark.rb"
end
