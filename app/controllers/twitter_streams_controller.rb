class TwitterStreamsController < ApplicationController
  def show
    @twitter_stream = TwitterStream.find_by!(id: params[:id], user: current_user)
  end
end