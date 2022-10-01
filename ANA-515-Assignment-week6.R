getwd()
setwd("C:/Users/Shreyesh Shetty/Documents/Data Storage")
install.packages("tidyverse")
library(tidyverse)

Storm_events<-read.csv("StormEvents_details-ftp_v1.0_d1990_c20220425_1.csv")
head(Storm_events)

## Selecting variables to create a dataframe
Stormdata<-Storm_events%>% select (BEGIN_YEARMONTH,BEGIN_DATE_TIME,END_YEARMONTH,
                                   END_DATE_TIME,STATE,STATE_FIPS,EVENT_TYPE,EPISODE_ID,EVENT_ID,CZ_NAME
                                   ,CZ_FIPS,CZ_TYPE,SOURCE,BEGIN_LAT,BEGIN_LON,END_LAT,END_LON)
Storm_data1<-data.frame(Stormdata)
head(Storm_data1)

## Arranging data by Begin_year and month
arrange(Storm_data1,BEGIN_YEARMONTH)

##Change state and county names to title case.
str_to_title(Storm_data1$STATE)
str_to_title(Storm_data1$CZ_NAME)

##Limit to the events listed 
STORM1 <-Storm_data1 %>%
  filter(CZ_TYPE== "C")
STORM2 <-STORM1 %>% select(!CZ_TYPE)


##Pad the state and county FIPS with a “0” 
STORM1$CZ_FIPS<-str_pad(STORM1$CZ_FIPS,width = 3,side = "left",pad="0")
STORM1$STATE_FIPS<-str_pad(STORM1$STATE_FIPS,width = 3,side = "left",pad="0")
STORM1$FIPS<-paste(STORM1$STATE_FIPS,STORM1$CZ_FIPS)

##Change all the column names to lower case
rename_all(STORM1,tolower)

##create a dataframe with these three columns: state name, area, and region 

data("state")
State_newdata<-data.frame(state=state.name, region=state.region, area=state.area)

##Create a dataframe with the number of events per state in the year of your birth
State_newdata1<-(mutate_all(State_newdata,toupper))
STORM_FREQ<-data.frame(table(STORM1$STATE))
STORM_FREQ1<-rename(STORM_FREQ,c("state"="Var1"))
merged<- merge(x=STORM_FREQ1,y=State_newdata1,by.x ="state",by.y = "state")


##10.	Create the following plot 
install.packages("ggplot2")
library(ggplot2)
storm_plot<-ggplot(merged,aes(x=area,y=Freq))+
  geom_point(aes(color=region))+
  labs(x="area_km",
       y="freq")
storm_plot

ggplot(merged,aes(area,Freq,color=class))+geom_point(aes(color=region))






