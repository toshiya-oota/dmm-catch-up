class MessagesController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    if Entry.exists?(user_id: current_user.id, room_id: message_params[:room_id])
      @message = Message.new(message_params.merge(user_id: current_user.id))

      if @message.save
        redirect_to room_path(@message.room_id), notice: 'メッセージが送信されました。'
      else
        redirect_to room_path(@message.room_id), alert: 'メッセージの送信に失敗しました。'
      end
    else
      redirect_back(fallback_location: root_path, alert: 'このルームにアクセスする権限がありません。')
    end
  end

  private

  def message_params
    params.require(:message).permit(:message, :content, :room_id)
  end
end