# Dati, oggetti, funzioni, linguaggio

# v1.3.3 27/08/2023

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
.cran_packages <- c( "car", "vcd", "nycflights13", "tidyverse", "tictoc", "beepr")

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

#if(play_audio) beep(sound = 6)


# Premessa 2. Misure e dati, osservazioni e variabili, tabelle ------------

# apre il dataset, che è incluso nell'installazione di base
data("iris")
# mostra il dataset nel tab View del pannello Source in RStudio. Rimuovi il segno 
# del commento per eseguire il comando
# View(iris)
# mostra l'aiuto del data set, in alternativa ?iris
# help(iris)
# stampa le prime 20 righe del data set nella Console o, in questo caso, nell'interno del documento
head(iris,20)
tail(iris, 20)
print(iris, digits = 2)
data(iris)
View(iris)
?iris
iris

#Arthritis

# carica la libreria (in realtà questo avviene in maniera automatica nel setup 
# dello script usato per generare questo capitolo)
library(vcd)
# carica il dataset
data("Arthritis")
# stampa il data set nella Console o, in questo caso, nell'interno del documento
head(Arthritis,20)
# più avanti vedremo delle funzioni che permettono di personalizzare l'aspetto
# di una tabella in un documento, in un report o una presentazione

View(Arthritis)
?Arthritis


# Tidy vs untidy ----------------------------------------------------------


# non badate ai comandi, tutti del pacchetto dplyr appartenente al tidyverse, 
# imparerete come usarli nei capitoli successivi
# qui head() è usato per stampare alcune righe

Arthr <- Arthritis %>% arrange(Treatment, Sex, Improved)
head(Arthr,20)

ir <- iris %>% dplyr::select(5, 1:4)
head(ir,20)

library(tidyr)
data("billboard")
head(billboard,25)

(espliciti <-data.frame(anno = c(1999,2000,2001,2002), vendite=c(100, NA, 101,102)))
(impliciti<-data.frame(anno = c(1999, 2001,2002), vendite=c(100, 101,102))) 

?NA
sqrt(-2)
?NULL


# assegnare nomi ----------------------------------------------------------


# un oggetto di tipo numerico, intero
# verrà solo stampato a console ma non assegnato
1L 
# 1L è un vettore intero di lunghezza 1
c(1, 2, 3) # un altro oggetto, un vettore numerico a precisione doppia di lunghezza 3
# l'assegnazione dell'oggetto al nome a, l'istruzione assegna ma non stampa a console
a <- 1L 
# stampa a console il valore di a
a 
# assegnare e stampare contemporaneamente
(a <- 1L)
class(a) # la classe di a
typeof(a) # il tipo o modo di a
# tre modi validi, per assegnare, ma il primo è preferibile perché meno ambiguo
b <- c(1, 2, 3)
b = c(1, 2, 3)
c(1, 2, 3) -> b
b

# un po' di magia
a
a <- b
a

# attributi importantissimi sono la classe e il tipo
class(b) # la classe di a
typeof(b) # il tipo o modo di a
# altri attributi importanti sono la dimensione 
# che (ha senso per gli oggetti a 2 o più dimensioni)
dim(Arthritis)
# e la lunghezza (ha senso per oggetti a una dimensione)
length(b)
# alcuni oggetti hanno nomi per i singoli elementi o per le diverse dimensioni
vettore_con_nomi <- c(a = 1, b = 2, c = 3)
names(vettore_con_nomi)
colnames(Arthritis)
rownames(Arthritis)

# queste funzioni possono essere usate per leggere o assegnare i nomi:
names(vettore_con_nomi)
vettore_con_nomi
names(vettore_con_nomi) <- c("d", "e", "f")
vettore_con_nomi


# il nome delle cose ------------------------------------------------------


