// pull in desired CSS/SASS files
require( './styles/main.scss' );
// var $ = jQuery = require( '../../node_modules/jquery/dist/jquery.js' );           // <--- remove if jQuery not needed
// require( '../../node_modules/bootstrap-sass/assets/javascripts/bootstrap.js' );   // <--- remove if Bootstrap's JS not needed
import {renderGraph} from './graph'

// inject bundled Elm app into div#main
var Elm = require( '../elm/Main' );
var app = Elm.Main.embed( document.getElementById( 'main' ) );
console.log(app)
console.log(app.ports)

app.ports.setFocusToElement.subscribe(({id, delay}) => {
    // We need to wait a bit to allow the DOM to be rendered...
    setTimeout(() => {
        const element = document.getElementById(id);
        if (element) {
            console.log(`Setting focus to ${id}`);
            element.focus();
            app.ports.setFocusToElementResult.send(id);
        }
    }, delay);
});

app.ports.render.subscribe(({title}) => {
    console.log(`Rendering graph with title ${title}.`);
    // rootElement = $('#graphContent');
    // rootElement.append('<h1>This is from JavaScript</h1>');
    // var sampleSVG = d3.select("#graphContent")
    //     .append("svg")
    //     .attr("width", 100)
    //     .attr("height", 100);

    // sampleSVG.append("circle")
    //     .style("stroke", "gray")
    //     .style("fill", "white")
    //     .attr("r", 40)
    //     .attr("cx", 50)
    //     .attr("cy", 50)
    //     .on("mouseover", function(){d3.select(this).style("fill", "aliceblue");})
    //     .on("mouseout", function(){d3.select(this).style("fill", "white");});

    renderGraph();
});