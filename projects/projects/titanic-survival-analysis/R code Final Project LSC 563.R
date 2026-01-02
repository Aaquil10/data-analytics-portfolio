#############. READ ME. #############
# Author: Ibrahima Medina Aaquil
# Date: 2025-04-30
# Data Source: Titanic Dataset
# Analysis Goals: Analyze survival patterns by class, gender, fare, and age
#################################

### ===================================================== ###
### Section 1: SETUP - Working Directory & Libraries
### ===================================================== ###

# Set working directory (ensure this path is correct for your system)
getwd()
setwd("~/Documents/R STUDIO CLASS PRACTIVE ")

# Load required libraries for data manipulation and visualization
library(readr)
library(tidyverse)   
library(ggplot2)    
library(forcats)     
library(viridis)     
library(ggridges)


# ===================================================== #
### Section 2: DATA LOADING & CLEANING
# ===================================================== #

# Load the final project data from the CSV file
Titanic <- read_csv("titanic.csv")

# Preview the first few rows and structure of the data
head(Titanic)
glimpse(Titanic)

# Clean column names to avoid issues with special characters in R
colnames(Titanic) <- make.names(colnames(Titanic))

# Convert the 'Survived' column to categorical values ("Yes"/"No")
Titanic$Survived <- ifelse(Titanic$Survived == 1, "Yes",
                           ifelse(Titanic$Survived == 0, "No", NA))
Titanic$Survived <- factor(Titanic$Survived, levels = c("No", "Yes"))

# Create a subset of the data with only the relevant variables:
# Sex, Pclass, Survived, and Fare.
subset <- select(Titanic, Sex, Pclass, Survived, Fare, Embarked)

# Rename variables for clarity (Gender, Class, Survival)
renamed <- rename(subset,
                  Gender = Sex,
                  Class = Pclass,
                  Survival = Survived)

# Additionally, create a subset with only female passengers.
filtered <- filter(renamed, Gender == "female")

# ===================================================== #
### Section 3: SUMMARY STATISTICS
# ===================================================== #

# Summary: Basic Fare statistics by Class
# This provides insight into the economic differences across classes.
fare_summary <- renamed %>%
  group_by(Class) %>%
  summarise(
    Mean_Fare = mean(Fare, na.rm = TRUE),
    Median_Fare = median(Fare, na.rm = TRUE),
    SD_Fare = sd(Fare, na.rm = TRUE),
    Count = n()
  )
print(fare_summary)

# Summary: Survival count by Gender
# Reveals differences in survival across male and female passengers.
gender_survival <- renamed %>%
  group_by(Gender, Survival) %>%
  summarise(Count = n(), .groups = "drop")
print(gender_survival)

# Summary: Fare statistics by Gender and Survival status
# Helps determine if fare price relates to the chances of survival.
fare_dist <- renamed %>%
  group_by(Gender, Survival) %>%
  summarise(
    Avg_Fare = mean(Fare, na.rm = TRUE),
    Min_Fare = min(Fare, na.rm = TRUE),
    Max_Fare = max(Fare, na.rm = TRUE),
    .groups = "drop"
  )
print(fare_dist)


# ===================================================== #
### Section 4: DEEPER or DETAILLED ANALYSIS
# ===================================================== #

# Analysis: Survival rate by Gender and Class
# Identifies which gender/class combinations had higher survival rates.
gender_class_survival <- renamed %>%
  group_by(Gender, Class) %>%
  summarise(Survival_Rate = mean(Survival == "Yes"), .groups = "drop") %>%
  arrange(desc(Survival_Rate))
print(gender_class_survival)

# Analysis: Average Fare by Survival status
# Determines if paying a higher fare was associated with a greater chance of survival.
fare_by_survival <- renamed %>%
  group_by(Survival) %>%
  summarise(Average_Fare = mean(Fare, na.rm = TRUE), .groups = "drop") %>%
  arrange(desc(Average_Fare))
print(fare_by_survival)

# Analysis: Income disparity (Fare spread) by Class
# Evaluates the range, median, and IQR of fares across different classes.
fare_spread <- renamed %>%
  group_by(Class) %>%
  summarise(
    Min_Fare = min(Fare, na.rm = TRUE),
    Max_Fare = max(Fare, na.rm = TRUE),
    Median_Fare = median(Fare, na.rm = TRUE),
    IQR_Fare = IQR(Fare, na.rm = TRUE),
    .groups = "drop"
  )
print(fare_spread)

# Create age bins to analyze survival by age groups
Titanic <- Titanic %>%
  mutate(AgeGroup = cut(Age,
                        breaks = c(0, 10, 20, 30, 40, 50, 60, 70, 80),
                        labels = c("0-10", "11-20", "21-30", "31-40",
                                   "41-50", "51-60", "61-70", "71-80")))

