class SendAsdCountJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Group.where(nightsend: true).each do |group|
      @group = group
      date = Date.yesterday 
      @asds = Asd.where(created_at: date.midnight..date.end_of_day, group: group)
      if SpecialEvent.find_by(group: @group)
        HTTParty.get(CGI.escape("http://api.telegram.org/bot#{bot_api_key}/sendPhoto?chat_id=#{@group.chat_id}&photo=http://www.lanciano.it/faccine/asdone.gif&caption=Così asdoso, asd. #{SpecialEvent.find_by(group: @group).text}"))
        SpecialEvent.find_by(group: @group).destroy
      end
      position = Group.all.sort_by{|group| group.asds.count}.pluck(:id).reverse.find_index(@group.id) + 1
      defmultipletimes = @asds.pluck(:multiple_times).sum
        HTTParty.get(CGI.escape("http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{@group.chat_id}&text=È mezzanotte, ora di sapere! Il contasd di ieri conta ben #{@asds.count}, asd. Sei il #{position}º gruppo per ASD inviati. (compresi quelli multipli, che sono #{defmultipletimes})"))
    end
  end
end
