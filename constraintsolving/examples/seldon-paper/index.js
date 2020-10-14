/**
 * Toy sample based on Fib 2.a of Seldon paper
 * Translated from python to javascript and adapted for using express library
 * There is SeldonCustimization.qll includes a class to include arguments to fs.write as sinks
 * The query Seldon.ql doesn't recognize any sanitizer
 * The boosted query SeldonTSM.ql recognizes sanitizePath as sanitizer and remove one false positive
 * TO-DO: See if the sinks could be also boosted 
 */

const express = require('express');
const fs = require('fs');
const path = require('path');

const app = express();
const port = 3000;

app.use(express.json());

const appDir = process.env.APP_PATH;
console.log(`Using appDir=[${appDir}]`);

// Should report warning 
app.post('/unsanitized', (req, res) => {
    console.log(req.body);
    // line 12 Fig 2.a req.body.path is pretending `request.files['f'].filename` on paper
    var resolvedPath =  path.join(appDir, req.body.path);
    // line 14 Fig 2.a req.body.contents is pretending request.files['f'] 
    fs.writeFile(resolvedPath, req.body.contents, (err) => {
        if (err) {
            res.sendStatus(500);
        } else {
            res.sendStatus(200);
        }
    });
});

// Should not report warning 
app.post('/sanitized', (req, res) => {
    console.log(req.body);
    // line 12 Fig 2.a req.body.path is pretending `request.files['f'].filename` on paper
    var resolvedPath =  path.join(appDir, req.body.path);
    // line 13 Fig 2.a secure filename(filename)
    resolvedPath = sanitizePath(resolvedPath);
    // line 14 Fig 2.a req.body.contents is pretending request.files['f'] 
    fs.writeFile(resolvedPath, req.body.contents, (err) => {
        if (err) {
            res.sendStatus(500);
        } else {
            res.sendStatus(200);
        }
    });
});

// Dummy method to mark as known sanitizer in the query
function sanitizePath(path) {
    return path;
}

app.listen(port, () => {
    console.log(`Application listenting on port ${port}...`);
});

