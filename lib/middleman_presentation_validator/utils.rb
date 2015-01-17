# encoding: utf-8
module MiddlemanPresentationValidator
  module Utils
    include FeduxOrgStdlib::Zipper

    def log_exception(err, extra_info: nil)
      Rails.logger.error extra_info if extra_info
      Rails.logger.error err.message
      Rails.logger.error err.backtrace.join("\n")
    end

    module_function :zip, :unzip, :log_exception
  end
end
