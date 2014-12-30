# encoding: utf-8
module MiddlemanPresentationBuilder
  class Command
    private

    attr_reader :working_directory, :command, :status

    public

    attr_reader :output

    def initialize(command, working_directory:)
      @working_directory = working_directory
      @command           = command
    end

    def execute
      @output, @status = Bundler.with_clean_env do
        Open3.capture2e(command)
      end
    end

    def exitstatus
      status.exitstatus
    end

    def success?
      status.success?
    end
  end
end
