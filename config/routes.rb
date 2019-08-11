Rails.application.routes.draw do
  post 'message_process', to: 'message#message_process'
  get 'classifica', to: 'standardpage#classifica'
  get 'grafico', to: 'standardpage#grafico'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
