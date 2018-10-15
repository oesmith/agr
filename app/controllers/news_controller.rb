class NewsController < ApplicationController
  def index
    @latest_scrape = Scrape.where(user_id: current_user).order(updated_at: :desc).first
    @posts = Post.where(user: current_user).limit(50)
  end

  def create
    scrape = Scrape.create(user: current_user, state: "pending")
    ScrapeJob.perform_later(scrape)
    redirect_to news_path(scrape)
  end

  def show
    @scrape = Scrape.find_by!(id: params[:id], user: current_user)
  end

  def errors
    @scrape = Scrape.find_by!(id: params[:id], user: current_user)
  end
end