# Attach the AgeGroup variable to the renamed dataset for analysis
renamed <- bind_cols(renamed, AgeGroup = Titanic$AgeGroup)

# Analysis: Survival rate by Age Group
# Understand how survival rates vary among different age ranges.
age_survival <- renamed %>%
  filter(!is.na(AgeGroup)) %>%
  group_by(AgeGroup) %>%
  summarise(Survival_Rate = mean(Survival == "Yes"), .groups = "drop")
print(age_survival)

# Analysis: Survival of the poorest passengers (bottom 25% by Fare)
# Determine if lower fare (likely indicating poorer passengers) influenced survival.
fare_quartiles <- quantile(renamed$Fare, probs = 0.25, na.rm = TRUE)
low_fare_cutoff <- fare_quartiles[[1]]

poorest_passengers <- renamed %>%
  filter(Fare <= low_fare_cutoff)

poor_survival_rate <- mean(poorest_passengers$Survival == "Yes", na.rm = TRUE)
cat("Survival rate among the bottom 25% (poorest passengers):", round(poor_survival_rate * 100, 1), "%\n")

# Breakdown of poorest passengers by class
poor_class_dist <- poorest_passengers %>%
  group_by(Class) %>%
  summarise(Count = n(), .groups = "drop")
print(poor_class_dist)


# ===================================================== #
### Section 5: VISUALIZATIONS
### ===================================================== #

### Plot 1: Survival by Class (Proportional Bar Chart)
# Rationale: Displays the proportion of survivors within each class to highlight socioeconomic differences.

ggplot(renamed, aes(x = Class, fill = Survival)) +
  geom_bar(position = "fill") +
  labs(
    title = "Figure 1. Survival by Class",
    x = "Passenger Class",
    y = "Proportion",
    fill = "Survived"
  ) +
  scale_fill_manual(values = c("yellow", "purple")) +
  theme_minimal(base_size = 14)


### Plot 2: Survival by Gender (Side-by-Side Bar Chart)
# Rationale: Compares the absolute counts of survivors across genders to expose the gender gap.
ggplot(renamed, aes(x = Gender, fill = Survival)) +
  geom_bar(position = "dodge") +
  labs(
    title = "Figure 2. Survival by Gender",
    x = "Gender",
    y = "Count",
    fill = "Survived"
  ) +
  scale_fill_manual(values = c("blue", "green")) +
  theme_minimal(base_size = 14)

### Plot 3: Survival Rate by Age Group (Column Chart)
# Rationale: Shows survival rate trends across different age bins, indicating age-related risks.
ggplot(age_survival, aes(x = AgeGroup, y = Survival_Rate, fill = Survival_Rate)) +
  geom_col() +
  geom_text(aes(label = round(Survival_Rate, 2)), vjust = -0.5, size = 4) +
  scale_fill_gradient(low = "orange", high = "darkgreen") +
  labs(
    title = " Figure 3. Survival Rate by Age Group",
    x = "Age Group",
    y = "Survival Rate"
  ) +
  ylim(0, 1) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none")

### Plot 4: Fare Distribution by Survival (Violin Plot + Boxplot + Jitter)
# Rationale: The violin plot illustrates the full distribution of fares, while the boxplot shows central tendency and spread;
# the jitter plot overlays individual data points to reveal outliers and variability.
ggplot(renamed, aes(x = Survival, y = Fare, fill = Survival)) +
  geom_violin(trim = FALSE, alpha = 0.4, color = NA) +
  geom_boxplot(width = 0.1, outlier.shape = NA, alpha = 0.6) +
  geom_jitter(width = 0.2, size = 1.2, alpha = 0.3) +
  scale_fill_manual(values = c("red", "darkgreen")) +
  labs(
    title = " Figure 4. Fare Distribution by Survival Status",
    x = "Survival",
    y = "Fare Paid (Ticket Price)"
  ) +
  theme_minimal(base_size = 12)

### Plot 5: Fare Distribution by Passenger Class (Boxplot)
# Rationale: Compares the fare distributions among classes, highlighting differences in variability.
renamed$Class <- factor(Titanic$Pclass, levels = c(1, 2, 3), labels = c("1st", "2nd", "3rd"))

# Create the boxplot with a legend.
ggplot(renamed, aes(x = Class, y = Fare, fill = Class)) +
  geom_boxplot(width = 0.6, outlier.shape = 16, outlier.size = 2, alpha = 0.8) +
  scale_fill_manual(values = c("#1f77b4", "#2ca02c", "#ff7f0e")) +
  labs(
    title = "Figure 5. Fare Distribution by Passenger Class",
    x = "Passenger Class",
    y = "Fare Paid"
  ) +
  theme_minimal(base_size = 12)

