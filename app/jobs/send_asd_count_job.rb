class SendAsdCountJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Group.where(nightsend: true).each do |group|
      @group = group
      date = Date.yesterday 
      @asds = Asd.where(created_at: date.midnight..date.end_of_day, group: group)
      position = Group.all.sort_by{|gp| gp.asds.count}.pluck(:id).reverse.find_index(@group.id) + 1
      defmultipletimes = @asds.pluck(:multiple_times).sum
      @specialevent = []
      if group.asds.count > 0
          Telegram.bot.send_message(chat_id: @group.chat_id, text: "È mezzanotte, ora di sapere! Il contasd di ieri conta ben #{@asds.count}, asd. Sei il #{position}º gruppo per ASD inviati. (compresi quelli multipli, che sono #{defmultipletimes})")  
      end
    end
  end
end
