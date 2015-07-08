class TopController < ApplicationController
  skip_before_action :authenticate, only: %i(index)

  def index
    if signed_in?
      redirect_to streams_path
    end
  end
end
