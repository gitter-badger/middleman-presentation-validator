# encoding: utf-8
module MiddlemanPresentationBuilder
  class Command
    private

    attr_reader :command, :status

    public

    attr_reader :output
    attr_accessor :working_directory

    def initialize(command, working_directory: nil)
      @working_directory = working_directory
      @command           = command
    end

    def execute
      options = {}
      options[:chdir] = working_directory if working_directory

      @output, @status = Bundler.with_clean_env do
        Open3.capture2e(command, **options)
      end
    end

    def exitstatus
      status.exitstatus
    end

    def success?
      status.success?
    end

    def to_s
      command
    end
  end
end
