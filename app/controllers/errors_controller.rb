class ErrorsController < ActionController::Base
  layout 'application'

  def not_found
    render status: :not_found
  end

  def invalid_request
    render status: :invalid_request
  end

  def server_error
    render status: :server_error
  end

  def error
    render status: :server_error
  end

  private

  def the_exception
    @e ||= env["action_dispatch.exception"]
  end
end
