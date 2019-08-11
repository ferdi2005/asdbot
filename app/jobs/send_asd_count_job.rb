class SendAsdCountJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Group.where(nightsend: true).each do |group|
      @group = group
      date = Date.yesterday 
      @asds = Asd.where(created_at: date.midnight..date.end_of_day, group: group)
      if SpecialEvent.find_by(group: @group)
        Telegram.bot.send_message(chat_id: @group.chat_id, text: "MMH... c'è qualcosa per cui dobbiamo festeggiare! (Ma non in tempo reale, perché non hai dato il comando /nightsend e quindi viene tutto inviato a mezzanotte del giorno dopo, asd). 🎉")
        SpecialEvent.where(group: @group).each do |specialevent|
          Telegram.bot.send_photo(chat_id: @group.chat_id, photo: "http://www.lanciano.it/faccine/asdone.gif", caption: "Così asdoso, asd. #{specialevent.text}")
          specialevent.destroy
        end
      end
      position = Group.all.sort_by{|gp| gp.asds.count}.pluck(:id).reverse.find_index(@group.id) + 1
      defmultipletimes = @asds.pluck(:multiple_times).sum
      Telegram.bot.send_message(chat_id: @group.chat_id, text: "È mezzanotte, ora di sapere! Il contasd di ieri conta ben #{@asds.count}, asd. Sei il #{position}º gruppo per ASD inviati. (compresi quelli multipli, che sono #{defmultipletimes})")
    end
  end
end
