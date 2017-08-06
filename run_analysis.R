# The purpose of this project is to demonstrate your ability to collect, work 
# with, and clean a data set. The goal is to prepare tidy data that can be used 
# for later analysis. You will be graded by your peers on a series of yes/no 
# questions related to the project. You will be required to submit: 1) a tidy 
# data set as described below, 2) a link to a Github repository with your script 
# for performing the analysis, and 3) a code book that describes the variables, 
# the data, and any transformations or work that you performed to clean up the 
# data called CodeBook.md. You should also include a README.md in the repo with 
# your scripts. This repo explains how all of the scripts work and how they are 
# connected.

# One of the most exciting areas in all of data science right now is wearable 
# computing - see for example this article . Companies like Fitbit, Nike, and 
# Jawbone Up are racing to develop the most advanced algorithms to attract new 
# users. The data linked to from the course website represent data collected 
# from the accelerometers from the Samsung Galaxy S smartphone. A full 
# description is available at the site where the data was obtained:
#         
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# 
# Here are the data for the project:
#         
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# You should create one R script called run_analysis.R that does the following.
# 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each 
# measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
# Good luck!

#Data specs: 

# 30 volunteers aged 19-48 (21 in training data, 9 in test data)
# 6 activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, 
#               LAYING)
# Raw measurements of 3-axial linear acceleration and 3-axial angular velocity
# (128 readings/window)
# Windows have vector of features applied to them
# Feature vector is a row on text file
# Observations: 7352

#1. Merging training and test sets to create one data set

