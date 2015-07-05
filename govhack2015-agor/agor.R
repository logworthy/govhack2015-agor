install.packages('GGally')
install.packages('igraph')
install.packages('httr')
install.packages('lubridate')
install.packages('plyr')
install.packages('ggplot')
install.packages('WikipediR')
library('WikipediR')
library('data.table')
library('GGally')
library(igraph)
library(httr)
library(lubridate)
library(plyr)
library(ggplot2)
library(stringr)
library(reshape2)

agor.test <- fread('http://data.gov.au/dataset/c77cface-69aa-4dd0-b99f-b065dc33c8e6/resource/27124ee1-17ad-44c3-abf2-ec256aa62d76/download/uploaddatafinalv2.csv')

agor.files <- c(
  'http://data.gov.au/dataset/c77cface-69aa-4dd0-b99f-b065dc33c8e6/resource/27124ee1-17ad-44c3-abf2-ec256aa62d76/download/uploaddatafinalv2.csv'
  ,'http://data.gov.au/dataset/c77cface-69aa-4dd0-b99f-b065dc33c8e6/resource/55c3a891-30e0-43a6-9d80-5def4506f43d/download/agorfile20150216data.gov.au.csv'
  ,'http://data.gov.au/dataset/c77cface-69aa-4dd0-b99f-b065dc33c8e6/resource/55db8e2c-dff7-435b-932c-4b8e9225de81/download/agorv2.020150424datagov.csv'
  ,'http://data.gov.au/dataset/c77cface-69aa-4dd0-b99f-b065dc33c8e6/resource/854be11a-5d3a-4df7-a7d1-4ec32124f0ee/download/agorv2.120150521.csv'
)

agor.dates <- c(
  ymd('20141211')
  , ymd('20150216')
  , ymd('20150424')
  , ymd('20150521')
)

agor.data <- data.table(ldply(
  1:length(agor.files)
  , function(i) {
    f <- agor.files[i]
    tmp <- GET(f)
    tmp.text <- content(tmp, as='text')
    tmp.filename <- tempfile()
    tmp.file <- file(tmp.filename, 'w')
    write(tmp.text, tmp.file)
    close(tmp.file)
    tmp.csv <- read.csv(tmp.filename)
    tmp.data <- data.table(tmp.csv)[,Date:=agor.dates[i]]
    return(tmp.data)
  }
))

d1 <- agor.data[with_tz(Date, tzone="UTC")==ymd('20141211'),]
setkeyv(d1, c('Entity', 'Portfolio'))
d2 <- agor.data[with_tz(Date, tzone="UTC")==ymd('20150521'),]
setkeyv(d2, c('Entity', 'Portfolio'))

d3 <- merge(
  d1[,list(Entity, Portfolio, Staff1=Average.Staffing.Level..ASL.)]
  , d2[,list(Entity, Portfolio, Staff2=Average.Staffing.Level..ASL.)]
  , all=T
)

data.table(agor.data)[ Entity=="Department of Defence",]

data.table(agor.data)[with_tz(Date, tzone="UTC")==ymd('20150521'),]

names(agor.data)
names(bar)


|-
! Entity
| {{{entity|''Unknown''}}}


column.names <- paste(names(bar))


## INFOBOX

param_table <- data.table(
  label=names(agor.test)
  , param=str_replace_all(tolower(names(agor.test)), '\\W', '_')
  , orig=names(tmp.csv)
)

param_table 

param_str <- paste(paste(
  '|-'
  , paste0('! ',param_table$label)
  , paste0('| {{{', param_table$param, '|',"''--''}}}")
  , sep='\n'
), collapse='\n')


agor.melt <- data.table(melt(
  id.vars=c("Entity", 'Portfolio', 'Date')
  , variable.name='orig'
  , agor.data))

record_data <- merge(agor.melt, param_table, by='orig')

record.entries <- unique(record_data[,list(Entity, Portfolio, Date)])
record.entities <- data.table(record.entries)
record.entities[,orig:="Entity"]
record.entities[,label:=orig]
record.entities[,value:=Entity]
record.entities[,param:="entity_name"]

record.portfolios <- data.table(record.entries)
record.portfolios[,orig:="Portfolio"]
record.portfolios[,label:=orig]
record.portfolios[,value:=Portfolio]
record.portfolios[,param:="portfolio"]

record.dates <- data.table(record.entries)
record.dates[,orig:="Date"]
record.dates[,label:=orig]
record.dates[,value:=format(Date, '%Y-%m-%d')]
record.dates[,param:="revision_date"]

record_final <- rbind(record_data, record.entities, record.portfolios, record.dates)

agor.departments <- unique(record_data[,list(Entity, Portfolio)])


entity <- 'Department of Agriculture'
portfolio <- 'Agriculture'

mw.csv <- ddply(
  .data=agor.departments
  , .variables=.(Entity, Portfolio)
  , .fun=function(x) {
  
    solo_record <- record_final[Entity == x$Entity & Portfolio ==x$Portfolio,]
    
    result <- ddply(
      .data=solo_record
      , .variables=.(Date)
      , .fun=function(y) {
        
        solo_str <- paste(
          paste0('|', y$param, '=', y$value)
          , collapse='\n'
        )
        
        article_str <- paste(
          '{{Infobox'
          , solo_str
          , '}}'
          , sep='\n'
          )
        
        return(article_str)
      }
    )
    
    return(result)
  }
)

tmp.csv <- data.table(mw.csv)
setkeyv(tmp.csv, c('Entity', 'Portfolio', 'Date'))

write.csv(tmp.csv, "~/govhack2015-agor/mw.csv", row.names=F)

record_final[Entity == 'Local Marine Advisory Committees - Townsville',]