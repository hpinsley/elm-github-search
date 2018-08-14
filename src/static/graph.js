import * as d3 from "d3";
import * as $ from "jQuery"

function renderGraph(title, monthData) {
    console.log(`In render graph with title ${title} and monthData ${monthData}`);

    var rootElement = $('#graphContent');
    rootElement.append('<h1>This is from JavaScript</h1>');

    var sampleSVG = d3.select("#graphContent")
        .append("svg")
        .attr("width", 100)
        .attr("height", 100);

    sampleSVG.append("circle")
        .style("stroke", "gray")
        .style("fill", "white")
        .attr("r", 40)
        .attr("cx", 50)
        .attr("cy", 50)
        .on("mouseover", function(){d3.select(this).style("fill", "aliceblue");})
        .on("mouseout", function(){d3.select(this).style("fill", "white");});

    sampleSVG.append("circle")
        .style("stroke", "gray")
        .style("fill", "white")
        .attr("r", 40)
        .attr("cx", 50)
        .attr("cy", 50)
      .transition()
        .delay(100)
        .duration(1000)
        .attr("r", 10)
        .attr("cx", 30)
        .style("fill", "black");
}

export { renderGraph };
