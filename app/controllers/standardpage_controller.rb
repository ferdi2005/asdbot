class StandardpageController < ApplicationController
  def classifica
    @groups = Group.all.sort_by{|sender| sender.asds.totalcount}.reverse
    @senders = Sender.all.sort_by{|sender| sender.asds.totalcount}.reverse
  end

  def usernametoid
    if params[:username].split('@').count == 2
      params[:username] = params[:username].split('@')[1]
    end
    if Group.where('lower(username) LIKE lower(?)', "#{params[:username]}").any?
      @group = Group.where('lower(username) LIKE lower(?)', "#{params[:username]}").first
      respond_to do |format|
        format.json { render json: {status: '200', chat_id: @group.chat_id} }
      end 
    elsif Sender.where('lower(username) LIKE lower(?)', "#{params[:username]}").any?
      @sender = Sender.where('lower(username) LIKE lower(?)', "#{params[:username]}").first
      respond_to do |format|
        format.json { render json: {status: '201', chat_id: @sender.chat_id} }
      end
    else
      respond_to do |format|
        error = { status: '404' }
        format.json { render json: error, status: :not_found}
      end
    end
  end
  
  def grafico
    if !params[:s].nil?
      @sender = Sender.find_by(chat_id: params[:s])
    elsif !params[:g].nil?
      @group = Group.find_by(chat_id: params[:g])
    end
  end

  def home
    ENV['DOMAIN'] = "http://0.0.0.0:3000"
  end
end
