library(tidyverse)

subInfo <- readxl::read_xlsx("all_beh_641.xlsx") %>%
  as_tibble()
subInfo

meaInfo <- read.csv("MergedTrackMeasure.csv") %>%
  as_tibble() %>%
  mutate(MRINumber = gsub("\\D*", "", SUBID)) %>%
  mutate(MRINumber = paste("BNU", MRINumber, sep = '')) %>%
  select(-c(StdIntensity, NumVoxel)) %>%
  filter(ROI == 16) %>%
  pivot_wider(names_from = c(Measure, ROI), values_from = MeanIntensity) %>%
  select(-SUBID)
meaInfo

subInfo %>%
  left_join(., meaInfo, by = "MRINumber") %>%
  writexl::write_xlsx(., "SubInfoMergedTrackMeasure_roi16.xlsx")

