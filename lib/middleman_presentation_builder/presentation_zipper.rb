# encoding: utf-8
module MiddlemanPresentationBuilder
  class PresentationZipper
    def use(directory, prefix)
      file = File.join(Dir.tmpdir, sprintf('presentation-%s.build.zip', SecureRandom.hex))
      Utils.zip(directory, file, prefix: prefix)

      file
    end
  end
end
