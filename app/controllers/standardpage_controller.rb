class StandardpageController < ApplicationController
  def classifica
    @groups = Group.all.sort_by{|sender| sender.asds.count}.reverse
    @senders = Sender.all.sort_by{|sender| sender.asds.count}.reverse
  end

  def grafico
    if !params[:s].nil?
      @sender = Sender.find_by(chat_id: params[:s])
    elsif !params[:g].nil?
      @group = Group.find_by(chat_id: params[:g])
    end
  end

  def home
  end
end
