# Rakefile for Selenium Ruby Client   -*- ruby -*-

$:.unshift 'lib'

require 'rake/clean'
require 'rake/testtask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/rdoctask'

require 'rubygems'
gem "rspec", "1.1.12"
require 'spec/rake/spectask'
require 'selenium/rake/tasks'

CLEAN.include("COMMENTS")
CLEAN.include('lib/selenium/client/generated_driver.rb', '**/*.log', "target", "pkg")

if ENV["SELENIUM_RC_JAR"]
	# User override
	SELENIUM_RC_JAR = ENV["SELENIUM_RC_JAR"] 
elsif not Dir[File.dirname(__FILE__) + "/../../selenium-server/target/selenium-server-*-standalone.jar"].empty?
	# We are part of the global Selenium RC Build
	SELENIUM_RC_JAR = Dir[File.dirname(__FILE__) + "/../../selenium-server/target/selenium-server-*-standalone.jar"].first
else
	# Bundled version
	SELENIUM_RC_JAR = Dir[File.dirname(__FILE__) + "/vendor/selenium-remote-control/selenium-server-*-standalone.jar"].first
end

raise "Invalid Selenium RC jar : '#{SELENIUM_RC_JAR}" unless File.exists?(SELENIUM_RC_JAR)
  
task :default => :"test:unit"

desc "Start a Selenium remote control, run all integration tests and stop the remote control"
task :'ci:integration' => [ :clean, :'test:unit' ] do
  Rake::Task[:"selenium:rc:stop"].execute [] rescue nil
  begin
    Rake::Task[:"sample_app:restart"].execute []   
    Rake::Task[:"selenium:rc:start"].execute []
    Rake::Task[:"test:integration"].execute []
    Rake::Task[:"examples"].execute []
  ensure
    Rake::Task[:"selenium:rc:stop"].execute []
    Rake::Task[:"sample_app:restart"].execute [] 
  end
end

file "target/iedoc.xml" do
  has_unzip = system "unzip -v"
  if has_unzip
    sh "unzip -uj '#{SELENIUM_RC_JAR}' core/iedoc.xml -d target"
  else  # Windows support assumes Java is installed 
    sh "jar xvf \"#{SELENIUM_RC_JAR}\" core/iedoc.xml"
    FileUtils.mkdir_p "target"
    FileUtils.mv "core/iedoc.xml", "target/iedoc.xml"
    FileUtils.rmdir "core"
  end
end

desc "Generate driver from iedoc.xml"
file "lib/selenium/client/generated_driver.rb" => [ "target/iedoc.xml" ] do
  sh "ant generate-sources"
end

desc "Run unit tests"
Rake::TestTask.new(:'test:unit') do |t|
  t.test_files = FileList['test/unit/**/*_test.rb']
  t.warning = true
end
task :"test:unit" => "lib/selenium/client/generated_driver.rb"

Selenium::Rake::RemoteControlStartTask.new do |rc|
  rc.port = 4444
  rc.timeout_in_seconds = 3 * 60
  rc.background = true
  rc.wait_until_up_and_running = true
  rc.jar_file = SELENIUM_RC_JAR
  rc.additional_args << "-singleWindow"
end

Selenium::Rake::RemoteControlStopTask.new do |rc|
  rc.host = "localhost"
  rc.port = 4444
  rc.timeout_in_seconds = 3 * 60
  rc.wait_until_stopped = true
end

desc "Restart Selenium Remote Control"
task :'selenium:rc:restart' do
  Rake::Task[:"selenium:rc:stop"].execute [] rescue nil
  Rake::Task[:"selenium:rc:start"].execute []
end

desc "Run all integration tests"
Spec::Rake::SpecTask.new("test:integration") do |t|
    t.spec_files = FileList['test/integration/**/*_spec.rb'] - FileList['test/integration/**/dummy_project/*_spec.rb']
    t.spec_opts << '--color'
    t.spec_opts << "--require 'lib/selenium/rspec/reporting/selenium_test_report_formatter'"
    t.spec_opts << "--format=Selenium::RSpec::SeleniumTestReportFormatter:./target/integration_tests_report.html"
    t.spec_opts << "--format=progress"                
end
task :"test:integration" => ["lib/selenium/client/generated_driver.rb"]

begin
  gem "deep_test", ">=1.2.1"
  require "deep_test/rake_tasks"

  desc "Run all integration tests in parallel"
  Spec::Rake::SpecTask.new("test:integration:parallel") do |t|
      t.spec_files = FileList['test/integration/**/*.rb']
      t.spec_opts << '--color'
      t.spec_opts << "--require 'lib/selenium/rspec/reporting/selenium_test_report_formatter'"
      t.spec_opts << "--format=Selenium::RSpec::SeleniumTestReportFormatter:./target/integration_tests_report.html"
      t.spec_opts << "--format=progress"                
      t.deep_test :number_of_workers => 5,
                  :timeout_in_seconds => 180
  end
