class FriendsController < ApplicationController
  before_action :set_friend, only: %i[ show edit update destroy ]
  #important into authentication
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]

  # GET /friends or /friends.json
  def index
    @friends = Friend.all
    #
    # # #wrócić do tego tutaj aby tylko wyświetlało albo home page albo friends i usunąć z indexu weryfikację
    # if user_signed_in?
    #   redirect_to friends_path
    # else
    #   redirect_to root_path
    # end
  end

  # if user isn't creator of this item redirect to friends
  # GET /friends/1 or /friends/1.json
  def show
    @friend = current_user.friends.find_by(id: params[:id])
    redirect_to friends_path if @friend.nil?
  end

  # GET /friends/new
  # important into authentication !
  def new
    @friend = current_user.friends.build
    # @friend = Friend.new
  end

  # GET /friends/1/edit
  def edit
  end

  # POST /friends or /friends.json
  # important into authentication
  def create
    # @friend = Friend.new(friend_params)
    @friend = current_user.friends.build(friend_params)

    respond_to do |format|
      if @friend.save
        format.html { redirect_to friend_url(@friend), notice: "Friend was successfully created." }
        format.json { render :show, status: :created, location: @friend }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @friend.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /friends/1 or /friends/1.json
  def update
    respond_to do |format|
      if @friend.update(friend_params)
        format.html { redirect_to friend_url(@friend), notice: "Friend was successfully updated." }
        format.json { render :show, status: :ok, location: @friend }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @friend.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /friends/1 or /friends/1.json
  def destroy
    @friend.destroy

    respond_to do |format|
      format.html { redirect_to friends_url, notice: "Friend was successfully deleted." }
      format.json { head :no_content }
    end
  end

  #important into authentication !!
  def correct_user
    @friend = current_user.friends.find_by(id: params[:id])
    redirect_to friends_path, notice: "Not authorized to edit this friend" if @friend.nil?
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_friend
      @friend = Friend.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def friend_params
      params.require(:friend).permit(:first_name, :last_name, :email, :phone, :twitter, :user_id)
    end
end
