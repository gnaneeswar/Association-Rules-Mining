### *** Play counts *** ###
lastfm <- read.csv("C:/Users/User/Desktop/R Codes/lastfm.csv")


lastfm[1:19,]

length(lastfm$user) ## 289,955 records in the file
lastfm$user <- factor(lastfm$user)
length(levels(lastfm$user)) ## 15,000 users
length(levels(lastfm$artist)) ## 1,004 artists

install.packages('Rtools')
install.packages('arules')
library(arules) ## a-rules package for association rules
## Computational environment for mining association rules and
## frequent item sets
## we need to manipulate the data a bit before using arules
## we split the data in the vector x into groups defined in vector f
## in supermarket terminology, think of users as shoppers and artists
## as items bought

playlist <- split(x=lastfm[,"artist"],f=lastfm$user)
## split into a list of users
playlist[1:2]
## the first two listeners (1 and 3) listen to the following bands

length(playlist)

?lapply

## an artist may be mentioned by the same user more than once
## it is important to remove artist duplicates before creating
## the incidence matrix
playlist <- lapply(playlist,unique) ## remove artist duplicates
playlist <- as(playlist,"transactions")
## view this as a list of "transactions"
## transactions is a data class defined in arules
itemFrequency(playlist)
## lists the support of the 1,004 bands
## number of times band is listed to on the playlist of 15,000 users
## computes relative frequency of artist mentioned by the 15,000 users

itemFrequencyPlot(playlist,support=.08,cex.names=1)
## plots the item frequencies (only bands with > % support)

## Finally, we build the association rules
## only associations with support > 0.01 and confidence > .50
## this rules out rare bands
musicrules <- apriori(playlist,parameter=list(support=.01,confidence=.5))


inspect(musicrules)

## let's filter by lift > 5.
## Among those associations with support > 0.01 and confidence > .50,
## only show those with lift > 5

inspect(subset(musicrules, subset=lift > 5))

## lastly, order by confidence to make it easier to understand


inspect(sort(subset(musicrules, subset=lift > 5), by="confidence"))
