class CallbackController < ApplicationController
  def twitter
    auth = request.env['omniauth.auth']
    remote_id = auth[:uid]
    stream = TwitterStream.find_by(user: current_user, remote_id: remote_id)
    if stream.nil?
      stream = TwitterStream.new(user: current_user, remote_id: remote_id)
    end
    stream.config = TwitterConfig.from_oauth(auth)
    stream.profile = TwitterProfile.from_oauth(auth)
    stream.save!
    # TODO: trigger stream load.
    redirect_to stream
  end
end
