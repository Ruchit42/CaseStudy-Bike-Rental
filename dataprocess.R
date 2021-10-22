# Case Study 1 Cyclistic  

# importing packages for analysis  
install.packages("tidyverse")
install.packages("lubridate") 
install.packages("ggplot2")

library(tidyverse)
library(lubridate)
library(ggplot2)

# Importing Key Datasets 
getwd() # shows the current directory 

# setting new directory 
setwd("/Users/ruchitpatel/Desktop/CaseStudyCyclistic")  

# Colleting data 
q2_2019 <- read_csv("Divvy_Trips_2019_Q2.csv") 
q3_2019 <- read_csv("Divvy_Trips_2019_Q3.csv")
q4_2019 <- read_csv("Divvy_Trips_2019_Q4.csv")
q1_2020 <- read_csv("Divvy_Trips_2020_Q1.csv")

# Make columns consistent and merge them into a single dataframe 

# check the column names for each data frame 
colnames(q2_2019)  

colnames(q3_2019)

colnames(q4_2019)

colnames(q1_2020)

# edit column names for q2_2019 
# Column names are different in each data tabel 

(q2_2019 <- rename(q2_2019, 
                   ride_id = "01 - Rental Details Rental ID",
                   rideable_type = "01 - Rental Details Bike ID",
                   started_at = "01 - Rental Details Local Start Time",
                   ended_at = "01 - Rental Details Local End Time" ,
                   start_station_name = "03 - Rental Start Station Name"  ,
                   start_station_id = "03 - Rental Start Station ID" ,
                   end_station_name = "02 - Rental End Station Name" ,
                   end_station_id = "02 - Rental End Station ID" , 
                   member_casual = "User Type" )) 

# Column names for q3_2019 

(q3_2019 <- rename(q3_2019, 
                   ride_id = trip_id , 
                   rideable_type = bikeid, 
                   started_at = start_time, 
                   ended_at = end_time, 
                   start_station_name = from_station_name, 
                   start_station_id = from_station_id, 
                   end_station_name = to_station_name , 
                   end_station_id = to_station_id , 
                   member_casual = usertype)) 

# Column names for q4_2019 

(q4_2019 <- rename(q4_2019, 
                   ride_id = trip_id , 
                   rideable_type = bikeid , 
                   started_at = start_time , 
                   ended_at = end_time , 
                   start_station_name = from_station_name , 
                   start_station_id = from_station_id , 
                   end_station_name = to_station_name , 
                   end_station_id = to_station_id, 
                   member_casual = usertype))
# Column names for q1_2020 

# all other data frame columns names are changed to matched with q1_2020 data frame !! 

# final inspection for columns names 

str(q2_2019)
str(q3_2019)
str(q4_2019)
str(q1_2020)

# After inspection ride_id and rideable_type in q2_2019 , q3_2019 and q4_2019 are stored as double data type 
# where as ride_id and rideable_type in q1_2020 is stored as character data type  


q2_2019 <- mutate(q2_2019, ride_id = as.character(ride_id) ,
                  rideable_type = as.character(rideable_type))

q3_2019 <- mutate(q3_2019, ride_id = as.character(ride_id) ,
                  rideable_type = as.character(rideable_type))

q4_2019 <- mutate(q4_2019,ride_id = as.character(ride_id) ,
                  rideable_type = as.character(rideable_type))

str(q4_2019)
str(q1_2020)
# at this point all data types and all columns names are same across multiple data tables 

# merging them into a single dataframe to make analysis easier 

all_trips <- bind_rows(q2_2019,q3_2019,q4_2019,q1_2020)

colnames(all_trips) 

# Remove Columns that are unnecessary for analysis  
 
all_trips <- all_trips %>% 
  select(-c(start_lat,start_lng,end_lat,end_lng,birthyear,gender,"01 - Rental Details Duration In Seconds Uncapped","05 - Member Details Member Birthday Year","Member Gender","tripduration"))
# After cleaning unwanted data, all_trips dataframe has a total of 9 columns. 

# Data combined into a single dataframe.  

# Data is now being cleaned and being prepared for analysis

