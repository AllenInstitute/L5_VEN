## Required functions
summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,
                      conf.interval=.95, .drop=TRUE, roundall = F) {
  require(dplyr)
  # This does the summary. For each group return a vector with
  # N, mean, and sd
  
  names(data)[names(data) == measurevar] <- "measurevar"
  
  datac <- data %>%
    select(one_of(groupvars,"measurevar")) %>%
    filter(ifelse(na.rm == T, !is.na(measurevar), T)) %>%
    mutate(measurevar = as.numeric(measurevar)) %>%
    group_by_(c(groupvars)) %>%
    summarise(N = n(),
              median = median(measurevar),
              mean = mean(measurevar),
              max = max(measurevar),
              sd = ifelse(N == 1, 0, sd(measurevar)),
              q25 = as.numeric(quantile(measurevar, 0.25)),
              q75 = as.numeric(quantile(measurevar, 0.75))) %>%
    mutate(se = sd/sqrt(N))
  #%>%
  #  mutate(ci =  se * qt(conf.interval/2 + 0.5, N-1))
  
  
  if(roundall) {
    roundcols <- c("median","mean","max","sd","q25","q75","se","ci")
    datac[roundcols] <- round(datac[roundcols],3)
  }
  
  # datac <- datac %>%
  #   mutate(xpos = 1:n())
  
  return(datac)
}


# This function makes the actual plots!
qcPlot <- function(anno,name,scaleLimits = c(-5000, 12000), 
                     scaleBreaks = seq(0, 12000, 2000),
                     scaleLabels = seq(0,12,2),
					 ylab = "value", yVal=0, width = 7, height = 3, 
					 fileName = gsub("\\.","_",gsub("_label","",name)),
					 screenPlot = TRUE)
{

# cluster_id is the annotation for cluster ordering based on the current, bootstrapped dendrogram
stats <- summarySE(data = anno,
                         measurevar = name,
                         groupvars = "cluster_id")

anno[anno[,name]>scaleLimits[2],name] = scaleLimits[2]
anno[anno[,name]<scaleLimits[1],name] = scaleLimits[1]
cols = anno$cluster_color[order(factor(anno$cluster_label,levels=labels(dend)))]
						 
genes_plot <- ggplot() +
  # geom_quasirandom from the ggbeeswarm package
  # makes violin-shaped jittered point plots
  geom_quasirandom(data = anno,
                   aes(x = cluster_id,
                       y = eval(parse(text=name))),  # might need eval(parse(text=name))
                   color = cols, #"skyblue",
                   # Need to set position_jitter height = 0 to prevent
                   # jitter on the y-axis, which changes data representation
                   position = position_jitter(width = .3,height = 0),
                   size = 0.1) +
  # Errorbars built using stats values
  geom_errorbar(data = stats,
                aes(x = cluster_id,
                    ymin = q25,
                    ymax = q75),
                size = 0.2) +
  # Median points from stats
  geom_point(data = stats,
             aes(x = cluster_id,
                 y = median),
             color = "black", #"red",
             size = 0.75) +
  # Cluster labels as text objects
  geom_text(data = cluster_anno,
            aes(x = cluster_id,
                y = yVal,
                label = cluster_label,
                color = cluster_color),
            angle = 90,
            hjust = 2,
            vjust = 0.3,
            size = 2*5/6) +
  scale_color_identity() +
  # Expand the y scale so that the labels are visible
  scale_y_continuous(ylab,
                     limits = scaleLimits, 
                     breaks = scaleBreaks,
                     labels = scaleLabels) +
  # Remove X-axis title
  scale_x_continuous("") +
  theme_bw() +
  # Theme tuning
  theme(axis.text.x = element_blank(),
        axis.ticks = element_blank(),
        panel.border = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank())
ggsave(paste0(fileName,"_QC.pdf"), genes_plot, width = width, height = height, useDingbats = F)
if(screenPlot) return(genes_plot)
}
