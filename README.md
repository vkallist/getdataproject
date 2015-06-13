#Explanation of the R code in run_analysis.R

First of all I load the two data sets (test and train) into the respective variables
```R
test<-read.table("UCI HAR Dataset/test/X_test.txt")
train<-read.table("UCI HAR Dataset/train/X_train.txt")
```
Then I load the activity data for each data set into separate variables, which are then binded as an extra column
in the respective data sets.
```R
activTest<-read.table("UCI HAR Dataset/test/y_test.txt")
activTrain<-read.table("UCI HAR Dataset/train/y_train.txt")
test<-cbind(test, activTest)
train<-cbind(train, activTrain)
```
The same is done for the subject data (the subject for which the measurement was made).
I load the subject data for each data set into separate variables, which are then binded as an extra column
in the respective data sets (which already contain the extra column on activity data).
```R
subjTest<-read.table("UCI HAR Dataset/test/subject_test.txt")
subjTrain<-read.table("UCI HAR Dataset/train/subject_train.txt")
test<-cbind(test, subjTest)
train<-cbind(train, subjTrain)
```
The the train and test data are joined in one set
```R
rawData<-rbind(train,test)
```
The column names of the measurements are loaded from the appropriate file and then
are inserted in the data set. Care is taken to also give the names of the two extra columns
which have been created by the previous steps.
```R
features<-read.table("UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)
names(rawData)<-c(features[,"V2"], "activity", "subject")
```
I select all the columns which have the strings "mean()" and "std()" in them (see *CodeBook.md* for an explanation), as well
as the last two columns which were appended. Then, I narrow the data set by keeping only those columns.
```R
selectedColumns<-grepl("mean()", names(rawData), fixed=TRUE) | grepl("std()", names(rawData), fixed=TRUE)
selectedColumns<-selectedColumns | c(rep(FALSE, 561), TRUE, TRUE)
narrowData <- rawData[,which(selectedColumns)]
```
Then I read the activity codes and their descriptions, and I join
the narrow data set with the activity data (in essence I add a column with the Activity Description)
and then I drop the column containing the activity code. The resulting data set has 68 columns.
```R
activDesc<-read.table("UCI HAR Dataset/activity_labels.txt")
names(activDesc)<-c("activity", "activityDesc")
narrowData<-merge(narrowData, activDesc)
narrowData<-narrowData[, 2:69]
```
I replace all occurrences of the "BodyBody" string in column names with just "Body" 
(see *CodeBook.md* for an explanation).
```R
names(narrowData)<-gsub("BodyBody", "Body", names(narrowData))
```
I summarize all the columns by taking the mean for the data of each activity and subject.
```R
tidyData<-summarise_each(group_by(narrowData, activityDesc, subject), funs(mean))
```
Finally, the summarized data are exported into a file.
```R
write.table(tidyData, "tidydata.txt", row.names=FALSE)
```