if(!file.exists("./coursera_repo/getting_and_cleaning_data/data_project/trainingSet.csv") & 
   !file.exists("./coursera_repo/getting_and_cleaning_data/data_project/testSet.csv"))
{        
        ##a. Loading data into R
        
        ###i. Opening compressed file and storing data in folder called data_project
        if(!file.exists("./coursera_repo/getting_and_cleaning_data/data_project"))
        {dir.create("./coursera_repo/getting_and_cleaning_data/data_project")}
        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileUrl,
                      destfile = "./coursera_repo/getting_and_cleaning_data/data_project/accelerometer.zip")
        # con <- gzfile("./coursera_repo/getting_and_cleaning_data/data_project/accelerometer.zip")
        # x <- readLines(con)
        unzip("./coursera_repo/getting_and_cleaning_data/data_project/accelerometer.zip")
        file.remove("./coursera_repo/getting_and_cleaning_data/data_project/accelerometer.zip")
        # list.files("./coursera_repo/getting_and_cleaning_data/data_project")
        
        ###ii. Reading in training set string vector, converting string character 
        #vectors into list of numeric vectors for each observation, assigning feature 
        #vector to each numeric vector observation in data frame, appending training 
        #labels and activity labels to data frame, then writing lists to a named data 
        #frame to be saved as a csv

        if(!file.exists("./coursera_repo/getting_and_cleaning_data/data_project/trainingSet.csv"))
        {
                ####1. train/X_train.txt
                X_train <- readLines(file("./coursera_repo/getting_and_cleaning_data/data_project/UCI HAR Dataset/train/X_train.txt"))
                splitX_train = strsplit(X_train, " |  ") #splitting long string vectors
                #into individual character vectors in a list
                splitX_train.noBlanks <- lapply(splitX_train,
                                                    function(elt) {elt[2:length(elt)]}) #removing
                #first space value from character vectors
                splitX_train.noBlanks <- lapply(splitX_train.noBlanks,
                                                    function(elt) {as.numeric(elt)}) #convert
                #character vectors into numeric vectors
                X_train <- splitX_train.noBlanks #list of numeric vectors for each obs
                rm(splitX_train)
                rm(splitX_train.noBlanks)
                
                ####2. features.txt
                features <- readLines(file("./coursera_repo/getting_and_cleaning_data/data_project/UCI HAR Dataset/features.txt"))
                split.features <- gsub("^[0-9] |^[0-9]. |^[0-9].. ","", features)
                #Substituting numeric values at beginning of character for ""
                features <- split.features #character vector of feature variables
                rm(split.features)
        
                ####3. train/y_train.txt
                y_train <- readLines(file("./coursera_repo/getting_and_cleaning_data/data_project/UCI HAR Dataset/train/y_train.txt"))
        
                ####4. Merging values together based on activity_labels
                y_train <- gsub("1", "1 WALKING", y_train)
                y_train <- gsub("2", "2 WALKING_UPSTAIRS", y_train)
                y_train <- gsub("3", "3 WALKING_DOWNSTAIRS", y_train)
                y_train <- gsub("4", "4 SITTING", y_train)
                y_train <- gsub("5", "5 STANDING", y_train)
                y_train <- gsub("6", "6 LAYING", y_train)
                
                ####5. train/subject_train.txt
                subject_train <- readLines(file("./coursera_repo/getting_and_cleaning_data/data_project/UCI HAR Dataset/train/subject_train.txt"))
        
                ####6. Converting lists into data frame
                trainingSet <- as.data.frame.list(X_train, stringsAsFactors = FALSE)
                TtrainingSet <- t(trainingSet)
                colnames(TtrainingSet) <- features
                trainingSet <- data.frame(TtrainingSet, y_train, subject_train, 
                                          stringsAsFactors = FALSE)
                rm(TtrainingSet)
                rm(X_train)
                rm(y_train)
                rm(subject_train)
                rm(features)
        
                ####8. Writing data frame as .csv to make reloading easier
                write.csv(trainingSet, 
                          file = "./coursera_repo/getting_and_cleaning_data/data_project/trainingSet.csv")
        }

        ###iii. Reading in test set string vector, converting string character 
        #vectors into list of numeric vectors for each observation, assigning feature 
        #vector to each numeric vector observation in data frame, appending test 
        #labels and activity labels to data frame, then writing lists to a named data 
        #frame to be saved as a csv

        if(!file.exists("./coursera_repo/getting_and_cleaning_data/data_project/testSet.csv"))
        {       
                ####1. test/X_test.txt
                X_test <- readLines(file("./coursera_repo/getting_and_cleaning_data/data_project/UCI HAR Dataset/test/X_test.txt"))
                splitX_test = strsplit(X_test, " |  ") #splitting long string vectors
                #into individual character vectors in a list
                # splitX_test[[4]]
                # splitX_test[[400]]
                splitX_test.noBlanks <- lapply(splitX_test,
                                                function(elt) {elt[2:length(elt)]}) #removing
                #first space value from character vectors
                splitX_test.noBlanks <- lapply(splitX_test.noBlanks,
                                                function(elt) {as.numeric(elt)}) #convert
                #character vectors into numeric vectors
                X_test <- splitX_test.noBlanks #list of numeric vectors for each obs
                rm(splitX_test)
                rm(splitX_test.noBlanks)
                
                ####2. features.txt
                features <- readLines(file("./coursera_repo/getting_and_cleaning_data/data_project/UCI HAR Dataset/features.txt"))
                split.features <- gsub("^[0-9] |^[0-9]. |^[0-9].. ","", features)
                #Substituting numeric values at beginning of character for ""
                features <- split.features #character vector of feature variables
                rm(split.features)
                
                ####3. test/y_test.txt
                y_test <- readLines(file("./coursera_repo/getting_and_cleaning_data/data_project/UCI HAR Dataset/test/y_test.txt"))
                
                ####4. Merging values together based on activity_labels
                y_test <- gsub("1", "1 WALKING", y_test)
                y_test <- gsub("2", "2 WALKING_UPSTAIRS", y_test)
                y_test <- gsub("3", "3 WALKING_DOWNSTAIRS", y_test)
                y_test <- gsub("4", "4 SITTING", y_test)
                y_test <- gsub("5", "5 STANDING", y_test)
                y_test <- gsub("6", "6 LAYING", y_test)
                
                ####5. test/subject_test.txt
                subject_test <- readLines(file("./coursera_repo/getting_and_cleaning_data/data_project/UCI HAR Dataset/test/subject_test.txt"))
                
                ####6. Converting lists into data frame
                testSet <- as.data.frame.list(X_test, stringsAsFactors = FALSE)
                TtestSet <- t(testSet)
                colnames(TtestSet) <- features
                testSet <- data.frame(TtestSet, y_test, subject_test, 
                                          stringsAsFactors = FALSE)
                rm(TtestSet)
                rm(X_test)
                rm(y_test)
                rm(subject_test)
                rm(features)
                
                
                ####8. Writing data frame as .csv to make reloading easier
                write.csv(testSet, 
                          file = "./coursera_repo/getting_and_cleaning_data/data_project/testSet.csv")
        }
}
##b. Merging datasets together 

