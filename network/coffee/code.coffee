
width = 1200
height = 900

svg = d3.select("body")
   .append("svg")
   .attr("width", width)
   .attr("height", height)

color = d3.scale.category10()

force = d3.layout.force()
   .charge(-120)
   .linkDistance(30)
   .size([
     width
     height
   ])

d3.json "data.json", (error, graph) ->
   force.nodes(graph.nodes)
      .links(graph.links)
      .start()
   link = svg.selectAll(".link")
      .data(graph.links)
      .enter()
      .append("line")
      .attr("class", "link")
      .style("stroke-width", (d) ->
         Math.sqrt d.value)
      .style("stroke", "#999")
      .style("stroke-opacity", ".6")

   node = svg.selectAll(".node")
      .data(graph.nodes)
      .enter()
      .append("circle")
      .attr("class", "node")
      .attr("r", 5)
      .style("fill", (d) ->
         color d.group)
      .style("stroke", "#fff")
      .style("stroke-width", "1px")
      .call(force.drag)
   node.append("title")
      .text (d) ->
         d.name

   force.on "tick", -> 
      link.attr("x1", (d) ->
         d.source.x
      ).attr("y1", (d) ->
         d.source.y
      ).attr("x2", (d) ->
         d.target.x
      ).attr "y2", (d) ->
         d.target.y
      node.attr("cx", (d) ->
         d.x
      ).attr "cy", (d) ->
         d.y

$ ->
  $("#slider-range-min").slider
    range: "min"
    value: -120
    min: -500
    max: 0
    slide: (event, ui) ->
      force.charge ui.value
      force.start()

 $ ->
  $("#slider-range-min2").slider
    range: "min"
    value: 30
    min: 1
    max: 1000
    slide: (event, ui) ->
      force.linkDistance ui.value 
      force.start()

$ ->
  $("#slider-range-min3").slider
    range: "min"
    value: 0.1
    min: 0.1
    max: 10
    slide: (event, ui) ->
      force.gravity ui.value 
      force.start()

