// Based on Fib 2.a of Seldon paper
// Adapted for using express library
const express = require('express');
const fs = require('fs');
const path = require('path');

const app = express();
const port = 3000;

app.use(express.json());

const appDir = process.env.APP_PATH;
console.log(`Using appDir=[${appDir}]`);

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

