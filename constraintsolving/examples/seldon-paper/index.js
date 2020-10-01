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
    var resolvedPath =  path.join(appDir, req.body.path);
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
    var resolvedPath =  path.join(appDir, req.body.path);
    resolvedPath = sanitizePath(resolvedPath);
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

