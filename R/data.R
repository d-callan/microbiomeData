#' Get Curated Data Set Names
#' 
#' Returns a vector of curated data set names from the 'microbiomeData' package. 
#' These data are the same from the MicrobiomeDB.org website and can be 
#' analyzed with the 'MicrobiomeDB' R package.
#' @return A vector of curated data set names
#' @export
getCuratedDatasetNames <- function() {
    return(data(package="microbiomeData")$results[, "Item"])
}

#' DiabImmune
#'
#' Broad Institute's study of three pediatric cohorts that examined the microbiome in 
#' children at high risk for development of Type 1 diabetes (T1D).
#' Includes 289 children across three sites, including Russia (Karelia), Finland and Estonia.
#' There are 3184 stool samples which have amplicon sequencing data from the V4 region of 16S rRNA gene.
#' There are 1149 stool samples having 'shotgun' metagenomic sequencing data.
#' Prospective cohort design with monthly sampling for the first ~3 years of life.
#
#' Website Release 32. (2023 May 30)
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
#' "Shotgun metagenomics: 4th level EC metagenome abundance data" \cr         
#' "Shotgun metagenomics: Metagenome enzyme pathway abundance data" \cr          
#' "Shotgun metagenomics: Metagenome enzyme pathway coverage data"  \cr        
#' "Shotgun metagenomics: Genus" \cr        
#' "Shotgun metagenomics: Species" \cr                                           
#' "Shotgun metagenomics: Family" \cr                                         
#' "Shotgun metagenomics: Order" \cr                                          
#' "Shotgun metagenomics: Phylum" \cr                                           
#' "Shotgun metagenomics: Class"  \cr                                          
#' "Shotgun metagenomics: Kingdom"  \cr                                          
#' "Shotgun metagenomics: Normalized number of taxon-specific sequence matches" \cr
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_a2f8877e68/new/download>
#' @name DiabImmune
"DiabImmune"

#' FARMM
#'
#' The Food and Resulting Microbial Metabolites (FARMM) study set out to define the impact of defined diets on the microbiome and metabolome.
#' Follows 31 healthy human adult volunteers monitored longitudinally over a 15 day period.
#' Includes 454 stool samples and sequencing controls; 'shotgun' metagenomic sequencing.
#'
#' Website Release 32. (2023 May 30)
#' 
#' @format ## `FARMM`
#' A MbioDataset object with 17 metadata variables, 454 shotgun stool assays and 150 mass spec assays.
#' It contains the following collections: \cr
#' "Metabolomics Mass spectrometry assay"                    
#' "Shotgun metagenomics: 4th level EC metagenome abundance data" \cr         
#' "Shotgun metagenomics: Metagenome enzyme pathway abundance data" \cr          
#' "Shotgun metagenomics: Metagenome enzyme pathway coverage data"  \cr        
#' "Shotgun metagenomics: Genus" \cr        
#' "Shotgun metagenomics: Species" \cr                                           
#' "Shotgun metagenomics: Family" \cr                                         
#' "Shotgun metagenomics: Order" \cr                                          
#' "Shotgun metagenomics: Phylum" \cr                                           
#' "Shotgun metagenomics: Class"  \cr                                          
#' "Shotgun metagenomics: Kingdom"  \cr                                          
#' "Shotgun metagenomics: Normalized number of taxon-specific sequence matches" \cr
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_4dfda49064/new/download>
#' @name FARMM
"FARMM"

#' Bangladesh 5yr
#'
#' This study set out to define the normal maturation of the gut microbiome during the first 5 years of postnatal life.
#'55 members of a birth cohort with consistently healthy anthropometric scores living within the Mirpur district of Dhaka, Bangladesh.
#' 2415 stool samples; V4 region of 16S rRNA gene.
#' Prospective cohort design with monthly sampling for the first ~5 years of life.
#'
#' Website Release 32. (2023 May 30)
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
#' @name Bangladesh
"Bangladesh"

