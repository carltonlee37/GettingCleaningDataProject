library(plyr)

# Download and unzip data files into local directory ./R/data
  if(!file.exists("./Desktop/R/data")){dir.create("./Desktop/R/data")}
  fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl,destfile="./Desktop/R/data/UCIHARDataSet.zip",method="curl")
  unzip("./data/UCIHARDataSet.zip",exdir="./data")

# Read variables, features, and activity labels into tables
  features<-read.table("./data/UCI Har Dataset/features.txt")
  activityLabels<-read.table("./data/UCI HAR Dataset/activity_labels.txt")
  xTest<-read.table("./data/UCI HAR Dataset/test/X_test.txt")
  yTest<-read.table("./data/UCI HAR Dataset/test/y_test.txt")
  subjectTest<-read.table("./data/UCI HAR Dataset/test/subject_test.txt")
  xTrain<-read.table("./data/UCI HAR Dataset/train/X_train.txt")
  yTrain<-read.table("./data/UCI HAR Dataset/train/y_train.txt")
  subjectTrain<-read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Merge test and train data tables
  xData<-rbind(xTest,xTrain)
  yData<-rbind(yTest,yTrain)
  subjectData<-rbind(subjectTest,subjectTrain)
  
# Extract mean and standard deviation variables
  meanStd<-grep("-(mean|std)\\(\\)", features[,2])
  xData<-xData[,meanStd]
  
# Apply descriptive activity names and appropriate labels
  yData[, 1]<-activityLabels[yData[, 1], 2]
  names(yData)<-"Activity"
  names(subjectData)<-"Subject"
  names(xData)<-features[meanStd,2]
  colnames(xData)<-gsub("^t","Time",colnames(xData))
  colnames(xData)<-gsub("^f","Freq",colnames(xData))
  colnames(xData)<-gsub("*-mean","Mean",colnames(xData))
  colnames(xData)<-gsub("*-std","Std",colnames(xData))
  colnames(xData)<-gsub("*\\(\\)","",colnames(xData))
  colnames(xData)<-gsub("*-",".",colnames(xData))
  
# Merge all tables into one dataset
  allData<-cbind(subjectData,yData,xData)
  
# Create new dataset with average of each variable for each activity and subject
  averageData<-ddply(allData,.(Subject,Activity),function(x)colMeans(x[, 3:68]))
  write.table(averageData,"./data/UCIHARAverageData.txt",row.names=FALSE)
  