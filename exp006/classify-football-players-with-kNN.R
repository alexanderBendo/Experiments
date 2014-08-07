library(gmodels)
library(class)

# Load player statistics from CSV file
# There are 1800 football players in the data file
player_data <- read.csv("player-stats.csv")

# Shuffle the data frame to ensure the players are not ordered
shuffled_player_data <- player_data[sample(nrow(player_data)),]

# Just for convenience, drop non-numeric features as well as all kind of id features, ranking and so on
# BUT store the target feature in the last column
shuffled_player_data <- shuffled_player_data[,c(seq(1,8),10,11, seq(13,17),19,22,seq(24,26),34,seq(36,40),seq(44,51),seq(53,56),31)]

# Standardize player features
players_z <- as.data.frame(scale(shuffled_player_data[,1:37]))

# Now that they are randomly ordered, take the first 1500 players for the training set
# and 300 for the test set
players_train <- players_z[1:1500,]
players_test <- players_z[1501:1800,]

# Store the target class label in factor vectors for evaluating model performance
players_train_labels <- shuffled_player_data[1:1500,39]
players_test_labels <- shuffled_player_data[1501:1800,39]

# Classify test data and evaluate model performance using different values of k
# k=9 seems to work best, with 88.7% of correct predictions

pred <- knn(train = players_train, test = players_test, cl = players_train_labels, k = 31)
CrossTable(x= players_test_labels, y = pred,prop.chisq = FALSE)

pred <- knn(train = players_train, test = players_test, cl = players_train_labels, k = 9)
CrossTable(x= players_test_labels, y = pred,prop.chisq = FALSE)

pred <- knn(train = players_train, test = players_test, cl = players_train_labels, k = 3)
CrossTable(x= players_test_labels, y = pred,prop.chisq = FALSE)
