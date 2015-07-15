#################################################################
##### Info: Script developed under the following conditions #####
#################################################################
# R version: 3.2.0
# R Studio version: 0.98.1103 
# OS: 64-bit Windows 7 environment


#################################################################################
##### step 1: Merges the training and the test sets to create one data set. #####
#################################################################################

#setwd("N:/Projects/Coursera/Course 3 - Getting and Cleaning Data/CourseProject")

# Read training predictor data into the "trainPred" data frame
trainPred <- read.table("UCI_HAR_Dataset/train/X_train.txt")

# Read training data labels into the "trainLabel" data frame
trainLabel <- read.table("UCI_HAR_Dataset/train/y_train.txt")

# Read test predictor data into the "testPred" data frame
testPred <- read.table("UCI_HAR_Dataset/test/X_test.txt")

# Read test data labels into the "testLabel" data frame
testLabel <- read.table("UCI_HAR_Dataset/test/y_test.txt")

# Read testpredictor data into the "testPred" data frame
trainSubject <- read.table("UCI_HAR_Dataset/train/subject_train.txt")

# Read test data labels into the "testLabel" data frame
testSubject <- read.table("UCI_HAR_Dataset/test/subject_test.txt")

# Create a total training set with both predictor variabels and label
trainTotal <- cbind(trainPred,trainLabel)

# Create a total test set with both predictor variabels and label
testTotal <- cbind(testPred,testLabel)

# Create a total test set with both predictor variabels and label
subjectTotal <- rbind(trainSubject,testSubject)

# Provide each data set type with either "train" or "test" respectively and combine into one data set
mergedData <- rbind(trainTotal,testTotal)
mergedData <- cbind(mergedData,subjectTotal)

# Free up memory by removing temporary variables
remove(trainPred,trainLabel,trainTotal,testPred,testLabel,testTotal,trainSubject,testSubject)

###########################################################################################################
##### step 2: Extracts only the measurements on the mean and standard deviation for each measurement. #####
###########################################################################################################

# Read the features from feature text file. 
features <- read.table("UCI_HAR_Dataset/features.txt") #,stringsAsFactors = FALSE)

# Find the indicies for the features that include "mean()" or "std()". This information is required from the features_info.txt file
IndexMeanStd <-grep("mean\\(\\)|std\\(\\)",features[,2]) # \\ is used for string characters like ( and ). See info for grep
IndexMeanStd <- c(IndexMeanStd,ncol(mergedData)-1,ncol(mergedData))

# Extract the relevant measurements from the total data set.
labelData <- data.frame(mergedData[,ncol(mergedData)-1])
subjectData <- data.frame(mergedData[,ncol(mergedData)])
mergedData <- mergedData[,IndexMeanStd[1:(length(IndexMeanStd)-2)]] 

# Name the label data
names(labelData) <- "Label"
names(subjectData) <- "Subject"

# Create one data set
mergedDataTotal <- cbind(mergedData,labelData,subjectData)

#############################################################################################
##### step 3: Uses descriptive activity names to name the activities in the data set.   #####
#############################################################################################

# Read the activity labels from the file "activity_labels.txt"
activity_Labels <- read.table("UCI_HAR_Dataset/activity_labels.txt")
head(activity_Labels) # Inspect the data
names(activity_Labels) <- c("activity","activityName")

# Replace the integers in the labelData with the appropriate label text.
mergedDataTotal <- merge(mergedDataTotal,activity_Labels,by.x="Label",by.y="activity")

# Remove "Label" column as we now have the "activityName" label
mergedDataTotal$Label <- NULL

#############################################################################################
##### step 4: 4.Appropriately labels the data set with descriptive variable names      ######
#############################################################################################

# Split up date in label, subject and the remaining data.
labelData <- mergedDataTotal["activityName"]
subjectData <- mergedDataTotal["Subject"]
varData <- mergedDataTotal[,1:(ncol(mergedDataTotal )-2)] 

# Format the feature names and use them to proper label the variable names
names(varData) <- gsub("\\(\\)", "", features[IndexMeanStd[1:(length(IndexMeanStd)-2)], 2]) 
names(varData) <- gsub("-", "", names(varData)) # replace "-" with nothing
names(varData) <- gsub("mean", "Mean", names(varData)) # Capitalize mean for better reading
names(varData) <- gsub("std", "Std", names(varData)) # Capitalize std for better reading

# Combine the variables, subjects and activityNmae into one data set
DataSet <- cbind(varData,subjectData,labelData)

#############################################################################################
##### step 5: 5.From the data set in step 4, creates a second, independent tidy data set##### 
##### with the average of each variable for each activity and each subject.             #####
#############################################################################################
library(dplyr)

# Make a copy of the data
Average_DataSet <- DataSet

# Group by activityName and Subject and mean all other variables
Average_DataSet <- 
  Average_DataSet %>%
  group_by(activityName,Subject) %>%
  summarise_each(funs(mean))

# Write the average dataset to a text file
write.table(Average_DataSet, "DataMeans_by_Subject_activityName.txt",row.name=FALSE) 

# Free up memory by removing temporary variables
remove(activity_Labels,features,labelData,mergedData,mergedDataTotal,subjectData,subjectTotal,varData,IndexMeanStd)

