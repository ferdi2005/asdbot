class MessageController < ApplicationController
  def message_process
    bot_api_key = '836213850:AAG-aBtJB8khJ53DNRlzORUVcFWOH5SOF9o'
    if params[:token] == bot_api_key
      message = params[:message][:message]
      message = OpenStruct.new(JSON.parse(message))
      if message.try(:chat).try(:type) == 'group'
          if message.text.match?('/asd/')
              unless Group.find_by(chat_id: message.chat.id)
                @group = Group.create(chat_id: message.chat.id, username: message.chat.username)
              else
                @group = Group.find_by(chat_id: message.chat.id)
              end
              
              unless Sender.find_by(chat_id: message.from.id)
                @sender = Sender.create(chat_id: message.from.id, username: message.from.username)
              else
                @sender = Sender.find_by(chat_id: message.from.id)
              end
              @asd = Asd.create(group: @group, sender: @sender, text: message.text)      

              asdcount = @group.asds.count
              case asdcount
              when 1
                  addtext = 'Il primo asd. Benvenuto nella grande famiglia di asdbot'
              when 10
                  addtext = 'Il decimo asd! Complimenti, asd.'
              when 100
                  addtext = 'IL CENTESIMO ASD, ASD! COMPLIMENTS CONGRATULATIONS AUF WIDERSHEN'
              when 1000
                  addtext = '1000 asd, wow! Questo gruppo è così asdoso, asd'
              when 10000
                  addtext = '10000 è un record mondiale, asd'
              else
                  noasdface = true
                  addtext = ''
              end
              unless noasdface
                HTTParty.get("http://api.telegram.org/bot#{bot_api_key}/sendPhoto?chat_id=#{@group.chat_id}&photo=http://www.lanciano.it/faccine/asdone.gif&caption=Così asdoso, asd.")
              end
              position = 'primo in assoluto'
              position = Group.all.sort_by{|group| group.asds.count}.pluck(:id).reverse.find_index(@group.id) if Group.count > 0
              HTTParty.get("http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{@group.chat_id}&text=Il contasd conta ben #{asdcount}, asd. Sei il #{position}º gruppo per ASD inviati. #{addtext}");
          end
      end

      if message.text == '/start' && message.try(:chat).try(:type) == 'group'
        unless Group.find_by(chat_id: message.chat.id)
          @group = Group.create(chat_id: message.chat.id, username: message.chat.username)
        else
          @group = Group.find_by(chat_id: message.chat.id)
        end
        HTTParty.get("http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{@group.chat_id}&text=Bella zio! Sono il bot asdoso creato da Ferdinando Traversa (ferdinando.me) da idea di Valerio Bozzolan (reyboz.it), asd! Digita /grafico per ricevere il link ad un grafico, anche in privato per averne uno personale, asd o /classifca per scoprire cose interessanti.");
      end

      if message.text == '/classifica'
        HTTParty.get("http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{@group.chat_id}&text=Vai su #{request.domain}/classifica per vedere la classifica.");
      end 
      if message.text == '/start' && message.try(:chat).try(:type) == 'private'
        HTTParty.get("http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{message.chat.id}&text=Bella zio! Sono il bot asdoso creato da Ferdinando Traversa (ferdinando.me @ferdi2005) da idea di Valerio Bozzolan (reyboz.it), asd! Aggiungimi ad un bel gruppo e conterò gli asd, altrimenti digita /grafico per il tuo grafico personal personal.");
      end

      if message.text == '/grafico' && message.try(:chat).try(:type) == 'private'
        unless Sender.find_by(chat_id: message.from.id)
          HTTParty.get("http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{message.chat.id}&text=Non ho ancora un grafico per te, sei nuovo per me, non ti conosco. Iscriviti in qualche gruppo con questo bot e manda asd a ripetizione, poi torna da me.");
        else
          @sender = Sender.find_by(chat_id: message.from.id)
          position = 'primo in assoluto'
          position = Sender.all.sort_by{|sender| sender.asds.count}.pluck(:id).reverse.find_index(@sender.id) if Sender.count > 0
          HTTParty.get("http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{message.chat.id}&text=Amico caro, la funzionalità grafico sta arrivando, arriverà quando questo numero (#{Group.count}) sarà uguale a 20, forse. Nel frattempo ti posso solo dire che hai al tuo attivo ben #{@sender.asds.count} asd e sei il #{position}º inviatore di ASD classifica globale!");
        end
      end

      if message.text == '/grafico' && message.try(:chat).try(:type) == 'group' 
        unless Group.find_by(chat_id: message.chat.id)
          @group = Group.create(chat_id: message.chat.id, username: message.chat.username)
          HTTParty.get("http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{message.chat.id}&text=Non ho ancora un grafico per te, sei nuovo per me, non ti conosco. Invia qualche asd e prova questo comando.");
        else
          @group = Group.find_by(chat_id: message.chat.id)
          position = 'primo in assoluto'
          position = Group.all.sort_by{|group| group.asds.count}.pluck(:id).reverse.find_index(@group.id) if Group.count > 0
          HTTParty.get("http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{message.chat.id}&text=Amico caro, la funzionalità grafico sta arrivando, arriverà quando questo numero (#{Group.count}) sarà uguale a 20, forse. Nel frattempo ti posso solo dire che hai al tuo attivo ben #{@group.asds.count} asd e sei il #{position}º gruppo!");
        end
      end
    end
  end

  def classifica
    @groups = Group.all.sort_by{|sender| sender.asds.count}.reverse
    @senders = Sender.all.sort_by{|sender| sender.asds.count}.reverse
  end
end
