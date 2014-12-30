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
      @commands << Command.new('bundle install')
      @commands << Command.new(build_command.join(' '))
    end

    def use(directory)
      build_directory = File.dirname(Dir.glob(File.join(directory, '**', '.middleman-presentation.yaml')).first)

      commands.each { |c| c.working_directory = build_directory }
      commands.each { |c| c.execute }

      [build_directory, output, success?]
    end

    private

    def output
      commands.each_with_object([]) do |e, a| 
        a << format('$ %s', e.to_s)
        a << e.output
      end.join("\n")
    end

    # def exitstatus
    #   commands.map(&:exitstatus).max
    # end

    def success?
      commands.all? { |c| c.success? }
    end
  end
end
