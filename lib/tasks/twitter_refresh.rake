namespace :twitter do
  desc "Refresh Twitter timelines"
  task refresh: :environment do
    TwitterStream.all.each do |stream|
      stream.refresh.save!
    end
  end
end