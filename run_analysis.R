# Loading the library
library(data.table)
library(dplyr)

# Downloading and unzipping the datafiles
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# Merges the training and the test sets to create one data set
# Reading files
# Trainings data
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Testing data
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Reading features and activity labels
features <- read.table('./data/UCI HAR Dataset/features.txt')
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')
activityLabels[,2] <- as.character(activityLabels[,2])

# Merge the training and the test sets
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
s_data <- rbind(s_train, s_test)

# Extracts only the measurements on the mean and standard deviation
selectedCols <- grep("-(mean|std).*", as.character(features[,2]))
selectedColNames <- features[selectedCols, 2]
selectedColNames <- gsub("-mean", "Mean", selectedColNames)
selectedColNames <- gsub("-std", "Std", selectedColNames)
selectedColNames <- gsub("[-()]", "", selectedColNames)

# Labeling the data set with descriptive variable names
x_data <- x_data[selectedCols]
allData <- cbind(s_data, y_data, x_data)
colnames(allData) <- c("ID", "Activity", selectedColNames)
allData$Activity <- factor(allData$Activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$ID <- as.factor(allData$ID)

# Generating the tidy data set after cleaning
meltedData <- melt(allData, id = c("ID", "Activity"))
tidyData <- dcast(meltedData, ID + Activity ~ variable, mean)
write.table(tidyData, "./Tidy.txt", row.names = FALSE, quote = FALSE)










