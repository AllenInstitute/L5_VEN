#' Cluster information for MTG data set.
#'
#' Cluster information (including name, color, and type) for MTG data sets.
#'
#' @format A data frame with 75 rows and 11 variables:
#' \describe{
#'   \item{cluster_id}{cluster identifier}
#'   \item{cluster_label}{cluster name}
#'   \item{cluster_color}{cluster color in MTG paper}
#'   \item{cluster_type_label}{What broad class is that cluster}
#'   \item{all others}{can be ignored}
#' }
#' @source \url{https://www.biorxiv.org/content/early/2018/08/05/384826}
"clusterInfoMTG"


#' snRNA-seq data from frontoinsula
#'
#' CPM values (rounded to the nearest integer) for all 879 nuclei passing QC in 
#'   the human FI data set.  
#'
#' @format A data frame with 30370 rows (genes) and 879 variables (nuclei):
#' \describe{
#'   \item{each column}{gene expression levels for all genes in that nucleus}
#' }
#' @source \url{https://github.com/AllenInstitute/VENcelltypes}
"FI_layer5_count_data"


#' Sample information for nuclei from frontoinsula.
#'
#' Sample information and various metadata for all 879 nuclei passing QC in 
#'   the human FI data set. 
#'
#' @format A data frame with 879 rows (nuclei) and 11 variables:
#' \describe{
#'   \item{cluster_id}{OLD cluster identifier}
#'   \item{cluster_label}{OLD cluster name}
#'   \item{cluster_color}{OLD cluster color}
#'   \item{patient_label}{donor of origin}
#'   \item{genecountsGTzeroFPKM_label}{Genes with expression > 0}
#'   \item{mappedReads_label}{Number of mapped reads per nucleus}
#'   \item{PCT_INTRONIC_BASES_label}{Percent of base pairs mapping to introns}
#'   \item{PCT_HUMAN_EXONS_BASES_label}{Percent of base pairs mapping to exons}
#'   \item{all others}{are not used in manuscript, but have reasonable column headers}
#' }
#' @source \url{https://github.com/AllenInstitute/VENcelltypes}
"FI_layer5_sample_information"


#' Mitochondrial-associated genes.
#'
#' Vector of mitochondrial-associated genes
#'
#' @format A character vector with 1182 elements:
#' \describe{
#'   \item{mito_genes}{cluster identifier}
#' }
#' @source \url{https://www.biorxiv.org/content/early/2018/08/05/384826}
"mito_genes"


#' Sex-associated genes.
#'
#' Vector of sex-associated genes
#'
#' @format A character vector with 2433 elements:
#' \describe{
#'   \item{sex_genes}{cluster identifier}
#' }
#' @source \url{https://www.biorxiv.org/content/early/2018/08/05/384826}
"sex_genes"