#' HMP Phase 1 Shotgun Metagenomics
#'
#' The Human Microbiome Project (HMP) profiled microbial communities across diverse habitats on the human body.
#' 103 healthly adult volunteers sampled at up to 20 different body sites.
#' 741 samples of various types, including stool, saliva, and oral, vaginal and nasal swabs; 'shotgun' metagenomic sequencing.
#' 
#' Website Release 32. (2023 May 30)
#'
#' @format ## `HMP_MGX`
#' A MbioDataset object with 14 metadata variables, 2145 shotgun metagenomic stool samples.
#' It contains the following collections: \cr
#' "Shotgun metagenomics: 4th level EC metagenome abundance data" \cr         
#' "Shotgun metagenomics: Metagenome enzyme pathway abundance data" \cr          
#' "Shotgun metagenomics: Metagenome enzyme pathway coverage data"  \cr        
#' "Shotgun metagenomics: Genus" \cr        
#' "Shotgun metagenomics: Species" \cr                                           
#' "Shotgun metagenomics: Family" \cr                                         
#' "Shotgun metagenomics: Order" \cr                                          
#' "Shotgun metagenomics: Phylum" \cr                                           
#' "Shotgun metagenomics: Class"  \cr                                          
#' "Shotgun metagenomics: Kingdom"  \cr                                          
#' "Shotgun metagenomics: Normalized number of taxon-specific sequence matches" \cr
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_898df5869d/new/download>
#' @name HMP_MGX
"HMP_MGX"

#' BONUS-CF
#'
#' The Baby Observational and Nutrition Study (BONUS) set out to identify microbial correlates of poor growth observed in infants with cystic fibrosis (CF)
#' 207 infants diagnosed with cystic fibrosis during newborn screening
#' Shotgun metagenomic sequencing of 122 samples collected from healthy controls, and 1157 stool samples from infants with CF collected at months 3, 4, 5, 6, 8, 10 and 12 of life
#' Longitudinal, observational, multicenter cohort study.
#' 
#' Website Release 32. (2023 May 30)
#'
#' @format ## `BONUS`
#' A MbioDataset object with 23 metadata variables, 1279 shotgun metagenomic stool samples.
#' It contains the following collections: \cr
#' "Shotgun metagenomics: 4th level EC metagenome abundance data" \cr         
#' "Shotgun metagenomics: Metagenome enzyme pathway abundance data" \cr          
#' "Shotgun metagenomics: Metagenome enzyme pathway coverage data"  \cr        
#' "Shotgun metagenomics: Genus" \cr        
#' "Shotgun metagenomics: Species" \cr                                           
#' "Shotgun metagenomics: Family" \cr                                         
#' "Shotgun metagenomics: Order" \cr                                          
#' "Shotgun metagenomics: Phylum" \cr                                           
#' "Shotgun metagenomics: Class"  \cr                                          
#' "Shotgun metagenomics: Kingdom"  \cr                                          
#' "Shotgun metagenomics: Normalized number of taxon-specific sequence matches" \cr
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_b3b3ae9838/new/download>
#' @name BONUS
"BONUS"

#' NICU-NEC
#'
#' The Neonatal Intensive Care Unit, Necrotizing Enterocolitis (NICU NEC) study set out to understand microbial factors associated with NEC onset
#' 150 infants born prematurely were sampled perinatally and at high frequency during the first few weeks to months of life
#" 1118 stool samples; 'shotgun' metagenomic sequencing.
#' Prospective cohort design.
#' 
#' Website Release 32. (2023 May 30)
#'
#' @format ## `NICU_NEC`
#' A MbioDataset object with 46 metadata variables, 1118 shotgun metagenomic stool samples.
#' It contains the following collections: \cr
#' "Shotgun metagenomics: 4th level EC metagenome abundance data" \cr         
#' "Shotgun metagenomics: Metagenome enzyme pathway abundance data" \cr          
#' "Shotgun metagenomics: Metagenome enzyme pathway coverage data"  \cr        
#' "Shotgun metagenomics: Genus" \cr        
#' "Shotgun metagenomics: Species" \cr                                           
#' "Shotgun metagenomics: Family" \cr                                         
#' "Shotgun metagenomics: Order" \cr                                          
#' "Shotgun metagenomics: Phylum" \cr                                           
#' "Shotgun metagenomics: Class"  \cr                                          
#' "Shotgun metagenomics: Kingdom"  \cr                                          
#' "Shotgun metagenomics: Normalized number of taxon-specific sequence matches" \cr
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_84fcb69f4e/new/download>
#' @name NICU_NEC
"NICU_NEC"

