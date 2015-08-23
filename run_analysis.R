setwd("/Users/gregk/Dropbox (Personal)/Data Science/Getting and Cleaning Data/Course Project/UCI HAR Dataset")
library(dplyr)
library(reshape2)

## reading in feature names
features <- read.table("features.txt")
keep_features <- filter(features, grepl("-mean()|-std()", V2))
keep_features <- filter(keep_features, !grepl("-meanFreq", V2))

## reading in activity lables
act_labels <- read.table("activity_labels.txt")
colnames(act_labels) <- c("V1","labels")

## reading in training sets
x_train <- read.table("train/X_train.txt")[, keep_features$V1]
colnames(x_train) <- keep_features$V2

y_train <- read.table("train/Y_train.txt")
y_train <- merge(y_train,act_labels)
y_train <- y_train$labels

subj_train <- read.table("train/subject_train.txt")
colnames(subj_train) <- "subject"
train_set <- cbind(subj_train,y_train,x_train)
names(train_set)[names(train_set)=="y_train"] <- "activity"

## reading in test sets
x_test <- read.table("test/X_test.txt")[, keep_features$V1]
colnames(x_test) <- keep_features$V2

y_test <- read.table("test/Y_test.txt")
y_test <- merge(y_test,act_labels)
y_test <- y_test$labels

subj_test <- read.table("test/subject_test.txt")
colnames(subj_test) <- "subject"
test_set <- cbind(subj_test,y_test,x_test)
names(test_set)[names(test_set)=="y_test"] <- "activity"

data_set <- rbind(train_set,test_set)

## creating tidy data

data_melt <- melt(data_set,id=c("subject","activity"),measure.vars=keep_features$V2)
tidy_data <- dcast(data_melt, subject + activity ~ variable, mean)
write.table(tidy_data,file = "gacd_tidy_data.txt", row.name=FALSE)

