# Interfacce e ambient 

# v1.0.2 13/10/2023

# Qui, come per gli altri capitoli, ho trasformato in codice tutto quello che 
# c'era di eseguibile nel testo o nei chunk di R.
# Per commenti e spiegazioni fai riferimento al libro.
# Se stai leggendo il libro sai già come esegui gruppi di comandi (se no vai
# al capitolo 2 del libro...)


# setup -------------------------------------------------------------------
# questa sezione di codice va fatta girare tutta insieme
# Installo/carico le librerie 
# creo un vettore (invisibile, perché il nome è preceduto dal .)
# con i nomi delle librerie/pacchetti da caricare
.cran_packages <- c("tidyverse", "tictoc", "beepr", "car")
# bisognerebbe aggiungere anche "Rcmdr"
# verifico quali sono installati nel sistema
.inst <- .cran_packages %in% installed.packages()
# installo quelli non presenti nel sistema
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
# operazioni che usano generatori di numeri casuali daranno un risultato # diverso ogni volta che si fa "girare" lo script) rimuovi il segno di commento
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
# ad esempio: (rimuovi il segno di commento # per produrre il beep)
# if(play_audio) beep(sound = 6) 
# notifica la fine dell'esecuzione di questo gruppo di istruzioni


# Il pannello Source ------------------------------------------------------

data(mtcars)
help("mtcars")
View(mtcars)
plot(mtcars$wt, mtcars$mpg)
mean(mtcars$mpg)


# Il pannello Console -----------------------------------------------------

1+2*log10(10)-3
a <- 1L
b = c("a","b","c")
c <- c(1, 2, 3)
list(numero = a, vettore_string = b) -> la_mia_prima_lista
calcola_media <- function(vettore_numerico){mean(vettore_numerico)}
c
calcola_media(c)


# Il tab Packages. --------------------------------------------------------

# il comando successivo assegna l'elenco dei pacchetti disponibili in libreria 
# (un vettore carattere) al nome mypckgs
# i cui primi elementi vengono poi stampati a Console
mypckgs <-  installed.packages()
head(mypckgs, n = 5L)
# le due operazioni seguenti sono state eseguite dal chunk di setup
# installa il pacchetto car, un pacchetto di strumenti per la regressione 
# install.packages("car", repos = "https://cran.mirror.garr.it/CRAN/")
# carica il pacchetto nell'ambiente di lavoro: è anche possibile usare require()
# library(car)

