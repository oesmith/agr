class StreamsController < ApplicationController
  def index
    @streams = Stream.where(user: current_user)
  end

  def new
  end

  def destroy
    Stream.find_by!(id: params[:id], user: current_user).destroy
    redirect_to streams_url, notice: "Stream was successfully destroyed."
  end
end
