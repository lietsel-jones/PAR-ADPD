# Overview ---------------------------------------------------------------
# Data Visualization for Known Variants Across Populations
  # Project: Cross-ancestry PAR analysis
  # Version: R/4.0
  # Last Updated: 05-JUN-2024

# Libraries ---------------------------------------------------------------
library(tidyverse)
library(viridis)
library(dplyr)
library(ggrepel)
library(patchwork)
library(ggtext)

# Import most recent data -------------------------------------------------
# Define the paths to the AD results folder, PD results folder, and PD known_variants folder
ad_results_folder <- "{WORK_DIR}/AD/results/" 
pd_results_folder <- "{WORK_DIR}/PD/results/"  
known_variants_folder <- "{WORK_DIR}/PD/known_variants/"

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

# Read the most recent CSV from the AD results folder ending with 'AD_PAR_results'
dat_ad <- read_most_recent_csv(ad_results_folder, "AD_PAR_results")
if (!is.null(dat_ad)) {
  ad_df <- dat_ad$data
  print(paste("Most recent AD file read:", dat_ad$file))
} else {
  print("No matching CSV files found in AD results folder.")
}

# Read the most recent CSV from the PD results folder ending with 'PD_PAR_results'
dat_pd <- read_most_recent_csv(pd_results_folder, "PD_PAR_results")
if (!is.null(dat_pd)) {
  pd_df <- pd_result$data
  print(paste("Most recent PD file read:", dat_pd$file))
} else {
  print("No matching CSV files found in PD results folder.")
}

# Read the most recent CSV from the known_variants folder ending with '_PD_PAR_lrrk2_gba1'
dat_known_variants <- read_most_recent_csv(known_variants_folder, "_PD_PAR_lrrk2_gba1")
if (!is.null(dat_known_variants)) {
  known_variants_df <- dat_known_variants$data
  print(paste("Most recent known variants file read:", dat_known_variants$file))
} else {
  print("No matching CSV files found in known_variants folder.")
}

# Subset and rename columns -----------------------------------------------
# APOE
df_apoe = subset(ad_df, Locus == 'APOE')
# LRRK2
df_lrrk2 = subset(pd_df, Locus == 'LRRK2')
df_lrrk2 = df_lrrk2 %>% mutate(aa_change = ifelse(SNP == "rs34637584", "G2019S", ""))
df2_lrrk2 = subset(known_variants_df, Locus == 'LRRK2') %>% rename(aa_change = `Protein change`)
new_lrrk2 <- rbind(df_lrrk2, df2_lrrk2) %>% distinct()
# GBA1
df_gba = subset(pd_df, Locus == 'GBA1' | Locus == 'GBAP1')
df_gba = df_gba %>% mutate(across('Locus', str_replace, 'GBAP1', 'GBA1'))
df_gba = df_gba %>% mutate(aa_change = ifelse(SNP == "rs76763715", "N370S", ""))
df2_gba = subset(known_variants_df, Locus == 'GBA1') %>% rename(aa_change = `Protein change`)
new_gba <- rbind(df_gba, df2_gba) #%>% distinct()

# Visualization -----------------------------------------------------------
# Bubble chart - APOE
df_apoe$ylbl <- paste(df_apoe$Locus, (df_apoe$SNP), sep = " ")
g1 = ggplot(df_apoe, aes(x = eaf_risk, y = odds_ratio_new, size = par, color = ancestry)) +
  geom_point(alpha=0.5) +
  scale_x_continuous(limits = c(0, 1)) +
  scale_y_continuous(limits = c(1 ,4)) +
  geom_text_repel(aes(label = ylbl), size = 3, min.segment.length = 0, 
                  #direction = "x",
                  lineheight = 3, segment.linetype = 2, #dashed line segment
                  nudge_x = -0.04,
                  nudge_y = 0.04,
                  hjust = "left", color = "black", fontface = "italic",
                  segment.size = 0.25, max.overlaps=nrow(df_apoe),
                  point.padding = .2, # additional padding around each point
                  box.padding = 1 # additional padding around each text label
  ) +  guides(fill = guide_legend(override.aes = aes(color = NA))) +
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
    color = "Ancestry",
    title = "Population attributable risk for known disease variants",
    subtitle = "APOE") + theme(plot.subtitle = element_text(face = "italic"))

# Bubble chart - LRRK2
#df_lrrk2$ylbl <- paste(df_lrrk2$Locus, (df_lrrk2$SNP), (df_lrrk2$aa_change), sep = ", ")
new_lrrk2$ylbl <- with(new_lrrk2, paste(Locus, SNP, ifelse(aa_change == "", "", ", "), aa_change))

g2 = ggplot(new_lrrk2, aes(x = eaf_risk, y = odds_ratio_new, size = par, color = ancestry)) +
  geom_point(alpha=0.5) +
  scale_x_continuous(limits = c(0, 1)) +
  #scale_y_continuous(limits = c(3 ,9)) +
  geom_text_repel(aes(label = ylbl), size = 3, min.segment.length = 0, 
                  #direction = "x",
                  lineheight = 3, segment.linetype = 2, #dashed line segment
                  nudge_x = -0.04,
                  nudge_y = 0.04,
                  hjust = "left", color = "black", fontface = "italic",
                  segment.size = 0.25, max.overlaps=nrow(new_lrrk2),
                  point.padding = .2, # additional padding around each point
                  box.padding = 1 # additional padding around each text label
  ) +  guides(fill = guide_legend(override.aes = aes(color = NA))) +
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
    color = "Ancestry",
    #title = "LRRK2 variants",
    subtitle = "LRRK2") + theme(plot.subtitle = element_text(face = "italic"))

# Bubble chart - GBA1
#new_gba$ylbl <- paste(new_gba$Locus, (new_gba$SNP), (new_gba$aa_change), sep = ", ")
new_gba$ylbl <- with(new_gba, paste(Locus, SNP, ifelse(aa_change == "", "", ", "), aa_change))
g3 = ggplot(new_gba, aes(x = eaf_risk, y = odds_ratio_new, size = par, color = ancestry)) +
  geom_point(alpha=0.5) +
  scale_x_continuous(limits = c(0, 1)) +
  scale_y_continuous(limits = c(1 ,3)) +
  geom_text_repel(aes(label = ylbl), size = 3, min.segment.length = 0, 
                  #direction = "x",
                  lineheight = 3, segment.linetype = 2, #dashed line segment
                  nudge_x = -0.04,
                  nudge_y = 0.04,
                  hjust = "left", color = "black", fontface = "italic",
                  segment.size = 0.25, max.overlaps=nrow(new_gba),
                  point.padding = .2, # additional padding around each point
                  box.padding = 1 # additional padding around each text label
  ) +  guides(fill = guide_legend(override.aes = aes(color = NA))) +
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
    color = "Ancestry",
    #title = "GBA1 variants",
    subtitle = "GBA1") + theme(plot.subtitle = element_text(face = "italic"))

# Use patchwork to create plot with APOE, LRRK2, GBA1 subplots
p <- g1 / g2 / g3

# Print the combined plot
print(p)

# Save the plot
ggsave("known_variants_par.jpg",
       plot = p)