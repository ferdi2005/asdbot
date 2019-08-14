class MessageController < ActionController::API
  def message_process
      message = params[:message]
      return if message.nil? || message[:chat].nil? || message[:text].nil?
      unless message[:text].nil? 
        text = message[:text]
      else
        text = message[:caption]
      end
      if text.split('@').count == 2
        if text.split('@')[1] == ENV['BOT_USERNAME']
          text = text.split('@')[0]
        end 
      end
      type = message[:chat][:type]
      id = message[:chat][:id]
      username = message[:chat][:username]
      update_id = params[:update_id]
      fromid = message[:from][:id]
      fromusername = message[:from][:username]

      unless Group.find_by(chat_id: id) && (type == 'group' || type == 'supergroup')
        @group = Group.create(chat_id: id, username: username, title: message[:chat][:title]) if id < 0
      else
        @group = Group.find_by(chat_id: id)
        title = message[:chat][:title]
        if @group.title.nil? || @group.title != title
          @group.update_attribute(:title, title)
        end
  
        if @group.username != message[:chat][:username]
          @group.update_attribute(:username, message[:chat][:username])
        end  
      end

      unless @group.nil?
        unless @group.welcomesent
          Telegram.bot.send_message(chat_id: @group.chat_id, text: "Bella zio! Sono il bot asdoso creato da Ferdinando Traversa (ferdinando.me) da idea di Valerio Bozzolan, asd! Digita /grafico per ricevere il link ad un grafico, anche in privato per averne uno personale, asd o /classifca per scoprire cose interessanti. L'impostazione automaticaè che io invii il conto degli ASD alla fine della serata, così però ti perdi cose belle e non è più così funny. Per modificare questa impostazione, basta digitare /nightsend ed invierò il messaggio di conteggio appena invii un asd.")
          @group.update_attribute(:welcomesent, true)
        end
      end

      unless Sender.find_by(chat_id: fromid)
        first_name = message[:from][:first_name]
        last_name = message[:from][:last_name]
        totalname = "#{first_name} #{last_name}"  
        @sender = Sender.create(chat_id: fromid, username: fromusername, name: totalname)
      else
        @sender = Sender.find_by(chat_id: fromid)
        first_name = message[:from][:first_name]
        last_name = message[:from][:last_name]
        totalname = "#{first_name} #{last_name}"  
        if @sender.name.nil? || @sender.name != totalname
          @sender.update_attribute(:name, totalname)
        end
  
        if @sender.username != message[:from][:username]
          @sender.update_attribute(:username, message[:from][:username])
        end
    
      end
  
      if type == 'group' || type == 'supergroup'
          if text =~ /asd/i
            multiplevalue = text.scan(/asd/i).count
            defmultiplevalue = multiplevalue - 1
            precedenteconto = @group.asds.totalcount
            @asd = Asd.create(group: @group, sender: @sender, text: text, update_id: update_id, multiple_times: defmultiplevalue)
            
            unless Asd.find_by(sender: @sender)
              unless @group.classifica
                Telegram.bot.send_message(chat_id: @group.chat_id, text: "Ciao amico, questo gruppo ha la classifica privata. È la prima volta che ti vedo e quindi imposto la classifica privata anche per te, non sarai visto in classifica! Se vai invece fiero della tua asdosità, manda il comando /fuoriclassifica in privato e riattiverò la tua presenza in classifica. Puoi anche dare /classifica per vedere questa classifica di cui tutti parlano o /grafico per il tuo grafico personal personal.")
                @sender.update_attribute(classifica: false)
              end
            end
              asdcount = @group.asds.count
              case asdcount
              when 100
                  addtext = 'IL CENTESIMO ASD, ASD! COMPLIMENTS CONGRATULATIONS AUF WIDERSHEN'
                  SpecialEvent.create(text: addtext, group: @group, asd: @asd)
              when 1000
                  addtext = '1000 asd, wow! Questo gruppo, così asdoso, asd'
                  SpecialEvent.create(text: addtext, group: @group, asd: @asd)
              when 10000
                  addtext = '10000è un record mondiale, asd'
                  SpecialEvent.create(text: addtext, group: @group, asd: @asd)
              when 100000
                  addtext = '100000, sei il campione degli asd.'
                  SpecialEvent.create(text: addtext, group: @group, asd: @asd)
              end
              if SpecialEvent.find_by(asd: @asd)
                Telegram.bot.send_photo(chat_id: @group.chat_id, photo: 'http://www.lanciano.it/faccine/asdone.gif', caption: "Così asdoso, asd. #{SpecialEvent.find_by(asd: @asd).text}")
                SpecialEvent.find_by(asd: @asd).destroy
              end

            unless @group.nightsend
              position = Group.all.sort_by{|group| group.asds.count}.pluck(:id).reverse.find_index(@group.id) + 1
              altdef = " (+#{defmultiplevalue})" if defmultiplevalue > 0
              altdef = "" if defmultiplevalue == 0
              Telegram.bot.send_message(chat_id: @group.chat_id, text: "Il contasd conta ben #{precedenteconto + 1}#{altdef}, asd. Sei il #{position}º gruppo per ASD inviati.")
            end
            if @asd.created_at.strftime('%H:%M') == '00:00'
              Telegram.bot.send_message(chat_id: @group.chat_id, text: "Asd di mezzanotte %F0%9F%8C%9A")
            end
            
          end
      end 
        
      if text == '/start' && (type == 'group' || type == 'supergroup')
        unless Group.find_by(chat_id: id)
          @group = Group.create(chat_id: id, username: username) if id < 0
        else
          @group = Group.find_by(chat_id: id)
        end
        Telegram.bot.send_message(chat_id: @group.chat_id, text: "Bella zio! Sono il bot asdoso creato da Ferdinando Traversa (ferdinando.me) da idea di Valerio Bozzolan, asd! Digita /grafico per ricevere il link ad un grafico, anche in privato per averne uno personale, asd o /classifca per scoprire cose interessanti. L'impostazione automatica è che io invii il conto degli ASD alla fine della serata, così però ti perdi cose belle e non è più così funny.  Per modificare questa impostazione, basta digitare /nightsend ed invierò il messaggio di conteggio appena invii un asd.")
        @group.update_attribute(:welcomesent, true)
      end

      if text == '/classifica'
        Telegram.bot.send_message(chat_id: id, text: "Vai su #{ENV['DOMAIN']}/classifica per vedere la classifica. Ci sono #{Group.count} che usano questo bot, comunque.")
      end 
      
      if text == '/start' && type == 'private'
        Telegram.bot.send_message(chat_id: id, text: "Bella zio! Sono il bot asdoso creato da Ferdinando Traversa (ferdinando.me @ferdi2005) da idea di Valerio Bozzolan, asd! Aggiungimi ad un bel gruppo e conterò gli asd, altrimenti digita /grafico per il tuo grafico personal personal.")
      end

      if text == '/grafico' && type == 'private'
        unless Sender.find_by(chat_id: fromid)
          Telegram.bot.send_message(chat_id: id, text: 'Non ho ancora un grafico per te, sei nuovo per me, non ti conosco. Iscriviti in qualche gruppo con questo bot e manda asd a ripetizione, poi torna da me.')
        else
          @sender = Sender.find_by(chat_id: fromid)
          position = Sender.all.sort_by{|sender| sender.asds.count}.pluck(:id).reverse.find_index(@sender.id) + 1 if Sender.count > 0
          Telegram.bot.send_message(chat_id: id, text: "Guarda il tuo grafico personalizzato per il gruppo su #{ENV['DOMAIN']}/grafico?s=#{@sender.chat_id} Inoltre sappi che sei il #{position}º inviatore di asd nel mondo!")
        end
      end
        
      if text == '/grafico' && (type == 'group' || type == 'supergroup')
        unless Group.find_by(chat_id: id)
          Telegram.bot.send_message(chat_id: id, text: 'Non ho ancora un grafico per te, sei nuovo per me, non ti conosco. Invia qualche asd e prova questo comando.')
        else
          @group = Group.find_by(chat_id: id)
          Telegram.bot.send_message(chat_id: id, text: "Guarda il tuo grafico personalizzato per il gruppo su #{ENV['DOMAIN']}/grafico?g=#{@group.chat_id}")
        end
      end

      if text == '/nightsend' && (type == 'group' || type == 'supergroup')
        unless Group.find_by(chat_id: id)
          Telegram.bot.send_message(chat_id: id, text: "Non conosco questo gruppo.")
        else
          @group = Group.find_by(chat_id: id)
          if @group.nightsend
            Telegram.bot.send_message(chat_id: id, text: "Ok, l'impostazione predefinitaè che l'invio del conto degli asd avvenga a mezzanotte, ma con questo comando la modifico. Procedo, ora avrai un messaggio ogni asd, asd.")
            @group.update_attribute(:nightsend, false)
          else
            Telegram.bot.send_message(chat_id: id, text: "Sei una persona triste, asd. Vuoi che il conteggio venga inviato a mezzanotte. Bozzolan dice sì, Ferdi dice no. Tu dici sì, allora conteggio a mezzanotte sia, asd")
            @group.update_attribute(:nightsend, true)
          end
        end
      end

      if text == '/fuoriclassifica' && (type == 'group' || type == 'supergroup')
        unless Group.find_by(chat_id: id) 
          Telegram.bot.send_message(chat_id: id, text: "Non conosco questo gruppo.")
        else
          @group = Group.find_by(chat_id: id)
          if @group.classifica
            Telegram.bot.send_message(chat_id: id, text: "Siete delle persone tristi e/o poco competitive? Amate la privasi anche se Google sa tutto di voi, anche come vi siete vestiti ieri, asd? Allora questo è il comando per voi. Da oggi siete fuori dalla classifica, per scelta. Datelo di nuovo per riattivare (sicuramente avete sbagliato, vero?)")
            @group.update_attribute(:classifica, false)
          else
            Telegram.bot.send_message(chat_id: id, text: "Bravo! Hai fatto la scelta giusta, fai ritornare il tuo gruppo nella classifica pubblica con questo semplice comandino")
            @group.update_attribute(:classifica, true)
          end
        end
      end

      if text == '/fuoriclassifica' && type == 'private'
        unless Sender.find_by(chat_id: id) 
          Telegram.bot.send_message(chat_id: id, text: "Non ti conosco, asd.")
        else
          @group = Sender.find_by(chat_id: id)
          if @group.classifica
            Telegram.bot.send_message(chat_id: id, text: "Sei una persona triste o poco competitiva? Questo è il comando giusto per te. Da oggi non apparirai più nella classifica pubblica.")
            @group.update_attribute(:classifica, false)
          else
            Telegram.bot.send_message(chat_id: id, text: "Bravo! Hai fatto la scelta giusta, ritorna nella classifica pubblica con questo semplice comandino")
            @group.update_attribute(:classifica, true)
          end
        end
      end

      comandi = ["/fuoriclassifica", "/classifica", "/start", "/grafico", "/nightsend"]
      if !text.in?(comandi) && type == 'private'
        Telegram.bot.send_message(chat_id: id, text: "Cos…? asd")
      end
      render nothing: true
  end
end