# un nome valido: è bene che i nomi siano descrittivi e che dal nome si possa capire
# per quanto possibile, che cos'é l'oggetto: questo aiuta molto nella lettura del codice
il_mio_nome <- "Maurizio"
# ma va bene anche
il_mio_nome <- c(1,2,3)
# in fondo, R che ne sa?
# lo stesso oggetto con 2 nomi
c <- d <- 3L
# maiuscole e minuscole non sono la stessa cosa
C <- 4L
# cat() è una funzione molto utile per documentare ciò che va in console
# \n permette di inserire un daccapo; 
cat("\nil valore di c piccolo è\n")
c
cat("\nil valore di C grande è\n")
C
# è bene dare nomi descrittivi agli oggetti
il_mio_nome <- "Maurizio"
# questo va bene e l'uso di _ per separare parole di chiama "snake case"
# questi funzionano ma vanno meno bene
ilmionome <- "Silvio"
ILMIONOME <- "Giorgia"
IlMioNome <- "Matteo"
# questo si chiama "camel case" perché le maiuscole assomigliano 
# alle gobbe di un cammello

# per le funzioni è meglio usare verbi
fai_la_somma <- function(a=1, b=2, c=3) a+b+c
cat("\nla somma di 5, 6 e 7 è\n")
fai_la_somma(5,6,7)

# un nome sbagliato, non sintattico
1schifodinome <- 1
# restituisce un errore
`1schifodinome` <- 1
`1schifodinome`
# questo funziona, ma è uno schifo
# questo piccolo trucco può venire comodo nell'importazione di dati da altri
# software che non hanno questo tipo di limitazioni


# vettori a una dimensione ------------------------------------------------

# riprendiamo alcuni dei vettori creati precedentemente e "interroghiamoli"
a
# la classe
class(a)
# il tipo o modo (che è il modo con cui R conserva in memoria l'oggetto)
typeof(a)
# la lunghezza
length(a)
# i nomi, se esistono (altrimenti restituisce NULL)
names(a)
# proviamo con un altro
vettore_con_nomi
class(vettore_con_nomi)
names(vettore_con_nomi)
# nota che il risultato di names() può essere assegnato
i_nomi <- names(vettore_con_nomi)
# che vettore abbiamo creato? di che classe, lunghezza, tipo?
# un modo semplice per conoscere gli attributi
attributes(vettore_con_nomi)
# che tipo di oggetto restituisce attributes()? Prova ad usare l'aiuto...
# con la funzione c() possiamo anche concatenare vettori. Vediamo che succede:
vettori_concatenati <- c(a,b)
class(vettori_concatenati)
typeof(vettori_concatenati)

# nota come questo sia un vettore carattere; eccone altri
il_mio_TESTO <- c("A","B","C")
il_mio_testo <- c("a","b","c") 
# nota che questo non è lo stesso oggetto e che anche i nomi sono diversi


# naturalmente è possibile creare un vettore logico direttamente

logico <- c(TRUE, FALSE, FALSE)

# ma anche 

logico <- c(T, F, F)

# alcune funzioni usate per interrogare oggetti restituiscono valori logici

is.numeric(a)
is.logical(logico)
is.logical(a)

# i fattori sono molto importanti, sia per ragioni storiche, sia perché sono il 
# prototipo delle variabili categoriche

# creiamo un fattore non ordinato (il default)
fattore_non_o <- factor(c("vowel","consonant","consonant"))
# la funzione str() ci dice qualcosa sulla struttura di quest'oggetto
str(fattore_non_o)
# come vedi, di default R ha assegnato il livello in ordine alfabetico
# nota anche come, in realtà, i valori siano conservati come interi (1, 2)
# mentre i nomi dei livelli sono attributi
# prova a leggere l'aiuto di factor() e as-factor()
# guarda cosa succede con una variabile ordinale, se non stiamo attenti
quanto <- factor(c("molto", "molto", "poco", "moltissimo", "abbastanza"))
quanto
str(quanto)
# sarebbe ovviamente desiderabile che ci fosse un ordine logico:
# in fondo poco è meno abbastanza, che è meno di molto che è meno di moltissimo
# a questo punto i default della funzione factor() non bastano, e dobbiamo essere
# più specifici, indicando i livelli:
quanto_ord <-factor(c("molto", "molto", "poco", "moltissimo", "abbastanza"),
                    levels = c("poco", "abbastanza", "molto", "moltissimo"),
                    ordered = T)
quanto_ord
str(quanto_ord)
# nota che i fattori sono conservati in memoria come interi, con attributi
typeof(quanto_ord)
attributes(quanto_ord)
# nota che è buona pratica di programmazione dividere in maniera logica su più 
# linee un singolo comando molto lungo; se non sei cert\* come farlo, prova a 
# selezionare il comando o la parte di codice che vuoi formattare correttamente e
# poi usa il menu <Code->Reformat Code> (in alcuni casi può essere utile <Reindent lines>)
# per quanto il codice diventi più lungo è più facile leggerlo


