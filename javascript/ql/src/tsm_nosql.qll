
import javascript
private import semmle.javascript.dataflow.Portals

module TSM{

    predicate isSink(DataFlow::Node node, float score){
        exists(rep(node)) and
        score = sum(getReprScore(rep(node), "snk"))/count(rep(node))
    }

    predicate isSource(DataFlow::Node node, float score){
        exists(rep(node)) and
        score = sum(getReprScore(rep(node), "src"))/count(rep(node))
    }

    predicate isSanitizer(DataFlow::Node node, float score){
        exists(rep(node)) and
        score = sum(getReprScore(rep(node), "san"))/count(rep(node))
    }

    private string rep(DataFlow::Node nd) {
        exists(Portal p | nd = p.getAnExitNode(_) or nd = p.getAnEntryNode(_) |
          exists(int i, string prefix |
            prefix = p.getBasePortal(i).toString() and
            result = p.toString().replaceAll(prefix, "*") and
            // ensure the suffix isn't entirely composed of `parameter` and `return` steps
            result.regexpMatch(".*\\((global|member|root).*")
          )
          or
          result = p.toString()
        )
    }

    float getReprScore(string repr, string t){
        repr = "(member email *)" and t = "src" and result = 1.0 or 
        repr = "(member username *)" and t = "src" and result = 1.0 or 
        repr = "(member title *)" and t = "src" and result = 1.0 or 
        repr = "(member key *)" and t = "src" and result = 1.0 or 
        repr = "(parameter 0 (parameter 1 (member get (return *))))" and t = "snk" and result = 1.0 or 
        repr = "(parameter 0 (parameter 1 (member get *)))" and t = "snk" and result = 0.5 or 
        repr = "(member avatar *)" and t = "src" and result = 1.0 or 
        repr = "(parameter 0 (member defineProperty (member Object (global))))" and t = "snk" and result = 1.0 or 
        repr = "(parameter 0 (member defineProperty *))" and t = "snk" and result = 0.375 or 
        repr = "(member length (return (member keys (member Object (global)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member keys (member Object *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member keys *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (return *))" and t = "san" and result = 1.0 or 
        repr = "(member length *)" and t = "san" and result = 1.0 or 
        repr = "(return (member create (member Object *)))" and t = "src" and result = 0.125 or 
        repr = "(return (member create *))" and t = "src" and result = 0.75 or 
        repr = "(member name (global))" and t = "src" and result = 1.0 or 
        repr = "(member name *)" and t = "src" and result = 1.0 or 
        repr = "(return (member replace *))" and t = "san" and result = 1.0 or 
        repr = "(return (member data *))" and t = "src" and result = 0.125 or 
        repr = "(member length (instance *))" and t = "san" and result = 1.0 or 
        repr = "(return (member createElement (member document (global))))" and t = "san" and result = 0.75 or 
        repr = "(parameter 0 (member test (instance (member RegExp *))))" and t = "snk" and result = 0.75 or 
        repr = "(parameter 0 (member test (return (member RegExp (global)))))" and t = "snk" and result = 0.8 or 
        repr = "(parameter 0 (member test *))" and t = "snk" and result = 0.2 or 
        repr = "(member pathname *)" and t = "san" and result = 1.0 or 
        repr = "(return (member join (return *)))" and t = "src" and result = 1.0 or 
        repr = "(return (member join *))" and t = "src" and result = 0.45 or 
        repr = "(member id (member params (parameter 0 (parameter 1 *))))" and t = "src" and result = 1.0 or 
        repr = "(member id (member params (parameter 0 *)))" and t = "src" and result = 1.0 or 
        repr = "(member id (member params *))" and t = "src" and result = 1.0 or 
        repr = "(member id *)" and t = "src" and result = 1.0 or 
        repr = "(member status *)" and t = "src" and result = 1.0 or 
        repr = "(member id (member params (parameter 0 (parameter 1 (member delete (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
        repr = "(member id (member params (parameter 0 (parameter 1 (member delete (return (member Router *)))))))" and t = "src" and result = 1.0 or 
        repr = "(member id (member params (parameter 0 (parameter 1 (member delete (return *))))))" and t = "src" and result = 1.0 or 
        repr = "(member id (member params (parameter 0 (parameter 1 (member delete *)))))" and t = "src" and result = 1.0 or 
        repr = "(parameter 0 (member find *))" and t = "snk" and result = 1.0 or 
        repr = "(parameter 0 (member map *))" and t = "snk" and result = 0.682099 or 
        repr = "(member length (parameter 0 *))" and t = "san" and result = 1.0 or 
        repr = "(return (member slice (parameter 0 *)))" and t = "src" and result = 0.5 or 
        repr = "(parameter 0 (member get *))" and t = "src" and result = 0.75 or 
        repr = "(parameter 0 (member matches *))" and t = "snk" and result = 0.208333 or 
        repr = "(parameter 0 (member error *))" and t = "src" and result = 0.5 or 
        repr = "(parameter 0 (member appendChild (return (member getElementById (member document (global))))))" and t = "snk" and result = 1.0 or 
        repr = "(parameter 0 (member appendChild (return (member getElementById (member document *)))))" and t = "snk" and result = 1.0 or 
        repr = "(parameter 0 (member appendChild (return (member getElementById *))))" and t = "snk" and result = 0.25 or 
        repr = "(parameter 0 (member appendChild *))" and t = "snk" and result = 0.25 or 
        repr = "(return (member getElementById (member document (global))))" and t = "san" and result = 1.0 or 
        repr = "(return (member getElementById (member document *)))" and t = "san" and result = 0.5 or 
        repr = "(member body *)" and t = "src" and result = 1.0 or 
        repr = "(parameter 0 (member find (return (member model (root https://www.npmjs.com/package/mongoose)))))" and t = "snk" and result = 1.0 or 
        repr = "(parameter 0 (member find (return (member model *))))" and t = "snk" and result = 1.0 or 
        repr = "(parameter 0 (member find (return *)))" and t = "snk" and result = 1.0 or 
        repr = "(member pathname (member location (global)))" and t = "san" and result = 1.0 or 
        repr = "(member pathname (member location (member window (global))))" and t = "san" and result = 1.0 or 
        repr = "(member pathname (member location (member window *)))" and t = "san" and result = 1.0 or 
        repr = "(member pathname (member location *))" and t = "san" and result = 1.0 or 
        repr = "(member zone *)" and t = "src" and result = 1.0 or 
        repr = "(member zone (member query (parameter 0 (parameter 0 (member get (return (member route (return (member Router (root https://www.npmjs.com/package/express))))))))))" and t = "src" and result = 1.0 or 
        repr = "(member zone (member query (parameter 0 (parameter 0 (member get (return (member route (return (member Router *)))))))))" and t = "src" and result = 1.0 or 
        repr = "(member zone (member query (parameter 0 (parameter 0 (member get (return (member route (return *))))))))" and t = "src" and result = 1.0 or 
        repr = "(member zone (member query (parameter 0 (parameter 0 (member get (return (member route *)))))))" and t = "src" and result = 1.0 or 
        repr = "(member zone (member query (parameter 0 (parameter 0 (member get (return *))))))" and t = "src" and result = 1.0 or 
        repr = "(member zone (member query (parameter 0 (parameter 0 (member get *)))))" and t = "src" and result = 1.0 or 
        repr = "(member zone (member query (parameter 0 (parameter 0 *))))" and t = "src" and result = 1.0 or 
        repr = "(member zone (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
        repr = "(member zone (member query *))" and t = "src" and result = 1.0 or 
        repr = "(return (member call *))" and t = "san" and result = 0.135802 or 
        repr = "(parameter 0 (member exec (instance *)))" and t = "snk" and result = 0.75 or 
        repr = "(parameter 0 (member exec (return (member RegExp *))))" and t = "snk" and result = 1.0 or 
        repr = "(return (member stringify (member JSON (global))))" and t = "src" and result = 0.875 or 
        repr = "(return (member stringify (member JSON (global))))" and t = "san" and result = 0.75 or 
        repr = "(parameter 1 (member call *))" and t = "snk" and result = 0.25 or 
        repr = "(parameter 0 (member escapeExpression (parameter 0 (member main (parameter 0 (member template *))))))" and t = "snk" and result = 0.75 or 
        repr = "(parameter 0 (member escapeExpression *))" and t = "snk" and result = 1.0 or 
        repr = "(member length (instance (parameter 0 (member defineProperty (member Object (global))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (parameter 0 (member defineProperty (member Object *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (parameter 0 (member defineProperty *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (parameter 0 *)))" and t = "san" and result = 1.0 or 
        repr = "(member data *)" and t = "src" and result = 1.0 or 
        repr = "(return (member extend *))" and t = "san" and result = 0.75 or 
        repr = "(parameter 0 (member setValue *))" and t = "snk" and result = 0.1 or 
        repr = "(return (member replace (return *)))" and t = "san" and result = 1.0 or 
        repr = "(return (member data (return (member jQuery (member window (global))))))" and t = "src" and result = 1.0 or 
        repr = "(return (member data (return (member jQuery (member window *)))))" and t = "src" and result = 0.375 or 
        repr = "(parameter 2 (member extend *))" and t = "snk" and result = 1.0 or 
        repr = "(member message *)" and t = "src" and result = 1.0 or 
        repr = "(member port *)" and t = "san" and result = 1.0 or 
        repr = "(member hash (member location *))" and t = "san" and result = 1.0 or 
        repr = "(member hash *)" and t = "san" and result = 1.0 or 
        repr = "(return (member encodeURIComponent (global)))" and t = "san" and result = 1.0 or 
        repr = "(return (member encodeURIComponent *))" and t = "san" and result = 1.0 or 
        repr = "(parameter 0 (parameter 1 (member addEventListener *)))" and t = "src" and result = 1.0 or 
        repr = "(parameter 0 (parameter 1 (member addEventListener (global))))" and t = "src" and result = 1.0 or 
        repr = "(parameter 0 (parameter 1 (member addEventListener (member window (global)))))" and t = "src" and result = 1.0 or 
        repr = "(parameter 0 (parameter 1 (member addEventListener (member window *))))" and t = "src" and result = 1.0 or 
        repr = "(parameter 0 (member get (return *)))" and t = "src" and result = 0.75 or 
        repr = "(return (member replace (return (member replace (return *)))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (return (member replace *))))" and t = "san" and result = 1.0 or 
        repr = "(member origin *)" and t = "src" and result = 1.0 or 
        repr = "(parameter 0 (member removeChild *))" and t = "snk" and result = 0.25 or 
        repr = "(member hash (member location (global)))" and t = "san" and result = 1.0 or 
        repr = "(member hash (member location (member window (global))))" and t = "san" and result = 1.0 or 
        repr = "(member hash (member location (member window *)))" and t = "san" and result = 1.0 or 
        repr = "(parameter 2 (member extend (parameter 0 *)))" and t = "snk" and result = 1.0 or 
        repr = "(member token *)" and t = "src" and result = 1.0 or 
        repr = "(return (member substring (return *)))" and t = "san" and result = 0.3 or 
        repr = "(member sort (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
        repr = "(member sort (member query *))" and t = "src" and result = 1.0 or 
        repr = "(member sort *)" and t = "src" and result = 1.0 or 
        repr = "(member body (parameter 0 (parameter 1 (member post (return (member Router (root https://www.npmjs.com/package/express)))))))" and t = "src" and result = 1.0 or 
        repr = "(member body (parameter 0 (parameter 1 (member post (return (member Router *))))))" and t = "src" and result = 1.0 or 
        repr = "(member body (parameter 0 (parameter 1 (member post (return *)))))" and t = "src" and result = 1.0 or 
        repr = "(member body (parameter 0 (parameter 1 (member post *))))" and t = "src" and result = 1.0 or 
        repr = "(member body (parameter 0 (parameter 1 *)))" and t = "src" and result = 1.0 or 
        repr = "(member body (parameter 0 *))" and t = "src" and result = 1.0 or 
        repr = "(member length (instance (member eq (member fn (member constructor (member fn (return (parameter 2 (member define (global))))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member eq (member fn (member constructor (member fn (return (parameter 2 (member define *)))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member eq (member fn (member constructor (member fn (return (parameter 2 *))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member eq (member fn (member constructor (member fn (return *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member eq (member fn (member constructor (member fn *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member eq (member fn (member constructor *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member eq (member fn (return (member noConflict (return (parameter 2 (member define (global))))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member eq (member fn (return (member noConflict (return (parameter 2 (member define *)))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member eq (member fn (return (member noConflict (return (parameter 2 *))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member eq (member fn (return (member noConflict (return *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member eq (member fn (return (member noConflict *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member eq (member fn (return (parameter 2 (member define (global))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member eq (member fn (return (parameter 2 (member define *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member eq (member fn (return (parameter 2 *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member eq (member fn (return *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member eq (member fn *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member eq *)))" and t = "san" and result = 1.0 or 
        repr = "(return (member getAttribute (parameter 0 *)))" and t = "san" and result = 0.3 or 
        repr = "(return (member replace (return (member getAttribute (parameter 1 (member find (return (parameter 2 (member define (global))))))))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (return (member getAttribute (parameter 1 (member find (return (parameter 2 (member define *)))))))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (return (member getAttribute (parameter 1 (member find (return (parameter 2 *))))))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (return (member getAttribute (parameter 1 (member find (return *)))))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (return (member getAttribute (parameter 1 (member find *))))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (return (member getAttribute (parameter 1 *)))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (return (member getAttribute *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member length (member length (member length (member length (member length (member length (return (member RegExp (global))))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member length (member length (member length (member length (member length (member length (return (member RegExp *)))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member length (member length (member length (member length (member length (member length (return *))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member length (member length (member length (member length (member length (member length *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member length (member length (member length (member length (member length (return (member RegExp (global)))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member length (member length (member length (member length (member length (return (member RegExp *))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member length (member length (member length (member length (member length (return *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member length (member length (member length (member length (member length *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member length (member length (member length (member length (return (member RegExp (global))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member length (member length (member length (member length (return (member RegExp *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member length (member length (member length (member length (return *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member length (member length (member length (member length *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member length (member length (member length (return (member RegExp (global)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member length (member length (member length (return (member RegExp *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member length (member length (member length (return *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member length (member length (member length *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member length (member length (return (member RegExp (global))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member length (member length (return (member RegExp *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member length (member length (return *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member length (member length *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (member length (return (member RegExp (global)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member length (return (member RegExp *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member length (return *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (member length *))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member RegExp (global))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member RegExp *)))" and t = "san" and result = 1.0 or 
        repr = "(parameter 0 (member matchesSelector *))" and t = "snk" and result = 0.85 or 
        repr = "(parameter 0 (member uniqueSort *))" and t = "src" and result = 0.0833333 or 
        repr = "(member length (parameter 0 (member tokenize *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member slice (parameter 0 (member tokenize *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member slice (parameter 0 *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member slice *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member compile (member find (member constructor (member fn (return (parameter 2 (member define (global))))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member compile (member find (member constructor (member fn (return (parameter 2 (member define *)))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member compile (member find (member constructor (member fn (return (parameter 2 *))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member compile (member find (member constructor (member fn (return *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member compile (member find (member constructor (member fn *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member compile (member find (member constructor *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member compile (member find (return (member noConflict (return (parameter 2 (member define (global))))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member compile (member find (return (member noConflict (return (parameter 2 (member define *)))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member compile (member find (return (member noConflict (return (parameter 2 *))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member compile (member find (return (member noConflict (return *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member compile (member find (return (member noConflict *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member compile (member find (return (parameter 2 (member define (global))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member compile (member find (return (parameter 2 (member define *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member compile (member find (return (parameter 2 *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member compile (member find (return *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member compile (member find *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member compile *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 *))" and t = "san" and result = 1.0 or 
        repr = "(member selector *)" and t = "src" and result = 0.0625 or 
        repr = "(parameter 0 (member filter *))" and t = "src" and result = 0.25 or 
        repr = "(member length (member undefined (global)))" and t = "san" and result = 1.0 or 
        repr = "(member length (member undefined *))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member access (member constructor (member fn (return (parameter 2 (member define (global)))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member access (member constructor (member fn (return (parameter 2 (member define *))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member access (member constructor (member fn (return (parameter 2 *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member access (member constructor (member fn (return *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member access (member constructor (member fn *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member access (member constructor *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member access (return (member noConflict (return (parameter 2 (member define (global)))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member access (return (member noConflict (return (parameter 2 (member define *))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member access (return (member noConflict (return (parameter 2 *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member access (return (member noConflict (return *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member access (return (member noConflict *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member access (return (parameter 2 (member define (global)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member access (return (parameter 2 (member define *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member access (return (parameter 2 *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member access (return *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member access *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member match (parameter 1 (member add (member event (return (parameter 2 (member define (global))))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member match (parameter 1 (member add (member event (return (parameter 2 (member define *)))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member match (parameter 1 (member add (member event (return (parameter 2 *))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member match (parameter 1 (member add (member event (return *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member match (parameter 1 (member add (member event *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member match (parameter 1 (member add *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member match (parameter 1 *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member match *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member match (parameter 1 (member remove (member event (return (parameter 2 (member define (global))))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member match (parameter 1 (member remove (member event (return (parameter 2 (member define *)))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member match (parameter 1 (member remove (member event (return (parameter 2 *))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member match (parameter 1 (member remove (member event (return *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member match (parameter 1 (member remove (member event *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member match (parameter 1 (member remove *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member props (instance (member fix (member event (return (parameter 2 (member define (global)))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member props (instance (member fix (member event (return (parameter 2 (member define *))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member props (instance (member fix (member event (return (parameter 2 *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member props (instance (member fix (member event (return *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member props (instance (member fix (member event *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member props (instance (member fix *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member props (instance *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (member props *))" and t = "san" and result = 1.0 or 
        repr = "(parameter 0 (member map (parameter 0 *)))" and t = "snk" and result = 1.0 or 
        repr = "(member length (parameter 0 (member collect (member exports (global)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member collect (member exports *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member collect (parameter 1 (instance (member Function (global)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member collect (parameter 1 (instance (member Function *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member collect (parameter 1 (instance *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member collect (parameter 1 (return (member Function (global)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member collect (parameter 1 (return (member Function *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member collect (parameter 1 (return *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member collect (parameter 1 *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member collect (parameter 2 (member call (instance (member Function (global))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member collect (parameter 2 (member call (instance (member Function *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member collect (parameter 2 (member call (instance *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member collect (parameter 2 (member call (return (member Function (global))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member collect (parameter 2 (member call (return (member Function *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member collect (parameter 2 (member call (return *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member collect (parameter 2 (member call *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member collect (parameter 2 *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member collect *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member map (member exports (global)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member map (member exports *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member map (parameter 1 (instance (member Function (global)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member map (parameter 1 (instance (member Function *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member map (parameter 1 (instance *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member map (parameter 1 (return (member Function (global)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member map (parameter 1 (return (member Function *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member map (parameter 1 (return *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member map (parameter 1 *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member map (parameter 2 (member call (instance (member Function (global))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member map (parameter 2 (member call (instance (member Function *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member map (parameter 2 (member call (instance *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member map (parameter 2 (member call (return (member Function (global))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member map (parameter 2 (member call (return (member Function *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member map (parameter 2 (member call (return *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member map (parameter 2 (member call *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member map (parameter 2 *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member map *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member collect (member exports (global)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member collect (member exports *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member collect (parameter 1 (instance (member Function (global)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member collect (parameter 1 (instance (member Function *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member collect (parameter 1 (instance *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member collect (parameter 1 (return (member Function (global)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member collect (parameter 1 (return (member Function *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member collect (parameter 1 (return *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member collect (parameter 1 *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member collect (parameter 2 (member call (instance (member Function (global))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member collect (parameter 2 (member call (instance (member Function *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member collect (parameter 2 (member call (instance *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member collect (parameter 2 (member call (return (member Function (global))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member collect (parameter 2 (member call (return (member Function *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member collect (parameter 2 (member call (return *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member collect (parameter 2 (member call *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member collect (parameter 2 *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member collect *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member map (member exports (global)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member map (member exports *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member map (parameter 1 (instance (member Function (global)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member map (parameter 1 (instance (member Function *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member map (parameter 1 (instance *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member map (parameter 1 (return (member Function (global)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member map (parameter 1 (return (member Function *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member map (parameter 1 (return *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member map (parameter 1 *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member map (parameter 2 (member call (instance (member Function (global))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member map (parameter 2 (member call (instance (member Function *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member map (parameter 2 (member call (instance *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member map (parameter 2 (member call (return (member Function (global))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member map (parameter 2 (member call (return (member Function *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member map (parameter 2 (member call (return *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member map (parameter 2 (member call *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member map (parameter 2 *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member map *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member indexOf (member exports (global)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member indexOf (member exports *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member indexOf (parameter 1 (instance (member Function (global)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member indexOf (parameter 1 (instance (member Function *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member indexOf (parameter 1 (instance *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member indexOf (parameter 1 (return (member Function (global)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member indexOf (parameter 1 (return (member Function *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member indexOf (parameter 1 (return *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member indexOf (parameter 1 *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member indexOf (parameter 2 (member call (instance (member Function (global))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member indexOf (parameter 2 (member call (instance (member Function *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member indexOf (parameter 2 (member call (instance *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member indexOf (parameter 2 (member call (return (member Function (global))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member indexOf (parameter 2 (member call (return (member Function *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member indexOf (parameter 2 (member call (return *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member indexOf (parameter 2 (member call *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member indexOf (parameter 2 *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member indexOf *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member lastIndexOf (member exports (global)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member lastIndexOf (member exports *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member lastIndexOf (parameter 1 (instance (member Function (global)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member lastIndexOf (parameter 1 (instance (member Function *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member lastIndexOf (parameter 1 (instance *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member lastIndexOf (parameter 1 (return (member Function (global)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member lastIndexOf (parameter 1 (return (member Function *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member lastIndexOf (parameter 1 (return *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member lastIndexOf (parameter 1 *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member lastIndexOf (parameter 2 (member call (instance (member Function (global))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member lastIndexOf (parameter 2 (member call (instance (member Function *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member lastIndexOf (parameter 2 (member call (instance *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member lastIndexOf (parameter 2 (member call (return (member Function (global))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member lastIndexOf (parameter 2 (member call (return (member Function *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member lastIndexOf (parameter 2 (member call (return *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member lastIndexOf (parameter 2 (member call *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member lastIndexOf (parameter 2 *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member lastIndexOf *)))" and t = "san" and result = 1.0 or 
        repr = "(member userID *)" and t = "src" and result = 1.0 or 
        repr = "(return (member getData *))" and t = "src" and result = 0.15 or 
        repr = "(member jugend *)" and t = "src" and result = 1.0 or 
        repr = "(member id (member query (parameter 0 (parameter 1 *))))" and t = "src" and result = 1.0 or 
        repr = "(member id (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
        repr = "(member id (member query *))" and t = "src" and result = 1.0 or 
        repr = "(member index *)" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member jQuery (global))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member jQuery *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member getElementsByTagName *)))" and t = "san" and result = 1.0 or 
        repr = "(member innerHTML *)" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member map (parameter 0 (parameter 1 (member define (global)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member map (parameter 0 (parameter 1 (member define *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member map (parameter 0 (parameter 1 *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member map (parameter 0 *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member props (instance (member fix (member event (member jQuery (global)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member props (instance (member fix (member event (member jQuery *))))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (parameter 0 *)))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (return (member replace (parameter 0 *)))))" and t = "src" and result = 1.0 or 
        repr = "(parameter 0 (member querySelectorAll (parameter 1 (member find (member jQuery (global))))))" and t = "snk" and result = 0.935918 or 
        repr = "(parameter 0 (member querySelectorAll (parameter 1 (member find (member jQuery *)))))" and t = "snk" and result = 1.0 or 
        repr = "(member length (instance (member init (member fn (member jQuery (global))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member init (member fn (member jQuery *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member init (member fn *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member init *)))" and t = "san" and result = 1.0 or 
        repr = "(member innerHTML (parameter 0 *))" and t = "san" and result = 1.0 or 
        repr = "(member length (member props (instance (member fix (member event (member constructor (member fn (member jQuery (global)))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member props (instance (member fix (member event (member constructor (member fn (member jQuery *))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member props (instance (member fix (member event (member constructor (member fn *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member props (instance (member fix (member event (member constructor *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member props (instance (member fix (member event (member jQuery (parameter 0 (member call (member eval (global))))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member props (instance (member fix (member event (member jQuery (parameter 0 (member call (member eval *)))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member props (instance (member fix (member event (member jQuery (parameter 0 (member call *))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member props (instance (member fix (member event (member jQuery (parameter 0 *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member concat (member props (instance (member fix (member event (member jQuery (global)))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member concat (member props (instance (member fix (member event (member jQuery *))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member concat (member props (instance (member fix (member event *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member concat (member props (instance (member fix *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member concat (member props (instance *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member concat (member props *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member concat *)))" and t = "san" and result = 1.0 or 
        repr = "(return (member toLowerCase (member nodeName (parameter 0 *))))" and t = "san" and result = 0.45 or 
        repr = "(return (member replace (return (member getAttribute (member document (global))))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (return (member getAttribute (member document (member window (global)))))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (return (member getAttribute (member document (member window *))))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (return (member getAttribute (member document *)))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (return (member getAttribute (member ownerDocument (parameter 0 (member setDocument *)))))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (return (member getAttribute (member ownerDocument (parameter 0 *))))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (return (member getAttribute (member ownerDocument *)))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (return (member getAttribute (parameter 0 (member setDocument *))))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (return (member getAttribute (parameter 0 *)))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (return (member getAttribute (parameter 1 (member find (member constructor (member fn (member jQuery (global))))))))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (return (member getAttribute (parameter 1 (member find (member constructor (member fn (member jQuery *)))))))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (return (member getAttribute (parameter 1 (member find (member constructor (member fn *))))))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (return (member getAttribute (parameter 1 (member find (member constructor *)))))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (return (member getAttribute (parameter 1 (member find (member jQuery (global))))))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (return (member getAttribute (parameter 1 (member find (member jQuery *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member split *)))" and t = "san" and result = 1.0 or 
        repr = "(member role *)" and t = "src" and result = 1.0 or 
        repr = "(member department *)" and t = "src" and result = 1.0 or 
        repr = "(parameter 1 (member setStyle *))" and t = "src" and result = 0.15 or 
        repr = "(return (member replace (return (member replace (parameter 1 *)))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (parameter 0 (member processHTML (parameter 1 (member create (member tinymce (global))))))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (parameter 0 (member processHTML (parameter 1 (member create (member tinymce *)))))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (parameter 0 (member processHTML (parameter 1 (member create *))))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (parameter 0 (member processHTML (parameter 1 *)))))" and t = "san" and result = 1.0 or 
        repr = "(return (member replace (parameter 0 (member processHTML *))))" and t = "san" and result = 1.0 or 
        repr = "(return (member encode *))" and t = "san" and result = 1.0 or 
        repr = "(parameter 0 (member writeStartElement *))" and t = "snk" and result = 0.2 or 
        repr = "(parameter 0 (member writeAttribute *))" and t = "snk" and result = 0.216667 or 
        repr = "(member content (return *))" and t = "src" and result = 0.7 or 
        repr = "(member content (return *))" and t = "snk" and result = 0.6 or 
        repr = "(parameter 0 (member push (member items *)))" and t = "snk" and result = 0.6 or 
        repr = "(member length (member data (instance *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (member data *))" and t = "san" and result = 1.0 or 
        repr = "(member length (member data (instance (member Line (member Morris (global))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member data (instance (member Line (member Morris *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member data (instance (member Line *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member split (parameter 0 *))))" and t = "san" and result = 1.0 or 
        repr = "(member filter *)" and t = "src" and result = 1.0 or 
        repr = "(member length (return (member String (global))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member String *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (member body (parameter 0 *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (member body *))" and t = "san" and result = 1.0 or 
        repr = "(member hostname (member location *))" and t = "san" and result = 1.0 or 
        repr = "(member hostname *)" and t = "san" and result = 1.0 or 
        repr = "(member port (member location (global)))" and t = "san" and result = 1.0 or 
        repr = "(member port (member location *))" and t = "san" and result = 1.0 or 
        repr = "(parameter 1 (member emit (instance (parameter 0 (root https://www.npmjs.com/package/inherits)))))" and t = "snk" and result = 1.0 or 
        repr = "(parameter 1 (member emit (instance (parameter 0 *))))" and t = "snk" and result = 0.9 or 
        repr = "(parameter 1 (member update *))" and t = "snk" and result = 1.0 or 
        repr = "(member length (instance (member Buffer *)))" and t = "san" and result = 1.0 or 
        repr = "(member host *)" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member Buffer (global))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member Buffer (global))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member Buffer *)))" and t = "san" and result = 1.0 or 
        repr = "(parameter 0 (root https://www.npmjs.com/package/path-is-absolute))" and t = "snk" and result = 0.475 or 
        repr = "(member length (instance (member toString (instance (parameter 0 (member defineProperty (member Object (global))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member toString (instance (parameter 0 (member defineProperty (member Object *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member toString (instance (parameter 0 (member defineProperty *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member toString (instance (parameter 0 *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member toString (instance *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member toString *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member compare *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member write (instance (parameter 0 (member defineProperty (member Object (global))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member write (instance (parameter 0 (member defineProperty (member Object *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member write (instance (parameter 0 (member defineProperty *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member write (instance (parameter 0 *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member write (instance *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member write *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member copy (instance (parameter 0 (member defineProperty (member Object (global))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member copy (instance (parameter 0 (member defineProperty (member Object *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member copy (instance (parameter 0 (member defineProperty *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member copy (instance (parameter 0 *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member copy (instance *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (instance (member copy *)))" and t = "san" and result = 1.0 or 
        repr = "(return (member toUrl (parameter 1 *)))" and t = "src" and result = 1.0 or 
        repr = "(parameter 0 (member get (return (parameter 1 (member define *)))))" and t = "src" and result = 1.0 or 
        repr = "(member html *)" and t = "san" and result = 1.0 or 
        repr = "(return (member parseBlock *))" and t = "san" and result = 0.271605 or 
        repr = "(member callee *)" and t = "snk" and result = 0.135802 or 
        repr = "(member callee *)" and t = "san" and result = 0.135802 or 
        repr = "(member template (parameter 0 (parameter 0 (member forEach (return (member findTemplatesForKind (parameter 1 (parameter 1 (member define (global))))))))))" and t = "san" and result = 1.0 or 
        repr = "(member template (parameter 0 (parameter 0 (member forEach (return (member findTemplatesForKind (parameter 1 (parameter 1 (member define *)))))))))" and t = "san" and result = 1.0 or 
        repr = "(member template (parameter 0 (parameter 0 (member forEach (return (member findTemplatesForKind (parameter 1 (parameter 1 *))))))))" and t = "san" and result = 1.0 or 
        repr = "(member template (parameter 0 (parameter 0 (member forEach (return (member findTemplatesForKind (parameter 1 *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member template (parameter 0 (parameter 0 (member forEach (return (member findTemplatesForKind *))))))" and t = "san" and result = 1.0 or 
        repr = "(member template (parameter 0 (parameter 0 (member forEach (return *)))))" and t = "san" and result = 1.0 or 
        repr = "(member template (parameter 0 (parameter 0 (member forEach *))))" and t = "san" and result = 1.0 or 
        repr = "(member template (parameter 0 (parameter 0 *)))" and t = "san" and result = 1.0 or 
        repr = "(member template (parameter 0 *))" and t = "san" and result = 1.0 or 
        repr = "(member template *)" and t = "san" and result = 1.0 or 
        repr = "(member project *)" and t = "src" and result = 1.0 or 
        repr = "(member length (return (member getElementsByTagName (member document (global)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member getElementsByTagName (member document *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member items *))" and t = "san" and result = 1.0 or 
        repr = "(parameter 0 (member from (member Buffer (global))))" and t = "snk" and result = 1.0 or 
        repr = "(parameter 0 (member from (member Buffer *)))" and t = "snk" and result = 0.625 or 
        repr = "(parameter 1 (member update (return (member model (root https://www.npmjs.com/package/mongoose)))))" and t = "snk" and result = 1.0 or 
        repr = "(parameter 1 (member update (return (member model *))))" and t = "snk" and result = 1.0 or 
        repr = "(parameter 1 (member update (return *)))" and t = "snk" and result = 1.0 or 
        repr = "(member length (member children (parameter 0 *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (member children *))" and t = "san" and result = 1.0 or 
        repr = "(parameter 1 (member textbox (return (member jQuery *))))" and t = "snk" and result = 1.0 or 
        repr = "(member length (return (member children *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (member frozenColumns (member options (return (member data (member jQuery (global)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member frozenColumns (member options (return (member data (member jQuery *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member frozenColumns (member options (return (member data *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member frozenColumns (member options (return *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (member frozenColumns (member options *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (member frozenColumns *))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member jQuery (member window (global)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member jQuery (member window *))))" and t = "san" and result = 1.0 or 
        repr = "(parameter 0 (member setHtml *))" and t = "snk" and result = 0.1 or 
        repr = "(member length (member aoColumns (parameter 0 *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (member aoColumns *))" and t = "san" and result = 1.0 or 
        repr = "(return (member extend (parameter 0 (parameter 2 (member define (global))))))" and t = "san" and result = 1.0 or 
        repr = "(return (member extend (parameter 0 (parameter 2 (member define *)))))" and t = "san" and result = 1.0 or 
        repr = "(return (member extend (parameter 0 (parameter 2 *))))" and t = "san" and result = 1.0 or 
        repr = "(parameter 2 (member extend (parameter 0 (parameter 2 *))))" and t = "snk" and result = 0.5 or 
        repr = "(parameter 0 (member map (parameter 0 (parameter 2 (member define (global))))))" and t = "snk" and result = 0.817901 or 
        repr = "(member length (member points (instance *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (member points *))" and t = "san" and result = 1.0 or 
        repr = "(member length (member curDragNodes (global)))" and t = "san" and result = 1.0 or 
        repr = "(member length (member curDragNodes *))" and t = "san" and result = 1.0 or 
        repr = "(return (member getNodeCache (member data (member _z (member zTree (member fn (member jQuery (global))))))))" and t = "san" and result = 0.75 or 
        repr = "(return (member getNodeCache *))" and t = "san" and result = 1.0 or 
        repr = "(return (member encodeURI (global)))" and t = "san" and result = 1.0 or 
        repr = "(return (member encodeURI *))" and t = "san" and result = 1.0 or 
        repr = "(parameter 0 (parameter 1 (member addEventListener (member self (global)))))" and t = "src" and result = 1.0 or 
        repr = "(parameter 0 (parameter 1 (member addEventListener (member self *))))" and t = "src" and result = 1.0 or 
        repr = "(member length (parameter 0 (return *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member initialize (return *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 0 (member initialize *)))" and t = "san" and result = 1.0 or 
        repr = "(member filter (member query (parameter 0 (parameter 2 (member get (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
        repr = "(member filter (member query (parameter 0 (parameter 2 (member get (return (member Router *)))))))" and t = "src" and result = 1.0 or 
        repr = "(member filter (member query (parameter 0 (parameter 2 (member get (return *))))))" and t = "src" and result = 1.0 or 
        repr = "(member filter (member query (parameter 0 (parameter 2 (member get *)))))" and t = "src" and result = 1.0 or 
        repr = "(member filter (member query (parameter 0 (parameter 2 *))))" and t = "src" and result = 1.0 or 
        repr = "(member filter (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
        repr = "(member filter (member query *))" and t = "src" and result = 1.0 or 
        repr = "(member length (return (member get (return (member array (member lang (member wysihtml5 (global))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member get (return (member array (member lang (member wysihtml5 *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member get (return (member array (member lang *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member get (return (member array *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member get (return *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member get *)))" and t = "san" and result = 1.0 or 
        repr = "(member recordsTotal (parameter 0 (member send (parameter 1 (parameter 1 (member get (return (member Router (root https://www.npmjs.com/package/express)))))))))" and t = "san" and result = 1.0 or 
        repr = "(member recordsTotal (parameter 0 (member send (parameter 1 (parameter 1 (member get (return (member Router *))))))))" and t = "san" and result = 1.0 or 
        repr = "(member recordsTotal (parameter 0 (member send (parameter 1 (parameter 1 (member get (return *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member recordsTotal (parameter 0 (member send (parameter 1 (parameter 1 (member get *))))))" and t = "san" and result = 1.0 or 
        repr = "(member recordsTotal (parameter 0 (member send (parameter 1 (parameter 1 *)))))" and t = "san" and result = 1.0 or 
        repr = "(member recordsTotal (parameter 0 (member send (parameter 1 *))))" and t = "san" and result = 1.0 or 
        repr = "(member recordsTotal (parameter 0 (member send *)))" and t = "san" and result = 1.0 or 
        repr = "(member recordsTotal (parameter 0 *))" and t = "san" and result = 1.0 or 
        repr = "(member recordsTotal *)" and t = "san" and result = 1.0 or 
        repr = "(member thirdCategory *)" and t = "src" and result = 1.0 or 
        repr = "(member length (return (member match (member a (parameter 0 (return (member createSimpleLexer (member PR (global)))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member match (member a (parameter 0 (return (member createSimpleLexer (member PR *))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member match (member a (parameter 0 (return (member createSimpleLexer *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member match (member a (parameter 0 (return *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member match (member a (parameter 0 *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (return (member match (member a *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member createSimpleLexer (member PR (global)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member createSimpleLexer (member PR *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member createSimpleLexer (return (parameter 2 (member define (global)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member createSimpleLexer (return (parameter 2 (member define (member window (global))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member createSimpleLexer (return (parameter 2 (member define (member window *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member createSimpleLexer (return (parameter 2 (member define *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member createSimpleLexer (return (parameter 2 *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member createSimpleLexer (return *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member createSimpleLexer *)))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member registerLangHandler (member PR (global)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member registerLangHandler (member PR *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member registerLangHandler (return (parameter 2 (member define (global)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member registerLangHandler (return (parameter 2 (member define (member window (global))))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member registerLangHandler (return (parameter 2 (member define (member window *)))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member registerLangHandler (return (parameter 2 (member define *))))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member registerLangHandler (return (parameter 2 *)))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member registerLangHandler (return *))))" and t = "san" and result = 1.0 or 
        repr = "(member length (parameter 1 (member registerLangHandler *)))" and t = "san" and result = 1.0 or 
        repr = "(parameter 0 (member indexOf (member longname *)))" and t = "snk" and result = 1.0            
    }    
}