require("@rails/ujs").start();
require("@rails/activestorage").start();
require("channels");
import "../stylesheets/application.scss";
var componentRequireContext = require.context("src", true);
var ReactRailsUJS = require("react_ujs");
ReactRailsUJS.useContext(componentRequireContext);