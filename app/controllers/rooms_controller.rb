class RoomsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @room = Room.new(user_id: current_user.id)
    @entry1 = @room.entries.build(user_id: current_user.id)
    @entry2 = @room.entries.build(entry_params)

    if @room.save
      redirect_to @room, notice: 'チャットルームが作成されました。'
    else
      flash[:alert] = 'チャットルームの作成に失敗しました。'
      redirect_to user_path(current_user)
    end
  end

  def show
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @messages = @room.messages
      @message = Message.new
      @entries = @room.entries
      @myUserId = current_user.id
    else
      redirect_back(fallback_location: root_path)
    end
  end
  
  private

  def entry_params
    params.require(:entry).permit(:user_id)
  end
end