# altri modi di stampare --------------------------------------------------

# caratteri speciali
# in alcuni casi potrebbe essere necessario aggiungere caratteri speciali al testo
# aggiungere esplicitamente delle virgolette
virgolettato <- c("'A'", "'B'", "'C'")
virgolettato
(virgolettato_doppio <- c('"A"', '"B"', '"C"'))
# degli a capo (per inserire tabulazioni puoi usare \t)
a_capo <- "A\nB\nC"

# altri modi di stampare 

# nota come diversi comandi possano stampare contenuto o contenuto "grezzo"
print(virgolettato)
cat(virgolettato)
writeLines(a_capo)


# coercizione -------------------------------------------------------------
due_vettori <- c(vettori_concatenati, i_nomi)
due_vettori
class(due_vettori)
typeof(due_vettori)
as.character(vettori_concatenati)
typeof(as.character(vettori_concatenati))
typeof(as.character(vettori_concatenati))
as.numeric(i_nomi)

# controlliamo se il contenuto dei due oggetti è identico, elemento per elemento, con la funzione ==
il_mio_TESTO == il_mio_testo
# cosa restituisce quest'operazione? Che lunghezza ha il risultato?
# Controlliamo, assegnando il risultato ad un vettore

risultato <- (il_mio_TESTO == il_mio_testo)
class(risultato)
typeof(risultato)
length(risultato)
# il risultato è un vettore logico di lunghezza 3, perché sono stati fatti 3 confronti

# oppure possiamo usare le funzioni as.xxxx()
as.factor(il_mio_testo)
as.numeric(logico)
as.character(b)
as.character(quanto)
as.logical(c(1,0,1,0))


# matrici e array ---------------------------------------------------------

?matrix
?array

# Questi comandi sono equivalenti, e creano una sequenza da 1 a 9
1:9
seq(1,9)
seq(from = 1, to = 9, by = 1)

# una matrice 3x3 riempita per colonne
per_colonne <- matrix(seq(1,9), nrow =3, ncol= 3, 
                      dimnames = list(c("A","B","C"),c("D","E","F")))
per_colonne

# che succede se il vettore ha la dimensione sbagliata?
per_colonne_sbagliato <- matrix(seq(1,10), nrow =3, ncol= 3, 
                                dimnames = list(c("A","B","C"),c("D","E","F")))
per_colonne_sbagliato_2 <- matrix(seq(1,8), nrow =3, ncol= 3, 
                                  dimnames = list(c("A","B","C"),c("D","E","F")))
warnings()

per_righe <- matrix(seq(1:9), 
                    nrow =3, ncol= 3, byrow = T, 
                    dimnames = list(c("A","B","C"),c("D","E","F")))
per_righe

# ovviamente è possibile creare matrici di valori carattere o logici o interi
matrice_logica <- matrix(c(logico, logico, logico),
                         nrow =3, ncol= 3, byrow = T, 
                         dimnames = list(c("A","B","C"),c("D","E","F")))
matrice_logica

si9 <- rep("Yes",9)
mantra <- rep(c("amore","pace"),6)

matrice_carattere <- matrix(mantra,
                            nrow =3, ncol= 2, byrow = T, 
                            dimnames = list(c("A","B","C"),c("A","B")))

per_colonne
matrice_carattere
matrice_logica

class(matrice_carattere)
typeof(matrice_carattere)
str(matrice_carattere)
dim(matrice_carattere)

# creo un array 3x4x3
array_per_colonne <- array(seq(1:36),
                           dim = c(3,4,3),
                           dimnames = list(c("A","B","C"),c("D","E","F","G"),
                                           c("X","Y","Z")))
# nota come viene riempito e stampato:
# strato 1, colonna 1, righe 1-n, etc.
array_per_colonne
# è anche possibile non specificare i nomi
array_senza_nomi <- array(rep(c(1,2,3), each = 6),
                          dim = c(3,3,2))
array_senza_nomi

