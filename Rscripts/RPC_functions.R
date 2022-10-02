plot.curcular.diagram <-
  function(input = df.input,
           programme.name = "") {
    process.input(input = input) -> geom.data
    
    plotter_fun(
      programme.name,
      diameter = geom.data[["diameter"]],
      lines = geom.data[["lines"]],
      points = geom.data[["points"]],
      layers = geom.data[["layers"]]
    ) -> circular.diagram
    
    return(circular.diagram)
  }

process.input <- function(input) {
  input[which(input$type == "evidence"), ] -> points
  points[["position"]] <- "end"
  
  diameter.main_circle = max(points[["length"]]) / 5
  
  points -> lines.starts
  lines.starts[["position"]] <- "start"
  lines.starts[["length"]] <- diameter.main_circle
  rbind(lines.starts, points) -> lines
  
  input[which(input == "layer"),] -> layers
  layers[["length.max"]] <-
    cumsum(layers[["length"]]) + diameter.main_circle
  layers[["length.min"]] <-
    layers[["length.max"]] - layers[["length"]]
  
  list(
    "diameter" = diameter.main_circle,
    "points" = points,
    "lines" = lines,
    "layers" = layers
  ) -> geom.data
  
  if(length(rownames(layers)) == 0) {
    geom.data[["layers"]] = NULL
  }
  
  if(length(rownames(points)) == 0) {
    geom.data[["points"]] = NULL
    geom.data[["lines"]] = NULL
  }
  
  return(geom.data)
}

plotter_fun <- function(programme.name = "",
                                  diameter = 40,
                                  lines = NULL,
                                  points = NULL,
                                  layers = NULL) {
  diameter.main_circle = diameter
  
  ggplot() +
    # main circle
    geom_rect(aes(
      ymin = 0,
      ymax = diameter.main_circle,
      xmin = 0,
      xmax = 360
    ),
    fill = "white") +
    geom_hline(yintercept = diameter.main_circle,
               size = 1) -> plot.diagram
  
  if (!is.null(points)) {
    plot.diagram +
      # lines of evidence
      geom_line(data = lines,
                aes(x = angle,
                    y = length,
                    group = label)) +
      # points of evidence
      geom_point(
        data = points,
        aes(x = angle,
            y = length,
            fill = label),
        shape = 21,
        size = 6,
        stroke = 0.75
      ) +
      # text labels of points of evidence
      geom_text(data = points,
                aes(x = angle,
                    y = length,
                    label = label),
                size = 4) -> plot.diagram
  }
  
  if (!is.null(layers)) {
    plot.diagram +
      # protective layers
      geom_rect(data = layers,
                aes(
                  ymin = length.min,
                  ymax = length.max,
                  xmin = 0,
                  xmax = 360,
                  fill = label
                )) +
      # text labels of layers
      geom_text(data = layers,
                aes(
                  x = 90,
                  y = length.min + (length / 2),
                  label = label
                ),
                size = 8 / .pt) -> plot.diagram
  }
  
  plot.diagram +
    coord_polar() +
    theme_void() +
    theme(legend.position = "none") +
    annotate(
      "text",
      label = programme.name,
      x = 0,
      y = 0,
      size = 4
    ) -> plot.diagram
  
  return(plot.diagram)
}
