class MessageController < ActionController::API
  def message_process
    bot_api_key = ENV['BOT_API_KEY']
    client = HTTPClient
    message = params[:message].to_unsafe_h
    unless message[:text].nil? 
      text = message[:text]
    else
      text = message[:caption]
    end
    type = message[:chat].to_h[:type]
    id = message[:chat].to_h[:id]
    
    username = message[:chat].to_h[:username]
    update_id = params[:update_id]
    fromid = message[:from].to_h[:id]
    fromusername = message[:from].to_h[:username]
    if type == 'group' || type == 'supergroup'
        if text =~ /asd/i
          multiplevalue = text.scan(/asd/i).count
            unless Group.find_by(chat_id: id)
              @group = Group.create(chat_id: id, username: username)
            else
              @group = Group.find_by(chat_id: id)
            end
            unless @group.welcomesent
              client.get "http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{@group.chat_id}&text=Bella zio! Sono il bot asdoso creato da Ferdinando Traversa (ferdinando.me) da idea di Valerio Bozzolan, asd! Digita /grafico per ricevere il link ad un grafico, anche in privato per averne uno personale, asd o /classifca per scoprire cose interessanti. L'impostazione automatica %C3%A8 che io invii il conto degli ASD alla fine della serata, cos%C3%AC per%C3%B2 ti perdi cose belle come la faccina dell'ASD di mezzanotte. Per modificare questa impostazione, basta digitare /nightsend ed invier%C3%B2 il messaggio di conteggio appena invii un asd"
              @group.update_attribute(:welcomesent, true)
            end

            unless Sender.find_by(chat_id: fromid)
              @sender = Sender.create(chat_id: fromid, username: fromusername)
            else
              @sender = Sender.find_by(chat_id: fromid)
            end
            defmultiplevalue = multiplevalue - 1
          @asd = Asd.new(group: @group, sender: @sender, text: text, update_id: update_id, multiple_times: defmultiplevalue)
          defmultiplevalue.times do
            Asd.create(group: @group, sender: @sender, text: text)
          end

            asdcount = @group.asds.count
            case asdcount
            when 1
                addtext = 'Il primo asd. Benvenuto nella grande famiglia di asdbot'
                SpecialEvent.create(text: addtext, group: @group, asd: @asd)
            when 10
                addtext = 'Il decimo asd! Complimenti, asd.'
                SpecialEvent.create(text: addtext, group: @group, asd: @asd)
            when 100
                addtext = 'IL CENTESIMO ASD, ASD! COMPLIMENTS CONGRATULATIONS AUF WIDERSHEN'
                SpecialEvent.create(text: addtext, group: @group, asd: @asd)
            when 1000
                addtext = '1000 asd, wow! Questo gruppo, cos%C3%AC asdoso, asd'
                SpecialEvent.create(text: addtext, group: @group, asd: @asd)
            when 10000
                addtext = '10000 %C3%A8 un record mondiale, asd'
                SpecialEvent.create(text: addtext, group: @group, asd: @asd)
            end
            
          unless @group.nightsend
            if SpecialEvent.find_by(asd: @asd)
              client.get "http://api.telegram.org/bot#{bot_api_key}/sendPhoto?chat_id=#{@group.chat_id}&photo=http://www.lanciano.it/faccine/asdone.gif&caption=Cos%C3%AC asdoso, asd. #{SpecialEvent.find_by(asd: @asd).text}"
              SpecialEvent.find_by(asd: @asd).destroy
            end
            position = Group.all.sort_by{|group| group.asds.count}.pluck(:id).reverse.find_index(@group.id) + 1
             client.get "http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{@group.chat_id}&text=Il contasd conta ben #{asdcount} (+ #{defmultiplevalue}), asd. Sei il #{position}%C2%BA gruppo per ASD inviati."
            if @asd.created_at.strftime('%H:%M') == '00:00'
              client.get "http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{@group.chat_id}&text=Asd di mezzanotte %F0%9F%8C%9A"
            end
          end
        end
    end 
      
    if text == '/start' && (type == 'group' || type == 'supergroup')
      unless Group.find_by(chat_id: id)
        @group = Group.create(chat_id: id, username: username)
      else
        @group = Group.find_by(chat_id: id)
      end
      client.get "http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{@group.chat_id}&text=Bella zio! Sono il bot asdoso creato da Ferdinando Traversa (ferdinando.me) da idea di Valerio Bozzolan, asd! Digita /grafico per ricevere il link ad un grafico, anche in privato per averne uno personale, asd o /classifca per scoprire cose interessanti. L'impostazione automatica %C3%A8 che io invii il conto degli ASD alla fine della serata, cos%C3%AC per%C3%B2 ti perdi cose belle come la faccina dell'ASD di mezzanotte. Per modificare questa impostazione, basta digitare /nightsend ed invier%C3%B2 il messaggio di conteggio appena invii un asd"
      @group.update_attribute(:welcomesent, true)
    end

    if text == '/classifica'
      client.get "http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{id}&text=Vai su #{ENV['DOMAIN']}/classifica per vedere la classifica. Ci sono #{Group.count} che usano questo bot, comunque."
    end 
    
    if text == '/start' && type == 'private'
      client.get "http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{id}&text=Bella zio! Sono il bot asdoso creato da Ferdinando Traversa (ferdinando.me @ferdi2005) da idea di Valerio Bozzolan, asd! Aggiungimi ad un bel gruppo e conter%C3%B2 gli asd, altrimenti digita /grafico per il tuo grafico personal personal."
    end

    if text == '/grafico' && type == 'private'
      unless Sender.find_by(chat_id: fromid)
        client.get "http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{id}&text=Non ho ancora un grafico per te, sei nuovo per me, non ti conosco. Iscriviti in qualche gruppo con questo bot e manda asd a ripetizione, poi torna da me."
      else
        @sender = Sender.find_by(chat_id: fromid)
        position = 'primo in assoluto'
        position = Sender.all.sort_by{|sender| sender.asds.count}.pluck(:id).reverse.find_index(@sender.id) + 1 if Sender.count > 0
        client.get "http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{id}&text=Guarda il tuo grafico personalizzato per il gruppo su #{ENV['DOMAIN']}/grafico?s=#{@sender.chat_id}"
      end
    end
      
    if text == '/grafico' && (type == 'group' || type == 'supergroup')
      unless Group.find_by(chat_id: id)
        client.get "http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{id}&text=Non ho ancora un grafico per te, sei nuovo per me, non ti conosco. Invia qualche asd e prova questo comando."
      else
        @group = Group.find_by(chat_id: id)
        position = Group.all.sort_by{|group| group.asds.count}.pluck(:id).reverse.find_index(@group.id) + 1
        client.get "http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{id}&text=Guarda il tuo grafico personalizzato per il gruppo su #{ENV['DOMAIN']}/grafico?g=#{@group.chat_id}"
      end
    end

    if text == '/nightsend' && (type == 'group' || type == 'supergroup')
      unless Group.find_by(chat_id: id)
        client.get "http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{id}&text=Ok, l'impostazione predefinita %C3%A8 che l'invio del conto degli asd avvenga a mezzanotte, ma con questo comando la modifico. Procedo, asd."
        @group.update_attribute(:nightsend, false)
      else
        @group = Group.find_by(chat_id: id)
        if @group.nightsend
          client.get "http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{id}&text=Ok, l'impostazione predefinita %C3%A8 che l'invio del conto degli asd avvenga a mezzanotte, ma con questo comando la modifico. Procedo, ora avrai un messaggio ogni asd, asd."
          @group.update_attribute(:nightsend, false)
        else
          client.get "http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{id}&text=Sei una persona triste, asd. Vuoi che il conteggio venga inviato a mezzanotte. Bozzolan dice s%C3%AC, Ferdi dice no. Tu dici s%C3%AC, allora conteggio a mezzanotte sia, asd"
          @group.update_attribute(:nightsend, true)
        end
      end
    end
    render nothing: true
  end
end