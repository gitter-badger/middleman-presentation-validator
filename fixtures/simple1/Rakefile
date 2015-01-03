#!/usr/bin/env ruby

require 'bundler'
Bundler.require :default, :development

desc 'Start presentation'
task default: :start

desc 'Bootstrap presentation'
task :bootstrap do
  sh 'script/bootstrap'
end

desc 'Start presentation'
task :start do
  sh 'script/start'
end

desc 'Build presentation'
task :build do
  sh 'script/build'
end

namespace :export do
  desc 'Export presentation as tar-archive'
  task :tar do
    sh 'script/export'
  end
end

desc 'Export presentation as tar-archive'
task export: 'export:tar'

namespace :edit do
  desc 'Edit all user defined slides'
  task slides: 'slides:user_defined'

  namespace :slides do
    desc 'Edit all user-defined slides'
    task :user_defined do
      slides = Rake::FileList.new('source/slides/*') do |l|
        l.exclude 'source/slides/999*'
      end

      sh "#{Middleman::Presentation.config.editor_command} #{slides.join(' ')}"
    end

    desc 'Edit all slides'
    task :all do
      slides = Rake::FileList.new('source/slides/*')

      sh "#{Middleman::Presentation.config.editor_command} #{slides.join(' ')}"
    end
  end
end

desc 'Edit all user defined slides'
task edit: 'edit:slides'
