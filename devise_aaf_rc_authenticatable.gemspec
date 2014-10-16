# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: devise_aaf_rc_authenticatable 0.0.6 ruby lib

Gem::Specification.new do |s|
  s.name = "devise_aaf_rc_authenticatable"
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Gabriel Gasser Noblia", "Shuqian Hon", "Daniel Theodosius", "Jake Farrell"]
  s.date = "2014-10-16"
  s.description = "Devise AAF Rapid Connect Authenticatable is an authentication strategy for the Devise[http://github.com/plataformatec/devise] authentication framework."
  s.email = ["gabriel@intersect.org.au", "shuqian@intersect.org.au", "danielt@intersect.org.au", "jake@intersect.org.au"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md",
    "README.rdoc"
  ]
  s.files = [
    ".ruby-gemset",
    ".ruby-version",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "app/controllers/devise/aaf_rc_sessions_controller.rb",
    "config/locales/en.yml",
    "devise_aaf_rc_authenticatable.gemspec",
    "lib/devise_aaf_rc_authenticatable.rb",
    "lib/devise_aaf_rc_authenticatable/exception.rb",
    "lib/devise_aaf_rc_authenticatable/logger.rb",
    "lib/devise_aaf_rc_authenticatable/model.rb",
    "lib/devise_aaf_rc_authenticatable/routes.rb",
    "lib/devise_aaf_rc_authenticatable/schema.rb",
    "lib/devise_aaf_rc_authenticatable/strategy.rb",
    "lib/devise_aaf_rc_authenticatable/version.rb",
    "lib/generators/devise_aaf_rc_authenticatable/install_generator.rb",
    "lib/generators/devise_aaf_rc_authenticatable/templates/aaf_rc.yml",
    "rails/init.rb"
  ]
  s.homepage = "http://github.com/IntersectAustralia/devise_aaf_rc_authenticatable"
  s.rubygems_version = "2.2.2"
  s.summary = "AAF Rapid Connect authentication module for Devise"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json-jwt>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0.1"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<builder>, [">= 0"])
      s.add_runtime_dependency(%q<devise>, [">= 2.2.4"])
    else
      s.add_dependency(%q<json-jwt>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<builder>, [">= 0"])
      s.add_dependency(%q<devise>, [">= 2.2.4"])
    end
  else
    s.add_dependency(%q<json-jwt>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<builder>, [">= 0"])
    s.add_dependency(%q<devise>, [">= 2.2.4"])
  end
end

