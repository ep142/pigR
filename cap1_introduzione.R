# Introduzione {#intro}


# v1.1.1 5/8/2023

# Qui, come per gli altri capitoli, ho trasformato in codice tutto quello che 
# c'era di eseguibile nel testo o nei chunk di R.
# se stai leggendo il libro sai già come esegui gruppi di comandi (se no vai
# al capitolo 2 del libro...)


# setup -------------------------------------------------------------------

# il segno "#" descrive un commento, che non verrà interpretato da R durante
# l'esecuzione.
# In realtà sarebbe buona pratica di stile usare "#'": si chiamano commenti in
# stile ROxygen e possono servire se si vuole produrre al volo un report da uno script
# siccome questo non è il nostro caso, non li userò.

# Questo è un "chunk" di codice R. Imparererai più avanti cosa significhi.
# Leggi attentamente il codice e i commenti, se e quando avrai tempo

knitr::opts_chunk$set(echo = TRUE)

# installa/carica le librerie 
# crea un vettore (invisibile, perché il nome è preceduto dal .)
# con i nomi delle librerie/pacchetti da caricare
.cran_packages <- c("tidyverse", "tictoc", "beepr")
# verifico quali sono installati nel sistema
.inst <- .cran_packages %in% installed.packages()
# istallo quelli non presenti nel sistema
if(any(!.inst)) {
  install.packages(.cran_packages[!.inst], repos = "https://cloud.r-project.org")
}
# uso un "functional" (sapply()) per caricare i pacchetti nell'ambiente
# di lavoro
sapply(.cran_packages, require, character.only = TRUE)

# naturalmente, in R ci sono molti modi per fare esattamente la stessa cosa

# altre operazioni di setup
# creo una copia dei parametri (grafici e non solo) di R
# per ripristinarli velocemente in caso vengano cambiati
opar <- par(no.readonly=TRUE) 
# modifico il parametro ask, in modo che demo(graphics) non richieda l'intervento dell'utente
par(ask=F) 
# se vuoi impostare un seme per il generatore di numeri casuali 
# (è importante per la riproducibilità per scopi didattici, altrimenti molte 
# operazioni che usano generatori di numeri casuali daranno un risultato 
# diverso ogni volta che si fa "girare" lo script) rimuovi il segno di commento
# (#) dall'istruzione successiva
# set.seed(1234) 
# imposta alcune opzioni utili in una sessione interattiva
#
# se T (vero) userà il comando sound() del pacchetto beepr per
# riprodurre un suono: utile per richiamare l'attenzione nel caso si 
# avviino calcoli linghi
play_audio <- T
# se T verrà avviato un contatore per alcune operazioni importanti
keep_time <- T
# se T verrà stampato output addizionale
verbose_output <- T
# ad esempio (per riprodurre il suono rimuovi il segno di commento):
# if(play_audio) beep(sound = 6) 
# notifica la fine dell'esecuzione di questo gruppo di istruzioni


# convenzioni -------------------------------------------------------------

# Quando nel testo compare un blocco in grigio, come quello che segue si tratta 
# di un comando o di una serie di comandi, e deve essere scritto nella console  

demo(graphics)

# provare per credere: app, GUI e altre diavolerie ------------------------

demo(graphics)
# segui le istruzioni sulla console
 # prova ora con 
help(demo)

# carica R commander
library(Rcmdr)
# Se appare un errore è perché il pacchetto non è ancora installato nel tuo sistema. 
# In questo caso rimuovi il segno # dal seguente comando e eseguilo:                   
install.packages("Rcmdr", dependencies = T)  

# installa e lancia Radiant (ci vuole un po')
install.packages("radiant")
require(radiant)
radiant::radiant()


