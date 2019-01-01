README
================

## Getting and Cleaning Data Course Project
*by: Timothy M. Amado*

### Introduction

This file summarizes all the steps done on achieving all the required steps in the Getting and Cleaning Data Course project. The submission includes the *run\_analysis.R* which contains the main script and a *code book* that details all the variables used in the submission.

Basically, the whole process of this project is divided into five parts namely:

1.  Getting the Data from the Source
2.  Merging the training and test sets
3.  Giving descriptive names to the *Activities* and *variables*
4.  Extracting data that contains mean and standard deviation
5.  Creating another tidyset which summarizes the mean of each activities per subject

The script starts by removing all variables in the global environment and loading the **dplyr** package. 

### Getting the data from the source
This is done by first checking if the directory and zipped file already exists in the machine. If not, the zipped file containing the data is downloaded and then unzipped.

The required data sets are read using *read.table* function (this is because the original datasets are in .txt format)

### Merging the training and test sets
The subject ID, activity ID and the sensor data for both training and test data are first merged together using *cbind* function. Then, the two data sets are joined together using *rbind* function.

### Giving Descriptive Names to the Variables
Using the descriptive names on the *features.txt* data set, the variables(column names) are changed accordingly. After which, the *activityID* is replaced by descriptive names from the *activity_labels* dataset. This is done by combining *mutate* and *arrange* functions from the **dplyr** package.

### Extracting data that contains mean and std
This is done using *select* function again from **dplyr** package.

###Creating another tidyset which summarizes the mean of each activities per subject
This is accomplised by using *arrange* and *group_by* function. The dataset are grouped and arranged by subjectID and activity names. After which, the *summarize_all* function is used to get the mean of all the remaining columns taken one group at a time.

The resulting tidy data set is now exported into a text file names *secondtidy.txt*.

edited test