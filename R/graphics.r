cbbPalette <- c("#E69F00", "#56B4E9", "#009E73", "#000000", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

my_fill_palette1 <- function() {scale_fill_brewer(palette="Set1")}
my_colour_palette1 <- function() {scale_colour_brewer(palette="Set1")}

#my_fill_palette1 <- function() {scale_fill_manual(values=cbbPalette)}
#my_colour_palette1 <- function() {scale_colour_manual(values=cbbPalette)}

normal_h = 5

normal_w = 6
narrow_w = 6

the_alpha = .3
the_base_size = 16

set_ggplot_theme <- function() {theme_set(theme_bw(base_size = the_base_size))}

require(grid)

theme_black <- function (base_size = 12,base_family=""){
  theme_grey(base_size=base_size,base_family=base_family) %+replace%
    theme(
      axis.line = element_blank(), 
      axis.text.x = element_text(size = base_size * 0.8, colour = 'white', lineheight = 0.9, vjust = 1), 
      axis.text.y = element_text(size = base_size * 0.8, colour = 'white', lineheight = 0.9, hjust = 1), 
      axis.ticks = element_line(colour = "white", size = 0.2), 
      axis.title.x = element_text(size = base_size, colour = 'white', vjust = 1), 
      axis.title.y = element_text(size = base_size, colour = 'white', angle = 90, vjust = 0.5), 
      axis.ticks.length = unit(0.3, "lines"), 
      axis.ticks.margin = unit(0.5, "lines"), 

      legend.background = element_rect(colour = NA, fill = 'black'), 
      legend.key = element_rect(colour = "white", fill = 'black'), 
      legend.key.size = unit(1.2, "lines"), 
      legend.key.height = NULL, 
      legend.key.width = NULL,     
      legend.text = element_text(size = base_size * 0.8, colour = 'white'), 
      legend.title = element_text(size = base_size * 0.8, face = "bold", hjust = 0, colour = 'white'), 
      legend.position = "right", 
      legend.text.align = NULL, 
      legend.title.align = NULL, 
      legend.direction = "vertical", 
      legend.box = NULL,    

      panel.background = element_rect(fill = "black", colour = NA), 
      panel.border = element_rect(fill = NA, colour = "white"), 
      panel.grid.major = element_blank(), 
      panel.grid.minor = element_blank(), 
      panel.margin = unit(0.25, "lines"), 

      strip.background = element_rect(fill = "grey30", colour = "grey10"), 
      strip.text.x = element_text(size = base_size * 0.8, colour = 'white'), 
      strip.text.y = element_text(size = base_size * 0.8, colour = 'white', angle = -90), 

      plot.background = element_rect(colour = 'black', fill = 'black'), 
      plot.title = element_text(size = base_size * 1.2, colour = "white"), 
      plot.margin = unit(c(1, 1, 0.5, 0.5), "lines")
    )
}


