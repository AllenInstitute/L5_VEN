auto_annotate <- function (anno, scale_num = "predicted", na_val_num = 0, colorset_num = c("darkblue", 
    "white", "red"), sort_label_cat = TRUE, na_val_cat = "ZZ_Missing", 
    colorset_cat = "varibow", color_order_cat = "sort") 
{
    anno_out <- anno
    if (!is.element("sample_name", colnames(anno_out))) {
        colnames(anno_out) <- gsub("sample_id", "sample_name", 
            colnames(anno_out))
    }
    cn <- colnames(anno_out)
    convertColumns <- cn[(!grepl("_label", cn)) & (!grepl("_id", 
        cn)) & (!grepl("_color", cn))]
    convertColumns <- setdiff(convertColumns, "sample_name")
    for (cc in convertColumns) {
        value <- anno_out[, cc]
        if (is.numeric(value)) {
            if (is.element(scale_num, c("linear", "log10", "log2", 
                "zscore"))) {
                anno_out <- annotate_num(df = anno_out, col = cc, 
                  scale = scale_num, na_val = na_val_num, colorset = colorset_num)
            }
            else {
                scalePred <- ifelse(min(value) < 0, "linear", 
                  "log10")
                if ((max(value + 1)/min(value + 1)) < 100) {
                  scalePred <- "linear"
                }
                if (mean((value - min(value))/diff(range(value))) < 
                  0.01) {
                  scalePred <- "log10"
                }
                anno_out <- annotate_num(df = anno_out, col = cc, 
                  scale = scalePred, na_val = na_val_num, colorset = colorset_num)
            }
        }
        else {
            if (is.factor(value)) {
                anno_out <- annotate_factor(df = anno_out, col = cc, 
                  base = cc, na_val = na_val_cat, colorset = colorset_cat, 
                  color_order = color_order_cat)
            }
            else {
                anno_out <- annotate_cat(df = anno_out, col = cc, 
                  base = cc, na_val = na_val_cat, colorset = colorset_cat, 
                  color_order = color_order_cat, sort_label = sort_label_cat)
            }
        }
    }
    anno_out <- group_annotations(anno_out)
    anno_out
}



annotate_num <- function (df, col = NULL, base = NULL, scale = "log10", na_val = 0, 
    colorset = c("darkblue", "white", "red")) 
{
    if (class(try(is.character(col), silent = T)) == "try-error") {
        col <- lazyeval::expr_text(col)
    }
    else if (class(col) == "NULL") {
        stop("Specify a column (col) to annotate.")
    }
    if (class(try(is.character(base), silent = T)) == "try-error") {
        base <- lazyeval::expr_text(base)
    }
    else if (class(base) == "NULL") {
        base <- col
    }
    if (!is.numeric(df[[col]])) {
        df[[col]] <- as.numeric(df[[col]])
    }
    df[[col]][is.na(df[[col]])] <- na_val
    x <- df[[col]]
    annotations <- data.frame(label = unique(x)) %>% dplyr::arrange(label) %>% 
        dplyr::mutate(id = 1:dplyr::n())
    if (scale == "log10") {
        colors <- values_to_colors(log10(annotations$label + 
            1), colorset = colorset)
    }
    else if (scale == "log2") {
        colors <- values_to_colors(log2(annotations$label + 1), 
            colorset = colorset)
    }
    else if (scale == "zscore") {
        colors <- values_to_colors(scale(annotations$label), 
            colorset = colorset)
    }
    else if (scale == "linear") {
        colors <- values_to_colors(annotations$label, colorset = colorset)
    }
    annotations <- mutate(annotations, color = colors)
    names(annotations) <- paste0(base, c("_label", "_id", "_color"))
    names(df)[names(df) == col] <- paste0(base, "_label")
    df <- dplyr::left_join(df, annotations, by = paste0(base, 
        "_label"))
    df
}


