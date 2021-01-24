const express = require('express');
const fs = require('fs');
const path = require('path');

const app = express();
const port = 3000;

app.use(express.json());

const appDir = process.env.APP_PATH;
console.log(`Using appDir=[${appDir}]`);

// For every example:
// req acts as source, and (parameter 0 (member writeFile (require fs))) as sink

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

// Tests simple interprocedural use case
function doWriteToFile(path, contents) {
    fs.writeFile(path, contents, (err) => {console.log(err)});
}

app.post('/test1', (req, res) => {
    var containerObject = {};
    containerObject.taintedField = path.join(appDir, req.body.path);
    var aliasedVar = containerObject.taintedField;
    // Sink method is called in the called function
    doWriteToFile(aliasedVar, req.body.contents);
});

// Tests interprocedural use case with object method
function OffendingWriter() {
    this.write = function(path, contents) {
        fs.writeFile(path, contents, (err) => {console.log(err)});
    }
}

app.post('/test2', (req, res) => {
    var writer = new OffendingWriter();
    var containerObject = {};
    containerObject.taintedField = path.join(appDir, req.body.path);
    var aliasedVar = containerObject.taintedField;
    // Sink method is called in the called function
    writer.write(aliasedVar, req.body.contents);
});

// Tests interprocedural use case with callback containing offending sink, and dispatcher object

function FileWriteDispatcher(callback) {
    this.callback = callback;
    this.dispatch = function(path, contents) {
        this.callback(path, contents);
    }
}

app.post('/test3', (req, res) => {
    var writer = new OffendingWriter();
    var dispatcher = new FileWriteDispatcher(writer.write);
    var containerObject = {};
    containerObject.taintedField = path.join(appDir, req.body.path);
    var aliasedVar = containerObject.taintedField;
    // Sink method is called in the called function
    dispatcher.dispatch(aliasedVar, req.body.contents);
});

// Tests interprocedural with method dictionary as driver
// The idea is to mimic a driver based implementation, who is responsible for having the actual implementation
// of the wrapped method. See https://github.com/baseprime/dynamodb/blob/master/lib/table.js#L64 for an example.
function DriverBasedWriter(driver) {
    this.driver = driver;
}
DriverBasedWriter.prototype.write = function(path, contents) {
    this.driver["write"].call(driver, path, contents);
}

function NonOffendingWriter() {}
NonOffendingWriter.prototype.write = function(path, contents) {}

// Using offending implementation
app.post('/test4.1', (req, res) => {
    var writer = new DriverBasedWriter(new OffendingWriter());
    var containerObject = {};
    containerObject.taintedField = path.join(appDir, req.body.path);
    var aliasedVar = containerObject.taintedField;
    // Sink method is called in the called function
    writer.write(aliasedVar, req.body.contents);
});

// Using non-offending implementation
app.post('/test4.2', (req, res) => {
    var writer = new DriverBasedWriter(new NonOffendingWriter());
    var containerObject = {};
    containerObject.taintedField = path.join(appDir, req.body.path);
    var aliasedVar = containerObject.taintedField;
    // Sink method is called in the called function
    writer.write(aliasedVar, req.body.contents);
});

app.listen(port, () => {
    console.log(`Application listenting on port ${port}...`);
});

function createNewEmptyObject() {
    return {};
}
