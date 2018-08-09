// pull in desired CSS/SASS files
require( './styles/main.scss' );
var $ = jQuery = require( '../../node_modules/jquery/dist/jquery.js' );           // <--- remove if jQuery not needed
require( '../../node_modules/bootstrap-sass/assets/javascripts/bootstrap.js' );   // <--- remove if Bootstrap's JS not needed

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
        }
    }, delay);
});