class MessageController < ApplicationController
  def message_process
    bot_api_key = '836213850:AAG-aBtJB8khJ53DNRlzORUVcFWOH5SOF9o'
    if params[:token] == bot_api_key
      message = params[:message][:message]
      ProcessMessageJob.perform_later(message)
    end
  end

  def classifica
    @groups = Group.all.sort_by{|sender| sender.asds.count}.reverse
    @senders = Sender.all.sort_by{|sender| sender.asds.count}.reverse
  end
end
