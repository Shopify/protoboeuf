require "rake/testtask"


BASE_DIR = File.dirname __FILE__
proto_files = Rake::FileList[File.join(BASE_DIR, "test/fixtures/*.proto")]
rb_files = proto_files.pathmap("#{BASE_DIR}/lib/proto/test/fixtures/%n_pb.rb")

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

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

task :test => rb_files
