# Libraries
library(plyr)
library(tidyverse)
library(viridis)
library(dplyr)
library(ggrepel)
library(patchwork)
library(ggtext)

# Import most recent data
dat_ad = read_csv('{WORK_DIR}/PAR/AD/results/{AD_filename_here}')
dat_pd_pval = read_csv('{WORK_DIR}/PAR/PD/results/{PD_filename_here}')

# Top 20 for each ancestry
dat_ad_10 <- ddply(dat_ad, "ancestry", function (x) head(x[order(x$par, decreasing = TRUE) , ], 10))
dat_pd_10_pval <- ddply(dat_pd_pval, "ancestry", function (x) head(x[order(x$par, decreasing = TRUE) , ], 10))

# Add notation for APOE rs7412 proxy in Europeans
dat_ad_10 <- dat_ad_10 %>%
  mutate(proxy = case_when(
    SNP %in% c("rs7412") ~ "", 
    SNP == "rs1065853" ~ "(proxy for rs7412)**",
    TRUE ~ "" 
  ))

# Prepare labels
dat_ad_10$ylbl <- with(dat_ad_10, paste(Locus, SNP, ifelse(proxy == "", "", ""), proxy))

# AD bubble plot
p1 <- ggplot(dat_ad_10, aes(x = eaf_risk, y = odds_ratio_new, size = par, color = Locus)) +
  geom_point(alpha=0.5) + facet_wrap(~ancestry) +
  scale_y_continuous(limits = c(1 ,4)) +
  geom_text_repel(aes(label = ylbl), size = 3, min.segment.length = 0, 
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

# Add subtitles
subtitle1 <- ggplot() +
  theme_void() +
  annotate("text", x = 0.5, y = 0.5, label = "*Derived from population summary statistics", size = 5, hjust = 0.5)

subtitle2 <- ggplot() +
  theme_void() +
  annotate("text", x = 0.5, y = 0.5, label = "**Correlated proxy to rs7412, and derived from population summary statistics", size = 5, hjust = 0.5)

# Combine the main plot and subtitles
combined_plot <- p1 / subtitle1 / subtitle2 + plot_layout(heights = c(1, 0.1, 0.1))

# Print the combined plot
print(combined_plot)

# Save plot
ggsave("{WORK_DIR}/AD_PAR_plot.tiff", plot = combined_plot, dpi = 300)

# PD bubble plot
dat_pd_10_pval$ylbl <- paste(dat_pd_10_pval$Locus, (dat_pd_10_pval$SNP), sep = " ")
p3 <- ggplot(dat_pd_10_pval, aes(x = eaf_risk, y = odds_ratio_new, size = par, color = Locus)) +
  geom_point(alpha=0.5) + facet_wrap(~ancestry) +
  scale_y_continuous(limits = c(1 ,4)) +
  geom_text_repel(aes(label = ylbl), size = 3, min.segment.length = 0, 
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
    title = "Cross-ancestry comparison of population attributable risk in PD") + ylim(c(0.5,3.5))
ggsave("{WORK_DIR}/PD_PAR_plot.tiff", plot = p3, dpi = 300)