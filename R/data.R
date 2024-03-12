## TODO add the rest of the datasets
## TODO add dates they were added to this package, MicrobiomeDB.org release version, etc. for provenance
## TODO consider this might be better as a single function `loadStudyData` that takes a study name and returns a MbioDataset object


#' DiabImmune
#'
#' Broad Institute's study of three pediatric cohorts that examined the microbiome in 
#' children at high risk for development of Type 1 diabetes (T1D).
#' Includes 289 children across three sites, including Russia (Karelia), Finland and Estonia.
#' There are 3184 stool samples which have amplicon sequencing data from the V4 region of 16S rRNA gene.
#' There are 1149 stool samples having 'shotgun' metagenomic sequencing data.
#' Prospective cohort design with monthly sampling for the first ~3 years of life.
#'
#' @format ## `DiabImmune`
#' A MbioDataset object with 60 metadata variables, 3184 16S stool samples and 1149 shotgun stool samples.
#' It contains the following collections: \cr
#' "16S Order" \cr                
#' "16S Genus" \cr                                           
#' "16S Family" \cr                                        
#' "16S Species" \cr                                          
#' "16S Class" \cr                                         
#' "16S Phylum" \cr                                           
#' "16S Kingdom" \cr                                          
#' "WGS 4th level EC metagenome abundance data" \cr         
#' "WGS Metagenome enzyme pathway abundance data" \cr          
#' "WGS Metagenome enzyme pathway coverage data"  \cr        
#' "WGS Genus" \cr        
#' "WGS Species" \cr                                           
#' "WGS Family" \cr                                         
#' "WGS Order" \cr                                          
#' "WGS Phylum" \cr                                           
#' "WGS Class"  \cr                                          
#' "WGS Kingdom"  \cr                                          
#' "WGS Normalized number of taxon-specific sequence matches" \cr
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_a2f8877e68/new/download>
"DiabImmune"

#' FARMM
#'
#' The Food and Resulting Microbial Metabolites (FARMM) study set out to define the impact of defined diets on the microbiome and metabolome.
#' Follows 31 healthy human adult volunteers monitored longitudinaly over a 15 day period.
#' Includes 454 stool samples and sequencing controls; 'shotgun' metagenomic sequencing.
#'
#' @format ## `FARMM`
#' A MbioDataset object with 17 metadata variables, 454 shotgun stool assays and 150 mass spec assays.
#' It contains the following collections: \cr
#' "Metabolomics Mass spectrometry assay"                    
#' "WGS 4th level EC metagenome abundance data" \cr         
#' "WGS Metagenome enzyme pathway abundance data" \cr          
#' "WGS Metagenome enzyme pathway coverage data"  \cr        
#' "WGS Genus" \cr        
#' "WGS Species" \cr                                           
#' "WGS Family" \cr                                         
#' "WGS Order" \cr                                          
#' "WGS Phylum" \cr                                           
#' "WGS Class"  \cr                                          
#' "WGS Kingdom"  \cr                                          
#' "WGS Normalized number of taxon-specific sequence matches" \cr
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_4dfda49064/new/download>
"FARMM"

#' Bangladesh 5yr
#'
#' This study set out to define the normal maturation of the gut microbiome during the first 5 years of postnatal life.
#'55 members of a birth cohort with consistently healthy anthropometric scores living within the Mirpur district of Dhaka, Bangladesh.
#' 2415 stool samples; V4 region of 16S rRNA gene.
#' Prospective cohort design with monthly sampling for the first ~5 years of life.
#'
#' @format ## `Bangladesh`
#' A MbioDataset object with 14 metadata variables, 2145 16S stool samples.
#' It contains the following collections: \cr
#' "16S Order" \cr                
#' "16S Genus" \cr                                           
#' "16S Family" \cr                                        
#' "16S Species" \cr                                          
#' "16S Class" \cr                                         
#' "16S Phylum" \cr                                           
#' "16S Kingdom" \cr 
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_1102462e80/new/download>
"Bangladesh"

#' HMP Phase 1 WGS
#'
#' The Human Microbiome Project (HMP) profiled microbial communities across diverse habitats on the human body.
#' 103 healthly adult volunteers sampled at up to 20 different body sites.
#' 741 samples of various types, including stool, saliva, and oral, vaginal and nasal swabs; 'shotgun' metagenomic sequencing.
#'
#' @format ## `HMP_WGS`
#' A MbioDataset object with 14 metadata variables, 2145 WGS stool samples.
#' It contains the following collections: \cr
#' "WGS 4th level EC metagenome abundance data" \cr         
#' "WGS Metagenome enzyme pathway abundance data" \cr          
#' "WGS Metagenome enzyme pathway coverage data"  \cr        
#' "WGS Genus" \cr        
#' "WGS Species" \cr                                           
#' "WGS Family" \cr                                         
#' "WGS Order" \cr                                          
#' "WGS Phylum" \cr                                           
#' "WGS Class"  \cr                                          
#' "WGS Kingdom"  \cr                                          
#' "WGS Normalized number of taxon-specific sequence matches" \cr
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_898df5869d/new/download>
"HMP_WGS"

#' BONUS-CF
#'
#' The Baby Observational and Nutrition Study (BONUS) set out to identify microbial correlates of poor growth observed in infants with cystic fibrosis (CF)
#' 207 infants diagnosed with cystic fibrosis during newborn screening
#' Shotgun metagenomic sequencing of 122 samples collected from healthy controls, and 1157 stool samples from infants with CF collected at months 3, 4, 5, 6, 8, 10 and 12 of life
#' Longitudinal, observational, multicenter cohort study.
#'
#' @format ## `BONUS`
#' A MbioDataset object with 23 metadata variables, 1279 WGS stool samples.
#' It contains the following collections: \cr
#' "WGS 4th level EC metagenome abundance data" \cr         
#' "WGS Metagenome enzyme pathway abundance data" \cr          
#' "WGS Metagenome enzyme pathway coverage data"  \cr        
#' "WGS Genus" \cr        
#' "WGS Species" \cr                                           
#' "WGS Family" \cr                                         
#' "WGS Order" \cr                                          
#' "WGS Phylum" \cr                                           
#' "WGS Class"  \cr                                          
#' "WGS Kingdom"  \cr                                          
#' "WGS Normalized number of taxon-specific sequence matches" \cr
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_b3b3ae9838/new/download>
"BONUS"

#' NICU-NEC
#'
#' The Neonatal Intensive Care Unit, Necrotizing Enterocolitis (NICU NEC) study set out to understand microbial factors associated with NEC onset
#' 150 infants born prematurely were sampled perinatally and at high frequency during the first few weeks to months of life
#" 1118 stool samples; 'shotgun' metagenomic sequencing.
#' Prospective cohort design.
#'
#' @format ## `NICU_NEC`
#' A MbioDataset object with 46 metadata variables, 1118 WGS stool samples.
#' It contains the following collections: \cr
#' "WGS 4th level EC metagenome abundance data" \cr         
#' "WGS Metagenome enzyme pathway abundance data" \cr          
#' "WGS Metagenome enzyme pathway coverage data"  \cr        
#' "WGS Genus" \cr        
#' "WGS Species" \cr                                           
#' "WGS Family" \cr                                         
#' "WGS Order" \cr                                          
#' "WGS Phylum" \cr                                           
#' "WGS Class"  \cr                                          
#' "WGS Kingdom"  \cr                                          
#' "WGS Normalized number of taxon-specific sequence matches" \cr
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_84fcb69f4e/new/download>
"NICU_NEC"