% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/other_functions.R
\name{mixColors}
\alias{mixColors}
\title{Returns the average color from a vector of colors}
\usage{
mixColors(colorVector, scaleFactor = 2, weights = NULL)
}
\arguments{
\item{colorVector}{a vector of colors (hex or color names are all okay)}

\item{scaleFactor}{How to scale.  Typically should be left at 2}

\item{return_type}{How to weight each color in the vector}
}
\value{
A hex color character
}
\description{
Returns the average color from a vector of colors
}
