###################################################################################
###  NLP example
###  John Halstead, Ph.D.
###  MPAA, October 6, 2014
####################################################################################

### get entire shakespear works from Gutenberg Library

TEXTFILE = "data/pg100.txt"
if (!file.exists(TEXTFILE)) {download.file("http://www.gutenberg.org/cache/epub/100/pg100.txt", destfile = TEXTFILE)}
shakespeare = readLines(TEXTFILE)
length(shakespeare)

###  Inspect document

head(shakespeare)
tail(shakespeare)

### Remove unneccessary header and footer information

shakespeare = shakespeare[-(1:173)]
shakespeare = shakespeare[-(124195:length(shakespeare))]
shakespeare = paste(shakespeare, collapse = " ")
nchar(shakespeare)

###  Remove special characters

shakespeare = strsplit(shakespeare, "<<[^>]*>>")[[1]]
length(shakespeare)

### Remove the small Dramatis Personae from the document

(dramatis.personae <- grep("Dramatis Personae", shakespeare, ignore.case = TRUE))
shakespeare = shakespeare[-dramatis.personae]

write.table(shakespeare,"~/data/shakespear.txt")

### Create a corpus

library(tm)
my.vec <- VectorSource(shakespeare)
my.corpus <- Corpus(my.vec)
summary(my.corpus)

### Corpus operations

library(SnowballC)
my.corpus <- tm_map(my.corpus, tolower)
my.corpus <- tm_map(my.corpus, removePunctuation)
my.corpus <- tm_map(my.corpus, removeNumbers)
my.corpus <- tm_map(my.corpus, removeWords, stopwords("english"))
my.corpus <- tm_map(my.corpus, stemDocument)
my.corpus <- tm_map(my.corpus, stripWhitespace)
inspect(my.corpus[8])

### Create the Document Term Matrix for Text Mining Operations

my.tdm <- TermDocumentMatrix(my.corpus)
my.tdm