#' GEMS1 Case Control
#'
#' The Global Enteric Multicenter Study (GEMS) investigated the cause, incidence and impact of 
#' moderate to severe diarrheal (MSD) disease in children. 514 MSD cases and 493 endemic controls from Bangladesh, 
#' The Gambia, Kenya and Mali were included. 1007 stool samples; V1-V2 region of 16S rRNA gene. 
#' Prospective, age-stratified, matched case-control design. Additional clinical and epidemiologic 
#' data for the same participants is available at ClinEpiDB.org.
#' 
#' Website Release 32. (2023 May 30)
#'
#' @format ## `GEMS1`
#' A MbioDataset object with 12 metadata variables, 1015 16S stool samples.
#' It contains the following collections: \cr
#' "16S Order" \cr                
#' "16S Genus" \cr                                           
#' "16S Family" \cr                                        
#' "16S Species" \cr                                          
#' "16S Class" \cr                                         
#' "16S Phylum" \cr                                           
#' "16S Kingdom" \cr 
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_a5167b81e3/new/download>
#' @name GEMS1
"GEMS1"

#' DailyBaby
#'
#' Near daily fecal specimens collected from term infants during the first year of life.
#' 12 healthy term infants born in Oslo, Norway.
#' 2684 stool samples total, with an average of 224 samples (range 116–267) per infant.
#' Prospective cohort design.
#' 
#' Website Release 32. (2023 May 30)
#'
#' @format ## `DailyBaby`
#' A MbioDataset object with 17 metadata variables, 2684 16S stool samples.
#' It contains the following collections: \cr
#' "16S Order" \cr                
#' "16S Genus" \cr                                           
#' "16S Family" \cr                                        
#' "16S Species" \cr                                          
#' "16S Class" \cr                                         
#' "16S Phylum" \cr                                           
#' "16S Kingdom" \cr 
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_5a4f8a1791/new/download>
#' @name DailyBaby
"DailyBaby"

#' Anopheles albimanus
#'
#' This study assessed the impact of pyrethroid exposure on the internal and cuticle microbiome of Anopheles albimanusi.
#' 125 samples, each pool of 3 mosquitos. V3-V4 region of 16S rRNA gene.
#' Adult and larval Anopheles albimanus collected in and around Las Cruces, Guatemala.
#' 
#' Website Release 32. (2023 May 30)
#'
#' @format ## `Anopheles_albimanus`
#' A MbioDataset object with 12 metadata variables, 125 16S samples.
#' It contains the following collections: \cr
#' "16S Order" \cr                
#' "16S Genus" \cr                                           
#' "16S Family" \cr                                        
#' "16S Species" \cr                                          
#' "16S Class" \cr                                         
#' "16S Phylum" \cr                                           
#' "16S Kingdom" \cr 
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_36cb9bab56/new/download>
#' @name Anopheles_albimanus
"Anopheles_albimanus"

#' ECAM
#' 
#' The Early Childhood Antibiotics and the Microbiome (ECAM) study set out to identify the impact of antibiotics, 
#' delivery mode and diet on the infant gut Microbiome. Prospective cohort design in healthy humans from USA.
#' 43 infants sampled during the first two years of life. 1216 samples of various types; V4 region of 16S rRNA gene.
#' 
#' Website Release 32. (2023 May 30)
#'
#' @format ## `ECAM`
#' A MbioDataset object with 27 metadata variables, 1216 16S samples.
#' It contains the following collections: \cr
#' "16S Order" \cr                
#' "16S Genus" \cr                                           
#' "16S Family" \cr                                        
#' "16S Species" \cr                                          
#' "16S Class" \cr                                         
#' "16S Phylum" \cr                                           
#' "16S Kingdom" \cr 
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_accd1b80f6/new/download>
#' @name ECAM
"ECAM"

