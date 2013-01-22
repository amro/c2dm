# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "c2dm"
  s.version     = "0.3.0"
  s.authors     = ["Amro Mousa"]
  s.email       = ["amromousa@gmail.com"]
  s.homepage    = "http://github.com/amro/c2dm"
  s.summary     = %q{sends push notifications to Android devices}
  s.description = %q{c2dm sends push notifications to Android devices via Google Cloud Messaging (GCM)}
  s.license     = "MIT"
  
  s.post_install_message = "Warning: C2DM versions 0.3.0 and newer include breaking changes like raising exceptions by default\n" +
                           "and a slightly different API! Please read more at http://github.com/amro/c2dm before upgrading from 0.2.x!"
  
  s.rubyforge_project = "c2dm"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('httparty')
  s.add_dependency('json')
end