annotate_cat <- function (df, col = NULL, base = NULL, sort_label = T, na_val = "ZZ_Missing", 
    colorset = "varibow", color_order = "sort") 
{
    if (class(try(is.character(col), silent = T)) == "try-error") {
        col <- lazyeval::expr_text(col)
    }
    else if (class(col) == "NULL") {
        stop("Specify a column (col) to annotate.")
    }
    if (class(try(is.character(base), silent = T)) == "try-error") {
        base <- lazyeval::expr_text(base)
    }
    else if (class(base) == "NULL") {
        base <- col
    }
    if (!is.character(df[[col]])) {
        df[[col]] <- as.character(df[[col]])
    }
    df[[col]][is.na(df[[col]])] <- na_val
    x <- df[[col]]
    annotations <- data.frame(label = unique(x), stringsAsFactors = F)
    if (sort_label) {
        annotations <- annotations %>% dplyr::arrange(label)
    }
    annotations <- annotations %>% dplyr::mutate(id = 1:n())
    if (colorset == "varibow") {
        colors <- varibow(nrow(annotations))
    }
    else if (colorset == "rainbow") {
        colors <- sub("FF$", "", grDevices::rainbow(nrow(annotations)))
    }
    else if (colorset == "viridis") {
        colors <- sub("FF$", "", viridisLite::viridis(nrow(annotations)))
    }
    else if (colorset == "magma") {
        colors <- sub("FF$", "", viridisLite::magma(nrow(annotations)))
    }
    else if (colorset == "inferno") {
        colors <- sub("FF$", "", viridisLite::inferno(nrow(annotations)))
    }
    else if (colorset == "plasma") {
        colors <- sub("FF$", "", viridisLite::plasma(nrow(annotations)))
    }
    else if (colorset == "terrain") {
        colors <- sub("FF$", "", grDevices::terrain.colors(nrow(annotations)))
    }
    else if (is.character(colorset)) {
        colors <- (grDevices::colorRampPalette(colorset))(nrow(annotations))
    }
    if (color_order == "random") {
        colors <- sample(colors, length(colors))
    }
    annotations <- dplyr::mutate(annotations, color = colors)
    names(annotations) <- paste0(base, c("_label", "_id", "_color"))
    names(df)[names(df) == col] <- paste0(base, "_label")
    df <- dplyr::left_join(df, annotations, by = paste0(base, 
        "_label"))
    df
}

annotate_factor <- function (df, col = NULL, base = NULL, na_val = "ZZ_Missing", 
    colorset = "varibow", color_order = "sort") 
{
    if (class(try(is.character(col), silent = T)) == "try-error") {
        col <- lazyeval::expr_text(col)
    }
    else if (class(col) == "NULL") {
        stop("Specify a column (col) to annotate.")
    }
    if (class(try(is.character(base), silent = T)) == "try-error") {
        base <- lazyeval::expr_text(base)
    }
    else if (class(base) == "NULL") {
        base <- col
    }
    if (!is.factor(df[[col]])) {
        df[[col]] <- as.factor(df[[col]])
    }
    if (sum(is.na(df[[col]])) > 0) {
        lev <- c(levels(df[[col]]), na_val)
        levels(df[[col]]) <- lev
        df[[col]][is.na(df[[col]])] <- na_val
    }
    x <- df[[col]]
    annotations <- data.frame(label = as.character(levels(x)), 
        stringsAsFactors = F)
    annotations <- annotations %>% dplyr::mutate(id = 1:n())
    if (colorset == "varibow") {
        colors <- varibow(nrow(annotations))
    }
    else if (colorset == "rainbow") {
        colors <- sub("FF$", "", grDevices::rainbow(nrow(annotations)))
    }
    else if (colorset == "viridis") {
        colors <- sub("FF$", "", viridisLite::viridis(nrow(annotations)))
    }
    else if (colorset == "magma") {
        colors <- sub("FF$", "", viridisLite::magma(nrow(annotations)))
    }
    else if (colorset == "inferno") {
        colors <- sub("FF$", "", viridisLite::inferno(nrow(annotations)))
    }
    else if (colorset == "plasma") {
        colors <- sub("FF$", "", viridisLite::plasma(nrow(annotations)))
    }
    else if (colorset == "terrain") {
        colors <- sub("FF$", "", grDevices::terrain.colors(nrow(annotations)))
    }
    else if (is.character(colorset)) {
        colors <- (grDevices::colorRampPalette(colorset))(nrow(annotations))
    }
    if (color_order == "random") {
        colors <- sample(colors, length(colors))
    }
    annotations <- dplyr::mutate(annotations, color = colors)
    names(annotations) <- paste0(base, c("_label", "_id", "_color"))
    names(df)[names(df) == col] <- paste0(base, "_label")
    df[[col]] <- as.character(df[[col]])
    df <- dplyr::left_join(df, annotations, by = paste0(base, 
        "_label"))
    df
}
