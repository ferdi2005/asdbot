# frozen_string_literal: true

class SendAsdCountJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    Group.where(nightsend: true).each do |group|
      @group = group
      date = Date.yesterday
      @asds = Asd.where(created_at: date.midnight..date.end_of_day, group: group)
      position = Group.all.sort_by { |gp| gp.asds.totalcount }.pluck(:id).reverse.find_index(@group.id) + 1
      defmultipletimes = @asds.pluck(:multiple_times).sum
      if @asds.count > 0 && !@group.silent
        Telegram.bot.send_message(chat_id: @group.chat_id, text: "È mezzanotte, ora di sapere! Il contasd di ieri conta ben #{@asds.count} (+#{defmultipletimes} multipli) per un totale di #{@asds.totalcount} asds, asd. Sei il #{position}º gruppo per ASD inviati. (Digita /silent per disattivarmi, non togliermi!)")
      end
    rescue StandardError => e
      puts e
    end
  end
end
