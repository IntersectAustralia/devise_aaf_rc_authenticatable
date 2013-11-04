require 'rake'
require 'rake/testtask'
require 'rdoc/task'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the devise_imapable plugin.'
Rake::TestTask.new(:test) do |t|
  # t.libs << 'lib'
  # t.libs << 'test'
  # t.pattern = 'test/**/*_test.rb'
  # t.verbose = true
end

desc 'Generate documentation for the devise_aaf_rc_authenticatable plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'DeviseAafRcAuthenticatable'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "devise_aaf_rc_authenticatable"
    gemspec.summary = "AAF Rapid Connect authentication module for Devise"
    gemspec.description = "Devise AAF Rapid Connect Authenticatable is an authentication strategy for the Devise[http://github.com/plataformatec/devise] authentication framework."
    gemspec.email = ["gabriel@intersect.org.au", "shuqian@intersect.org.au"]
    gemspec.homepage = "http://github.com/IntersectAustralia/devise_aaf_rc_authenticatable"
    gemspec.authors = ["Gabriel Gasser Noblia", "Shuqian Hon"]
    gemspec.add_runtime_dependency "devise", ">= 1.5.4"
    gemspec.version = "0.0.1"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end
