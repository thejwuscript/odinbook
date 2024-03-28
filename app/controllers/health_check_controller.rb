class HealthCheckController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    render plain: 'ok', status: :ok
  end
end
