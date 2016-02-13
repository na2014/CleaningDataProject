# CodeBook

Here are the steps that were taken to transform the data:

* Training and test data set were merged
* Field Names assigned using "features"
* Fields that did not have "mean" or "std" were removed 
* Fields in "y" were used to name activities
* Subject names taken from the "subject" files

Column names were then cleaned up by doing the following

* Remove parenthesis and hyphens
* Convert t to Time and f to Frequency
* Convert std to Std and mean to Mean
* Convert BodyBody to Body
* Use the column heading Activity for the activity names

The data was then reduced by taking the mean for each
(Subject,Activity) pair.  This resulting data set was saved in the
"tidyData.txt" file.
