# encoding: utf-8
module MiddlemanPresentationBuilder
  class PresentationBuilder
    private

    attr_reader :commands

    public

    def initialize(add_static_servers:)
      build_command = []
      build_command << 'bundle exec middleman-presentation build presentation'
      if add_static_servers == true
        build_command << '--add-static-servers'
      else
        build_command << '--add-static-servers=false'
      end

      @commands = []
      @commands << Command.new('bundle install', working_directory: build_directory)
      @commands << Command.new(build_command.join(' '), working_directory: build_directory)
    end

    def build(presentation)
      presentation.build_directory
    end



    def run
      commands.each { |c| c.execute }
    end

    def output
      comands.map(&:output).join("\n")
    end

    def exitstatus
      comands.map(&:exitstatus).max
    end

    def success?
      commands.all? { |c| c.success? }
    end
  end
end