#' Eco-CF
#' 
#' The Ecology of Cystic Fibrosis (Eco-CF) study profiled the microbiome in pediatric CF patients.
#' 169 pediatric cystic fibrosis patients seen over a four year period at Columbia Univeristy Medical Center in NYC, USA.
#' 844 samples, including sputum, oral swabs and bronchoalveolar lavage (BAL) fluid; V4 region of 16S rRNA gene.
#' Prospective cohort design.
#' 
#' Website Release 32. (2023 May 30)
#'
#' @format ## `EcoCF`
#' A MbioDataset object with 77 metadata variables, 844 16S samples.
#' It contains the following collections: \cr
#' "16S Order" \cr                
#' "16S Genus" \cr                                           
#' "16S Family" \cr                                        
#' "16S Species" \cr                                          
#' "16S Class" \cr                                         
#' "16S Phylum" \cr                                           
#' "16S Kingdom" \cr 
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_5a4f8a1791/new/download>
#' @name EcoCF
"EcoCF"

#' HMP Phase 1 (V1-V3)
#' 
#' The Human Microbiome Project (HMP) profiled microbial communities across diverse habitats on the human body.
#' 242 healthly adult volunteers sampled at approximately 15 different body sites.
#' 3156 samples of various types; V1-V3 region of 16S rRNA gene.
#' 
#' Website Release 32. (2023 May 30)
#'
#' @format ## `HMP_V1V3`
#' A MbioDataset object with 11 metadata variables, 3045 16S samples.
#' It contains the following collections: \cr
#' "16S Order" \cr                
#' "16S Genus" \cr                                           
#' "16S Family" \cr                                        
#' "16S Species" \cr                                          
#' "16S Class" \cr                                         
#' "16S Phylum" \cr                                           
#' "16S Kingdom" \cr 
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_570856e10e/new/download>
#' @name HMP_V1V3
"HMP_V1V3"

#' HMP Phase 1 (V3-V5)
#' 
#' The Human Microbiome Project (HMP) profiled microbial communities across diverse habitats on the human body.
#' 242 healthly adult volunteers sampled at approximately 15 different body sites.
#' 5826 samples of various types; V3-V5 region of 16S rRNA gene.
#' 
#' Website Release 32. (2023 May 30)
#'
#' @format ## `HMP_V3V5`
#' A MbioDataset object with 13 metadata variables, 5462 16S samples.
#' It contains the following collections: \cr
#' "16S Order" \cr                
#' "16S Genus" \cr                                           
#' "16S Family" \cr                                        
#' "16S Species" \cr                                          
#' "16S Class" \cr                                         
#' "16S Phylum" \cr                                           
#' "16S Kingdom" \cr 
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_ca4404e155/new/download>
#' @name HMP_V3V5
"HMP_V3V5"

#' Human cutaneous leishmaniasis
#' 
#' This study explored the skin microbiome during human cutaneous leishmaniasis.
#' 45 patients with cutaneous leishmaniasis.
#' 128 skin swabs collected from affected and unaffected skin; V1-V3 region of 16S rRNA gene.
#' Case-control (restrospective) design in patients seen at a field hospital 
#' (Clinica em Leishmaniose Dr. Jackson Costa) in Corte de Pedra, Bahia, Brazil.
#' 
#' Website Release 32. (2023 May 30)
#'
#' @format ## `Leishmaniasis`
#' A MbioDataset object with 16 metadata variables, 128 16S samples.
#' It contains the following collections: \cr
#' "16S Order" \cr                
#' "16S Genus" \cr                                           
#' "16S Family" \cr                                        
#' "16S Species" \cr                                          
#' "16S Class" \cr                                         
#' "16S Phylum" \cr                                           
#' "16S Kingdom" \cr 
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_75221fce95/new/download>
#' @name Leishmaniasis
"Leishmaniasis"

