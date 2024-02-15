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