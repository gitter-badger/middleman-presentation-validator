# encoding: utf-8
module MiddlemanPresentationBuilder
  class BuildCleaner
    def use(*directories)
      directories = directories.flatten

      FileUtils.rm_rf directories if !directories.blank? && directories.all? { |d| d.start_with? Dir.tmpdir }
    end
  end
end

