# frozen_string_literal: true

require "rake/testtask"
require "rake/clean"

require "rubocop/rake_task"
RuboCop::RakeTask.new

BASE_DIR = File.dirname(__FILE__)
codegen_rb_files = ["lib/protoboeuf/codegen.rb"]
proto_files = Rake::FileList[File.join(BASE_DIR, "test/fixtures/*.proto")]
rb_files = proto_files.pathmap("#{BASE_DIR}/test/fixtures/%n_pb.rb")

BENCHMARK_UPSTREAM_PB = "bench/lib/upstream/benchmark_pb.rb"
BENCHMARK_PROTOBOEUF_PB = "bench/lib/protoboeuf/benchmark_pb.rb"

well_known_types = Rake::FileList[
  File.join(BASE_DIR, "lib/protoboeuf/google/**/*.proto")
]

WELL_KNOWN_PB = well_known_types.pathmap("%X.rb")

# Clobber/clean rules
rb_files.each { |x| CLOBBER.append(x) }
CLOBBER.append(BENCHMARK_UPSTREAM_PB)
CLOBBER.append(BENCHMARK_PROTOBOEUF_PB)
CLOBBER.append(WELL_KNOWN_PB)

protoc_import_path_string = "'#{well_known_types.pathmap("%d").uniq.join("':'")}'"

rule ".rb" => ["%X.proto"] + codegen_rb_files do |t|
  codegen_rb_files.each { |f| require_relative f }

  require "tempfile"
  require "pathname"

  unit = Tempfile.create(File.basename(t.source)) do |f|
    File.unlink(f.path)
    sh("protoc -I #{protoc_import_path_string} #{File.basename(t.source)} -o #{f.path}")
    require "google/protobuf/descriptor_pb"
    Google::Protobuf::FileDescriptorSet.decode(File.binread(f.path))
  end

  # force the package to be our own so we generate classes inside our namespace
  unit.file.each do |f|
    next if f.package == "proto_boeuf" || f.package.start_with?("proto_boeuf.")

    f.package = "proto_boeuf.#{f.package}"
  end

  puts "writing #{t.name}"
  dest = Pathname.new(t.name).relative_path_from(File.join(BASE_DIR, "lib")).to_s.delete_suffix(".rb")
  options = {
    append_as_bytes: !ENV["NO_APPEND_AS_BYTES"],
  }
  File.binwrite(t.name, ProtoBoeuf::CodeGen.new(unit).to_ruby(dest, options))
end

task well_known_types: WELL_KNOWN_PB

# Makefile-like rule to generate "_pb.rb"
rule "_pb.rb" => "test/fixtures/%{_pb,}n.proto" do |task|
  sh("protoc #{task.source} --ruby_out=.")
rescue
  $stderr.puts "#" * 80
  $stderr.puts "Make sure protobuf is installed"
  $stderr.puts "#" * 90
  raise
end

file BENCHMARK_UPSTREAM_PB => "bench/fixtures/benchmark.proto" do
  mkdir_p "bench/lib/upstream"
  Dir.chdir("bench/fixtures") do
    sh "protoc benchmark.proto --ruby_out=../lib/upstream"
  end
end

# This is a file task to generate an rb file from benchmark.proto
file BENCHMARK_PROTOBOEUF_PB => ["bench/fixtures/benchmark.proto"] + codegen_rb_files do |t|
  mkdir_p "bench/lib/protoboeuf"
  codegen_rb_files.each { |f| require_relative f }

  unit = ProtoBoeuf.parse_file(t.source)
  unit.file.each do |f|
    next if f.package == "proto_boeuf" || f.package.start_with?("proto_boeuf.")

    f.package = "proto_boeuf.#{f.package}"
  end

  gen = ProtoBoeuf::CodeGen.new(unit)

  File.binwrite(t.name, gen.to_ruby)
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/*_test.rb"]
  t.verbose = true
end

desc "Regenerate protobuf files"
task gen_proto: rb_files

task test: [:gen_proto, :well_known_types]
task default: :test

task bench: [BENCHMARK_UPSTREAM_PB, BENCHMARK_PROTOBOEUF_PB] do
  rm_rf "bench/tmp"
  mkdir_p "bench/tmp"

  ENV["BENCH_HOLD"] = "bench/tmp/"

  puts "###### INTERPRETER ######"
  ruby "-I lib:bench/lib bench/benchmark.rb"

  puts
  puts "###### YJIT ######"
  ruby "--yjit -I lib:bench/lib bench/benchmark.rb"
end