trainingSet <- read.csv("./coursera_repo/getting_and_cleaning_data/data_project/trainingSet.csv")
testSet <- read.csv("./coursera_repo/getting_and_cleaning_data/data_project/testSet.csv")

# names(trainingSet)
# names(testSet)

mergedDataSet <- merge(trainingSet, testSet, all = TRUE)
# str(mergedDataSet)

#2. Extracting measurements of mean and standard deviation for each measurement

##a. Subsetting data frame by columns containing proper expression

###i. Drafting character vector containing only sd, mean related names

columnNames <- colnames(mergedDataSet)
x1 <- grepl(".mean|.std.", columnNames)
columnNames <- columnNames[x1]
x2 <- !grepl(".meanFreq.", columnNames)
# columnNames[x2]

###ii. Downloading dplyr and subsetting data frame

library(dplyr)

subsetData <- select(mergedDataSet, c(columnNames[x2]), y_train, y_test, 
                     subject_test, subject_train)
# str(subsetData)

#3. Using descriptive activity names to name activities in data set

##i. Cleaning data to get activities in one factorial column
subsetData <- mutate(subsetData, activity = factor(c(y_train[!is.na(y_train)], 
                                              y_test[!is.na(y_test)])))
# str(subsetData)
subsetData <- mutate(subsetData, activity = gsub("1", "WALKING", activity))
subsetData <- mutate(subsetData, activity = gsub("2", "WALKING_UPSTAIRS", activity))
subsetData <- mutate(subsetData, activity = gsub("3", "WALKING_DOWNSTAIRS", activity))
subsetData <- mutate(subsetData, activity = gsub("4", "SITTING", activity))
subsetData <- mutate(subsetData, activity = gsub("5", "STANDING", activity))
subsetData <- mutate(subsetData, activity = gsub("6", "LAYING", activity))
# str(subsetData)
# head(subsetData, 8)
subsetData <- select(subsetData, -(c(y_train, y_test)))
subsetData <- mutate(subsetData, activity = factor(activity))
# head(subsetData, 8)
# str(subsetData)

##ii. Cleaning Data to have subject number in same column
subsetData <- mutate(subsetData, ID = factor(c(subject_train[!is.na(subject_train)],
                                        subject_test[!is.na(subject_test)])))
subsetData <- select(subsetData, -(c(subject_train, subject_test)))
# str(subsetData)
# head(subsetData, 8)

#5. Creating second independent tidy data set w/average of each variable for
#each activity and each subject

##a. Grouping data set by activity and ID, averaging over all other variables, 
#and printing result

tidyData <- group_by(subsetData, activity, ID)
tidyDataFinal <- summarize_all(tidyData, mean)
write.csv(tidyDataFinal, file = "./coursera_repo/getting_and_cleaning_data/data_project/tidyDataFinal.csv")
write.table(tidyDataFinal, file = "./coursera_repo/getting_and_cleaning_data/data_project/tidyDataFinal.txt", row.names = FALSE)
# str(allMeans)
# head(allMeans)









