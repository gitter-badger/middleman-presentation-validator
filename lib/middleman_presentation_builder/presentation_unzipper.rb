# encoding: utf-8
module MiddlemanPresentationBuilder
  class PresentationUnzipper
    def use(zip_file)
      tmp_dir = Dir.mktmpdir('presentation')
      Utils.unzip(zip_file, tmp_dir)

      tmp_dir
    end
  end
end
