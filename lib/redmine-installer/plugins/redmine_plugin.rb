module Redmine::Installer::Plugin
  class RedminePlugin < Base

    # Search plugins folder
    def self.am_i_there?
      records = Dir.glob(File.join('plugins', '*'))
      records.map! do |record|
        File.basename(record)
      end

      records.include?(self.class_name.downcase)
    end

  end
end

##
# EasyProject
#
# http://www.easyredmine.com
#
# Easy Redmine is complex project management web application best suited to project teams between
# 10 - 100 users. Whether you manage just yourself or a huge team of software developers,
# Easy Redmine will provide all necessary project management features to complete your projects
# on time, scope and budget.
#
class EasyProject < Redmine::Installer::Plugin::RedminePlugin

  class Redmine::Installer::Command
    def rake_easyproject_install(env)
      run(RAKE, 'easyproject:install', get_rails_env(env), :'plugin.redmine_plugin.easyproject.install')
    end
  end

  def self.install(base)
    command.rake_easyproject_install(base.env) if am_i_there?
  end

  def self.upgrade(base)
    # Copy client modification folders
    # plugins/easyproject/easy_plugins/modification_*
    unless base.options['skip-old-modifications']
      easy_plugins_dir = File.join('plugins', 'easyproject', 'easy_plugins')
      old_modifications = Dir.glob(File.join(base.redmine_root, easy_plugins_dir, 'modification_*'))
      new_modifications = Dir.glob(File.join(base.tmp_redmine_root, easy_plugins_dir, 'modification_*'))

      # Modifications which are on old redmine but not new
      missing_modifications = old_modifications - new_modifications

      FileUtils.cp_r(missing_modifications, File.join(base.tmp_redmine_root, easy_plugins_dir))
    end

    install(base)
  end
end