### Plot 6: Survival Among the Poorest Passengers (Bar Chart)
# Rationale: Visualizes the survival percentage among the bottom 25% fare payers, underscoring economic disparities.
poor_survival_summary <- poorest_passengers %>%
  group_by(Survival) %>%
  summarise(Count = n(), .groups = "drop") %>%
  mutate(Percentage = round(Count / sum(Count) * 100, 1))

ggplot(poor_survival_summary, aes(x = Survival, y = Percentage, fill = Survival)) +
  geom_col(width = 0.6) +
  geom_text(aes(label = paste0(Percentage, "%")), vjust = -0.4, size = 4.5) +
  scale_fill_manual(values = c("red", "darkgreen")) +
  labs(
    title = "Figure 6. Survival Rate Among the Poorest Passengers (Bottom 25%)",
    x = "Survival Status",
    y = "Percentage"
  ) +
  ylim(0, 100) +
  theme_minimal(base_size = 9)

### Plot 7: Survival by Embarkation Port (Proportional Bar Chart)
# Rationale: Examines if the port of embarkation had any influence on survival chances.
# Create a cleaned subset with factors properly set

embarked_plot <- Titanic %>%
  filter(!is.na(Embarked), !is.na(Survived)) %>%
  mutate(
    Embarked = factor(Embarked, levels = c("C", "Q", "S"),
                      labels = c("Cherbourg", "Queenstown", "Southampton"))
  )

# Plot: Proportional survival by embarkation port
ggplot(embarked_plot, aes(x = Embarked, fill = Survived)) +
  geom_bar(position = "fill") +
  scale_fill_manual(values = c("brown", "skyblue")) +
  labs(
    title = "Figure 7. Survival Rate by Embarkation Port",
    x = "Embarked From",
    y = "Proportion",
    fill = "Survived"
  ) +
  theme_minimal(base_size = 14)

### Plot 8: Gender vs. Class with LOESS Smoothing (Scatterplot)
# Rationale: Investigates the combined effects of gender and class on survival. 
# The jitter adds variation while the LOESS smoother reveals underlying trends.
gender_class_plot <- Titanic %>%
  filter(!is.na(Sex), !is.na(Pclass), !is.na(Survived)) %>%
  mutate(
    Gender = factor(Sex, levels = c("female", "male")),                      
    Class = factor(Pclass, levels = c(1, 2, 3), labels = c("1st", "2nd", "3rd")),  
    Survival = Survived
  )
ggplot(gender_class_plot, aes(x = Class, y = Gender, color = Survival)) +
  geom_jitter(width = 0.25, alpha = 0.6, size = 2) +                        
  geom_smooth(aes(x = as.numeric(Class), y = as.numeric(Gender), group = Survival),
              method = "loess", se = FALSE, linewidth = 1.2) +
  scale_color_manual(values = c("red", "purple")) +
  labs(
    title = " Figure 8. Gender and Class Patterns by Survival Status",
    x = "Passenger Class",
    y = "Gender",
    color = "Survived"
  ) +
  theme_minimal(base_size = 14)

### Plot 9: Age Distribution by Gender & Survival (Ridge Plot)
# Rationale: Uses ridge plots to portray age distributions stratified by gender and survival,
# highlighting differences in age patterns between survivors and non-survivors.
ridge_data <- Titanic %>%
  filter(!is.na(Sex), !is.na(Survived), !is.na(Age)) %>%
  mutate(
    Gender = factor(Sex),
    Survival = Survived
  )
ggplot(ridge_data, aes(x = Age, y = Gender, fill = Survival)) +
  geom_density_ridges(alpha = 0.7, scale = 1) +
  scale_fill_manual(values = c("red", "blue")) +
  labs(
    title = "Figure 9. Age Distribution by Gender and Survival Status",
    x = "Age",
    y = "Gender",
    fill = "Survived"
  ) +
  theme_minimal(base_size = 10)

### Plot 10: Passenger Count by Class, Gender, Embarkation & Survival (Balloon Plot)
# Rationale: Combines multiple dimensions (Class, Gender, Embarked, Survival) into one visual using point size.
# Create balloon_data using the renamed dataframe (which now contains Embarked)
balloon_data <- renamed %>%
  filter(!is.na(Class), !is.na(Gender), !is.na(Survival), !is.na(Embarked)) %>%
  group_by(Class, Gender, Survival, Embarked) %>%
  summarise(Passenger_Count = n(), .groups = "drop")

