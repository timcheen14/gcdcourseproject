## run_analysis.R 
## Written by: Timothy M. Amado
## Date: 01/27/2018
##
## Description: This is an R Script for the Getting and Cleaning Data 
## course project. The script does the following: 
## 1. Download a zipped data set
## 2. Merges training and test data sets collected from accelerometers 
## 3. Extracts the measurements on the mean and SD of each observation
## 4. Label columns using descriptive names
## 5. Create a second tidy data set with the average of each variable 
## for each activity and each subject
##


#Load dplyr package and remove all variables in the global environment
library(dplyr)
rm(list = ls())


#Download and unzip the data set
url_zip <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!dir.exists("./gcd_course_project")){
  dir.create("./gcd_course_project")
}


if(!file.exists("./gcd_course_project/dataset.zip")){
  download.file(url_zip, destfile = "./gcd_course_project/dataset.zip")
}

if(!file.exists("./gcd_course_project/UCI HAR Dataset")){
  unzip(zipfile = "./gcd_course_project/dataset.zip", exdir = "./gcd_course_project")
}

rm(url_zip)

#Read all the data sets in the UCI HAR Dataset folder except Inertial Signals
x_test <- read.table("./gcd_course_project/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./gcd_course_project/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./gcd_course_project/UCI HAR Dataset/test/subject_test.txt")

x_train <- read.table("./gcd_course_project/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./gcd_course_project/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./gcd_course_project/UCI HAR Dataset/train/subject_train.txt")

activity_labels <- read.table("./gcd_course_project/UCI HAR Dataset/activity_labels.txt")
features <- read.table("./gcd_course_project/UCI HAR Dataset/features.txt")

#Merge the training and test data sets in a single large data set

##Merge subjectID, activityID and sensor data to a single data set
binded_test <- cbind(subject_test, y_test, x_test)
binded_train <- cbind(subject_train, y_train, x_train)

##Merge both test and training data sets
merged_data <- rbind(binded_test,binded_train)

#Give descriptive variable names to the data set
colnames(merged_data) <- c("subjectID", "activityID", as.character(features[,2]))
colnames(activity_labels) <- c("activityID", "activityNames")

#Subset the merged_data set to data that contains the mean and std

###NOTE: The 'features.txt' contains duplicate column names, hence, to
### use the dplyr package, the duplicated column names are removed
### this should have been avoided if the column names were correct

merged_data_tibble <- as_tibble(merged_data[ ,!duplicated(colnames(merged_data))])

##Match acvitivyNames to activityID of the merged_data set
activityNames <- activity_labels$activityNames[match(merged_data_tibble$activityID,activity_labels$activityID)]

##Mutate the merged data set with activityNames
merged <- merged_data_tibble %>%                                                 #store new data set to merged
          select(subjectID, activityID, contains("mean"), contains("std")) %>%   #selects columns containing mean and std
          mutate(activityNames = activityNames) %>%                              #create a new column with activityNames
          select(subjectID, activityNames, everything(), -activityID)            #rearrange columns removing activityID

#Create a second tidy data set with the average of each variable ...

secondtidy <- merged %>%                              #Create a second tidy set
              arrange(subjectID, activityNames) %>%   #Arrange by subjectID and then by activityNames
              group_by(subjectID, activityNames) %>%  #Group by subjectID and then by activityNames
              summarize_all(mean)                     #Get the mean by activityNames for each subject

#Export the second tidy set into a .txt file
write.table(secondtidy, "secondtidy.txt", row.names = FALSE)