# head() permette di stamparìe solo alcune righe
head(Arthritis[,c(2,3)], 10)
class(Arthritis[,c(2,3)])
class(as.matrix(Arthritis[,c(2,3)]))

df_a <- Arthritis[,c(2,3)]
is.matrix(df_a)
m_a <- as.matrix(df_a)
is.matrix(m_a)
is.array(per_colonne)


# i data frame nel bene e nel male ----------------------------------------

?data.frame
?tibble::tibble

data_frame_4 <- data.frame(rep(1:4,2),
                           rep(1:4, each = 2),
                           mantra[1:8])
data_frame_4

# assegno nomi alle colonne:
colnames(data_frame_4) <- c("quattro","quattro_coppie","mantra")
data_frame_4

# i nomi di riga:
rownames(data_frame_4)
# ora li assegno
rownames(data_frame_4) <- letters[1:nrow(data_frame_4)]

tre_per_tre <- as.data.frame(per_colonne)

tre_per_sei <- cbind(tre_per_tre, per_colonne)
tre_per_sei

sei_per_tre <- rbind(tre_per_tre, per_colonne)
sei_per_tre

molta_artrite <- dplyr::bind_rows(Arthritis, Arthritis)
sei_per_tre <- dplyr::bind_cols(tre_per_tre, tre_per_tre)

# creare una tibble con as_tibble
tib_Arthritis <- as_tibble(Arthritis)
tib_Arthritis
class(tib_Arthritis)

la_mia_tibble <- tibble::tibble(B = b,
                                F = fattore_non_o)

?tibble::tribble

df <- data.frame(NULL)
# ci vuole un po' per aprire l'editor
df <- edit(df)


# liste ------------------------------------------------------------------

# creiamo la nostra prima lista
la_mia_prima_lista <- list(b, due_vettori, mantra, per_colonne)
# nota in che modo viene stampata;
la_mia_prima_lista
str(la_mia_prima_lista)
is.list(la_mia_prima_lista)

# i data frame sono liste!
is.list(Arthritis)

# le liste possono avere nomi, e possono essere annidate, cioé contenere altre liste
la_mia_prima_lista_con_nomi  <- list(a = b, 
                                     b = due_vettori, 
                                     c = mantra, 
                                     d = per_colonne,
                                     e = la_mia_prima_lista)
str(la_mia_prima_lista_con_nomi)

# si può anche creare una lista e poi riempirla
la_mia_lista <- list()
la_mia_lista[[1]] <- i_nomi


# altre cose --------------------------------------------------------------


?table
?ts
?DateTimeClasses
?as.Date

# Tabelle
# ecco una tabella che conta il numero di casi con nessun miglioramento (None)
# qualche miglioramento (Some) e un deciso miglioramento (Marked), 
# in funzione del trattamento (Placebo o Treated) e del sesso
tabella_artrite <- table(Arthritis$Treatment, Arthritis$Improved, Arthritis$Sex)
tabella_artrite
# ha classe tabella ma è anche un array di interi!
class(tabella_artrite)
is.array(tabella_artrite)
is.integer((tabella_artrite))

# un oggetto di classe time series:
data("AirPassengers")
# sono i totali, in migliaia, dei passaggeri delle linee aeree mondiali dal 1949 al 1960, per mese
AirPassengers
# nota come sia formattato come una matrice

# creiamo una serie fittizia con frequenza annuale
i_miei_anni <-ts(1:50, start = 1960, frequency = 1)
# per frequency 1 rappresenta gli anni, 4 i trimestri, 12 i mesi, 
# 6 groups di 10 minuti in un'ora, 7 i giorni, 24 le ore in un giorno
# 30 i mesi in un anno
print(i_miei_anni)
# ora una serie mensile, dal 1960 al 1968
(i_miei_mesi <- ts(c(1:50,50:1), start = c(1960,2), frequency = 12))

# un calendario settimanale, che parte dal 12° giorno della 12° settimana
i_miei_giorni <- ts(c(1:7,7:1,1:7,7:1), start = c(12,2), frequency = 7)
print(i_miei_giorni, calendar = T)

le_mie_date <- c("1962/02/14","1964/12/07")
typeof(le_mie_date)
le_mie_date_sbagliate <- c("14/02/1962","07/12/1964")

