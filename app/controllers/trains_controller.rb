class TrainsController < ApplicationController
  before_action :set_train, only: [:show, :edit, :update, :destroy]

  # GET /trains
  def index
    @trains = Train.where(user: current_user)
  end

  # GET /trains/1
  def show
    redirect_to("/train/#{@train.from}/#{@train.to}")
  end

  # GET /train/:from/:to
  def view
    @departures = Trains::TransportAPI.live_departures(params[:from])
    @live = Trains::LDB.live_departures(params[:from], params[:to])
  end

  # GET /trains/new
  def new
    @train = Train.new
  end

  # GET /trains/1/edit
  def edit
  end

  # POST /trains
  def create
    @train = Train.new(train_params.merge(user: current_user))

    if @train.save
      redirect_to @train, notice: "Train was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /trains/1
  def update
    if @train.update(train_params)
      redirect_to @train, notice: "Train was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /trains/1
  def destroy
    @train.destroy
    redirect_to trains_url, notice: "Train was successfully destroyed."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_train
    @train = Train.find_by!(id: params[:id], user: current_user)
  end

  # Only allow a trusted parameter "white list" through.
  def train_params
    params.require(:train).permit(:from, :to)
  end
end
