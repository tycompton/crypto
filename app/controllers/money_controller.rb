class MoneyController < ApplicationController
  before_action :set_money, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :correct_user, only: [:show, :edit, :update, :destroy]

  # GET /money
  # GET /money.json
  def index
    @money = Money.all
    require 'net/http'
    require 'json'
    @url = 'https://api.coinmarketcap.com/v1/ticker/'
    @uri = URI(@url)
    @response = Net::HTTP.get(@uri)
    @lookup_money = JSON.parse(@response)
  end

  # GET /money/1
  # GET /money/1.json
  def show
  end

  # GET /money/new
  def new
    @money = Money.new
  end

  # GET /money/1/edit
  def edit
  end

  # POST /money
  # POST /money.json
  def create
    @money = Money.new(money_params)

    respond_to do |format|
      if @money.save
        format.html { redirect_to @money, notice: 'Money was successfully created.' }
        format.json { render :show, status: :created, location: @money }
      else
        format.html { render :new }
        format.json { render json: @money.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /money/1
  # PATCH/PUT /money/1.json
  def update
    respond_to do |format|
      if @money.update(money_params)
        format.html { redirect_to @money, notice: 'Money was successfully updated.' }
        format.json { render :show, status: :ok, location: @money }
      else
        format.html { render :edit }
        format.json { render json: @money.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /money/1
  # DELETE /money/1.json
  def destroy
    @money.destroy
    respond_to do |format|
      format.html { redirect_to money_index_url, notice: 'Money was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_money
      @money = Money.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def money_params
      params.require(:money).permit(:symbol, :user_id, :cost_per, :amount_owned)
    end

    def correct_user
      @correct = current_user.money.find_by(id: params[:id])
      redirect_to money_index_path, notice: "Not authorized to edit this entry" if @correct.nil?
    end
end
