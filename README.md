# README

Crea un bellissimo bot che conta gli ASD.

ENV variabili richieste: DOMAIN (abbastanza ovvio, il dominio) e BOT_API_KEY, la vostra api key telegram per il bot, BOT_USERNAME

Inoltre, amici, vi ricordo che dovete avere un certificato SSL ed impostare il webhook telegram.

Schedulare in qualche modo il job, io uso Heroku Scheduler con `echo 'SendAsdCountJob.perform_now' | bundle exec rails c`