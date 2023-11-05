# Dentro e fuori R

# v1.2.1 3/11/2023

# Qui, come per gli altri capitoli, ho trasformato in codice tutto quello che 
# c'era di eseguibile nel testo o nei chunk di R.
# Per commenti e spiegazioni fai riferimento al libro.
# Se stai leggendo il libro sai già come esegui gruppi di comandi (se no vai
# al capitolo 2 del libro...)


# setup -------------------------------------------------------------------

# carico i pacchetti (installandoli prima se necessario)

.cran_packages <- c( "vcd", "nycflights13", "data.table", "tidyverse", "openxlsx", 
                     "readxl", "foreign", "Hmisc","beepr", "tictoc")

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


# ogni cosa al suo posto --------------------------------------------------
# qual'è la tua working directory?
getwd()

# stampo a console la wd e attribuisco il nome lamiawd all'oggetto restituito
# dalla funzione getwd()

lamiawd <- getwd()

# che tipo di oggetto è?
# cambio la wd. Il comando non è specifico per il mio sistema, perché .. indica la
# cartella che contiene la cartella su cui sto lavorando

setwd("..")
getwd()

# riporto al wd a quella originale

setwd(lamiawd)


# facciamola semplice -----------------------------------------------------

library(tidyverse)
library (readxl)
library(vcd)
library(openxlsx)
data("Arthritis")
# salva un file delimitato da , con . come separatore decimale
write_csv(Arthritis, file = "Arthritis_comma.csv")
# salva un file delimitato da ; con . come separatore decimale
write_csv2(Arthritis, file = "Arthritis_semicolon.csv")
# salva un file delimitato da tabulazioni con . come separatore decimale
write_tsv(Arthritis, file = "Arthritis_tab.txt")
# salva un file .xlsx
write.xlsx(Arthritis, file = "Arthritis.xlsx")

# i comandi generati da Import dataset
library(readr)
Arthritis_semicolon <- read_delim("Arthritis_semicolon.csv", 
                                  delim = ";", escape_double = FALSE, trim_ws = TRUE)
View(Arthritis_semicolon)


# gestire file di testo con readr -----------------------------------------

# uso read_tsv per aprire un file da una URL
study_metadata <- read_tsv("https://tinyurl.com/34u6a9md")


#  da e per Excel ---------------------------------------------------------


arthritis_xlsx <- read_excel("Arthritis.xlsx")
arthritis_xlsx


# E' andato tutto bene? ---------------------------------------------------

View(Arthritis)
Arthritis
class(Arthritis)
Arthritis_2 <- as_tibble(Arthritis)
Arthritis_2
glimpse(Arthritis_2)
summary(Arthritis)


# Lavorare con i nomi dei file e le directory -----------------------------

# il percorso della tua working directory: quale delimitatore? \ o /?
getwd()

# percorsi indipendenti dalla piattaforma
mypath <- file.path(getwd(), "DataL3")
mypath 

# liste di file
la_mia_lista_di_file <- list.files(getwd())
str(la_mia_lista_di_file) 
# che cos'é? Che tipo di oggetto? Puoi immaginare comandi con cui usarlo?

la_mia_lista_di_file

# ora uso . per accedere gerarchicamente i livelli del file system
# nella cartella di lavoro
list.files(".")
# un livello superiore
list.files("..")

# guardare nelle cartelle
list.files(".", recursive = T)

# schegliere un file in modo interattivo
il_nome_del_file <- file.choose()

# Prova a ricostruire quello che fanno questi comandi usando l'aiuto:

head(la_mia_lista_di_file)
la_mia_wd <- getwd()
il_nome_della_mia_wd <- basename(la_mia_wd)
# la tilde abbrevia il percorso a una cartella, path.expand() lo espande
file.path("~","il_nome_della_mia_wd")
path.expand(file.path("~","il_nome_della_mia_wd"))
head(list.files(path.expand(file.path("~","il_nome_della_mia_wd"))),5)

?dir.create

la_mia_wd <- getwd()
if(!dir.exists(file.path(la_mia_wd,"lavori"))) dir.create(file.path(la_mia_wd,"lavori"))


# Appendice 1 -------------------------------------------------------------

# tre modi diversi per scrivere lo stesso comando
write_tsv(Arthritis, file = "Arthritis.tsv", append = F)
write_tsv(Arthritis, "Arthritis.tsv")
write_tsv(Arthritis, na = "NA", file = "Arthritis.tsv")


# Appendice 2 -------------------------------------------------------------


# preparazione, divido Arthritis in k=5 pezzi
j = 5 
if(j>nrow(Arthritis)) cat("\nATTENZIONE: scegli un valore più piccolo per k\n")
# crea opzionalmente una directory per contenere i file
if(!("kArthritis" %in% list.files(file.path(".")))) dir.create(file.path(".","kArthritis"))
# crea un indice per le righe dei pezzi da salvare
indice <- sort(gl(j, 1, nrow(Arthritis)))
# creo una copia
Arthritis_3 <- Arthritis
Arthritis_3$indice <- indice
# uso un loop (più avanti vedremo come questo può essere sostituito da un functional) per
# salvare pezzi separati
for (i in seq_along(1:j)){
  minidf <- dplyr::filter(Arthritis_3, indice == i)
  nome_file <- str_c("Arthritis_",i,".tsv", sep ="")
  write_tsv(dplyr::select(minidf, -indice), file = file.path(".", "kArthritis", nome_file))
}
# ora uso un loop per rimettere insieme i pezzi, usando i nomi dei file come indice
# quanti file di tipo .tsv ci sono?
nomi_file <- list.files(file.path(".", "kArthritis"))
quali_sono_tsv <- str_detect(nomi_file, "\\.tsv")
nomi_file<-nomi_file[quali_sono_tsv]
# creo una list vuota della lunghezza giusta
lista_file <- vector("list", length = length(nomi_file))
# questo loop legge i nomi dei file negli slot della lista
for (i in seq_along(nomi_file)){
  lista_file[[i]] <- read_tsv(file.path(".","kArthritis", nomi_file[i]))
  names(lista_file)[i]<-nomi_file[i]
}


# trasforma la lista in un data frame (e se si potesse fare con un loop?)
# modo n. 1, bruttino
Arthritis_frankenstein_brutto <- do.call(rbind, lista_file)
# modo n. 2 con map_dfr(), un functional, cioé un comando che applica una funzione a una lista
# e restituisce un data frame
Arthritis_frankenstein <- map_dfr(lista_file, bind_rows) # senza conservare i nomi dei file
Arthritis_frankenstein_nomi <- map_dfr(lista_file, bind_rows, .id = "nomi_file") # con i nomi dei file

# e, per farla ancora più semplice
percorsi <- file.path(".","kArthritis", nomi_file)
Arthritis_frankenstein_nomi_2 <- map_dfr(percorsi, read_tsv, .id = "nomi_file")