#' MAL-ED 0-2yr
#' 
#' This study set out to define the normal maturation of the gut microbiome during the first 2 years of postnatal life.
#' 50 children from four sites in the MAL-ED study: Brazil, India, Peru and South Africa.
#' 1091 stool samples; V4 region of 16S rRNA gene.
#' Prospective cohort design with monthly sampling for the first ~2 years of life.
#' Additional clinical and epidemiologic data for the same participants is available at ClinEpiDB.org.
#' 
#' Website Release 32. (2023 May 30)
#'
#' @format ## `MALED_2yr`
#' A MbioDataset object with 16 metadata variables, 1091 16S stool samples.
#' It contains the following collections: \cr
#' "16S Order" \cr                
#' "16S Genus" \cr                                           
#' "16S Family" \cr                                        
#' "16S Species" \cr                                          
#' "16S Class" \cr                                         
#' "16S Phylum" \cr                                           
#' "16S Kingdom" \cr 
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_72c94486c6/new/download>
#' @name MALED_2yr
"MALED_2yr"

#' MAL-ED diarrhea
#' 
#' This study set out to define the consequence of diarrhea on maturation of the gut
#'  microbiome during the first 2 years of postnatal life.
#' 271 children from the Amazonian lowlands near Iquitos, Peru
#' 928 stool samples; V4 region of 16S rRNA gene.
#' Prospective cohort design with samples obtained at postnatal months 6, 12, 18, and 24
#' Additional clinical and epidemiologic data for the same participants is available at ClinEpiDB.org.
#' 
#' Website Release 32. (2023 May 30)
#'
#' @format ## `MALED_diarrhea`
#' A MbioDataset object with 36 metadata variables, 928 16S stool samples.
#' It contains the following collections: \cr
#' "16S Order" \cr                
#' "16S Genus" \cr                                           
#' "16S Family" \cr                                        
#' "16S Species" \cr                                          
#' "16S Class" \cr                                         
#' "16S Phylum" \cr                                           
#' "16S Kingdom" \cr 
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_2e56313a65/new/download>
#' @name MALED_diarrhea
"MALED_diarrhea"

#' Malaysia helminth
#' 
#' The Malaysia Helminth study profiled gut metagenomes of indigenous and 
#' non-indigenous individuals originating from 5 villages
#' 407 adult and pediatric participants from 5 villages 
#' (Bangkong, Tanjung Sepat, Rasau, Legong, and Judah), and Kuala Lumpur
#' 650 stool samples; 'shotgun' metagenomic sequencing.
#' 
#' Website Release 32. (2023 May 30)
#'
#' @format ## `Malaysia_helminth`
#' A MbioDataset object with 28 metadata variables, 650 shotgun stool samples.
#' It contains the following collections: \cr
#' "Shotgun metagenomics: 4th level EC metagenome abundance data" \cr         
#' "Shotgun metagenomics: Metagenome enzyme pathway abundance data" \cr          
#' "Shotgun metagenomics: Metagenome enzyme pathway coverage data"  \cr        
#' "Shotgun metagenomics: Genus" \cr        
#' "Shotgun metagenomics: Species" \cr                                           
#' "Shotgun metagenomics: Family" \cr                                         
#' "Shotgun metagenomics: Order" \cr                                          
#' "Shotgun metagenomics: Phylum" \cr                                           
#' "Shotgun metagenomics: Class"  \cr                                          
#' "Shotgun metagenomics: Kingdom"  \cr                                          
#' "Shotgun metagenomics: Normalized number of taxon-specific sequence matches" \cr
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_abcf1b1d90/new/download>
#' @name Malaysia_helminth
"Malaysia_helminth"

