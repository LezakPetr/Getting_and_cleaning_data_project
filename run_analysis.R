library(dplyr)

features = read.csv(file = 'UCI HAR Dataset/features.txt', sep = ' ', header = FALSE)[,2];
activity_labels = read.csv(file = 'UCI HAR Dataset/activity_labels.txt', sep = ' ', header = FALSE);

x_train <- read.fwf(file = 'UCI HAR Dataset/train/X_train.txt', rep(16, 561), col.names = features);
y_train <- read.csv(file = 'UCI HAR Dataset/train/y_train.txt', header = FALSE);
subject_train <- read.csv(file = 'UCI HAR Dataset/train/subject_train.txt', header = FALSE);

x_test <- read.fwf(file = 'UCI HAR Dataset/test/X_test.txt', rep(16, 561), col.names = features);
y_test <- read.csv(file = 'UCI HAR Dataset/test/y_test.txt', header = FALSE);
subject_test <- read.csv(file = 'UCI HAR Dataset/test/subject_test.txt', header = FALSE);

x <- rbind (x_train, x_test);
activity <- factor (unlist(rbind (y_train, y_test)), levels = activity_labels[,1], labels = activity_labels[,2]);
names(activity) <- "activity";

subject = rbind (subject_train, subject_test);
names(subject) <- "subject";

data <- cbind(x[,grep (".*mean.*|.*std.*", names(x))], subject, activity);
write.csv(file = 'data.csv', data);

tidy_data <- group_by(data, activity, subject) %>% summarise_all(mean);
write.table(file = 'tidy_data.txt', tidy_data, row.name=FALSE);
