# CaseStudy-Bike-Rental 

Ask 

Guiding questions 
 What is the problem am I trying to solve? 
Cyclistic is a bike loaning company located in Chicago. The focus of this experiment is to study and analyze the companies data from over the last 12 months to identify trends that help the company in its goal of converting causal riders into annual members. 

How do annual members and casual riders use Cyclistic bikes differently? 
Why would casual riders buy Cyclistic annual memberships? 
It is important to understand the difference between the causal riders and annual members. From the data collected, we need to see whether the needs of casual riders are similar to the annual members. If so, why are they not getting the annual membership? 

Prepare  
The data has been made available by Motivate International Inc. 
License = https://www.divvybikes.com/data-license-agreement 

** The dataset contains Cyslistic user data from the last 12 months. 

Process 

Since the dataset contains a large amount of data, I have decided to use R to clean and filter data. First I will import the data into the data frame in R  and then use the function available in R to clean and combine data. 
An advantage in using R is that It will make visualizing my data easier when I do get to the sharing stage of my process. 

* I did try to import the CSV files to Excel but the files were too large and it would not let me view all data in Excel. 

Cleaning Data 

1) After importing and studying the dataset I noticed that column names were not consistent. For example ride_id and trip_id. They contained the same data but If I were to combine the datasets together, it is important to have the same column name across the datasets.    
		
2) The data type of the variables was not consistent. One dataset had ride_id as doubles. I changed them to characters using the mutate function in R. 
3) I combined all datasets into a single data frame
4) Member_causal column had 4 labels. It has 2 names for members and 2 names for the causal riders. I changed them into 2 names so the column would be cleaned and there would be less confusion as to which label is referring to what.  
5) Created a new column called “ride_length” which calculated the duration of each trip.  
6) Delete all rides which resulted in negative “ride_length” ( can’t have negative duration) 
7) Created columns for the day, month, year to help me analyze data in the future. 

Analyze 
	Charts and graphs for the analysis is uploaded in this repo 

I wanted to look into the behavioral trend when it comes to average duration and the number of rides between an annual member and a casual rider. 

Share 

https://docs.google.com/presentation/d/1zRrkRicm-K1ZoypudW2TXJKUvI58Wu62pxMHyw9XFy0/edit?usp=sharing 