colnames(all_trips) # 9 columns 

nrow(all_trips) #3879822 rows of data  

dim(all_trips) 

summary(all_trips)

view(all_trips) 

# After viewing all_trips, the "member_casual have multiple labes which have similar meaning 
# Making the labes from four to two 
table(all_trips$member_casual)

all_trips <- all_trips %>% 
  mutate(member_casual = recode(member_casual,
                                "Subscriber" = "member",
                                "Customer" = "casual"))
# member_casual has two labels 

# dates are all merged into a single column 
# creating new columns for date, month, day, year and day of week 

all_trips$date <- as.Date(all_trips$started_at) # create a data column (started_at)
all_trips$month <- format(as.Date(all_trips$date),"%m") # create a month column 
all_trips$day <- format(as.Date(all_trips$date),"%d") # create a day column 
all_trips$year <- format(as.Date(all_trips$date),"%Y") #create a year column

all_trips$day_of_week <- format(as.Date(all_trips$date),"%A") #create a day of week column 

# adding a ride_length column to the entire dataframe 

all_trips$ride_length <- difftime(all_trips$ended_at, all_trips$started_at)

str(all_trips)
 
# delete all the negative time from ride_length col 
is.factor(all_trips$ride_length)
all_trips$ride_length <- as.numeric(as.character(all_trips$ride_length))
is.numeric(all_trips$ride_length) 

# create a new dataframe where the negative data is taken out 

all_trips_v2 <- all_trips[!(all_trips$start_station_name =="HQ QR" | all_trips$ride_length <0),]

# data is prepared and cleaned for analysis 

write.csv(all_trips_v2,file = "all_trips_v2.csv",row.names = FALSE) 

# Conduct Analysis 

# : How do annual members and casual riders use Cyclistic bikes differently? 

summary(all_trips_v2)
# mean ride_length = 1479 Seconds 
# median ride_length = 712 Seconds 
# Max ride_length = 9387024 Seconds ( Red Flag )
# Min ride_length = 1 Seconds ( Red Flag ) 


# Members vs Casual Users 

aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = mean )
# casual = 3552.7502 Seconds 
# member = 850.0662 Seconds 
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = median )
#casual = 1546 Seconds 
# member = 589 Seconds 
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = max ) 
# casual = 9387024 Seconds 
# member = 9056634 Seconds 
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = min ) 
# casual = 2 Seconds 
# member = 1 Second 

# Average ride time by each day for memebrs Vs casual 
all_trips_v2$day_of_week <- ordered(all_trips_v2$day_of_week, levels=c("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"))

aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean ) 

member_casual_DOW <- aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean ) 
# savind data into a file 
write.csv(member_casual_DOW,file = "member_casual_DOW.csv",row.names = FALSE) 


# ridership data by type and weekday 

all_trips_v2 %>% mutate(weekday = wday(started_at,label = TRUE)) %>%
group_by(member_casual,weekday) %>% 
  summarise(number_of_rides = n(),average_duration = mean(ride_length)) %>%
  arrange(member_casual,weekday)

member_casual_NOR_AD <-all_trips_v2 %>% mutate(weekday = wday(started_at,label = TRUE)) %>%
  group_by(member_casual,weekday) %>% 
  summarise(number_of_rides = n(),average_duration = mean(ride_length)) %>%
  arrange(member_casual,weekday) 

write.csv(member_casual_NOR_AD,file = "member_casual_NOR_AD.csv",row.names = FALSE) 

# numbers of rides by rider_type 

all_trips_v2 %>% 
  mutate(weekday = wday(started_at,label = TRUE)) %>%
  group_by(member_casual,weekday) %>%
  summarise(number_of_rides = n(), average_duration = mean(ride_length)) %>%
  arrange(member_casual,weekday) %>%
  ggplot(aes(x=weekday, y = number_of_rides,fill = member_casual)) + geom_col(position = "dodge") + labs(title = "Number of Rides based on Weekday")


# Average duration 

all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge") + labs(title = "Average duration based on Weekday") 

final_V <- aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)

write.csv(final_V,file = "final_V.csv",row.names = FALSE)  
