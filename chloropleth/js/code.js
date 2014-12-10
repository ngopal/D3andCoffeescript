// Generated by CoffeeScript 1.6.3
(function() {
  var height, margin, svg, width;

  margin = {
    top: 20,
    right: 20,
    bottom: 30,
    left: 50
  };

  height = 500 - margin.top - margin.bottom;

  width = 960 - margin.left - margin.right;

  svg = d3.select("body").append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  d3.json("gz_2010_us_040_00_500k.json", function(json) {
    var dataset, path, projection;
    projection = d3.geo.albersUsa().translate([width / 2, height / 2]).scale([1000]);
    path = d3.geo.path().projection(projection);
    svg.selectAll("path").data(json.features).enter().append("path").attr("d", path);
    dataset = [];
    return d3.csv("all_day.csv", function(error, data) {
      dataset = data.map(function(d) {
        return [+d["longitude"], +d["latitude"], +d["mag"], +d["depth"]];
      });
      return svg.selectAll("circle").data(dataset).enter().append("circle").attr("cx", function(d) {
        var err;
        try {
          return projection([d[0], d[1]])[0];
        } catch (_error) {
          err = _error;
          return 0;
        }
      }).attr("cy", function(d) {
        var err;
        try {
          return projection([d[0], d[1]])[1];
        } catch (_error) {
          err = _error;
          return 0;
        }
      }).attr("r", function(d) {
        var err;
        try {
          if (d[3] < 1) {
            return 0;
          }
          return Math.exp(d[2] / d[3]) * 2.5;
        } catch (_error) {
          err = _error;
          return 0;
        }
      }).style("fill", "red");
    });
  });

}).call(this);
