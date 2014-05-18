// skeleton for web page scraping script
var io = require("cheerio");
var req = require("request");

process.argv.slice(2).forEach(function(val, index, array) {
    console.log("requesting " + val);
    req(val, function(err, res, body) {
        if (err) {
            throw err;
        }

        if (res.statusCode == 200) {
            var $ = io.load(body);
            // do any work using $
        } else {
            console.log(res.statusCode);
        }
    });
});

