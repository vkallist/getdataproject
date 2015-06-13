test<-read.table("UCI HAR Dataset/test/X_test.txt")
train<-read.table("UCI HAR Dataset/train/X_train.txt")
activTest<-read.table("UCI HAR Dataset/test/y_test.txt")
activTrain<-read.table("UCI HAR Dataset/train/y_train.txt")
test<-cbind(test, activTest)
train<-cbind(train, activTrain)
subjTest<-read.table("UCI HAR Dataset/test/subject_test.txt")
subjTrain<-read.table("UCI HAR Dataset/train/subject_train.txt")
test<-cbind(test, subjTest)
train<-cbind(train, subjTrain)
rawData<-rbind(train,test)
features<-read.table("UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)
names(rawData)<-c(features[,"V2"], "activity", "subject")

selectedColumns<-grepl("mean()", names(rawData), fixed=TRUE) | grepl("std()", names(rawData), fixed=TRUE)
selectedColumns<-selectedColumns | c(rep(FALSE, 561), TRUE, TRUE)
narrowData <- rawData[,which(selectedColumns)]

activDesc<-read.table("UCI HAR Dataset/activity_labels.txt")
names(activDesc)<-c("activity", "activityDesc")
narrowData<-merge(narrowData, activDesc)
narrowData<-narrowData[, 2:69]

names(narrowData)<-gsub("BodyBody", "Body", names(narrowData))

tidyData<-summarise_each(group_by(narrowData, activityDesc, subject), funs(mean))

write.table(tidyData, "tidydata.txt", row.names=FALSE)
