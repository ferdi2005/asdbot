class MessageController < ApplicationController
  def message_process
    client = HTTPClient
    bot_api_key = '836213850:AAG-aBtJB8khJ53DNRlzORUVcFWOH5SOF9o'
    return false if params[:message].blank?
    message = params[:message].to_unsafe_h
    if message[:chat][:type] == 'group' || message[:chat][:type] == 'supergroup'
        if message[:text].downcase =~ /asd/
          multiplevalue = message[:text].downcase.scan(/asd/).count
            unless Group.find_by(chat_id: message[:chat][:id])
              @group = Group.create(chat_id: message[:chat][:id], username: message[:chat][:username])
            else
              @group = Group.find_by(chat_id: message[:chat][:id])
            end
            
            unless @group.welcomesent
              client.get("http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{@group.chat_id}&text=Bella zio! Sono il bot asdoso creato da Ferdinando Traversa (ferdinando.me) da idea di Valerio Bozzolan, asd! Digita /grafico per ricevere il link ad un grafico, anche in privato per averne uno personale, asd o /classifca per scoprire cose interessanti. L'impostazione automatica è che io invii il conto degli ASD alla fine della serata, così però ti perdi cose belle come la faccina dell'ASD di mezzanotte. Per modificare questa impostazione, basta digitare /nightsend ed invierò il messaggio di conteggio appena invii un asd")
              @group.update_attribute(:welcomesent, true)
            end

            unless Sender.find_by(chat_id: message[:from][:id])
              @sender = Sender.create(chat_id: message[:from][:id], username: message[:from][:username])
            else
              @sender = Sender.find_by(chat_id: message[:from][:id])
            end
            defmultiplevalue = multiplevalue - 1
          @asd = Asd.new(group: @group, sender: @sender, text: message[:text], update_id: params[:update_id], multiple_value: defmultiplevalue)
          defmultiplevalue.each do |multiple|
            multiple = Asd.new(group: @group, sender: @sender, text: message[:text])
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
                addtext = '1000 asd, wow! Questo gruppo, così asdoso, asd'
                SpecialEvent.create(text: addtext, group: @group, asd: @asd)
            when 10000
                addtext = '10000 è un record mondiale, asd'
                SpecialEvent.create(text: addtext, group: @group, asd: @asd)
            end
            
          unless @group.nightsend
            if SpecialEvent.find_by(asd: @asd)
              client.get("http://api.telegram.org/bot#{bot_api_key}/sendPhoto?chat_id=#{@group.chat_id}&photo=http://www.lanciano.it/faccine/asdone.gif&caption=Così asdoso, asd. #{SpecialEvent.find_by(asd: @asd).text}")
              SpecialEvent.find_by(asd: @asd).destroy
            end
            position = Group.all.sort_by{|group| group.asds.count}.pluck(:id).reverse.find_index(@group.id) + 1
              client.get("http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{@group.chat_id}&text=Il contasd conta ben #{asdcount} (+ #{defmultiplevalue}), asd. Sei il #{position}º gruppo per ASD inviati.")
            if @asd.created_at.strftime('%H:%M') == '00:00'
              client.get("http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{@group.chat_id}&text=Asd di mezzanotte 🌚")
            end
          end
        end
    end 
      
    if message[:text] == '/start' && (message[:chat][:type] == 'group' || message[:chat][:type] == 'supergroup')
      unless Group.find_by(chat_id: message[:chat][:id])
        @group = Group.create(chat_id: message[:chat][:id], username: message[:chat][:username])
      else
        @group = Group.find_by(chat_id: message[:chat][:id])
      end
      client.get("http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{@group.chat_id}&text=Bella zio! Sono il bot asdoso creato da Ferdinando Traversa (ferdinando.me) da idea di Valerio Bozzolan, asd! Digita /grafico per ricevere il link ad un grafico, anche in privato per averne uno personale, asd o /classifca per scoprire cose interessanti. L'impostazione automatica è che io invii il conto degli ASD alla fine della serata, così però ti perdi cose belle come la faccina dell'ASD di mezzanotte. Per modificare questa impostazione, basta digitare /nightsend ed invierò il messaggio di conteggio appena invii un asd.")
      @group.update_attribute(:welcomesent, true)
    end

    if message[:text] == '/classifica'
      client.get("http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{message[:chat][:id]}&text=Vai su #{ENV['DOMAIN']}/classifica per vedere la classifica. Ci sono #{Group.count} che usano questo bot, comunque.")
    end 
    
    if message[:text] == '/start' && message[:chat][:type] == 'private'
      client.get("http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{message[:chat][:id]}&text=Bella zio! Sono il bot asdoso creato da Ferdinando Traversa (ferdinando.me @ferdi2005) da idea di Valerio Bozzolan, asd! Aggiungimi ad un bel gruppo e conterò gli asd, altrimenti digita /grafico per il tuo grafico personal personal.")
    end

    if message[:text] == '/grafico' && message[:chat][:type] == 'private'
      unless Sender.find_by(chat_id: message[:from][:id])
        client.get("http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{message[:chat][:id]}&text=Non ho ancora un grafico per te, sei nuovo per me, non ti conosco. Iscriviti in qualche gruppo con questo bot e manda asd a ripetizione, poi torna da me.")
      else
        @sender = Sender.find_by(chat_id: message[:from][:id])
        position = 'primo in assoluto'
        position = Sender.all.sort_by{|sender| sender.asds.count}.pluck(:id).reverse.find_index(@sender.id) + 1 if Sender.count > 0
        client.get("http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{message[:chat][:id]}&text=Amico caro, la funzionalità grafico sta arrivando, arriva quando questo numero (#{Group.count}) uguale a 20, forse. Nel frattempo ti posso solo dire che hai al tuo attivo ben #{@sender.asds.count} asd e sei il #{position}º inviatore di ASD classifica globale!")
      end
    end
      
    if message[:text] == '/grafico' && (message[:chat][:type] == 'group' || message[:chat][:type] == 'supergroup')
      unless Group.find_by(chat_id: message[:chat][:id])
        @group = Group.create(chat_id: message[:chat][:id], username: message[:chat][:username])
        client.get("http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{message[:chat][:id]}&text=Non ho ancora un grafico per te, sei nuovo per me, non ti conosco. Invia qualche asd e prova questo comando.")
      else
        @group = Group.find_by(chat_id: message[:chat][:id])
        position = Group.all.sort_by{|group| group.asds.count}.pluck(:id).reverse.find_index(@group.id) + 1
        client.get("http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{message[:chat][:id]}&text=Amico caro, la funzionalità grafico sta arrivando, arriverà quando questo numero (#{Group.count}) sarà uguale a 20, forse. Nel frattempo ti posso solo dire che hai al tuo attivo ben #{@group.asds.count} asd e sei il #{position}º gruppo!")
      end
    end

    if message[:text] == '/nightsend' && (message[:chat][:type] == 'group' || message[:chat][:type] == 'supergroup')
      unless Group.find_by(chat_id: message[:chat][:id])
        @group = Group.create(chat_id: message[:chat][:id], username: message[:chat][:username])
        client.get("http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{message[:chat][:id]}&text=Ok, l'impostazione predefinita è che l'invio del conto degli asd avvenga a mezzanotte, ma con questo comando la modifico. Procedo, asd.")
        @group.update_attribute(:nightsend, false)
      else
        @group = Group.find_by(chat_id: message[:chat][:id])
        if @group.nightsend
          client.get("http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{message[:chat][:id]}&text=Ok, l'impostazione predefinita è che l'invio del conto degli asd avvenga a mezzanotte, ma con questo comando la modifico. Procedo, ora avrai un messaggio ogni asd, asd.")
          @group.update_attribute(:nightsend, false)
        else
          client.get("http://api.telegram.org/bot#{bot_api_key}/sendMessage?chat_id=#{message[:chat][:id]}&text=Sei una persona triste, asd. Vuoi che il conteggio venga inviato a mezzanotte. Bozzolan dice sì, Ferdi dice no. Tu dici sì, allora conteggio a mezzanotte sia, asd")
          @group.update_attribute(:nightsend, true)
        end
      end
    end
  end

  def classifica
    @groups = Group.all.sort_by{|sender| sender.asds.count}.reverse
    @senders = Sender.all.sort_by{|sender| sender.asds.count}.reverse
  end

  def home
  end
end