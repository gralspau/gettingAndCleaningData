Analysis Information
====================

The analysis begins with loading the compressed dataset into R, extracting its contents, and storing them in a folder in your local directory.

Reading in Test and Training Sets
---------------------------------

Since the relevant numeric data are text files, the program reads these text files into R as a character vector containing thousands of 561-element long strings.  The script then splits these strings, converts their contents into numeric elements, and extracts a long list of 561-element numeric vectors.  

After loading in the feature vector, the activity labels for each observation, and the subject labels for each observation, the script creates a 564 column data frame with the feature vector, activity labels, and subject labels as column names.  Both the training set and test set data frames are written to your local directory as a csv to expedite the future execution of this script. 

Remaining Steps
-----------------

After reading the csv data frames, the script merges them together using the default merge function settings, excepting the specification that all observations be included in the new data frame.  Following this step, the script isolates the features with mean and std functions applied to them and subsets a new data frame with these features, as well as the activity labels and subject labels.  After cleaning the activity and subject labels, the data frame is grouped by activity label and subject level, then all other features are averaged across these groups.  The final output is a csv file with 180 observations representing the intersection between subject and activity.  