#' MORDOR phase 1
#' 
#' The Macrolides Oraux pour Réduire les Décès avec un Oeil sur la Résistance (MORDOR) I 
#' metagenome study evaluated the impact of mass azithromycin administration on the gut microbiome in children
#' 574 pediatric (preschool) participants from 30 Nigerien communities
#' Rectal swabs; 'shotgun' metagenomic sequencing of RNA.
#' 
#' Website Release 32. (2023 May 30)
#'
#' @format ## `MORDOR`
#' A MbioDataset object with 10 metadata variables, 574 shotgun stool samples.
#' It contains the following collections: \cr
#' "Shotgun metagenomics: 4th level EC metagenome abundance data" \cr         
#' "Shotgun metagenomics: Metagenome enzyme pathway abundance data" \cr          
#' "Shotgun metagenomics: Metagenomeenzyme pathway coverage data"  \cr        
#' "Shotgun metagenomics: Genus" \cr        
#' "Shotgun metagenomics: Species" \cr                                           
#' "Shotgun metagenomics: Family" \cr                                         
#' "Shotgun metagenomics: Order" \cr                                          
#' "Shotgun metagenomics: Phylum" \cr                                           
#' "Shotgun metagenomics: Class"  \cr                                          
#' "Shotgun metagenomics: Kingdom"  \cr                                          
#' "Shotgun metagenomics: Normalized number of taxon-specific sequence matches" \cr
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_39d3629e79/new/download>
#' @name MORDOR
"MORDOR"

#' PIH Uganda
#' 
#' This study profiled microbes present in the cerebrospinal fluid (CSF) of pediatric patients 
#' with infectious and non-infectious hydrocephalus. 92 children from Uganda, including 58 with 
#' postinfectious hydrocephalus (PIH) and 34 with non-postinfectious hydrocephalus (NPIH).
#' 92 cerebrospinal fluid (CSF) samples retained in this workflow; V1-V2 region of 16S rRNA gene.
#' Case-control (retrospective) design with samples collected in the first ~100 days of life.
#' 
#' Website Release 32. (2023 May 30)
#'
#' @format ## `PIH_Uganda`
#' A MbioDataset object with 11 metadata variables, 92 CSF samples.
#' It contains the following collections: \cr
#' "16S Order" \cr                
#' "16S Genus" \cr                                           
#' "16S Family" \cr                                        
#' "16S Species" \cr                                          
#' "16S Class" \cr                                         
#' "16S Phylum" \cr                                           
#' "16S Kingdom" \cr 
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_d00b1afb83/new/download>
#' @name PIH_Uganda
"PIH_Uganda"

#' Preterm Infant Resistome 1
#' 
#' The Preterm Infant Resistome I study used 16S rRNA marker gene sequencing and shotgun 
#' metagenomics to profile the stool metagenome in preterm infants (born < 33 weeks gestational age) 
#' stratified by antibiotic use during their hospitalization.
#' 84 preterm infant patients seen at the Washington University School of Medicine in St. Louis, MO, USA.
#' 399 stool samples; 'shotgun' metagenomic sequencing.
#' 103/399 stool samples; V4 16S rRNA gene sequencing.
#' Prospective cohort design.
#' 
#' Website Release 32. (2023 May 30)
#'
#' @format ## `PretermInfantResistome1`
#' A MbioDataset object with 64 metadata variables, 399 shotgun stool samples, 103 16S stool samples.
#' It contains the following collections: \cr
#' "Shotgun metagenomics: 4th level EC metagenome abundance data" \cr         
#' "Shotgun metagenomics: Metagenomeenzyme pathway abundance data" \cr          
#' "Shotgun metagenomics: Metagenomeenzyme pathway coverage data"  \cr        
#' "Shotgun metagenomics: Genus" \cr        
#' "Shotgun metagenomics: Species" \cr                                           
#' "Shotgun metagenomics: Family" \cr                                         
#' "Shotgun metagenomics: Order" \cr                                          
#' "Shotgun metagenomics: Phylum" \cr                                           
#' "Shotgun metagenomics: Class"  \cr                                          
#' "Shotgun metagenomics: Kingdom"  \cr                                          
#' "Shotgun metagenomics: Normalized number of taxon-specific sequence matches" \cr
#' "16S Order" \cr                
#' "16S Genus" \cr                                           
#' "16S Family" \cr                                        
#' "16S Species" \cr                                          
#' "16S Class" \cr                                         
#' "16S Phylum" \cr                                           
#' "16S Kingdom" \cr 
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_d1b9f788dc/new/download>
#' @name PretermInfantResistome1
"PretermInfantResistome1"