rescue Exception
  puts "Could not find DeepTest, disable parallel run"
end

desc "Run API integration tests"
Spec::Rake::SpecTask.new("test:integration:api") do |t|
    t.spec_files = FileList['test/integration/api/**/*_spec.rb']
    t.spec_opts << '--color'
    t.spec_opts << "--require 'lib/selenium/rspec/reporting/selenium_test_report_formatter'"
    t.spec_opts << "--format=Selenium::RSpec::SeleniumTestReportFormatter:./target/api_integration_tests_report.html"
    t.spec_opts << "--format=progress"                
end

desc "Run API integration tests"
Spec::Rake::SpecTask.new("test:integration:smoke") do |t|
    t.spec_files = FileList['test/integration/smoke/**/*backward*.rb']
    t.spec_opts << '--color'
    t.spec_opts << "--require 'lib/selenium/rspec/reporting/selenium_test_report_formatter'"
    t.spec_opts << "--format=Selenium::RSpec::SeleniumTestReportFormatter:./target/smoke_tests_report.html"
    t.spec_opts << "--format=progress"                
end

desc "Run Test::Unit example"
Rake::TestTask.new("examples:testunit"  ) do |t|
  t.test_files = FileList['examples/testunit/**/*_test.rb']
  t.warning = true
end

desc "Run RSpec examples"
Spec::Rake::SpecTask.new("examples:rspec") do |t|
    t.spec_files = FileList['examples/rspec/**/*_spec.rb']
    t.spec_opts << '--color'
    t.spec_opts << "--require 'lib/selenium/rspec/reporting/selenium_test_report_formatter'"
    t.spec_opts << "--format=Selenium::RSpec::SeleniumTestReportFormatter:./target/smoke_tests_report.html"
    t.spec_opts << "--format=progress"                
end

desc "Run script example"
task :'examples:script' do
  sh "ruby examples/script/*.rb"
end

desc "Run all examples"
task :'examples' => [:'examples:rspec', :'examples:testunit', :'examples:script']

desc "Run tests that are part of Selenium RC maven build (When Selenium Client is part of Selenium RC Workspace)."
task :'test:maven_build' do |t|
  Rake::Task[:"test:unit"].invoke
  if (ENV['HEADLESS_TEST_MODE'] || "").downcase == "true"
    puts "Headless test mode detected"
  else
    Rake::Task[:"test:integration"].invoke
  end
end

desc "Run tests in parallel"
Spec::Rake::SpecTask.new("test:parallel") do |t|
    t.spec_files = FileList['test/integration/*_spec.rb']
    t.spec_opts << '--color'
    t.spec_opts << "--require 'lib/selenium/rspec/reporting/selenium_test_report_formatter'"
    t.spec_opts << "--format=Selenium::RSpec::SeleniumTestReportFormatter:./target/report.html"
    t.spec_opts << "--format=progress"                
end

desc "Launch Sample App"
task :'sample_app:start' do
  Nautilus::Shell.new.run \
      "\"#{File.expand_path(File.dirname(__FILE__) + '/test/integration/sample-app/sample_app.rb')}\"",
      :background => true
end

desc "Stop Sample App"
task :'sample_app:stop' do
  Net::HTTP.get("localhost", '/shutdown', 4567)
end

desc "Restart Sample App"
task :'sample_app:restart' do
  Rake::Task[:"sample_app:stop"].execute([]) rescue nil
  Rake::Task[:"sample_app:start"].execute []
end


specification = Gem::Specification.new do |s|
  s.name = "selenium-client"
  s.summary = "Official Ruby Client for Selenium RC."
  s.version = "1.2.12"
  s.author = "OpenQA"
  s.email = 'selenium-client@rubyforge.org'
  s.homepage = "http://selenium-client.rubyforge.com"
  s.rubyforge_project = 'selenium-client'
  s.platform = Gem::Platform::RUBY
  s.files = FileList['lib/**/*.rb'] +  FileList['examples/**/*.rb']
  s.require_path = "lib"
  s.extensions = []
  s.rdoc_options << '--title' << 'Selenium Client' << '--main' << 'README' << '--line-numbers'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.markdown']
	s.test_file = "test/all_unit_tests.rb"
end

Rake::GemPackageTask.new(specification) do |package|
  package.need_zip = false
  package.need_tar = false
end

desc "Build the RubyGem"
task :gem
 
desc "Generate documentation"
Rake::RDocTask.new("rdoc") do |rdoc|
  rdoc.title    = "Selenium Client"
  rdoc.main = "README"
  rdoc.rdoc_dir = "doc"
  rdoc.rdoc_files.include('README.markdown')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.rdoc_files.include('doc/**/*.rdoc')
  rdoc.options << '--line-numbers' << '--inline-source' 
end

desc "Publish RDoc on Rubyforge website"
task :'rdoc:publish' => :rdoc do
  sh "scp -r doc/* #{ENV['USER']}@rubyforge.org:/var/www/gforge-projects/selenium-client"
end