### Plot the balloon chart ###
ggplot(balloon_data, aes(x = Class, y = Gender)) +
  geom_point(aes(size = Passenger_Count, color = Survival), alpha = 0.8) +
   scale_size_continuous(range = c(6, 20)) +
  scale_color_manual(values = c("red", "darkgreen")) +
  facet_wrap(~ Embarked) +
  
  labs(
    title = " Figure 10. Passenger Count by Class, Gender & Survival",
    x = "Class",
    y = "Gender",
    size = "Count",
    color = "Survived"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title   = element_text(face = "bold", hjust = 0.5),
    strip.text   = element_text(face = "bold"),
    legend.position = "right"
  )


### Plot 11: Fare vs. Age by Survival (Faceted Scatterplot)
# Rationale: Explores relationship between age and fare while comparing survival groups; faceting by class helps reveal subtleties within each class.
fare_age_data <- Titanic %>%
  filter(!is.na(Age), !is.na(Fare), !is.na(Survived), !is.na(Pclass)) %>%
  mutate(
    Survival = factor(Survived, levels = c("No", "Yes")),
    Class = factor(Pclass, levels = c(1, 2, 3), labels = c("1st", "2nd", "3rd"))
  )
ggplot(fare_age_data, aes(x = Age, y = Fare, color = Survival)) +
  geom_point(alpha = 0.5, size = 2) +
  geom_smooth(method = "loess", se = FALSE, linewidth = 1.2) +
  scale_color_manual(values = c("red", "darkblue")) +
  facet_wrap(~ Class) +
  labs(
    title = "Figure 11. Fare vs Age by Survival Status (Faceted by Class)",
    x = "Age",
    y = "Fare Paid",
    color = "Survived"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    strip.text = element_text(face = "bold")
  )

### Plot 12: Gender Breakdown Within Survival (100% Stacked Bar Chart)
# Rationale: This chart provides a percentage view of the gender split within each survival category, 
# further broken down by class, showing proportional differences clearly.
ggplot(renamed, aes(x = Survival, fill = Gender)) +
  geom_bar(position = "fill", width = 0.6) +
  facet_wrap(~ Class) +
  scale_fill_manual(values = c("skyblue", "orange")) +
  labs(
    title = " Figure 12. Gender Breakdown Within Survival Status (Faceted by Class)",
    x = "Survival Status",
    y = "Proportion",
    fill = "Gender"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    strip.text = element_text(face = "bold"),
    plot.title = element_text(face = "bold", hjust = 0.5)
  )

### Plot 13: Fare vs Age by Survival (2D Histogram / Heatmap)
# Rationale: Uses a 2D histogram to visualize clusters of passengers by age and fare, comparing survivors vs. non-survivors.
heatmap_data <- Titanic %>%
  filter(!is.na(Age), !is.na(Fare), !is.na(Survived))
ggplot(heatmap_data, aes(x = Age, y = Fare)) +
  geom_bin2d(bins = 25) +
  scale_fill_viridis(option = "magma") +
  facet_wrap(~ Survived) +
  labs(
    title = "Figure 13. Fare vs Age by Survival (2D Histogram)",
    x = "Passenger Age",
    y = "Fare Paid",
    fill = "Density"
  ) +
  theme_minimal(base_size = 12)


### Regression Analysis & Statistical Transformation ###


# Plot 14: Linear Regression: Fare vs Age by Survival
# Rationale: Using linear regression (method = "lm") helps us understand the linear trend between Age and Fare,
# and comparing survival groups may reveal if the slope or intercept differs between survivors and non-survivors.
ggplot(fare_age_data, aes(x = Age, y = Fare, color = Survival)) +
  geom_point(alpha = 0.6) +                           
  geom_smooth(method = "lm", se = TRUE, linewidth = 1.2) +  
  labs(
    title = "Figure 14. Linear Regression: Fare vs Age by Survival",
    x = "Age",
    y = "Fare Paid",
    color = "Survived"
  ) +
  theme_minimal(base_size = 14)

# Plot 15: Mean Fare by Age with Bootstrap Confidence Intervals using stat_summary()
# Rationale: This plot computes the mean Fare for each Age (or binned Age) along with error bars (bootstrapped CIs).
# It provides a statistical transformation that reveals the central tendency and variability of Fare across Age.
ggplot(fare_age_data, aes(x = Age, y = Fare)) +
  geom_point(alpha = 0.5, color = "grey") +           
  stat_summary(aes(color = "CI"), fun.data = "mean_cl_boot", geom = "errorbar", 
               width = 1.0) +          
  stat_summary(aes(color = "Mean"), fun = mean, geom = "line", size = 1.2) +           
  scale_color_manual(name = "Legend", values = c("Mean" = "orange", "CI" = "blue")) +
  labs(
    title = "Figure 15. Mean Fare by Age with Bootstrap Confidence Intervals",
    x = "Age",
    y = "Fare Paid"
  ) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "right")