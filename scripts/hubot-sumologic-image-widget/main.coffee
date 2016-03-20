# Payou Experimental lab for display sumologic widget as
# a screenshot image


# Idea #1
# Input - Widget data from sumologic
# 1) Use combinaison of jsdom and highchart to generate an svg graph
# 2) Use svg2img to generate image file
# 3) Render it in an accessible place but temporary
# 4) Show image url
# Ouput : Display widget image in slack where hubot called


# Idea #2
# Input - Widget data from sumologic
# 1) Use combinaison of jsdom and highchart to generate an svg graph
# 2) Render it in a base64 img using the following snippet (untested with jsdom)
#      xml = svgEl.outerHTML
#      function svgImage(xml) {
#        var image = new Image();
#        image.src = 'data:image/svg+xml;base64,' + window.btoa(xml);
#        return image;
#      }
# 3) Render it in an accessible place but temporary
# 4) Show image url
# Ouput : Display widget image in slack where hubot called

jsdom = require "jsdom"
highcharts = require "highcharts"

svg2png = require "svg2png"
#Remove me i'm here only for testing purpose !
#pn = require "pn"
fs = require "pn/fs"

console.log "================================================================================"
console.log "=== Libs dump "
console.log "================================================================================"
console.log jsdom
console.log highcharts

console.log __dirname

fs.readFile(__dirname + "/batman-logo.svg")
  .then(svg2png)
  .then(  (buffer) => fs.writeFile(__dirname + "/dest.png", buffer) )
  .catch( (e) => console.error(e) )
