require( './styles/main.scss' );
import {renderGraph} from './graph'

// inject bundled Elm app into div#main
var Elm = require( '../elm/Main' );
var app = Elm.Main.embed( document.getElementById( 'main' ) );

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

app.ports.render.subscribe(({title, monthData}) => {
    renderGraph(title, monthData);
});