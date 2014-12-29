# encoding: utf-8
module MiddlemanPresentationBuilder
  class PresentationBuilder
    private

    attr_reader :build_directory, :add_static_servers

    public

    def initialize(build_directory, add_static_servers:)
      @build_directory    = build_directory
      @add_static_servers = add_static_servers
    end

    def run
      Dir.chdir build_directory do
        Bundler.with_clean_env do
          system(gem_install_command)
          system(build_command)
        end
      end
    end

    private

    def gem_install_command
      'bundle install'
    end

    def build_command
      c = []
      c << 'bundle exec middleman-presentation build presentation'
      c.concat arguments

      c.join(' ')
    end

    def arguments
      a = []

      if add_static_servers == true
        a << '--add-static-servers'
      else
        a << '--add-static-servers=false'
      end

      a
    end
  end
end
