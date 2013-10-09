# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "active_directory"
  s.version = "1.2.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Richard Navarrete"]
  s.date = "2011-06-10"
  s.description = "ActiveDirectory uses Net::LDAP to provide a means of accessing and modifying an Active Directory data store.  This is a fork of the activedirectory gem."
  s.email = "richardun@gmail.com"
  s.extra_rdoc_files = ["README.md"]
  s.files = [".idea/.name", ".idea/.rakeTasks", ".idea/active_directory.iml", ".idea/encodings.xml", ".idea/misc.xml", ".idea/modules.xml", ".idea/vcs.xml", ".idea/workspace.xml", "README.md", "Rakefile", "VERSION", "active_directory.gemspec", "lib/active_directory.rb", "lib/active_directory/base.rb", "lib/active_directory/computer.rb", "lib/active_directory/container.rb", "lib/active_directory/field_type/binary.rb", "lib/active_directory/field_type/date.rb", "lib/active_directory/field_type/dn_array.rb", "lib/active_directory/field_type/group_dn_array.rb", "lib/active_directory/field_type/member_dn_array.rb", "lib/active_directory/field_type/password.rb", "lib/active_directory/field_type/timestamp.rb", "lib/active_directory/field_type/user_dn_array.rb", "lib/active_directory/group.rb", "lib/active_directory/member.rb", "lib/active_directory/user.rb"]
  s.homepage = "http://github.com/richardun/active_directory"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "An interface library for accessing Microsoft's Active Directory."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<net-ldap>, [">= 0.5.0"])
    else
      s.add_dependency(%q<net-ldap>, [">= 0.5.0"])
    end
  else
    s.add_dependency(%q<net-ldap>, [">= 0.5.0"])
  end
end
