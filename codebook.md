# Getting and Cleaning Data Course Project CodeBook
This file describes the important variables, the data, and any transformations or work that you performed to clean up the data in the "run_analysis.R" script.
Variables will in the following be written in italic.

## Steps in the "run_analysis.R" script
The script is divided into 6 sections. An info section and the 5 steps relating to the steps described in the assignment.

### Info
* States the R version, R Studio version and OS in which the script was developed.

### Step 1
1. Read the data files X_train.txt, y_train.txt, X_test.txt, y_test.txt, subject_train.txt and subject_test.txt into the variables 
*trainPred*, *trainLabel*, *testPred*, *testLabel*, *trainSubject* and *testSubject* respectively.
2. Combined the *trainPred* and *trainLabel* into the *trainTotal* variable (column bind).
3. Combined the *testPred* and *testLabel* into the *testTotal* variable (column bind).
4. Combined the *trainSubject* and *testSubject* into the *subjectTotal* variable (row bind).
5. Row bind *trainTotal* and *testTotal* together and afterwards column bind *subjectTotal* to this. The result is saved in the variable mergedData.
6. Free up memory by removing temporary varibles.

### Step 2
1. Read the features from the features.txt file and save it into the *features* varible.
2. Get indices for the variables containing "mean()" or "std()" in the *features* variable, including the Label and Subject columns. Save the indicies in the variable *IndexMeanStd*.
3. Put the Labels in the variable *labelData* and the subject data in the variable *subjectData*.
4. Use the *IndexMeanStd* to extract the relevant columns from the *mergedData* variable and overwrite the *mergedData* variable.
5. Label the *labelData* "Label" and the *subjectData* "Subject".
6. Combine the *labelData*, *subjectData* and the *mergedData* variables in the *mergedDataTotal* variable.

### Step 3
1. Read the activity labels from the file "activity_labels.txt" into the variable *activity_Labels*
2. Name the columns "activity" and "activityName" respectively.
3. Replace the integers in the "Label" column in the *mergeDataTotal* variable with the appropriate label text by mergeing *mergeDataTotal* and *activity_Labels*.
4. Drop the "Label" column in *mergeDataTotal* as it now contains "activityName".

### Step 4
1. Split up data in label, subject and the remaining data in the variables *labelData*, *subjectData* and *varData*.
2. Name the columns in the *varData* using the *features* variable. The "(", ")" and "-" are removed and mean and std are capitalized in order to improve reading.
3. The variables *labelData*, *subjectData* and *varData* are combined in the variable *DataSet*.

### Step 5
1. Read the "dplyr" library
2. Make a copy of the data *DataSet* to the variable *Average_DataSet*.
3. Group the varibale *Average_DataSet* by "Suject" and "activityName" and mean all other columns.
4. Write the *Average_DataSet* variable to the text file "DataMeans_by_Subject_activityName.txt"


