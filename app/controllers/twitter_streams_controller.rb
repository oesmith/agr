class TwitterStreamsController < ApplicationController
  etag { current_user.id }

  def show
    @twitter_stream = TwitterStream.find_by!(id: params[:id], user: current_user)
    fresh_when(@twitter_stream)
  end
end
