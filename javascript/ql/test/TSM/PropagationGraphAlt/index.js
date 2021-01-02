const express = require('express');
const fs = require('fs');
const path = require('path');

const app = express();
const port = 3000;

app.use(express.json());

const appDir = process.env.APP_PATH;
console.log(`Using appDir=[${appDir}]`);

// For every example:
// req acts as source, and (parameter 0 (member writeFile (root fs))) as sink

app.post('/simple-aliasing-case', (req, res) => {
    var resolvedPath =  path.join(appDir, req.body.path);
    fs.writeFile(resolvedPath, req.body.contents, (err) => {
        if (err) {
            res.sendStatus(500);
        } else {
            res.sendStatus(200);
        }
    });
});

app.post('/two-vars-aliasing', (req, res) => {
    var resolvedPath =  path.join(appDir, req.body.path);
    var alisedResolvedPath = resolvedPath;
    fs.writeFile(alisedResolvedPath, req.body.contents, (err) => {
        if (err) {
            res.sendStatus(500);
        } else {
            res.sendStatus(200);
        }
    });
});

app.post('/object-field-aliasing', (req, res) => {
    var resolvedPath =  path.join(appDir, req.body.path);
    var containerObject = {};
    containerObject.taintedField = resolvedPath;
    fs.writeFile(containerObject.taintedField, req.body.contents, (err) => {
        if (err) {
            res.sendStatus(500);
        } else {
            res.sendStatus(200);
        }
    });
});

app.post('/object-field-aliasing-with-custom-new-object-from-method', (req, res) => {
    var resolvedPath =  path.join(appDir, req.body.path);
    var containerObject = createNewEmptyObject();
    containerObject.taintedField = resolvedPath;
    fs.writeFile(containerObject.taintedField, req.body.contents, (err) => {
        if (err) {
            res.sendStatus(500);
        } else {
            res.sendStatus(200);
        }
    });
});

app.post('/object-field-aliasing-with-new-object-from-method', (req, res) => {
    var resolvedPath =  path.join(appDir, req.body.path);
    var containerObject = new Object();
    containerObject.taintedField = resolvedPath;
    fs.writeFile(containerObject.taintedField, req.body.contents, (err) => {
        if (err) {
            res.sendStatus(500);
        } else {
            res.sendStatus(200);
        }
    });
});

app.post('/object-field-aliasing-on-init', (req, res) => {
    var resolvedPath =  path.join(appDir, req.body.path);
    var containerObject = {
        taintedField: resolvedPath,
    };
    fs.writeFile(containerObject.taintedField, req.body.contents, (err) => {
        if (err) {
            res.sendStatus(500);
        } else {
            res.sendStatus(200);
        }
    });
});

app.post('/object-field-aliasing-with-var-in-the-middle', (req, res) => {
    var resolvedPath =  path.join(appDir, req.body.path);
    var containerObject = {};
    containerObject.taintedField = resolvedPath;
    var aliasedVar = containerObject.taintedField;
    fs.writeFile(aliasedVar, req.body.contents, (err) => {
        if (err) {
            res.sendStatus(500);
        } else {
            res.sendStatus(200);
        }
    });
});

app.post('/object-field-aliasing-with-tainted-assignment-to-field', (req, res) => {
    var containerObject = {};
    containerObject.taintedField = path.join(appDir, req.body.path);
    var aliasedVar = containerObject.taintedField;
    fs.writeFile(aliasedVar, req.body.contents, (err) => {
        if (err) {
            res.sendStatus(500);
        } else {
            res.sendStatus(200);
        }
    });
});

app.listen(port, () => {
    console.log(`Application listenting on port ${port}...`);
});

function createNewEmptyObject() {
    return {};
}
