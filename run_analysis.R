setwd("C:/Users/Modelling/Documents/aditya/Coursera R programming/getting and cleaning data/UCI HAR Dataset")
library(data.table)
library(reshape)
library(dplyr)
library(reshape2)

act_labels <- read.table("activity_labels.txt")
feat <- data.table(read.delim("features.txt", header = FALSE, sep = " ", stringsAsFactors = FALSE))

feat_names <- feat$V2
feat_sort <- grep(".*mean.*|.*std.*", tolower(feat_names))
feat_names <- feat_names[feat_sort]

ytest <- read.table("C:/Users/Modelling/Documents/aditya/Coursera R programming/getting and cleaning data/UCI HAR Dataset/test/Y_test.txt")
xtest <- read.table("C:/Users/Modelling/Documents/aditya/Coursera R programming/getting and cleaning data/UCI HAR Dataset/test/X_test.txt")[feat_sort]
sub_test <- read.table("C:/Users/Modelling/Documents/aditya/Coursera R programming/getting and cleaning data/UCI HAR Dataset/test/subject_test.txt")


ytrain <- read.table("C:/Users/Modelling/Documents/aditya/Coursera R programming/getting and cleaning data/UCI HAR Dataset/train/Y_train.txt")
xtrain <- read.table("C:/Users/Modelling/Documents/aditya/Coursera R programming/getting and cleaning data/UCI HAR Dataset/train/X_train.txt")[feat_sort]
sub_train <- read.table("C:/Users/Modelling/Documents/aditya/Coursera R programming/getting and cleaning data/UCI HAR Dataset/train/subject_train.txt")

feat_names <- gsub("-mean", "Mean", feat_names)
feat_names <- gsub("-std", "Std", feat_names)
feat_names <- gsub("[-()]", "", feat_names)


colnames(xtest) <- feat_names
colnames(xtrain) <- feat_names

colnames(ytest) <- c("Activity")
colnames(ytrain) <- c("Activity")
colnames(sub_test) <- c("Subject")
colnames(sub_train) <- c("Subject")

train <- cbind(sub_train,xtrain,ytrain)
test <- cbind(sub_test,xtest,ytest)

data <- rbind(train,test)

data$Activity <- factor(data$Activity, levels = act_labels[,1], labels = act_labels[,2])
data$Subject <- as.factor(data$Subject)



data_melt <- melt(data, id = c("Subject", "Activity"))

data_mean <- dcast(data_melt, Subject + Activity ~ variable, mean)

write.table(data_mean, "tidy.txt", row.names = FALSE, quote = FALSE)