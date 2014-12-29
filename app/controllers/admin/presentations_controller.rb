class Admin::PresentationsController < ApplicationController
  def load
    PresentationDiscovererWorker.perform_later(Rails.configuration.x.presentations_directory)

    respond_to do |format|
      format.json { render content_type: 'application/vnd.api+json' }
    end
  end
end
