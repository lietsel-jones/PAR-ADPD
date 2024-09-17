# Overview ---------------------------------------------------------------
# Data Visualization for Cross-ancestry PAR analysis
  # Project: Cross-ancestry PAR analysis
  # Version: R/4.0
  # Last Updated: 05-JUN-2024

# Libraries ---------------------------------------------------------------
library(plyr)
library(tidyverse)
library(viridis)
library(dplyr)
library(ggrepel)
library(patchwork)
library(ggtext)

# Import data to visualize ------------------------------------------------
# Define the paths to the AD and PD results folders
ad_results_folder <- "{WORK_DIR}/AD/results/"
pd_results_folder <- "{WORK_DIR}/PD/results/"

# Function to find and read the most recent CSV matching a specific filename pattern
read_most_recent_csv <- function(folder_path, pattern) {
  # Get the list of all CSV files in the folder matching the specific pattern
  csv_files <- list.files(path = folder_path, pattern = paste0(pattern, "\\.csv$"), full.names = TRUE)
  
  # Check if there are any matching CSV files
  if (length(csv_files) > 0) {
    # Extract the date prefix from the filenames (YYYY-MM-DD) and get modification time
    file_dates <- gsub(".*/|_.*", "", csv_files)  # Extract the date portion from filenames
    valid_dates <- as.Date(file_dates, format = "%Y-%m-%d")  # Convert to Date object
    
    # Get the most recent file by the date prefix in the filename
    most_recent_file <- csv_files[which.max(valid_dates)]
    
    # Read the most recent CSV into a dataframe
    df <- read.csv(most_recent_file)
    
    # Return the dataframe and the file name
    list(data = df, file = most_recent_file)
  } else {
    # Return NULL if no matching CSV files are found
    NULL
  }
}

# Read the most recent CSV from the AD results folder ending with '_AD_PAR_results_top20_filtered.csv'
dat_ad <- read_most_recent_csv_with_pattern(ad_results_folder, "_AD_PAR_results_top20_filtered.csv")
if (!is.null(dat_ad)) {
  ad_df <- dat_ad$data
  print(paste("Most recent AD file read:", dat_ad$file))
} else {
  print("No matching CSV files found in AD results folder.")
}

# Read the most recent CSV from the PD results folder ending with '_PD_PAR_results_top20_filtered.csv'
dat_pd <- read_most_recent_csv_with_pattern(pd_results_folder, "_PD_PAR_results_top20_filtered.csv")
if (!is.null(dat_pd)) {
  pd_df <- dat_pd$data
  print(paste("Most recent PD file read:", dat_pd$file))
} else {
  print("No matching CSV files found in PD results folder.")
}

# Select top 10 for AD & PD -----------------------------------------------
# Plot will be too crowded -> only do top 10 for each
dat_ad_10 <- ddply(ad_df, "ancestry", function (x) head(x[order(x$par, decreasing = TRUE) , ], 10))
dat_pd_10 <- ddply(pd_df, "ancestry", function (x) head(x[order(x$par, decreasing = TRUE) , ], 10))

# Visualization - AD ------------------------------------------------------
# Add a new column to indicate proxy rsID's
dat_ad_10 <- dat_ad_10 %>%
  mutate(proxy = case_when(
    SNP %in% c("rs429358", "rs7412") ~ "*",
    SNP == "rs1081105" ~ "(proxy for rs429358)**",
    SNP == "rs1065853" ~ "(proxy for rs7412)**",
    TRUE ~ "" # Default case if none of the conditions match
  ))

# Add a label that shows the locus, rsID, and proxy info if applicable
dat_ad_10$ylbl <- with(dat_ad_10, paste(Locus, SNP, ifelse(proxy == "", "", ""), proxy))

