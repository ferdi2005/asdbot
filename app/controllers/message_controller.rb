class MessageController < ApplicationController
  def message_process
      message = params[:message][:message]
      ProcessMessageJob.perform_later(message)
  end

  def classifica
    @groups = Group.all.sort_by{|sender| sender.asds.count}.reverse
    @senders = Sender.all.sort_by{|sender| sender.asds.count}.reverse
  end
end