# convertiamo in date
le_mie_Date <- as.Date(le_mie_date)
typeof(le_mie_Date)
as.numeric(le_mie_Date)

le_mie_Date_formattate <- as.Date(le_mie_date_sbagliate, "%d/%m/%Y")
le_mie_Date_formattate

le_mie_Date_formattate <- format(le_mie_Date_formattate, format = "%A %d %B %y")
le_mie_Date_formattate
format(le_mie_Date_formattate, format = "%a %d %b %y")
le_mie_Date_formattate

oggi <- Sys.time()
ora <- date()

?difftime
difftime(le_mie_Date[2], le_mie_Date[1], units = "weeks")


# indirizzare, selezionare ------------------------------------------------


# partiamo da un singolo vettore ad una dimensione 
due_vettori
# ed estraiamo il 3° elemento
due_vettori[3]
# i primi 3
due_vettori[1:3]
# i primi tre, ma in ordine inverso
due_vettori[3:1]
# con un vettore di posizioni (adiacenti o meno)
due_vettori[c(1,2,4,7)]
# naturalmente possiamo usare queste espressioni per assegnare l'oggetto 
# risultante a un nome
quattro_elementi <- due_vettori[c(1,2,4,7)]
# ripetere l'indice di una posizione è l'equivalente di duplicare o 
# triplicare l'elemento nel vettore che ne risulta
due_vettori[c(1,1,1,2,2,2)]
# possiamo usare gli indici per cambiare singoli elementi o elementi multipli 
# di un vettore esistente
a
a[3] <- 4
a
a[c(1,3)] <- c(3,1)
a

tre_per_tre
tre_per_tre[2]
tre_per_tre[c(1,2)]

tre_per_tre[2,]
tre_per_tre[,2]

# indici di riga e colonna
tre_per_tre[1,1]
# vettori di posizioni
tre_per_tre[c(1,2),c(1,2)]
tre_per_tre[c(1,3),c(1,3)]

# usare indici per assegnare
due_per_due <- tre_per_tre[c(1,3),c(1,3)]
due_per_due
due_per_due[1,1] <- 2
due_per_due
# lo stesso vale per i data frame
iris[1:5,1:5]

array_senza_nomi
# un vettore di un elemento
array_senza_nomi[1,2,1]
# un vettore composto dalle prime tre righe della 2° colonna del 2° strato
array_senza_nomi[1:3,2,2]
# la , può essere usata per intere righe o colonne
iris[1,]
array_senza_nomi[,1,1]
array_senza_nomi[1,2,]

# una lista annidata
la_mia_prima_lista_con_nomi
# il primo elemento, come lista
la_mia_prima_lista_con_nomi[1]
class(la_mia_prima_lista_con_nomi[1])
# con la sua classe originale
la_mia_prima_lista_con_nomi[[1]]
class(la_mia_prima_lista_con_nomi[[1]])
# un elemento di un elemento
# come lista
# prima troviamo la lunghezza della lista
length(la_mia_prima_lista_con_nomi)
# il quinto elemento, oltre ad essere un bel film, è una lista, 
# il cui 4° elemento è una matrice
la_mia_prima_lista_con_nomi[[5]][[4]]
# estraggo la prima colonna
la_mia_prima_lista_con_nomi[[5]][[4]][,1]
# questo funziona, e calcola la somma degli elementi del primo vettore
sum(la_mia_prima_lista_con_nomi[[1]])

# Questo invece non funzionerebbe, prova a scrivrlo nella console:
sum(la_mia_prima_lista_con_nomi[1])


# usare i nomi ------------------------------------------------------------

# i primi 5 elementi della colonna Improved in Arthritis
Arthritis$Improved[1:5]
# gli stessi elementi, riordinati usando un vettore di posizioni
Arthritis$Improved[c(4,5,3,2,1)]
# i nomi delle variabili in Arthritis
colnames(Arthritis)

head(Arthritis$A)
# non funziona con iris
# questo funziona
head(iris$Petal.Length,10)
# questo no
head(iris$P,10)

names(la_mia_prima_lista_con_nomi$e) <- c("aa", "ab", "ac", "ad")
# e ora vediamo che succede
la_mia_prima_lista_con_nomi$a
class(la_mia_prima_lista_con_nomi$a)
la_mia_prima_lista_con_nomi$e
class(la_mia_prima_lista_con_nomi$e)
la_mia_prima_lista_con_nomi$e$aa