#' Preterm Infant Resistome 1
#' 
#' The Preterm Infant Resistome II study profiled the stool metagenome in preterm infants 
#' (born < 33 weeks gestational age) throughout the first 21 months of life.
#'  Patients were stratified by antibiotic use during their hospitalization
#' 41 preterm infants and 17 antibiotic-naive, healthy early term or late-preterm infants 
#' seen at the Washington University School of Medicine in St. Louis, MO, USA
#' 437 stool samples; 'shotgun' metagenomic sequencing.
#' Prospective cohort design.
#' 
#' Website Release 32. (2023 May 30)
#'
#' @format ## `PretermInfantResistome2`
#' A MbioDataset object with 24 metadata variables, 427 shotgun stool samples.
#' It contains the following collections: \cr
#' "Shotgun metagenomics: 4th level EC metagenome abundance data" \cr         
#' "Shotgun metagenomics: Metagenomeenzyme pathway abundance data" \cr          
#' "Shotgun metagenomics: Metagenomeenzyme pathway coverage data"  \cr        
#' "Shotgun metagenomics: Genus" \cr        
#' "Shotgun metagenomics: Species" \cr                                           
#' "Shotgun metagenomics: Family" \cr                                         
#' "Shotgun metagenomics: Order" \cr                                          
#' "Shotgun metagenomics: Phylum" \cr                                           
#' "Shotgun metagenomics: Class"  \cr                                          
#' "Shotgun metagenomics: Kingdom"  \cr                                          
#' "Shotgun metagenomics: Normalized number of taxon-specific sequence matches" \cr
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_b9dc726b20/new/download>
#' @name PretermInfantResistome2
"PretermInfantResistome2"

#' Uganda Maternal
#' 
#' The Uganda Maternal microbiome study profled vaginal samples obtained from 
#' Ugandan pregnant women during active labor but before birth. 
#' Patients were catergorizd by intrapartum fever status
#' 99 adult intrapartum women seen at the Mbarara (n=50) or Mbale (n=49) 
#' Hospitals in western and eastern Uganda, respectively
#' 99 vaginal swab samples; profiled using both V1-V2 and V3-V4 region of 16S rRNA gene.
#' 
#' Website Release 32. (2023 May 30)
#' 
#' @format ## `UgandaMaternal`
#' A MbioDataset object with 11 metadata variables, 99 successful V1V2 assays and 97 successful V3V4 assays.
#' It contains the following collections: \cr
#' "16S V1V2 Order" \cr                
#' "16S V1V2 Genus" \cr                                           
#' "16S V1V2 Family" \cr                                        
#' "16S V1V2 Species" \cr                                          
#' "16S V1V2 Class" \cr                                         
#' "16S V1V2 Phylum" \cr                                           
#' "16S V1V2 Kingdom" \cr 
#' "16S V3V4 Order" \cr                
#' "16S V3V4 Genus" \cr                                           
#' "16S V3V4 Family" \cr                                        
#' "16S V3V4 Species" \cr                                          
#' "16S V3V4 Class" \cr                                         
#' "16S V3V4 Phylum" \cr                                           
#' "16S V3V4 Kingdom" \cr 
#' @source <https://microbiomedb.org/mbio/app/workspace/analyses/DS_d3053dfc9c/new/download>
#' @name UgandaMaternal
"UgandaMaternal"