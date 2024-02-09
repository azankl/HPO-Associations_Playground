#find number of HPO terms for each OMIM disorder
library(readr)
library(dplyr)

#read HPOA tsv file
hpoa <- read_tsv("HPOA 2023-10-09.tsv", col_names = TRUE, skip = 4)

#keep only rows where database_id starts with OMIM
hpoa <- hpoa %>% filter(grepl("^OMIM", database_id))

#group by database_id and count, sort ascending by count #only keep count < 3
hpoa_count <- hpoa %>%
  group_by(database_id) %>%
  count() %>%
  #filter(n < 3) %>%
  arrange(n)

#use this for all OMIM disorders (not just Skeletal Dysplasias)
#read mondo_omim_table from /Users/azankl/Github/R_Projects/MONDO-OIMIM-Mapping/mondo_omim_table.tsv
#mondo_omim_table <- read_tsv("/Users/azankl/Github/R_Projects/MONDO-OIMIM-Mapping/mondo_omim_table.tsv", col_names = TRUE)

#use this for only Skeletal Dysplasias
#read mondo_omim_skeldys_table from /Users/azankl/Github/R_Projects/MONDO-OIMIM-Mapping/mondo_omim_table.tsv
mondo_omim_table <- read_tsv("/Users/azankl/Github/R_Projects/MONDO-OIMIM-Mapping/mondo_omim_skeldys_table.tsv", col_names = TRUE)

#merge Ontology and Term column into new column, separated by :
mondo_omim_table$Ontology_Term <- paste(mondo_omim_table$Ontology, mondo_omim_table$Term, sep = ":")
#remove Ontology and Term column
mondo_omim_table <- mondo_omim_table %>% select(-Ontology, -Term)
#rename Ontology_Term to OMIM
mondo_omim_table <- mondo_omim_table %>% rename(OMIM = Ontology_Term)

#join mondo_omim_table and hpoa_count on database_id
mondo_omim_table <- mondo_omim_table %>% left_join(hpoa_count, by = c("OMIM" = "database_id"))
#sort descending by n
mondo_omim_table <- mondo_omim_table %>% arrange(n)