# usare valori logici -----------------------------------------------------

tre_selezioni <- c(T,F,T)
# estrae il 1° e terzo elemento da vettore_con_nomi e li 
# attribuisce a un altro vettore
due_elementi <- vettore_con_nomi[tre_selezioni]

tre_per_tre_logica <- matrix(rep(c(T,T,F),3), nrow = 3, ncol = 3, byrow = F)
per_colonne
per_colonne[tre_per_tre_logica]

per_colonne>3
maggiore_di_tre <- per_colonne>3
per_colonne[per_colonne>3]
per_colonne[maggiore_di_tre]
which(per_colonne>3)
# cosa restituiscono?

# cosa succede qui?
colnames(Arthritis)
colnames(Arthritis) == "ID"
# che vettore restituisce l'espressione precedente?
# individuare le posizioni di due colonne in Arthritis sulla base dei nomi
# nota l'uso dell'operatore |, che rappresenta un OR logico,
# sono selezionate le condizioni per cui è vera l'una o l'altra espressione
colnames(Arthritis) == "ID" | colnames(Arthritis) == "Age" 
# oppure potrei usare %in%
# creo un vettore dei nomi che voglio cercare
i_nomi <- c("ID","Age")
colnames(Arthritis) %in% i_nomi 
# e ne estraggo le posizioni con which()
which(colnames(Arthritis) %in% i_nomi)
head(Arthritis[which(colnames(Arthritis) %in% i_nomi)])

subset(Arthritis, Age > 67, select = Sex:Improved)


#  attach, with, within ---------------------------------------------------


# library(vcd)
data(Arthritis)
Arthr1 <- Arthritis[1:20,]
Arthr2 <- Arthritis[21:40,]

head(Age)

head(Arthr1$Age, 5)
head(Arthr2$Age, 5)

Arthr1$Age[Arthr1$Sex == "Female"]

Arthr2$Age[Arthr2$Sex == "Female"]

attach(Arthr1)
head(Treatment,5)
summary(Treatment)
detach(Arthr1)
Arthr2$Age[Arthr2$Sex == "Female"]

with(Arthr1, sum(Age))

with(Arthr1, somma_età <- sum(Age))

with(Arthr1, somma_età_2 <<- sum(Age))
somma_età_2


# funzioni, operatori -----------------------------------------------------


1+2
2^5
7%%2
5/0
0/0

# attenzione alla priorità nelle operazioni
x <- 1+4/2
x
x <- (1+4)/2
x

# le operazioni sono vettorializzate; guarda che succede se aggiungo 
# uno scalare a un vettore o se moltiplico uno scalare per un vettore
y <- c(1,2,3,4)
(y+1)
(y*1.1)
# attenzione all'effetto degli NA
z <- c(1,2,3,4,NA)
(z/2)

# nelle operazioni fra vettori, il vettore più corto viene riciclato,
# se necessario con un warning

w <- c(1,2) # è un vettore di lunghezza infereiore a x

length(w) < length(y)
w
y
(w+y)

k<-c(1,2,3)
(y+k)
# qui solo i primo elemento viene riciclato

(sqrt(2))^2==2
dplyr::near((sqrt(2)^2),2)


una_matrice <- matrix(c(1.1,1.2,1.3,2.1,2.2,2.3), nrow = 2, ncol=3, byrow = T)
una_matrice

# guarda quello che succede con operazioni con vettori di diversa
# lunghezza
una_matrice+0.05
una_matrice*0.5

(una_nuova_matrice <- una_matrice+c(0.01,0.02,0.03))
(una_matrice + c(0.1,0.05))

# le operazioni avvengono per colonna e i vettori più corti vengono
# riciclati

un_logico <- c(T,T,F)
3*un_logico
un_fattore <- factor(c("a", "b", "c", "b"))
3*un_fattore
3*as.numeric(un_fattore)


# funzioni built-in -------------------------------------------------------


sqrt(c(1,4,9))

log(10)

log10(exp(1))

try(log(-1))

?try
?tryCatch

# calcola la somma della colonna Age in Arthritis
sum(Arthritis$Age)
# calcola la media
mean(Arthritis$Age)

