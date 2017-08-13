class LinksController < ApplicationController
  before_action :set_link, only: [:show, :destroy]

  # GET /links
  def index
    @links = Link.where(user: current_user)
  end

  # GET /links/1
  def show
    redirect_to @link.url
  end

  # GET /links/new
  def new
    @link = Link.new(url: params.permit(:url)[:url])
  end

  # POST /links
  def create
    begin
      data = Net::HTTP.get(URI(link_params[:url]))
    rescue
      render :new, notice: 'Failed to fetch link'
    end
    @link = Link.new(link_params)
    begin
      @link.title = Nokogiri.HTML(data).css('title').first.content
    rescue
      # noop
    end
    @link.user = current_user
    if @link.save
      redirect_to links_path, notice: 'Link was successfully created.'
    else
      render :new
    end
  end

  # DELETE /links/1
  def destroy
    @link.destroy
    redirect_to links_url, notice: 'Link was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.find_by!(id: params[:id], user: current_user)
    end

    # Only allow a trusted parameter "white list" through.
    def link_params
      params.require(:link).permit(:url)
    end
end
