#' (From Seurat) logs a command
#'
#' Logs a command run, storing the name, timestamp, and argument list. Stores in
#' the Seurat object
#' @param object Name of Seurat object
#'
#' @return returns the Seurat object with command stored
#'
LogSeuratCommand <- function(object, return.command = FALSE) {
  time.stamp <- Sys.time()
  #capture function name
  command.name <- as.character(deparse(sys.calls()[[sys.nframe() - 1]]))
  command.name <- gsub(pattern = ".Seurat", replacement = "", x = command.name)
  call.string <- command.name
  command.name <- ExtractField(string = command.name, field = 1, delim = "\\(")
  #capture function arguments
  argnames <- names(x = formals(fun = sys.function(which = sys.parent(n = 1))))
  argnames <- grep(pattern = "object", x = argnames, invert = TRUE, value = TRUE)
  argnames <- grep(pattern = "anchorset", x = argnames, invert = TRUE, value = TRUE)
  argnames <- grep(pattern = "\\.\\.\\.", x = argnames, invert = TRUE, value = TRUE)
  params <- list()
  p.env <- parent.frame(n = 1)
  argnames <- intersect(x = argnames, y = ls(name = p.env))
  # fill in params list
  for (arg in argnames) {
    param_value <- get(x = arg, envir = p.env)
    #TODO Institute some check of object size?
    params[[arg]] <- param_value
  }
  # check if function works on the Assay and/or the DimReduc Level
  assay <- params[["assay"]]
  reduction <- params[["reduction"]]
  if (class(x = reduction) == 'DimReduc') {
    reduction = 'DimReduc'
  }
  # rename function name to include Assay/DimReduc info
  if (length(x = assay) == 1) {
    command.name <- paste(command.name, assay, reduction, sep = '.')
  }
  command.name <- sub(pattern = "[\\.]+$", replacement = "", x = command.name, perl = TRUE)
  command.name <- sub(pattern = "\\.\\.", replacement = "\\.", x = command.name, perl = TRUE)
  # store results
  seurat.command <- new(
    Class = 'SeuratCommand',
    name = command.name,
    params = params,
    time.stamp = time.stamp,
    call.string = call.string
  )
  if (return.command) {
    return(seurat.command)
  }
  object[[command.name]] <- seurat.command
  return(object)
}


`%||%` <- function(lhs, rhs) {
  if (!is.null(x = lhs)) {
    return(lhs)
  } else {
    return(rhs)
  }
}


#` (From Seurat) Extract delimiter information from a string.
#`
#` Parses a string (usually a cell name) and extracts fields based on a delimiter
#`
#` @param string String to parse.
#` @param field Integer(s) indicating which field(s) to extract. Can be a vector multiple numbers.
#` @param delim Delimiter to use, set to underscore by default.
#`
#` @return A new string, that parses out the requested fields, and (if multiple), rejoins them with the same delimiter
#`
#` @export
#`
#` @examples
#` ExtractField(string = 'Hello World', field = 1, delim = '_')
#`
ExtractField <- function(string, field = 1, delim = "_") {
  fields <- as.numeric(x = unlist(x = strsplit(x = as.character(x = field), split = ",")))
  if (length(x = fields) == 1) {
    return(strsplit(x = string, split = delim)[[1]][field])
  }
  return(paste(strsplit(x = string, split = delim)[[1]][fields], collapse = delim))
}

#' (From Seurat) FindNeighbors (required for Windows compatibility)
#'
#' @param assay Assay to use in construction of SNN
#' @param features Features to use as input for building the SNN
#' @param reduction Reduction to use as input for building the SNN
#' @param dims Dimensions of reduction to use as input
#' @param do.plot Plot SNN graph on tSNE coordinates
#' @param graph.name Optional naming parameter for stored SNN graph. Default is
#' assay.name_snn.
#'
#' @importFrom igraph graph.adjacency plot.igraph E
#'
#' @rdname FindNeighbors
#' @export
#' @method FindNeighbors Seurat
#'
FindNeighbors.Seurat <- function(
  object,
  reduction = "pca",
  dims = 1:10,
  assay = NULL,
  features = NULL,
  k.param = 20,
  compute.SNN = TRUE,
  prune.SNN = 1/15,
  nn.eps = 0,
  verbose = TRUE,
  force.recalc = FALSE,
  do.plot = FALSE,
  graph.name = NULL,
  ...
) {
  if (!is.null(x = dims)) {
    assay <- assay %||% DefaultAssay(object = object)
    data.use <- Embeddings(object = object[[reduction]])
    if (max(dims) > ncol(x = data.use)) {
      stop("More dimensions specified in dims than have been computed")
    }
    data.use <- data.use[, dims]
    neighbor.graphs <- FindNeighbors(
      object = data.use,
      k.param = k.param,
      compute.SNN = compute.SNN,
      prune.SNN = prune.SNN,
      nn.eps = nn.eps,
      verbose = verbose,
      force.recalc = force.recalc
    )
  } else {
    assay <- assay %||% DefaultAssay(object = object)
    data.use <- GetAssay(object = object, assay = assay)
    neighbor.graphs <- FindNeighbors(
      object = data.use,
      features = features,
      k.param = k.param,
      compute.SNN = compute.SNN,
      prune.SNN = prune.SNN,
      nn.eps = nn.eps,
      verbose = verbose,
      force.recalc = force.recalc
    )
  }
  graph.name <- graph.name %||% paste0(assay, "_", names(x = neighbor.graphs))
  for (ii in 1:length(x = graph.name)) {
    object[[graph.name[[ii]]]] <- neighbor.graphs[[ii]]
  }
  if (do.plot) {
    if (!"tsne" %in% names(x = object@reductions)) {
      warning("Please compute a tSNE for SNN visualization. See RunTSNE().")
    } else {
      if (nrow(x = Embeddings(object = object[["tsne"]])) != ncol(x = object)) {
        warning("Please compute a tSNE for SNN visualization. See RunTSNE().")
      } else {
        net <- graph.adjacency(
          adjmatrix = as.matrix(x = neighbor.graphs[[2]]),
          mode = "undirected",
          weighted = TRUE,
          diag = FALSE
        )
        plot.igraph(
          x = net,
          layout = as.matrix(x = Embeddings(object = object[["tsne"]])),
          edge.width = E(graph = net)$weight,
          vertex.label = NA,
          vertex.size = 0
        )
      }
    }
  }
  object <- LogSeuratCommand(object = object)
  return(object)
}