# encoding: utf-8
module MiddlemanPresentationBuilder
  class Webapp < Sinatra::Base
    set :root, File.expand_path('../../..', __FILE__)

    configure do
      enable :logging

      file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
      file.sync = true

      use Rack::CommonLogger, file
    end

    error InvalidRequestError do
      halt 400, haml(:invalid_request)
    end

    get '/presentation/build' do
      haml :form
    end

    post '/presentation/build' do
      builder = BuildOrchestrator.new

      begin
        add_static_servers = params[:add_static_servers] ? true : false
        uploaded_presentation = UploadedPresentation.new(params[:zip_file], add_static_servers: add_static_servers)
        built_presentation = builder.build(uploaded_presentation)
      rescue RuntimeError
        raise InvalidRequestError
      end

      send_file(
        built_presentation.file,
        :type => 'application/zip',
        :disposition => 'attachment',
        :filename => built_presentation.suggested_filename + '.zip',
        :stream => false
      )
    end
  end
end
