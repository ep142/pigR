# Chiedere aiuto

# v1.1.1 30/10/2023

# Qui, come per gli altri capitoli, ho trasformato in codice tutto quello che 
# c'era di eseguibile nel testo o nei chunk di R.
# Per commenti e spiegazioni fai riferimento al libro.
# Se stai leggendo il libro sai già come esegui gruppi di comandi (se no vai
# al capitolo 2 del libro...)


# setup -------------------------------------------------------------------
# questo chunk è disponibile, con commenti, nelle lezioni 1 e 2
# in questa lezione i commenti sono stati eliminati tranne che per il
# materiale nuovo
# Scorri rapidamente il codice e cerca di ricordare cosa fanno i 
# diversi comandi: se non ci riesci apri la lezione 1 o 2


.cran_packages <- c("car", "tidyverse", "tictoc", "beepr", "microbenchmark")

.inst <- .cran_packages %in% installed.packages()

if(any(!.inst)) {
  install.packages(.cran_packages[!.inst], repos = "https://cloud.r-project.org")
}

sapply(.cran_packages, require, character.only = TRUE)

opar <- par(no.readonly=TRUE) 

par(ask=F) 
# set.seed(1234) 

play_audio <- T

keep_time <- T

verbose_output <- T

# if(play_audio) beep(sound = 6) 


# molti modi per pelare un gatto ------------------------------------------

# creo un data frame (in realtà una tibble) con numeri casuali 
# estratti da una distribuzione uniforme
# installa il pacchetto e caricalo se necessario rimuovendo il segno di commento
# ed eseguendo i due comandi successivi
# install.packages ("tidyverse")
# require(tidyverse)
# numero di righe o casi nella tabella df
n_casi <- 10000
# creo la tibble
df <- tibble( a = rnorm(n_casi), b = rnorm(n_casi),
              c = rnorm(n_casi), d = rnorm(n_casi),
              e = rnorm(n_casi), f = rnorm(n_casi),
              g = rnorm(n_casi), h =rnorm(n_casi))

# il data frame
df

tempo0 <- Sys.time() # inizializza it tempo con il tempo di sistema
# 1. uso la stessa funzione su ciascuna colonna e unisco i risultati
# in un vettore con la funzione c()
mediane <- c(median(df$a), 
             median(df$b),
             median(df$c),
             median(df$d),
             median(df$e),
             median(df$f),
             median(df$g),
             median(df$h))
# memorizzo il valore del tempo trascorso
chiamate_multiple <- Sys.time()-tempo0
# stampo a console un messaggio informativo con la funzione cat(); \n crea
# un ritorno a capo
cat("mediane con chiamate singole\n")
# "stampo" a console il risultato
mediane
# il risultato è un vettore, privo dell'attributo nomi 
# (identificante ogni elemento del vettore), 
# che poteva essere aggiunto usando, per esempio a = median(df$a)

# 2. uso di un loop sulle colonne
tempo0 <- Sys.time()
# inizializzo un vettore che riceverà i risultati
output <- vector("double", length = ncol(df))
# creo l'output con un loop for 
for (i in seq_along(df)) { # la sequenza 
  output[[i]] <- median(df[[i]]) # il corpo del loop 
} 
uso_un_loop <- Sys.time()-tempo0
cat("mediane con loop for\n")
output

# 3. uso di apply()
tempo0 <- Sys.time()
# apply "applica" la funzione median alla dimensione 2 (le colonne) di df
mediane_apply <- apply(df, 2, median)
uso_apply <- Sys.time()-tempo0
cat("mediane con apply\n")
mediane_apply

# 4. uso la funzione map_dbl() del pacchetto purrr del tidyverse
tempo0 <- Sys.time()
# map_dbl "applica" la funzione median alle colonne di df
le_mie_mediane <- map_dbl(df, median)
con_purrr <- Sys.time()-tempo0
cat("\nmediane con purrr:map_dbl()\n")
le_mie_mediane

# creo un vettore con i tempi calcolati per ciascuna modalità
tempi <- c(multiple = chiamate_multiple, loop = uso_un_loop, 
           apply = uso_apply, purrr = con_purrr)
cat("\ntempi di esecuzione\n")
tempi


# funzioni per chiedere aiuto ---------------------------------------------

# aprire la pagina di aiuto
help.start()
# aprire la pagina di aiuto per una pagina specifica
help("plot") 
# le virgolette sono opzionali; se non si usa l'opzione package verrà mostrato 
# l'aiuto per l'ultimo pacchetto  caricato in memoria (vedi capitolo 4)
?plot
# cercare nell'aiuto con una parola chiave
help.search("array") 
# in questo caso le virgolette sono obbligatorie
??array
# far girare il codice degli esempi di una funzione
example("pretty") 
# caricare una vignetta 
vignette("embedding", package = "car") 
# cercare le funzioni il cui nome contiene la parola ("plot")
apropos("plot", mode = "function")
# cercare nel sito di R una parola chiave
RSiteSearch("scatterplot")
# ottenere una lista dei data set presenti nei pacchetti caricati in memoria
data()

# Ovviamente, in maniera piuttosto ricorsiva, puoi cercare aiuto su ciascuna di queste funzioni: prova a scrivere nella `Console`:
help(help)
# il risultato della funzione `help()`, se non usi l'opzione `package` potrebbe dipendere dall'ordine con il quale sono caricati i pacchetti
library(dplyr)  
help(filter)  
help(filter, package ="dplyr")  
help(filter, package ="stats")  