range(Arthritis$Age)
with(Arthritis, fivenum(Age))

# incollare più valori di testo, con uno spaziatore
paste("questo", "capitolo", "è un po' lungo", sep =" ")
# trovare gli elementi di un vettore che contengono una lettera
# o un pattern di caratteri
# la lettera e in qualsiasi posizione
grep("e", c("Teresa","Mario","Adele"))
# la lettera e alla fine
grep("e$", c("Teresa","Mario","Adele"))
# restituire un valore logico che indica se un pattern è presente in
# un vettore
grepl("e", c("Teresa","Mario","Adele"))

# più sintetico, ma difficile da leggere
(media_log_age <- mean(log10(Arthritis$Age)))
# meno sintetico ma più facile da leggere
logAge <- log10(Arthritis$Age)
media_log_age <- mean(logAge)
media_log_age


# funzioni definite dall'utente -------------------------------------------

stat_descrittive <- function(x, parametriche=TRUE, stampa=FALSE, trm = 0.05, narm = T) {
  if (parametriche) {
    valore_centrale <- mean(x, trim = trm, na.rm = narm)
    dispersione <- sd(x, na.rm = narm)
  } else {
    valore_centrale <- median(x, na.rm = narm)
    dispersione <- mad(x, na.rm = narm)
  }
  if (stampa & parametriche) {
    cat("Media=", valore_centrale, "\n", "SD=", dispersione, "\n")
  } else if (stampa & !parametriche) {
    cat("Median=", valore_centrale, "\n", "MAD=", dispersione, "\n")
  }
  risultato <- c(valore_centrale, dispersione)
  if (parametriche){
    names(risultato) <- c("media","SD")
  } else {
    names(risultato) <- c("mediana","MAD")
  }
  return(risultato)
}

stat_età <- stat_descrittive(Arthritis$Age)
print(stat_età, digits = 4)
# non parametriche, con stampa
stat_età <- stat_descrittive(Arthritis$Age, parametriche = F, stampa = T)
# parametriche, media sfrondata (o trimmed mean, vengono eliminati il 10% dei valori estremi,
# niente stampa)
stat_età <- stat_descrittive(Arthritis$Age, parametriche = T, trm = 0.1)
print(stat_età, digits = 4)

# voglio calcolare media e deviazione standard su la stessa
# variabile in tre data frame e creare un vettore con nomi con i risultati
stat_età_1 <- c(media = mean(Arthritis$Age, trm = 0.1), 
                SD = sd(Arthritis$Age))
stat_età_1
stat_età_2 <- c(media = mean(Arthr1$Age, trm = 0.1), 
                SD = sd(Arthritis$Age))
stat_età_2
stat_età_3 <- c(media = mean(Arthr2$Age, trm = 0.1), 
                SD = sd(Arthritis$Age))
stat_età_3
# lo stesso con la funzione
stat_descrittive(Arthritis$Age, trm = 0.1)
stat_descrittive(Arthr1$Age, trm = 0.1)
stat_descrittive(Arthr2$Age, trm = 0.1)

stat_età_1 <- c(media = mean(Arthritis$Age, trm = 0.1), 
                SD = sd(Arthritis$Age))


# un ambiente affollato ---------------------------------------------------

# elencare gli oggetti nell'ambiente di lavoro e assegnare 
# l'elenco ad un oggetto
i_miei_oggetti <- ls()
head(i_miei_oggetti,10)
# che tipo di oggetto ho creato?

ls.str()

# in questo esempio quelli che hanno un nome che inizia per A maiuscola
ls.str(pattern="^A")
# o il cui nome contiene "a" o "A", 
ls.str(pattern="A|a")
# o finisce per  "i",
ls.str(pattern="i$")
# o inizia con "per"
ls.str(pattern="^per")
# contains "tre" 1 o più volte
ls.str(pattern="tre+")

copia_Arthritis <- Arthritis
rm(Arthritis)
# salvo l'abiente come immagine (vedi capitolo 5)
save.image(file = "lambiente.Rdata)
# gli oggetti che iniziano con la A
rm(ls(pattern = "^A"))
# tutti gli oggetti
rm(list = ls())
# ricarico tutto
load(file = "lambiente.Rdata)


