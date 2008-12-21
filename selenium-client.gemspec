Gem::Specification.new do |s|
  s.name = %q{selenium-client}
  s.version = "1.2.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["OpenQA"]
  s.date = %q{2008-12-21}
  s.email = %q{selenium-client@rubyforge.org}
  s.extra_rdoc_files = ["README.markdown"]
  s.files = ["lib/nautilus/shell.rb", "lib/selenium/client/base.rb", "lib/selenium/client/driver.rb", "lib/selenium/client/extensions.rb", "lib/selenium/client/generated_driver.rb", "lib/selenium/client/idiomatic.rb", "lib/selenium/client/protocol.rb", "lib/selenium/client/selenium_helper.rb", "lib/selenium/client.rb", "lib/selenium/command_error.rb", "lib/selenium/protocol_error.rb", "lib/selenium/rake/remote_control_start_task.rb", "lib/selenium/rake/remote_control_stop_task.rb", "lib/selenium/rake/tasks.rb", "lib/selenium/remote_control/remote_control.rb", "lib/selenium/rspec/reporting/file_path_strategy.rb", "lib/selenium/rspec/reporting/html_report.rb", "lib/selenium/rspec/reporting/selenium_test_report_formatter.rb", "lib/selenium/rspec/reporting/system_capture.rb", "lib/selenium/rspec/rspec_extensions.rb", "lib/selenium/rspec/spec_helper.rb", "lib/selenium.rb", "lib/tcp_socket_extension.rb", "vendor/selenium-remote-control/selenium-server-1.0-SNAPSHOT-standalone.jar", "test/all_unit_tests.rb", "README.markdown"]
  s.has_rdoc = true
  s.homepage = %q{http://selenium-client.rubyforge.com}
  s.rdoc_options = ["--title", "Selenium Client", "--main", "README", "--line-numbers"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{selenium-client}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Official Ruby Client for Selenium RC.}
  s.test_files = ["test/all_unit_tests.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
    else
    end
  else
  end
end
