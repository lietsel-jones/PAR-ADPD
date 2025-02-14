# Libraries
library(tidyverse)
library(viridis)
library(dplyr)
library(ggrepel)
library(patchwork)
library(ggtext)

# Import data
dat_ad = read_csv('{{WORK_DIR}/PAR/PD/notebooks/AD_PAR_results.csv')
dat_pd = read_csv('{WORK_DIR}/PAR/PD/notebooks/20240614_PD_PAR_results.csv')
dat_pd2 = read_csv('{WORK_DIR}/PAR/PD/notebooks/PD_PAR_lrrk2_gba1.csv')

df_apoe = subset(dat_ad, Locus == 'APOE')
df_lrrk2 = subset(dat_pd, Locus == 'LRRK2')
df_lrrk2 = df_lrrk2 %>% mutate(aa_change = ifelse(SNP == "rs34637584", "G2019S", ""))

df2_lrrk2 = subset(dat_pd2, Locus == 'LRRK2') %>% rename(aa_change = `Protein change`)
new_lrrk2 <- rbind(df_lrrk2, df2_lrrk2) %>% distinct()

df_gba = subset(dat_pd, Locus == 'GBA1' | Locus == 'GBAP1')
df_gba = df_gba %>% mutate(across('Locus', str_replace, 'GBAP1', 'GBA1'))
df_gba = df_gba %>% mutate(aa_change = ifelse(SNP == "rs76763715", "N370S", ""))

df2_gba = subset(dat_pd2, Locus == 'GBA1') %>% rename(aa_change = `Protein change`)
new_gba <- rbind(df_gba, df2_gba) 

# Combine into one dataframe and plot
df_all <- bind_rows(df_apoe, new_lrrk2, new_gba)
df_all$aa_change <- ifelse(is.na(df_all$aa_change), "", df_all$aa_change)
df_all$ylbl <- with(df_all, paste(Locus, SNP, ifelse(aa_change == "", "", ", "), aa_change))
p1 = ggplot(df_all, aes(x = eaf_risk, y = odds_ratio_new, size = par, color = ancestry)) +
  facet_wrap(~Locus, nrow = 3, ncol = 1) +
  geom_point(alpha=0.5) + 
  scale_x_continuous(limits = c(0, 1)) +
  geom_text_repel(aes(label = ylbl), size = 3, min.segment.length = 0, 
                  direction = "y",
                  lineheight = 5, segment.linetype = 2, #dashed line segment
                  nudge_x = 0.02,
                  nudge_y = 0.04,
                  hjust = "left", color = "black", fontface = "italic",
                  segment.size = 0.25, max.overlaps=nrow(df_all),
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
    title = "Population attributable risk for major genetic risk factors")
p1
ggsave("major_carrieris.tiff", plot = p1, dpi = 300, device = "tiff")