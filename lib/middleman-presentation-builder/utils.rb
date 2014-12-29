# encoding: utf-8
module MiddlemanPresentationBuilder
  module Utils
    def unzip(source_file, destination_directory)
      Zip::File.open(source_file) do |z|
        z.each do |e|
          e.extract(File.join(destination_directory, e.name))
        end
      end
    end

    def zip(source_directory, destination_file, prefix: '')
      Zip::File.open(destination_file, Zip::File::CREATE) do |z|
        Dir.glob(File.join(source_directory, '**', '*')).each do |filename|
          paths = []
          paths << Pathname.new(prefix) if prefix
          paths << Pathname.new(filename).relative_path_from(Pathname.new(source_directory))

          z.add(File.join(*paths), filename)
          z.file.chmod(0755, File.join(*paths)) if File.executable? filename
          z.file.chmod(0755, File.join(*paths)) if %w(server.linux server.windows server.darwin).any? { |f| Regexp.new(f) === filename }
        end
      end
    end

    module_function :zip, :unzip
  end
end