# Scatter plot 
p1 <- ggplot(dat_ad_10, aes(x = eaf_risk, y = odds_ratio_new, size = par, color = Locus)) +
  geom_point(alpha=0.5) + facet_wrap(~ancestry) +
  #scale_x_continuous(limits = c(0, 1)) +
  scale_y_continuous(limits = c(1 ,4)) +
  geom_text_repel(aes(label = ylbl), size = 3, min.segment.length = 0, 
                  #direction = "x",
                  lineheight = 3, segment.linetype = 2, #dashed line segment
                  nudge_x = -0.04,
                  nudge_y = 0.04,
                  hjust = "left", color = "black", fontface = "italic",
                  segment.size = 0.25, max.overlaps=nrow(dat_ad_10),
                  point.padding = .2, # additional padding around each point
                  box.padding = 1 # additional padding around each text label
  ) +
  guides(fill = guide_legend(override.aes = aes(color = NA))) +
  scale_size(range = c(4, 10), name="PAR") +
  theme_bw() + theme(legend.text = element_text(face = "italic", size=12),
                     legend.title = element_text(size=14),
                     axis.text = element_text(size=12),
                     axis.title = element_text(size=14),
                     strip.text = element_text(size = 14)) +
  theme(plot.title = element_text(size = 16, face = "bold")) +
  labs(
    x = "Risk allele frequency",
    y = "Odds ratio",
    color = "Nearest gene",
    title = "Cross-ancestry comparison of population attributable risk in AD") + ylim(c(0.5,3.5))

# Add annotation for proxy labels
# Subtitle 1 plot (empty plot with subtitle text)
subtitle1 <- ggplot() +
  theme_void() +
  annotate("text", x = 0.5, y = 0.5, label = "*Derived from population summary statistics", size = 5, hjust = 0.5)

# Subtitle 2 plot (empty plot with subtitle text)
subtitle2 <- ggplot() +
  theme_void() +
  annotate("text", x = 0.5, y = 0.5, label = "**Correlated proxies to rs429358 and rs7412, and derived from population summary statistics", size = 5, hjust = 0.5)

# Combine the main plot and subtitles
combined_plot <- p1 / subtitle1 / subtitle2 + plot_layout(heights = c(1, 0.1, 0.1))

# Print the combined plot
print(combined_plot)

# Save the plot
ggsave("ad_par.jpg",
       plot = combined_plot,
       dpi = 1200)

# Visualization - PD ------------------------------------------------------
# Add label for Locus & rsID
dat_pd_10_pval$ylbl <- paste(dat_pd_10$Locus, (dat_pd_10$SNP), sep = " ")

# Scatter plot
p2 <- ggplot(dat_pd_10, aes(x = eaf_risk, y = odds_ratio_new, size = par, color = Locus)) +
  geom_point(alpha=0.5) + facet_wrap(~ancestry) +
  #scale_x_continuous(limits = c(0, 1)) +
  scale_y_continuous(limits = c(1 ,4)) +
  geom_text_repel(aes(label = ylbl), size = 3, min.segment.length = 0, 
                  #direction = "x",
                  lineheight = 3, segment.linetype = 2, #dashed line segment
                  nudge_x = -0.04,
                  nudge_y = 0.04,
                  hjust = "left", color = "black", fontface = "italic",
                  segment.size = 0.25, max.overlaps=nrow(dat_pd_10),
                  point.padding = .2, # additional padding around each point
                  box.padding = 1 # additional padding around each text label
  ) +
  guides(fill = guide_legend(override.aes = aes(color = NA))) +
  scale_size(range = c(4, 10), name="PAR") +
  theme_bw() + theme(legend.text = element_text(face = "italic", size=12),
                     legend.title = element_text(size=14),
                     axis.text = element_text(size=12),
                     axis.title = element_text(size=14),
                     strip.text = element_text(size = 14)) +
  theme(plot.title = element_text(size = 16, face = "bold")) +
  labs(
    x = "Risk allele frequency",
    y = "Odds ratio",
    color = "Nearest gene",
    title = "Cross-ancestry comparison of population attributable risk in PD") + ylim(c(0.5,3.5))

# Print the combined plot
print(p2)

# Save the plot
ggsave("pd_par.jpg",
       plot = p2,
       dpi = 1200)