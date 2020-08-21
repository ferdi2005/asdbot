# frozen_string_literal: true

Rails.application.routes.draw do
  root 'standardpage#home'
  post 'message_process', to: 'message#message_process'
  get 'classifica', to: 'standardpage#classifica'
  get 'grafico', to: 'standardpage#grafico'
  get 'usernametoid', to: 'standardpage#usernametoid'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
