
import javascript
private import semmle.javascript.dataflow.Portals

module TSM3{

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
        repr = "(root https://www.npmjs.com/package/path)" and t = "src" and result = 0.2204526748971185 or 
repr = "(parameter 0 (parameter 0 (member forEach (return *))))" and t = "src" and result = 0.37500000000000155 or 
repr = "(member content *)" and t = "snk" and result = 0.46256515775034296 or 
repr = "(parameter 0 (member send *))" and t = "snk" and result = 0.25000000000000044 or 
repr = "(return (member trim *))" and t = "src" and result = 0.12500000000000022 or 
repr = "(return (member trim *))" and t = "san" and result = 0.25 or 
repr = "(member src (member query (parameter 0 (parameter 1 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member resolve *))" and t = "san" and result = 1.0 or 
repr = "(member src (member query *))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member send (parameter 1 (parameter 1 *))))" and t = "snk" and result = 0.6108024691358016 or 
repr = "(member query (parameter 0 (parameter 1 (member get *))))" and t = "snk" and result = 0.9999999999999972 or 
repr = "(parameter 0 (parameter 0 (member forEach *)))" and t = "src" and result = 0.125 or 
repr = "(member email *)" and t = "src" and result = 1.0 or 
repr = "(member src *)" and t = "src" and result = 1.0 or 
repr = "(member query (parameter 0 (parameter 1 (member get (return (member Router (root https://www.npmjs.com/package/express)))))))" and t = "snk" and result = 1.0 or 
repr = "(member query (parameter 0 (parameter 1 (member get (return *)))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member log (member console (global))))" and t = "snk" and result = 0.12500000000000155 or 
repr = "(member src (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member send (parameter 1 *)))" and t = "snk" and result = 1.0 or 
repr = "(member src (member query (parameter 0 (parameter 1 (member get (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(member query (parameter 0 *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member get (return *))))" and t = "src" and result = 0.7499999999999977 or 
repr = "(parameter 0 (parameter 1 (member get (return *))))" and t = "snk" and result = 0.5000000000000016 or 
repr = "(parameter 1 (member resolve (root https://www.npmjs.com/package/path)))" and t = "snk" and result = 0.04016460905350128 or 
repr = "(member src (member query (parameter 0 (parameter 1 *))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member log (member console *)))" and t = "snk" and result = 1.0 or 
repr = "(member query (parameter 0 (parameter 1 (member get (return (member Router *))))))" and t = "snk" and result = 1.0 or 
repr = "(return (member format *))" and t = "src" and result = 0.2817558299039771 or 
repr = "(member src (member query (parameter 0 (parameter 1 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(member src (member query (parameter 0 (parameter 1 (member get (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(member query *)" and t = "snk" and result = 1.0 or 
repr = "(member query (parameter 0 (parameter 1 *)))" and t = "snk" and result = 1.0 or 
repr = "(return (member parse (member JSON *)))" and t = "src" and result = 0.02839506172839623 or 
repr = "(member userId (member params (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member call *))" and t = "src" and result = 0.10000000000000162 or 
repr = "(parameter 1 (member call *))" and t = "snk" and result = 0.07486968449931508 or 
repr = "(parameter 0 (member equal (member to (return *))))" and t = "san" and result = 1.0 or 
repr = "(return (member parse (member JSON (global))))" and t = "san" and result = 0.9716049382716055 or 
repr = "(member name (member window *))" and t = "src" and result = 1.0 or 
repr = "(member pathname *)" and t = "san" and result = 1.0000000000000002 or 
repr = "(member userId (member params (parameter 0 (parameter 1 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member status *)" and t = "src" and result = 1.0 or 
repr = "(return (member replace (return (member replace (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 1 (member put (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(return (member substr *))" and t = "src" and result = 0.25 or 
repr = "(return (member substr *))" and t = "san" and result = 0.2500000000000008 or 
repr = "(parameter 0 (member keys (member Object *)))" and t = "san" and result = 1.0000000000000004 or 
repr = "(parameter 0 (member Uint8Array *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member get *))" and t = "snk" and result = 0.2499999999999995 or 
repr = "(return (member filter (return (member keys *))))" and t = "src" and result = 0.3274544385655506 or 
repr = "(parameter 0 (member dispose *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member get (return *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member Number (global)))" and t = "src" and result = 0.9999999999999984 or 
repr = "(member id (member params (parameter 0 (parameter 1 (member delete *)))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member encodeURIComponent *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return *)))" and t = "snk" and result = 0.5 or 
repr = "(return (member attr (return (member jQuery *))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member data *))" and t = "snk" and result = 0.07870370370370317 or 
repr = "(parameter 0 (member parseInt *))" and t = "snk" and result = 0.4810699588477364 or 
repr = "(member length (instance (member element (member angular (parameter 0 (member jQuery *))))))" and t = "san" and result = 0.999999999999999 or 
repr = "(parameter 1 (member equals *))" and t = "san" and result = 1.0 or 
repr = "(return (member split *))" and t = "src" and result = 0.24999999999999922 or 
repr = "(return (member split *))" and t = "snk" and result = 0.49999999999999967 or 
repr = "(return (member split *))" and t = "san" and result = 0.25 or 
repr = "(member userId (member params (parameter 0 (parameter 1 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member info (member console (global))))" and t = "san" and result = 1.0000000000000004 or 
repr = "(parameter 0 (member test (return *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member parseFloat (global)))" and t = "src" and result = 1.0 or 
repr = "(member userId (member params *))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member max (member Math (global))))" and t = "san" and result = 1.0000000000000004 or 
repr = "(return (member join *))" and t = "snk" and result = 0.2500000000000001 or 
repr = "(member id *)" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member json (parameter 1 *)))" and t = "san" and result = 1.000000000000001 or 
repr = "(return (member attr (return (member parent *))))" and t = "san" and result = 0.28793415637859876 or 
repr = "(parameter 1 (member pow *))" and t = "san" and result = 1.0000000000000004 or 
repr = "(return (member parseInt *))" and t = "san" and result = 0.4704526748971195 or 
repr = "(parameter 0 (member equal *))" and t = "san" and result = 1.0 or 
repr = "(return (member from *))" and t = "snk" and result = 0.15000000000000097 or 
repr = "(parameter 0 (parameter 1 (member on *)))" and t = "src" and result = 1.0000000000000002 or 
repr = "(member id (member params (parameter 0 (parameter 1 (member post (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member exec *))" and t = "snk" and result = 0.5896433470507545 or 
repr = "(parameter 1 (member min (member Math (global))))" and t = "san" and result = 1.0000000000000004 or 
repr = "(parameter 0 (member parse (member JSON *)))" and t = "src" and result = 0.6369684499314128 or 
repr = "(member id (member params (parameter 0 (parameter 2 (member get (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(member userId (member params (parameter 0 (parameter 1 (member delete (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member from *))" and t = "src" and result = 0.16666666666666677 or 
repr = "(parameter 0 (member from *))" and t = "snk" and result = 0.4499999999999996 or 
repr = "(parameter 0 (member querySelector *))" and t = "snk" and result = 0.7500000000000013 or 
repr = "(parameter 1 (member min *))" and t = "san" and result = 1.0 or 
repr = "(return (member map (return *)))" and t = "src" and result = 0.249999999999996 or 
repr = "(return (member map (return *)))" and t = "snk" and result = 0.5189300411522636 or 
repr = "(return (member map (return *)))" and t = "san" and result = 0.32142857142857506 or 
repr = "(parameter 0 (member appendChild *))" and t = "snk" and result = 0.5 or 
repr = "(return (member map *))" and t = "src" and result = 0.3749999999999978 or 
repr = "(return (member map *))" and t = "snk" and result = 0.4810699588477364 or 
repr = "(return (member map *))" and t = "san" and result = 0.1785714285714252 or 
repr = "(member length (instance *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member Array *))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member element (member angular *))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member element (member angular (parameter 0 (member jQuery (member window (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member location (member window *))" and t = "src" and result = 0.4047619047619051 or 
repr = "(parameter 0 (member appendChild (return (member getElementById (member document (global))))))" and t = "snk" and result = 0.5000000000000001 or 
repr = "(parameter 0 (member create *))" and t = "src" and result = 0.7500000000000013 or 
repr = "(parameter 0 (member test (instance *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member Date (global)))" and t = "snk" and result = 0.49999999999999867 or 
repr = "(parameter 0 (member equal (member to *)))" and t = "san" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 1 (member patch *)))))" and t = "src" and result = 1.0 or 
repr = "(return (member min (member Math *)))" and t = "src" and result = 0.833333333333334 or 
repr = "(return (member getElementById (member document *)))" and t = "san" and result = 0.75 or 
repr = "(member location (global))" and t = "snk" and result = 0.4761904761904763 or 
repr = "(parameter 0 (member keys *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member stringify (member JSON *)))" and t = "san" and result = 0.45567901234568114 or 
repr = "(member length (parameter 0 *))" and t = "san" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 1 (member put (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(return (member replace *))" and t = "san" and result = 1.0000000000000002 or 
repr = "(member length (return (member keys *)))" and t = "san" and result = 1.0 or 
repr = "(return (member getAttribute *))" and t = "src" and result = 0.25 or 
repr = "(return (member substring *))" and t = "src" and result = 0.20061728395061657 or 
repr = "(return (member substring *))" and t = "san" and result = 0.25000000000000244 or 
repr = "(member options *)" and t = "src" and result = 0.4166666666666667 or 
repr = "(member options *)" and t = "snk" and result = 0.23809523809523697 or 
repr = "(parameter 0 (member test (return (member RegExp (global)))))" and t = "src" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 1 (member patch (return *))))))" and t = "src" and result = 1.0 or 
repr = "(return (parameter 0 (member map (return (member keys (member Object (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 2 *))))" and t = "src" and result = 1.0 or 
repr = "(return (member querySelector (member document *)))" and t = "src" and result = 0.7499999999999987 or 
repr = "(return (member createElement (member document (global))))" and t = "san" and result = 0.75 or 
repr = "(member userId (member params (parameter 0 (parameter 1 (member delete *)))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member test (return (member RegExp *))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member stringify (member JSON (global))))" and t = "snk" and result = 0.3914266117969817 or 
repr = "(parameter 0 (member stringify (member JSON (global))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member push *))" and t = "snk" and result = 0.46256515775034296 or 
repr = "(member id (member params (parameter 0 (parameter 1 (member delete (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(return (member data (member jQuery *)))" and t = "src" and result = 0.5000000000000006 or 
repr = "(parameter 0 (member max (member Math (global))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member min (member Math *)))" and t = "san" and result = 1.0 or 
repr = "(return (member clone *))" and t = "src" and result = 0.25 or 
repr = "(return (member indexOf *))" and t = "san" and result = 0.25 or 
repr = "(member id (member params (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member Number *))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member append *))" and t = "san" and result = 0.9999999999999944 or 
repr = "(parameter 0 (parameter 0 (member map *)))" and t = "src" and result = 0.5000000000000031 or 
repr = "(return (member getElementById (member document (global))))" and t = "src" and result = 0.6000000000000009 or 
repr = "(parameter 0 (member Uint8Array (global)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member max *))" and t = "san" and result = 1.0 or 
repr = "(return (member max (member Math *)))" and t = "snk" and result = 0.7500000000000047 or 
repr = "(member length (instance (member element *)))" and t = "san" and result = 1.0 or 
repr = "(return (member getAttribute (return *)))" and t = "san" and result = 0.5 or 
repr = "(parameter 1 (member pow (member Math *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member filter *))" and t = "src" and result = 0.23220306915269645 or 
repr = "(parameter 0 (member Array (global)))" and t = "san" and result = 1.0 or 
repr = "(instance (member RegExp *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member encodeURIComponent (global)))" and t = "src" and result = 0.9999999999999997 or 
repr = "(parameter 0 (member encodeURIComponent (global)))" and t = "san" and result = 0.49999999999999967 or 
repr = "(member name (member window (global)))" and t = "src" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 1 (member patch (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member min (member Math *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member max (member Math *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member decodeURIComponent (global)))" and t = "snk" and result = 0.5000000000000009 or 
repr = "(member id (member params (parameter 0 (parameter 1 (member put (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 2 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(return (member data *))" and t = "san" and result = 0.28703703703703776 or 
repr = "(parameter 0 (member send (return *)))" and t = "snk" and result = 1.0 or 
repr = "(member length (instance (member element (member angular (parameter 0 (member jQuery (member window *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member replace *))" and t = "src" and result = 0.24999999999999956 or 
repr = "(parameter 0 (member replace *))" and t = "snk" and result = 0.050000000000000155 or 
repr = "(member id (member params (parameter 0 (parameter 1 (member post *)))))" and t = "src" and result = 1.0 or 
repr = "(member userId (member params (parameter 0 (parameter 1 (member delete (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(member userId (member params (parameter 0 (parameter 1 (member delete (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member argv (member process (global)))" and t = "src" and result = 0.5 or 
repr = "(return (member encodeURIComponent (global)))" and t = "san" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 1 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member length (instance (member element (member angular (global)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (member to (return (member expect (root https://www.npmjs.com/package/chai))))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(parameter 0 (member round *))" and t = "snk" and result = 0.04432098765432074 or 
repr = "(parameter 0 (member appendChild (return (member getElementById (member document *)))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member RegExp *))" and t = "san" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 1 (member post (return *))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member data (member jQuery *)))" and t = "src" and result = 0.4999999999999989 or 
repr = "(parameter 0 (member test (instance (member RegExp (global)))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (parameter 0 (member then (return *))))" and t = "src" and result = 0.16982167352537864 or 
repr = "(parameter 0 (member append (return *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (parameter 0 (member map (return (member keys *)))))" and t = "src" and result = 0.6249999999999964 or 
repr = "(instance (member RegExp (global)))" and t = "snk" and result = 1.0000000000000004 or 
repr = "(return (member map (return (member keys (member Object *)))))" and t = "snk" and result = 1.0 or 
repr = "(member userId (member params (parameter 0 (parameter 1 *))))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member log *))" and t = "src" and result = 0.053571428571427604 or 
repr = "(parameter 1 (member log *))" and t = "snk" and result = 0.7499999999999996 or 
repr = "(member userId *)" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member slice *))" and t = "san" and result = 1.0 or 
repr = "(return (member get *))" and t = "snk" and result = 0.75 or 
repr = "(return (member parseFloat (global)))" and t = "snk" and result = 0.4810699588477364 or 
repr = "(return (member parseFloat (global)))" and t = "san" and result = 0.5295473251028805 or 
repr = "(return (member toString *))" and t = "src" and result = 0.499999999999998 or 
repr = "(parameter 0 (member test *))" and t = "src" and result = 1.0000000000000016 or 
repr = "(member protocol *)" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member element (member angular (parameter 0 *)))))" and t = "san" and result = 1.0 or 
repr = "(member location *)" and t = "src" and result = 0.5 or 
repr = "(member id (member params (parameter 0 (parameter 1 (member post (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(member length (return (member keys (member Object *))))" and t = "san" and result = 1.0 or 
repr = "(return (parameter 0 (member map (return (member keys (member Object *))))))" and t = "san" and result = 1.0 or 
repr = "(return (member map (return (member keys (member Object (global))))))" and t = "snk" and result = 0.4999999999999957 or 
repr = "(member id (member params (parameter 0 (parameter 2 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(return (member attr (return (member jQuery (global)))))" and t = "src" and result = 0.6296296296296261 or 
repr = "(parameter 0 (member RegExp (global)))" and t = "san" and result = 1.0 or 
repr = "(member name (global))" and t = "src" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 1 (member delete (return *))))))" and t = "src" and result = 1.0 or 
repr = "(return (member apply *))" and t = "snk" and result = 0.4113580246913554 or 
repr = "(parameter 0 (member all *))" and t = "snk" and result = 0.6499999999999999 or 
repr = "(member length (instance (member element (member angular (parameter 0 (member jQuery (global)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member isNaN (global)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member isArray *))" and t = "snk" and result = 0.3891975308641991 or 
repr = "(parameter 0 (member sync *))" and t = "snk" and result = 0.2499999999999999 or 
repr = "(member length (return (member keys (member Object (global)))))" and t = "san" and result = 1.0 or 
repr = "(return (member parse *))" and t = "san" and result = 0.4999999999999998 or 
repr = "(member path *)" and t = "src" and result = 0.6250000000000001 or 
repr = "(parameter 0 (member min (member Math (global))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (member to (return (member expect *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member parse *))" and t = "src" and result = 0.1603566529492455 or 
repr = "(parameter 0 (member parse *))" and t = "snk" and result = 0.22160493827160538 or 
repr = "(return (parameter 0 (member map (return (member keys *)))))" and t = "san" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 1 (member get (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member error *))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (parameter 0 (member map (return *))))" and t = "src" and result = 0.12499999999999589 or 
repr = "(member userId (member params (parameter 0 (parameter 1 (member get (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member min *))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member max (member Math *)))" and t = "san" and result = 1.0 or 
repr = "(return (parameter 0 (member map (return *))))" and t = "san" and result = 1.0 or 
repr = "(member search *)" and t = "src" and result = 1.0000000000000016 or 
repr = "(return (member match *))" and t = "san" and result = 0.24999999999999933 or 
repr = "(member length *)" and t = "san" and result = 1.0 or 
repr = "(return (member slice (parameter 0 *)))" and t = "src" and result = 0.0526920438957435 or 
repr = "(return (member slice (parameter 0 *)))" and t = "san" and result = 0.6499999999999988 or 
repr = "(parameter 0 (member keys (member Object (global))))" and t = "san" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 1 (member delete (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(return (parameter 0 (member map *)))" and t = "san" and result = 1.0000000000000016 or 
repr = "(member length (instance (member element (member angular (parameter 0 (member undefined *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member parseFloat *))" and t = "src" and result = 1.0 or 
repr = "(return (member querySelector (member document (global))))" and t = "san" and result = 0.374999999999997 or 
repr = "(parameter 0 (member Error *))" and t = "snk" and result = 0.5000000000000016 or 
repr = "(member id (member params (parameter 0 (parameter 1 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member info (member console *)))" and t = "san" and result = 1.0 or 
repr = "(member id (member params *))" and t = "src" and result = 1.0 or 
repr = "(return (member replace (return *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member info *))" and t = "san" and result = 1.0 or 
repr = "(member length (return *))" and t = "san" and result = 1.0 or 
repr = "(return (member jQuery (global)))" and t = "snk" and result = 0.8333333333333337 or 
repr = "(return (member jQuery (global)))" and t = "san" and result = 0.31481481481481305 or 
repr = "(parameter 0 (member isNaN *))" and t = "san" and result = 1.0 or 
repr = "(parameter 5 (member Date (global)))" and t = "snk" and result = 0.4704526748971165 or 
repr = "(parameter 0 (member concat *))" and t = "snk" and result = 0.20535714285714363 or 
repr = "(parameter 0 (member json *))" and t = "san" and result = 1.0 or 
repr = "(return (member slice *))" and t = "src" and result = 0.39175240054870103 or 
repr = "(return (member slice *))" and t = "san" and result = 0.35000000000000137 or 
repr = "(member length (instance (member element (member angular (parameter 0 (member undefined (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member to (return (member expect *)))" and t = "snk" and result = 1.0000000000000062 or 
repr = "(member id (member params (parameter 0 (parameter 1 (member put *)))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member find *))" and t = "snk" and result = 1.0 or 
repr = "(return (member indexOf (parameter 0 *)))" and t = "src" and result = 0.7500000000000027 or 
repr = "(parameter 1 (member log (member console *)))" and t = "snk" and result = 0.018930041152264043 or 
repr = "(parameter 0 (member substring *))" and t = "san" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 1 (member get (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member pow (member Math (global))))" and t = "san" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 1 (member patch (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(member userId (member params (parameter 0 (parameter 1 (member get (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(return (member keys (member Object *)))" and t = "src" and result = 0.7499999999999973 or 
repr = "(return (member keys (member Object *)))" and t = "snk" and result = 0.7499999999999996 or 
repr = "(parameter 0 (member test (instance (member RegExp *))))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member apply *))" and t = "snk" and result = 0.39658436213991594 or 
repr = "(parameter 1 (member max *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member stringify *))" and t = "snk" and result = 0.330178326474623 or 
repr = "(return (member Number (global)))" and t = "san" and result = 1.0000000000000016 or 
repr = "(member id (member params (parameter 0 (parameter 2 (member get (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(return (member encodeURIComponent *))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace *))))" and t = "san" and result = 1.0000000000000013 or 
repr = "(member hash *)" and t = "san" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 1 *))))" and t = "src" and result = 1.0 or 
repr = "(member name *)" and t = "src" and result = 1.0 or 
repr = "(return (member join (return *)))" and t = "san" and result = 0.3749999999999937 or 
repr = "(member range (member query (parameter 0 (parameter 0 (member get (return (member route (return *))))))))" and t = "src" and result = 1.0 or 
repr = "(member range (member query *))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member attr (return *)))" and t = "san" and result = 1.0000000000000002 or 
repr = "(member range (member query (parameter 0 (parameter 0 (member get (return (member route (return (member Router *)))))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member attr *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member join (root https://www.npmjs.com/package/path)))" and t = "san" and result = 1.0 or 
repr = "(member value (member query (parameter 0 (parameter 0 (member get (return (member route (return *))))))))" and t = "src" and result = 1.0 or 
repr = "(member zone (member query (parameter 0 (parameter 0 (member get (return (member route (return (member Router (root https://www.npmjs.com/package/express))))))))))" and t = "src" and result = 1.0000000000000013 or 
repr = "(parameter 0 (member addNetworkClass (instance (root https://www.npmjs.com/package/cidr-matcher))))" and t = "src" and result = 1.0000000000000029 or 
repr = "(member cnameTLD (member query (parameter 0 (parameter 0 *))))" and t = "src" and result = 1.0000000000000013 or 
repr = "(member source (member query (parameter 0 (parameter 0 (member get (return (member route (return (member Router *)))))))))" and t = "src" and result = 1.0 or 
repr = "(member value (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 0 (member get *)))))" and t = "src" and result = 1.0000000000000013 or 
repr = "(member dnsType (member query (parameter 0 (parameter 0 (member get (return (member route (return *))))))))" and t = "src" and result = 1.0000000000000013 or 
repr = "(return (member exec *))" and t = "src" and result = 0.3396433470507541 or 
repr = "(return (member exec *))" and t = "san" and result = 0.3396433470507553 or 
repr = "(parameter 0 (member addNetworkClass (return *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member open *))" and t = "san" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 0 (member get (return (member route (return (member Router (root https://www.npmjs.com/package/express))))))))))" and t = "src" and result = 1.0 or 
repr = "(return (member toLowerCase *))" and t = "src" and result = 0.2500000000000001 or 
repr = "(return (member toLowerCase *))" and t = "snk" and result = 0.5252400548696844 or 
repr = "(member ip (member query *))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member aggregate (return *)))" and t = "snk" and result = 1.0 or 
repr = "(member value (member query (parameter 0 (parameter 0 (member get (return (member route *)))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member getElementById (member document *)))" and t = "san" and result = 1.0000000000000004 or 
repr = "(member source (member query (parameter 0 (parameter 0 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member open (return (member XMLHttpRequest (global)))))" and t = "snk" and result = 1.0 or 
repr = "(member cnameTLD *)" and t = "src" and result = 1.0 or 
repr = "(member range (member query (parameter 0 (parameter 0 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member make_get_request *))" and t = "snk" and result = 0.49999999999999967 or 
repr = "(member zone *)" and t = "src" and result = 1.0 or 
repr = "(member ip (member query (parameter 0 (parameter 0 (member get (return (member route *)))))))" and t = "src" and result = 1.0 or 
repr = "(member dnsType (member query *))" and t = "src" and result = 1.0 or 
repr = "(member domain (member query (parameter 0 (parameter 0 (member get (return (member route (return (member Router (root https://www.npmjs.com/package/express))))))))))" and t = "src" and result = 1.0 or 
repr = "(member zone (member query (parameter 0 (parameter 0 (member get (return (member route *)))))))" and t = "src" and result = 1.0 or 
repr = "(member innerHTML (return (member getElementById *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member countDocuments (return *)))" and t = "snk" and result = 1.0 or 
repr = "(member cnameTLD (member query (parameter 0 (parameter 0 (member get (return (member route (return *))))))))" and t = "src" and result = 1.0 or 
repr = "(member limit (member query (parameter 0 (parameter 0 (member get (return (member route (return (member Router *)))))))))" and t = "src" and result = 1.0000000000000013 or 
repr = "(member zone (member params (parameter 0 (parameter 0 (member get (return (member route (return (member Router (root https://www.npmjs.com/package/express))))))))))" and t = "src" and result = 1.0000000000000013 or 
repr = "(return (member stringify (member JSON (global))))" and t = "san" and result = 0.7500000000000007 or 
repr = "(member pathname (member location (member window (global))))" and t = "san" and result = 1.0 or 
repr = "(member limit (member query (parameter 0 (parameter 0 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(member limit *)" and t = "src" and result = 1.0 or 
repr = "(member zone (member query (parameter 0 (parameter 0 (member get (return (member route (return (member Router *)))))))))" and t = "src" and result = 1.0 or 
repr = "(member limit (member query (parameter 0 (parameter 0 (member get (return (member route *)))))))" and t = "src" and result = 1.0 or 
repr = "(member value *)" and t = "src" and result = 1.0000000000000013 or 
repr = "(parameter 0 (member countDocuments *))" and t = "snk" and result = 1.0 or 
repr = "(member zone (member params (parameter 0 (parameter 0 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(member dnsType *)" and t = "src" and result = 1.0 or 
repr = "(member dnsType (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(member source (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(member ip (member query (parameter 0 (parameter 0 (member get (return (member route (return *))))))))" and t = "src" and result = 1.0 or 
repr = "(member cnameTLD (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(member algorithm (member params *))" and t = "src" and result = 1.0000000000000013 or 
repr = "(member cnameTLD (member query (parameter 0 (parameter 0 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member value (member query (parameter 0 (parameter 0 (member get (return (member route (return (member Router (root https://www.npmjs.com/package/express))))))))))" and t = "src" and result = 1.0 or 
repr = "(member innerHTML (return (member getElementById (member document (global)))))" and t = "san" and result = 1.0 or 
repr = "(member value (member query (parameter 0 (parameter 0 *))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member find (return *)))" and t = "snk" and result = 1.0 or 
repr = "(member cnameTLD (member query (parameter 0 (parameter 0 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(member ip (member query (parameter 0 (parameter 0 *))))" and t = "src" and result = 1.0 or 
repr = "(member ip *)" and t = "src" and result = 1.0 or 
repr = "(member zone (member params (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(return (member stringify (member JSON *)))" and t = "src" and result = 0.75 or 
repr = "(return (member stringify (member JSON *)))" and t = "snk" and result = 0.3891975308641991 or 
repr = "(member ip (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(member limit (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(member zone (member params (parameter 0 (parameter 0 (member get (return (member route (return *))))))))" and t = "src" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 0 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member getElementById (member document (global))))" and t = "san" and result = 1.0 or 
repr = "(member algorithm (member params (parameter 0 (parameter 0 (member get (return (member route (return (member Router *)))))))))" and t = "src" and result = 1.0 or 
repr = "(member algorithm (member params (parameter 0 (parameter 0 (member get (return (member route *)))))))" and t = "src" and result = 1.0 or 
repr = "(member value (member query (parameter 0 (parameter 0 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member aggregate (return (member model (root https://www.npmjs.com/package/mongoose)))))" and t = "snk" and result = 1.0 or 
repr = "(member algorithm (member params (parameter 0 (parameter 0 *))))" and t = "src" and result = 1.0 or 
repr = "(member source (member query (parameter 0 (parameter 0 (member get (return (member route (return (member Router (root https://www.npmjs.com/package/express))))))))))" and t = "src" and result = 1.0 or 
repr = "(member algorithm (member params (parameter 0 (parameter 0 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member zone (member query (parameter 0 (parameter 0 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member domain (member query (parameter 0 (parameter 0 (member get (return (member route (return *))))))))" and t = "src" and result = 1.0 or 
repr = "(member ip (member query (parameter 0 (parameter 0 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member limit (member query *))" and t = "src" and result = 1.0 or 
repr = "(member source (member query (parameter 0 (parameter 0 *))))" and t = "src" and result = 1.0 or 
repr = "(member limit (member query (parameter 0 (parameter 0 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member domain (member query *))" and t = "src" and result = 1.0 or 
repr = "(member zone (member params *))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member open (instance (member XMLHttpRequest *))))" and t = "snk" and result = 1.0 or 
repr = "(member range (member query (parameter 0 (parameter 0 *))))" and t = "src" and result = 1.0 or 
repr = "(member dnsType (member query (parameter 0 (parameter 0 *))))" and t = "src" and result = 1.0 or 
repr = "(member innerHTML (return *))" and t = "san" and result = 1.0 or 
repr = "(member domain (member query (parameter 0 (parameter 0 (member get (return (member route *)))))))" and t = "src" and result = 1.0 or 
repr = "(member ip (member query (parameter 0 (parameter 0 (member get (return (member route (return (member Router *)))))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member inRange (root https://www.npmjs.com/package/range_check)))" and t = "src" and result = 0.999999999999999 or 
repr = "(parameter 0 (member aggregate *))" and t = "snk" and result = 1.0 or 
repr = "(member cnameTLD (member query *))" and t = "src" and result = 1.0 or 
repr = "(member value (member query (parameter 0 (parameter 0 (member get (return (member route (return (member Router *)))))))))" and t = "src" and result = 1.0 or 
repr = "(member range (member query (parameter 0 (parameter 0 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member inRange (root https://www.npmjs.com/package/range_check)))" and t = "src" and result = 0.999999999999999 or 
repr = "(parameter 0 (member open (member window *)))" and t = "san" and result = 1.0 or 
repr = "(member page (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member open (instance (member XMLHttpRequest (global)))))" and t = "snk" and result = 1.0 or 
repr = "(member domain (member query (parameter 0 (parameter 0 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(return (member join (root https://www.npmjs.com/package/path)))" and t = "src" and result = 0.5590946502057645 or 
repr = "(return (member join (root https://www.npmjs.com/package/path)))" and t = "snk" and result = 0.04589849108367766 or 
repr = "(return (member join (root https://www.npmjs.com/package/path)))" and t = "san" and result = 0.2954732510288103 or 
repr = "(member zone (member query *))" and t = "src" and result = 1.0 or 
repr = "(member zone (member params (parameter 0 (parameter 0 *))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member contains (return *)))" and t = "src" and result = 1.0 or 
repr = "(member zone (member query (parameter 0 (parameter 0 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(member ip (member query (parameter 0 (parameter 0 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(member domain (member query (parameter 0 (parameter 0 *))))" and t = "src" and result = 1.0 or 
repr = "(member cnameTLD (member query (parameter 0 (parameter 0 (member get (return (member route (return (member Router *)))))))))" and t = "src" and result = 1.0 or 
repr = "(member domain (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(member zone (member params (parameter 0 (parameter 0 (member get (return (member route *)))))))" and t = "src" and result = 1.0 or 
repr = "(member algorithm (member params (parameter 0 (parameter 0 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member countDocuments (return (member model *))))" and t = "snk" and result = 1.0 or 
repr = "(member ip (member query (parameter 0 (parameter 0 (member get (return (member route (return (member Router (root https://www.npmjs.com/package/express))))))))))" and t = "src" and result = 1.0 or 
repr = "(member algorithm (member params (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member open (global)))" and t = "san" and result = 1.0 or 
repr = "(member cnameTLD (member query (parameter 0 (parameter 0 (member get (return (member route (return (member Router (root https://www.npmjs.com/package/express))))))))))" and t = "src" and result = 1.0 or 
repr = "(member zone (member query (parameter 0 (parameter 0 (member get (return (member route (return *))))))))" and t = "src" and result = 1.0 or 
repr = "(member source (member query *))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member addNetworkClass *))" and t = "src" and result = 1.0 or 
repr = "(member limit (member query (parameter 0 (parameter 0 *))))" and t = "src" and result = 1.0 or 
repr = "(member algorithm *)" and t = "src" and result = 1.0 or 
repr = "(member innerHTML (return (member getElementById (member document *))))" and t = "san" and result = 1.0 or 
repr = "(member domain *)" and t = "src" and result = 1.0000000000000013 or 
repr = "(member domain (member query (parameter 0 (parameter 0 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member getElementById *))" and t = "san" and result = 1.0 or 
repr = "(member value (member query (parameter 0 (parameter 0 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(member range *)" and t = "src" and result = 1.0 or 
repr = "(member zone (member params (parameter 0 (parameter 0 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member algorithm (member params (parameter 0 (parameter 0 (member get (return (member route (return (member Router (root https://www.npmjs.com/package/express))))))))))" and t = "src" and result = 1.0 or 
repr = "(member dnsType (member query (parameter 0 (parameter 0 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member join *))" and t = "san" and result = 1.0 or 
repr = "(member value (member query *))" and t = "src" and result = 1.0 or 
repr = "(member pathname (member location *))" and t = "san" and result = 1.0 or 
repr = "(member source (member query (parameter 0 (parameter 0 (member get (return (member route *)))))))" and t = "src" and result = 1.0 or 
repr = "(member domain (member query (parameter 0 (parameter 0 (member get (return (member route (return (member Router *)))))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member find (return (member model (root https://www.npmjs.com/package/mongoose)))))" and t = "snk" and result = 1.0 or 
repr = "(member zone (member query (parameter 0 (parameter 0 *))))" and t = "src" and result = 1.0 or 
repr = "(member page (member query *))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member countDocuments (return (member model (root https://www.npmjs.com/package/mongoose)))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member inRange *))" and t = "src" and result = 1.0 or 
repr = "(member page *)" and t = "src" and result = 1.0 or 
repr = "(member zone (member params (parameter 0 (parameter 0 (member get (return (member route (return (member Router *)))))))))" and t = "src" and result = 1.0 or 
repr = "(member range (member query (parameter 0 (parameter 0 (member get (return (member route *)))))))" and t = "src" and result = 1.0 or 
repr = "(member pathname (member location (global)))" and t = "san" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 0 *))))" and t = "src" and result = 1.0 or 
repr = "(member limit (member query (parameter 0 (parameter 0 (member get (return (member route (return *))))))))" and t = "src" and result = 1.0 or 
repr = "(member cnameTLD (member query (parameter 0 (parameter 0 (member get (return (member route *)))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member inRange *))" and t = "src" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 0 (member get (return (member route (return (member Router *)))))))))" and t = "src" and result = 1.0 or 
repr = "(member dnsType (member query (parameter 0 (parameter 0 (member get (return (member route (return (member Router *)))))))))" and t = "src" and result = 1.0 or 
repr = "(member dnsType (member query (parameter 0 (parameter 0 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member open (member window (global))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member find (return (member model *))))" and t = "snk" and result = 1.0 or 
repr = "(member dnsType (member query (parameter 0 (parameter 0 (member get (return (member route *)))))))" and t = "src" and result = 1.0 or 
repr = "(member limit (member query (parameter 0 (parameter 0 (member get (return (member route (return (member Router (root https://www.npmjs.com/package/express))))))))))" and t = "src" and result = 1.0 or 
repr = "(member source (member query (parameter 0 (parameter 0 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(member pathname (member location (member window *)))" and t = "san" and result = 1.0 or 
repr = "(member innerHTML *)" and t = "san" and result = 1.0000000000000002 or 
repr = "(member source (member query (parameter 0 (parameter 0 (member get (return (member route (return *))))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member on (return *))))" and t = "src" and result = 1.0 or 
repr = "(member value (return *))" and t = "snk" and result = 0.012620027434842251 or 
repr = "(parameter 1 (member open (instance *)))" and t = "snk" and result = 0.4999999999999998 or 
repr = "(member range (member query (parameter 0 (parameter 0 (member get (return (member route (return (member Router (root https://www.npmjs.com/package/express))))))))))" and t = "src" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 0 (member get (return (member route (return *))))))))" and t = "src" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 0 (member get (return (member route *)))))))" and t = "src" and result = 1.0 or 
repr = "(member algorithm (member params (parameter 0 (parameter 0 (member get (return (member route (return *))))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member addNetworkClass (instance *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member addNetworkClass (return (root https://www.npmjs.com/package/cidr-matcher))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member aggregate (return (member model *))))" and t = "snk" and result = 1.0 or 
repr = "(member range (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(member source *)" and t = "src" and result = 1.0000000000000013 or 
repr = "(parameter 0 (member create_anchor *))" and t = "snk" and result = 0.49999999999999967 or 
repr = "(member dnsType (member query (parameter 0 (parameter 0 (member get (return (member route (return (member Router (root https://www.npmjs.com/package/express))))))))))" and t = "src" and result = 1.0 or 
repr = "(member zone (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member trim *))" and t = "src" and result = 0.4427194317605275 or 
repr = "(parameter 0 (member trim *))" and t = "snk" and result = 0.9045473251028804 or 
repr = "(parameter 0 (parameter 0 (member forEach (return (member keys *)))))" and t = "src" and result = 0.5628257887517092 or 
repr = "(member length (instance (parameter 0 (member defineProperty *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance (member InlineLexer (return (parameter 0 (member define *)))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member random (member Math (global))))" and t = "src" and result = 0.750000000000001 or 
repr = "(parameter 0 (member trim (member jQuery *)))" and t = "snk" and result = 0.35175799086758097 or 
repr = "(return (member substring (parameter 0 *)))" and t = "src" and result = 0.549382716049386 or 
repr = "(member query (parameter 0 (parameter 2 (member get (return *)))))" and t = "snk" and result = 0.9999999999999972 or 
repr = "(parameter 0 (member assign *))" and t = "src" and result = 0.1500000000000008 or 
repr = "(parameter 0 (member assign *))" and t = "snk" and result = 0.7500000000000002 or 
repr = "(return (member exec (instance *)))" and t = "src" and result = 0.8207133058984907 or 
repr = "(parameter 0 (member apply *))" and t = "src" and result = 0.10274426807760076 or 
repr = "(return (member assign *))" and t = "snk" and result = 0.7500000000000002 or 
repr = "(return (member assign *))" and t = "san" and result = 0.2500000000000003 or 
repr = "(member query (parameter 0 (parameter 2 *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member exec (instance *)))" and t = "snk" and result = 0.7499999999999996 or 
repr = "(member query (parameter 0 (parameter 2 (member get (return (member Router *))))))" and t = "snk" and result = 1.0 or 
repr = "(return (member exec (instance (member RegExp (global)))))" and t = "src" and result = 0.6016872427983554 or 
repr = "(return (member exec (instance (member RegExp (global)))))" and t = "san" and result = 0.6376954732510163 or 
repr = "(parameter 0 (member exec (return (member RegExp (global)))))" and t = "snk" and result = 1.0 or 
repr = "(return (member String (global)))" and t = "src" and result = 0.9704526748971196 or 
repr = "(return (member String (global)))" and t = "san" and result = 0.4999999999999999 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance (member InlineLexer *))))))" and t = "san" and result = 1.0 or 
repr = "(return (member assign (member Object *)))" and t = "san" and result = 1.0 or 
repr = "(member templates (member Handlebars (global)))" and t = "san" and result = 1.0000000000000004 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance (member InlineLexer (return *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member isEmpty *))" and t = "snk" and result = 0.7500000000000006 or 
repr = "(parameter 0 (member append (instance *)))" and t = "san" and result = 1.0 or 
repr = "(member type (parameter 0 *))" and t = "snk" and result = 0.2594650205761355 or 
repr = "(parameter 0 (member isUndefined *))" and t = "src" and result = 0.25252400548696907 or 
repr = "(member query (parameter 0 (parameter 2 (member get (return (member Router (root https://www.npmjs.com/package/express)))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member forEach *))" and t = "snk" and result = 0.5000000000000004 or 
repr = "(parameter 0 (member exec (return *)))" and t = "snk" and result = 0.5707133058984915 or 
repr = "(member protocol (member location *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member String *))" and t = "snk" and result = 0.47045267489711806 or 
repr = "(parameter 0 (member substring (parameter 0 (member output *))))" and t = "san" and result = 1.0 or 
repr = "(return (member assign (member Object (global))))" and t = "san" and result = 0.2500000000000005 or 
repr = "(member error *)" and t = "snk" and result = 0.21639623750734793 or 
repr = "(return (member exec (return (member RegExp *))))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member assign (member Object (global))))" and t = "src" and result = 1.0000000000000004 or 
repr = "(return (member join (return (member map *))))" and t = "src" and result = 0.5625000000000016 or 
repr = "(return (member exec (return (member RegExp (global)))))" and t = "src" and result = 1.0 or 
repr = "(return (member exec (return (member RegExp (global)))))" and t = "san" and result = 0.5106172839506288 or 
repr = "(return (member extend *))" and t = "src" and result = 0.10714285714286059 or 
repr = "(return (member extend *))" and t = "san" and result = 0.25000000000000044 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance (member InlineLexer (return (parameter 0 (member define (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance (member InlineLexer (return (parameter 0 *))))))))" and t = "san" and result = 1.0 or 
repr = "(member templates (member Handlebars *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member abs (member Math (global))))" and t = "snk" and result = 0.04432098765432074 or 
repr = "(parameter 0 (member TypeError *))" and t = "snk" and result = 0.49999999999999967 or 
repr = "(member length (instance (parameter 0 (member defineProperty (member Object *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member assign *))" and t = "src" and result = 1.0 or 
repr = "(return (member escape *))" and t = "src" and result = 0.5 or 
repr = "(member parameters *)" and t = "src" and result = 1.0 or 
repr = "(member url *)" and t = "src" and result = 1.000000000000001 or 
repr = "(return (member String *))" and t = "snk" and result = 0.40454732510288216 or 
repr = "(parameter 0 (member floor (member Math *)))" and t = "snk" and result = 0.04432098765432074 or 
repr = "(parameter 0 (member exec (return (member RegExp *))))" and t = "snk" and result = 0.32759945130315576 or 
repr = "(member url (parameter 0 *))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (parameter 0 (member defineProperty (member Object (global))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (parameter 0 *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member isFinite (global)))" and t = "snk" and result = 0.5954526748971194 or 
repr = "(parameter 1 (member assign (member Object *)))" and t = "src" and result = 1.0 or 
repr = "(member templates *)" and t = "san" and result = 1.0 or 
repr = "(member length (instance (parameter 0 *)))" and t = "san" and result = 1.0 or 
repr = "(return (member call *))" and t = "snk" and result = 0.020000000000000545 or 
repr = "(member protocol (member location (member window (global))))" and t = "san" and result = 1.0 or 
repr = "(return (member split (return *)))" and t = "snk" and result = 0.44090534979423773 or 
repr = "(member protocol (member location (member window *)))" and t = "san" and result = 1.0 or 
repr = "(member query (parameter 0 (parameter 2 (member get *))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (root https://www.npmjs.com/package/request))" and t = "snk" and result = 0.49999999999999944 or 
repr = "(member protocol (member location (global)))" and t = "san" and result = 1.0 or 
repr = "(return (member extend (member jQuery (global))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member Uint8Array *)))" and t = "san" and result = 1.0000000000000016 or 
repr = "(member length (parameter 1 (member insertInLine (parameter 0 (member implement *)))))" and t = "san" and result = 1.0000000000000013 or 
repr = "(parameter 0 (member count *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 1 (member stringRepeat (return (parameter 0 *))))" and t = "san" and result = 1.000000000000001 or 
repr = "(member HtmlHighlightRules (return (parameter 0 (parameter 2 (member define *)))))" and t = "san" and result = 1.000000000000001 or 
repr = "(member column (parameter 1 (member fromPoints (member Range (return (parameter 0 (parameter 2 *)))))))" and t = "san" and result = 0.9999999999999984 or 
repr = "(parameter 2 (member log *))" and t = "san" and result = 1.0000000000000013 or 
repr = "(parameter 0 (member Uint32Array (global)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member isFunction *))" and t = "san" and result = 1.0000000000000004 or 
repr = "(member length (parameter 1 (member insertLines (parameter 0 (member implement (return (parameter 0 (parameter 2 (member define (global))))))))))" and t = "san" and result = 1.0000000000000013 or 
repr = "(return (member data (return (member jQuery (member window *)))))" and t = "src" and result = 1.0 or 
repr = "(member length (instance (member Uint8Array *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member setTimeout (global)))" and t = "snk" and result = 0.5000000000000031 or 
repr = "(parameter 3 (member Range (return *)))" and t = "san" and result = 1.000000000000001 or 
repr = "(member column *)" and t = "san" and result = 1.0 or 
repr = "(member column (parameter 1 (member fromPoints (member Range (return (parameter 0 (parameter 2 (member define (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member insertInLine *)))" and t = "san" and result = 1.0 or 
repr = "(member column (parameter 1 (member fromPoints (member Range (return (parameter 0 (parameter 2 (member define *))))))))" and t = "san" and result = 1.0 or 
repr = "(member column (parameter 1 (member fromPoints (member Range *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member Range *))" and t = "san" and result = 1.000000000000001 or 
repr = "(parameter 0 (member jQuery *))" and t = "san" and result = 1.0 or 
repr = "(parameter 3 (member Range (return (parameter 0 (parameter 2 *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member Range (return *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member Int32Array (global)))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member insertLines (parameter 0 (member implement (return *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member log (member console *)))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member insertInLine (parameter 0 *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member count (return *)))" and t = "snk" and result = 1.0 or 
repr = "(return (member setTimeout (global)))" and t = "snk" and result = 0.5000000000000031 or 
repr = "(parameter 0 (member callback *))" and t = "src" and result = 1.0 or 
repr = "(member length (parameter 1 (member insertLines (parameter 0 *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member extend *))" and t = "snk" and result = 0.47222222222221893 or 
repr = "(parameter 1 (member Range (return (parameter 0 (parameter 2 *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member setValue *))" and t = "snk" and result = 0.2352263374485598 or 
repr = "(parameter 0 (member jQuery (member window *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member Range (return (parameter 0 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member insertInLine (parameter 0 (member implement (return *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member replace (parameter 0 *)))" and t = "src" and result = 0.21256515775034396 or 
repr = "(parameter 0 (member jQuery (global)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member Uint8Array (global))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member stringRepeat (return (parameter 0 (parameter 2 (member define *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member extend *))" and t = "src" and result = 1.0000000000000002 or 
repr = "(member length (parameter 1 (member insertInLine (parameter 0 (member implement (return (parameter 0 (parameter 2 (member define (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member column (parameter 1 (member fromPoints (member Range (return (parameter 0 *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member insertLines *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 3 (member Range (return (parameter 0 (parameter 2 (member define *))))))" and t = "san" and result = 1.0 or 
repr = "(member HtmlHighlightRules (return (parameter 0 (parameter 2 (member define (global))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member replace *))" and t = "snk" and result = 0.12973251028806637 or 
repr = "(member HtmlHighlightRules (return (parameter 0 (parameter 2 *))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member String (global)))))" and t = "san" and result = 0.9999999999999996 or 
repr = "(parameter 1 (member Range (return (parameter 0 (parameter 2 (member define (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member Uint8Array (global))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member Int32Array *))" and t = "san" and result = 1.0 or 
repr = "(member element (instance *))" and t = "src" and result = 0.0009523809523814125 or 
repr = "(member HtmlHighlightRules *)" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member insertInLine (parameter 0 (member implement (return (parameter 0 *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member insertLines (parameter 0 (member implement (return (parameter 0 (parameter 2 (member define *)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member Range (return (parameter 0 (parameter 2 (member define *))))))" and t = "san" and result = 1.0 or 
repr = "(member column (parameter 1 *))" and t = "san" and result = 1.0 or 
repr = "(member fn *)" and t = "src" and result = 0.6428571428571418 or 
repr = "(parameter 0 (member isNull *))" and t = "src" and result = 0.12720850480109763 or 
repr = "(return (member replace (return (member String *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 3 (member Range *))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member extend *))" and t = "san" and result = 1.0000000000000002 or 
repr = "(member column (parameter 1 (member fromPoints *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member stringRepeat (return (parameter 0 (parameter 2 *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member stringRepeat (return (parameter 0 (parameter 2 (member define (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member HtmlHighlightRules (return *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member eval (global)))" and t = "snk" and result = 0.4704526748971196 or 
repr = "(member length (parameter 1 (member insertLines (parameter 0 (member implement (return (parameter 0 (parameter 2 *))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member extend (member jQuery *)))" and t = "san" and result = 0.14285714285714152 or 
repr = "(member length (parameter 1 (member insertLines (parameter 0 (member implement (return (parameter 0 *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member log (member console (global))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member jQuery (member window (global))))" and t = "san" and result = 1.0 or 
repr = "(return (member data (return (member jQuery (member window (global))))))" and t = "src" and result = 0.5000000000000029 or 
repr = "(member length (parameter 1 (member insertInLine (parameter 0 (member implement (return (parameter 0 (parameter 2 *))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 3 (member Range (return (parameter 0 *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member each *))" and t = "snk" and result = 0.47222222222221893 or 
repr = "(parameter 1 (member stringRepeat (return *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member set (return *)))" and t = "snk" and result = 0.05909465020576454 or 
repr = "(parameter 3 (member Range (return (parameter 0 (parameter 2 (member define (global)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member stringRepeat *))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member insertInLine (parameter 0 (member implement (return (parameter 0 (parameter 2 (member define *)))))))))" and t = "san" and result = 1.0 or 
repr = "(member column (parameter 1 (member fromPoints (member Range (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member HtmlHighlightRules (return (parameter 0 *)))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member insertLines (parameter 0 (member implement *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member Uint32Array *))" and t = "san" and result = 1.0 or 
repr = "(member HtmlFormat (return (member require (member goog (global)))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(parameter 0 (member unescape (global)))" and t = "san" and result = 1.0 or 
repr = "(member innerHTML (member head (member document (member win (member ampdoc (parameter 0 *))))))" and t = "san" and result = 1.000000000000001 or 
repr = "(member templates_ (instance (parameter 1 (member registerElement (parameter 0 (parameter 2 (member extension (member AMP *))))))))" and t = "san" and result = 0.9999999999999984 or 
repr = "(parameter 0 (member toEqual (return *)))" and t = "san" and result = 0.9999999999999984 or 
repr = "(parameter 0 (parameter 1 (member addEventListener (member window (global)))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member pow (member Math (global))))" and t = "san" and result = 1.0000000000000004 or 
repr = "(parameter 3 (member log (member console *)))" and t = "san" and result = 1.0000000000000004 or 
repr = "(parameter 0 (member include *))" and t = "san" and result = 1.0000000000000016 or 
repr = "(parameter 0 (member callCount (member have (member to (return (member expect (global)))))))" and t = "san" and result = 1.000000000000001 or 
repr = "(return (member cwd (root https://www.npmjs.com/package/process)))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member encodeURI (global)))" and t = "src" and result = 0.5000000000000019 or 
repr = "(member length (member children (return *)))" and t = "san" and result = 1.0 or 
repr = "(return (member readFile (member promises *)))" and t = "snk" and result = 0.7405349794238726 or 
repr = "(parameter 0 (member length (member have (member to (return (member expect (root https://www.npmjs.com/package/chai)))))))" and t = "san" and result = 1.000000000000001 or 
repr = "(member origin (member location *))" and t = "san" and result = 1.0 or 
repr = "(return (member expect (global)))" and t = "snk" and result = 0.6000000000000001 or 
repr = "(parameter 0 (member cyan (root https://www.npmjs.com/package/ansi-colors)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member stub (member sandbox (parameter 0 *))))" and t = "san" and result = 1.0 or 
repr = "(member hash (member location (member self *)))" and t = "san" and result = 1.0000000000000002 or 
repr = "(return (member replace (parameter 0 *)))" and t = "san" and result = 1.000000000000001 or 
repr = "(member templates_ *)" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member slice *))" and t = "san" and result = 1.0 or 
repr = "(member url (parameter 0 (parameter 1 *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (root https://www.npmjs.com/package/gulp-file))" and t = "snk" and result = 0.20833333333333356 or 
repr = "(parameter 0 (member values (member Object (global))))" and t = "san" and result = 1.0000000000000004 or 
repr = "(member length (return (member getElementsByTagName (member document (member win (parameter 0 (parameter 2 (member realWin (member describes *)))))))))" and t = "san" and result = 1.0000000000000013 or 
repr = "(member innerHTML (member head (member document (member win (member ampdoc (parameter 0 (parameter 2 (member realWin (member describes *)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member have (member to *)))" and t = "san" and result = 1.000000000000001 or 
repr = "(parameter 0 (member mock (member sandbox (parameter 0 *))))" and t = "san" and result = 1.0000000000000016 or 
repr = "(parameter 0 (member pow *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member stub *))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member join (root https://www.npmjs.com/package/path)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member pow (member Math *)))" and t = "san" and result = 1.0 or 
repr = "(return (member substr (return *)))" and t = "snk" and result = 0.4852263374485595 or 
repr = "(parameter 0 (member contain (member to (return (member expect *)))))" and t = "san" and result = 1.0000000000000016 or 
repr = "(member innerHTML (member head (member document *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member have (member to (return *))))" and t = "san" and result = 1.0 or 
repr = "(member hash (member location (global)))" and t = "san" and result = 1.0 or 
repr = "(member innerHTML (return (member createElement *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member writeFileSync *))" and t = "snk" and result = 0.41666666666666713 or 
repr = "(member origin (member location (global)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member stub (member sandbox (parameter 0 (parameter 2 *)))))" and t = "san" and result = 1.0 or 
repr = "(member HtmlFormat (return (member require *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member length (member have (member to (return *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member include (member to (return (member expect *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member dirname *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member addEventListener *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member addEventListener (global))))" and t = "src" and result = 1.0 or 
repr = "(member templates_ (instance (parameter 1 (member registerElement (parameter 0 (parameter 2 (member extension (member AMP (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getElementsByTagName (member document (member win (parameter 0 (parameter 2 *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (member to (return (member expect (global))))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(parameter 0 (member concat (return *)))" and t = "snk" and result = 0.7355482069370938 or 
repr = "(return (member dirname *))" and t = "src" and result = 0.4999999999999984 or 
repr = "(member ssrTemplateHelper_ (instance *))" and t = "san" and result = 1.0 or 
repr = "(member length (member have (member to (return (member expect (global))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member each *)))" and t = "src" and result = 0.330178326474623 or 
repr = "(parameter 0 (member encode (return *)))" and t = "src" and result = 0.10037411148522096 or 
repr = "(return (member resolve (member Promise (global))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member expect (global)))" and t = "snk" and result = 0.6000000000000001 or 
repr = "(parameter 2 (member assign (member Object *)))" and t = "snk" and result = 0.5738683127572031 or 
repr = "(parameter 0 (member existsSync *))" and t = "snk" and result = 0.5 or 
repr = "(parameter 0 (root https://www.npmjs.com/package/minimatch))" and t = "snk" and result = 0.2795473251028816 or 
repr = "(member length (member have (member to (return (member expect *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member mock (member sandbox (parameter 0 (parameter 2 (member fakeWin *))))))" and t = "san" and result = 1.0 or 
repr = "(member outerHTML *)" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member btoa (global)))" and t = "src" and result = 0.3750000000000006 or 
repr = "(return (member apply (member max (member Math (global)))))" and t = "snk" and result = 0.5886419753086415 or 
repr = "(member length (return (member getElementsByTagName (member document (member win *)))))" and t = "san" and result = 1.0 or 
repr = "(member content (return *))" and t = "src" and result = 0.4999999999999999 or 
repr = "(parameter 0 (member contain (member to *)))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member readFileSync *))))" and t = "san" and result = 0.9999999999999996 or 
repr = "(member innerHTML (member head *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member createTextNode (member document *)))" and t = "snk" and result = 0.750000000000002 or 
repr = "(parameter 1 (member join *))" and t = "san" and result = 1.0 or 
repr = "(return (member encodeURI *))" and t = "san" and result = 1.0 or 
repr = "(member at (member be (member to (return *))))" and t = "snk" and result = 0.28864197530864144 or 
repr = "(parameter 1 (member slice (return *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member fetch *))" and t = "snk" and result = 0.36111111111111105 or 
repr = "(parameter 0 (member include (member to (return (member expect (global))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member readFile *))" and t = "san" and result = 1.0 or 
repr = "(return (member substring (return *)))" and t = "snk" and result = 0.49999999999999967 or 
repr = "(member url (parameter 0 (parameter 1 (member get (return *)))))" and t = "src" and result = 1.0 or 
repr = "(member innerHTML (member head (member document (member win (member ampdoc *)))))" and t = "san" and result = 1.0 or 
repr = "(member innerHTML (member head (member document (member win (member ampdoc (parameter 0 (parameter 2 *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member readFileSync (root https://www.npmjs.com/package/fs)))" and t = "san" and result = 1.0 or 
repr = "(member templates_ (instance (parameter 1 (member registerElement (parameter 0 *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member contain (member not (member to (return (member expect *))))))" and t = "san" and result = 1.0 or 
repr = "(member hash (member location (member self (global))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (parameter 0 (member forEach *)))" and t = "src" and result = 0.125 or 
repr = "(parameter 0 (member mock (member sandbox (parameter 0 (parameter 2 (member fakeWin (member describes (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getElementsByTagName *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member addEventListener (member window *))))" and t = "src" and result = 1.0 or 
repr = "(return (member all (member Promise *)))" and t = "src" and result = 0.7500000000000002 or 
repr = "(member url (parameter 0 (parameter 1 (member get (return (root https://www.npmjs.com/package/express))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member values *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member resolve (member Promise (global))))" and t = "san" and result = 1.0000000000000004 or 
repr = "(parameter 0 (root https://www.npmjs.com/package/fancy-log))" and t = "snk" and result = 0.5000000000000004 or 
repr = "(member url (parameter 0 (parameter 1 (member get *))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member all (member Promise *)))" and t = "snk" and result = 0.1000000000000113 or 
repr = "(parameter 0 (member all (member Promise *)))" and t = "san" and result = 0.4553571428571459 or 
repr = "(parameter 0 (member deepEqual (parameter 0 (parameter 1 *))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(member templates_ (instance (parameter 1 *)))" and t = "san" and result = 1.0 or 
repr = "(member hostname *)" and t = "san" and result = 1.0 or 
repr = "(return (member red *))" and t = "src" and result = 0.5000000000000002 or 
repr = "(member base *)" and t = "snk" and result = 0.5 or 
repr = "(member templates_ (instance (parameter 1 (member registerElement (parameter 0 (parameter 2 *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member callCount (member have (member to (return (member expect *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member inArray *))" and t = "snk" and result = 0.16635802469136507 or 
repr = "(return (member pipe (return *)))" and t = "snk" and result = 0.5000000000000009 or 
repr = "(member HtmlFormat (return *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member validateString (return (member require (member goog (global))))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(parameter 0 (member send (instance (member XMLHttpRequest *))))" and t = "snk" and result = 1.0 or 
repr = "(return (member relative (root https://www.npmjs.com/package/path)))" and t = "src" and result = 0.05909465020576177 or 
repr = "(return (member concat *))" and t = "src" and result = 0.3482142857142855 or 
repr = "(return (member concat *))" and t = "snk" and result = 0.4017857142857145 or 
repr = "(parameter 0 (member slice (parameter 0 *)))" and t = "san" and result = 1.0 or 
repr = "(instance (member Promise (global)))" and t = "snk" and result = 0.018930041152269927 or 
repr = "(member ssrTemplateHelper_ (instance (parameter 1 (member registerElement (parameter 0 (parameter 2 *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member basename (root https://www.npmjs.com/package/path)))" and t = "san" and result = 1.0 or 
repr = "(member host (return *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member mock (member sandbox (parameter 0 (parameter 2 (member fakeWin (member describes *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getElementsByTagName (member document (member win (parameter 0 *))))))" and t = "san" and result = 1.0 or 
repr = "(member className *)" and t = "src" and result = 0.500000000000001 or 
repr = "(member className *)" and t = "snk" and result = 0.5 or 
repr = "(parameter 0 (member contain (member to (return (member expect (global))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member querySelectorAll *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member mock (member sandbox (parameter 0 (parameter 2 *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member toEqual (return (member expect (global)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member write (member document *)))" and t = "snk" and result = 0.5000000000000016 or 
repr = "(member ssrTemplateHelper_ (instance (parameter 1 (member registerElement (parameter 0 (parameter 2 (member extension (member AMP *))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 0 (member obj *)))" and t = "src" and result = 0.3000000000000017 or 
repr = "(parameter 0 (member validateString (return *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member length *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member deepEqual (parameter 0 *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getElementsByTagName (member document (member win (parameter 0 (parameter 2 (member realWin (member describes (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member innerHTML (member head (member document (member win (member ampdoc (parameter 0 (parameter 2 (member realWin (member describes (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member encode *))" and t = "san" and result = 1.0000000000000016 or 
repr = "(parameter 0 (member assert *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member validateString (return (member require (member goog *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member stub (member sandbox (parameter 0 (parameter 2 (member realWin *))))))" and t = "san" and result = 1.0 or 
repr = "(return (member all *))" and t = "snk" and result = 0.75 or 
repr = "(member hostname (member location (global)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member callCount (member have (member to (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member message (parameter 0 *))" and t = "src" and result = 0.029547325102880384 or 
repr = "(parameter 0 (member querySelectorAll *))" and t = "snk" and result = 0.9625651577503429 or 
repr = "(member templates_ (instance *))" and t = "san" and result = 1.0 or 
repr = "(parameter 3 (member log (member console (global))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getElementsByTagName (member document *))))" and t = "san" and result = 1.0 or 
repr = "(member contents *)" and t = "src" and result = 0.499999999999998 or 
repr = "(member contents *)" and t = "snk" and result = 0.7499999999999982 or 
repr = "(return (member clone (instance *)))" and t = "src" and result = 0.08333333333333363 or 
repr = "(parameter 0 (member end (parameter 1 *)))" and t = "snk" and result = 0.01893004115226493 or 
repr = "(member length (return (member atob (global))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member values (member Object *)))" and t = "san" and result = 1.0 or 
repr = "(member href *)" and t = "snk" and result = 0.2500000000000009 or 
repr = "(parameter 0 (member callCount *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member basename *))" and t = "san" and result = 1.0 or 
repr = "(return (member maybeValidateAmpCreative (instance (parameter 1 (member registerElement (parameter 0 (parameter 2 (member extension (member AMP (global))))))))))" and t = "src" and result = 1.0 or 
repr = "(member location (member document *))" and t = "src" and result = 0.25000000000000006 or 
repr = "(parameter 0 (member stub (member sandbox *)))" and t = "san" and result = 1.0 or 
repr = "(member innerHTML (member head (member document (member win (member ampdoc (parameter 0 (parameter 2 (member realWin *))))))))" and t = "san" and result = 1.0 or 
repr = "(member hash (member location (member window (global))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(parameter 0 (member toEqual *))" and t = "san" and result = 1.0 or 
repr = "(return (member maybeValidateAmpCreative (instance (parameter 1 (member registerElement (parameter 0 (parameter 2 *)))))))" and t = "src" and result = 0.2500000000000001 or 
repr = "(parameter 0 (member deepEqual *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 0 (parameter 0 (member Promise (global)))))" and t = "src" and result = 0.018930041152263155 or 
repr = "(return (member readFileSync *))" and t = "src" and result = 0.33333333333333337 or 
repr = "(parameter 0 (member include (member to (return *))))" and t = "san" and result = 1.0 or 
repr = "(member hostname (member location (member window (global))))" and t = "san" and result = 1.0 or 
repr = "(member templates_ (instance (parameter 1 (member registerElement *))))" and t = "san" and result = 1.0 or 
repr = "(member ssrTemplateHelper_ *)" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member unescape *))" and t = "san" and result = 1.0 or 
repr = "(return (member toLowerCase (return *)))" and t = "snk" and result = 0.4149977137631461 or 
repr = "(member templates_ (instance (parameter 1 (member registerElement (parameter 0 (parameter 2 (member extension *)))))))" and t = "san" and result = 1.0 or 
repr = "(return (member month *))" and t = "src" and result = 0.16666666666666677 or 
repr = "(parameter 1 (member replace (return *)))" and t = "snk" and result = 0.7036008230452676 or 
repr = "(member origin *)" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member dirname (root https://www.npmjs.com/package/path)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member contain (member not *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member validateString (return (member require *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member relative *))" and t = "snk" and result = 0.3916598079561061 or 
repr = "(return (member basename *))" and t = "src" and result = 0.16666666666666652 or 
repr = "(parameter 0 (member length (member have (member to (return (member expect *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member encode *))" and t = "src" and result = 0.490534979423869 or 
repr = "(member hostname (member location (member window *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member contain (member not (member to (return (member expect (global)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 3 (member log *))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member call (return *)))" and t = "src" and result = 0.4000000000000016 or 
repr = "(return (member resolve (member Promise *)))" and t = "snk" and result = 0.1250000000000003 or 
repr = "(member HtmlFormat (return (member require (member goog *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member readFile (member promises *)))" and t = "snk" and result = 0.749999999999994 or 
repr = "(return (root https://www.npmjs.com/package/minimist))" and t = "src" and result = 0.10137459990854994 or 
repr = "(parameter 2 (member assign *))" and t = "snk" and result = 0.17613168724279743 or 
repr = "(parameter 0 (member contain (member not (member to *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member atob *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member toEqual (return (member expect *))))" and t = "san" and result = 1.0 or 
repr = "(member ssrTemplateHelper_ (instance (parameter 1 (member registerElement (parameter 0 (parameter 2 (member extension *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member mock (member sandbox *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member readFileSync *))" and t = "san" and result = 1.0 or 
repr = "(member length (member children *))" and t = "san" and result = 1.0 or 
repr = "(member ssrTemplateHelper_ (instance (parameter 1 (member registerElement (parameter 0 (parameter 2 (member extension (member AMP (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member reject (member Promise *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member contain (member to (return *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member writeFileSync (root https://www.npmjs.com/package/fs)))" and t = "snk" and result = 0.5833333333333313 or 
repr = "(return (member encodeURI (global)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member validateString *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member contain *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member callCount (member have (member to *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member include (member to *)))" and t = "san" and result = 1.0 or 
repr = "(return (member match (return *)))" and t = "san" and result = 0.2500000000000009 or 
repr = "(member ssrTemplateHelper_ (instance (parameter 1 (member registerElement (parameter 0 *)))))" and t = "san" and result = 1.0 or 
repr = "(return (member add (instance *)))" and t = "src" and result = 0.33333333333333354 or 
repr = "(return (member readFileSync (root https://www.npmjs.com/package/fs)))" and t = "src" and result = 0.1666666666666664 or 
repr = "(member HtmlFormat *)" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member resolve (member Promise *)))" and t = "san" and result = 1.0 or 
repr = "(member hash (member location *))" and t = "san" and result = 1.0 or 
repr = "(member length (member have *))" and t = "san" and result = 1.0 or 
repr = "(member not (member to (return (member expect (global)))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member write *))" and t = "snk" and result = 0.5 or 
repr = "(parameter 0 (parameter 1 (member removeEventListener *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member length (member have *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member stub (member sandbox (parameter 0 (parameter 2 (member realWin (member describes *)))))))" and t = "san" and result = 1.0 or 
repr = "(member path (parameter 0 (parameter 1 (member get (return (root https://www.npmjs.com/package/express))))))" and t = "src" and result = 0.8749999999999952 or 
repr = "(return (member atob *))" and t = "src" and result = 0.4999999999999991 or 
repr = "(member innerHTML (return (member createElement (member document *))))" and t = "san" and result = 1.0 or 
repr = "(member at (member be (member to (return (member expect (global))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member send (return (member XMLHttpRequest *))))" and t = "snk" and result = 0.9000000000000025 or 
repr = "(return (member join (return (member map (return *)))))" and t = "snk" and result = 0.2499999999999934 or 
repr = "(parameter 0 (member existsSync (root https://www.npmjs.com/package/fs)))" and t = "snk" and result = 0.29316872427983187 or 
repr = "(parameter 0 (member callCount (member have *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member cyan *))" and t = "san" and result = 1.0 or 
repr = "(member innerHTML (member head (member document (member win *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member contain (member not (member to (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member classList *)" and t = "snk" and result = 1.0 or 
repr = "(member hash (member location (member window *)))" and t = "san" and result = 1.0 or 
repr = "(return (member basename (root https://www.npmjs.com/package/path)))" and t = "src" and result = 0.3333333333333319 or 
repr = "(parameter 0 (member writeFile *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member mock *))" and t = "san" and result = 1.0 or 
repr = "(member resolve *)" and t = "snk" and result = 0.49999999999999956 or 
repr = "(return (member maybeValidateAmpCreative (instance (parameter 1 (member registerElement (parameter 0 (parameter 2 (member extension (member AMP *)))))))))" and t = "src" and result = 1.0 or 
repr = "(member hostname (member location *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member stub (member sandbox (parameter 0 (parameter 2 (member realWin (member describes (global))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member replace (return (member replace (return *)))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member maybeValidateAmpCreative (instance (parameter 1 (member registerElement (parameter 0 (parameter 2 (member extension *))))))))" and t = "src" and result = 0.4500000000000009 or 
repr = "(member length (return (member getElementsByTagName (member document (member win (parameter 0 (parameter 2 (member realWin *))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member length (member have (member to *))))" and t = "san" and result = 1.0 or 
repr = "(member stderr *)" and t = "src" and result = 0.2204526748971187 or 
repr = "(member ssrTemplateHelper_ (instance (parameter 1 (member registerElement *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member reject (member Promise (global))))" and t = "snk" and result = 0.5518747142203922 or 
repr = "(parameter 0 (member encodeURI *))" and t = "snk" and result = 0.5 or 
repr = "(member context (member window *))" and t = "src" and result = 1.0 or 
repr = "(member ssrTemplateHelper_ (instance (parameter 1 *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 0 (parameter 0 (member Promise *))))" and t = "snk" and result = 0.5189300411522633 or 
repr = "(member location (member context (member window (global))))" and t = "src" and result = 0.7499999999999999 or 
repr = "(parameter 0 (member findById (return (member model *))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member findById *))" and t = "src" and result = 1.0 or 
repr = "(member sort (member query (parameter 0 (parameter 1 (member get (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(member sort (member query (parameter 0 (parameter 1 (member get (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member findById (return *)))" and t = "src" and result = 1.0 or 
repr = "(member titulo (member query (parameter 0 (parameter 1 *))))" and t = "src" and result = 1.0 or 
repr = "(member titulo (member query *))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member findById (return (member model (root https://www.npmjs.com/package/mongoose)))))" and t = "src" and result = 1.0 or 
repr = "(member autor *)" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (return (member model *)))" and t = "src" and result = 1.0 or 
repr = "(member sort (member query (parameter 0 (parameter 1 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(member titulo *)" and t = "src" and result = 1.0 or 
repr = "(member autor (member query (parameter 0 (parameter 1 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member autor (member query (parameter 0 (parameter 1 (member get (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(member sort (member query *))" and t = "src" and result = 1.0 or 
repr = "(member autor (member query *))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (return (member model (root https://www.npmjs.com/package/mongoose))))" and t = "src" and result = 1.0 or 
repr = "(member titulo (member query (parameter 0 (parameter 1 (member get (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(member autor (member query (parameter 0 (parameter 1 *))))" and t = "src" and result = 1.0 or 
repr = "(member autor (member query (parameter 0 (parameter 1 (member get (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(member titulo (member query (parameter 0 (parameter 1 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member findOne (return (member model *))))" and t = "snk" and result = 1.0 or 
repr = "(member titulo (member query (parameter 0 (parameter 1 (member get (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(member sort (member query (parameter 0 (parameter 1 *))))" and t = "src" and result = 1.0 or 
repr = "(member autor (member query (parameter 0 (parameter 1 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(member sort (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member findOne (return (member model (root https://www.npmjs.com/package/mongoose)))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member findOne (return *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member findOne *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 3 (member extend (member jQuery (global))))" and t = "snk" and result = 0.47222222222221827 or 
repr = "(member sort (member query (parameter 0 (parameter 1 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member titulo (member query (parameter 0 (parameter 1 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(member sort *)" and t = "src" and result = 1.0 or 
repr = "(member titulo (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(member autor (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(member length (parameter 0 (member each (member exports (global)))))" and t = "san" and result = 1.0000000000000318 or 
repr = "(member length (parameter 0 (member map *)))" and t = "san" and result = 1.0000000000001024 or 
repr = "(member length (return (member collect (parameter 2 (member call (return *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member tokenize (member find (member constructor (member fn (return (parameter 2 (member define (global))))))))))" and t = "san" and result = 1.0000000000000109 or 
repr = "(member length (parameter 1 (member compile (member find (member constructor (member fn *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member get (member fn *))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member get (member fn (return (parameter 2 *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 2 (member ATTR (member filter (member selectors (member find (return (parameter 2 (member define *)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member compile (member find (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member each (parameter 2 (member call *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member map (member exports (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member forEach (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member slice (parameter 0 (member select (member find (return (parameter 2 (member define *))))))))" and t = "san" and result = 1.0 or 
repr = "(member setting *)" and t = "snk" and result = 1.0 or 
repr = "(member length (parameter 0 (member access (return (parameter 2 (member define (global)))))))" and t = "san" and result = 0.9999999999999944 or 
repr = "(member length (return (member shift (return (member exec (instance (member RegExp *)))))))" and t = "san" and result = 1.0000000000000107 or 
repr = "(member length (parameter 0 (member collect (parameter 2 (member call *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member lastIndexOf (parameter 1 (instance (member Function (global)))))))" and t = "san" and result = 0.9999999999999937 or 
repr = "(member setting (member body (parameter 0 (parameter 1 *))))" and t = "snk" and result = 1.0 or 
repr = "(member length (return (member shift (return (member exec (return *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member shift (return (member exec *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member collect (parameter 2 *))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member getAttribute (parameter 1 (member find (return *)))))))" and t = "san" and result = 0.9999999999999982 or 
repr = "(member length (parameter 0 (member each (parameter 2 (member call (instance (member Function *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member indexOf (parameter 2 *))))" and t = "san" and result = 0.9999999999999937 or 
repr = "(member newID (member body *))" and t = "snk" and result = 1.0 or 
repr = "(member length (return (member match (parameter 1 (member remove *)))))" and t = "san" and result = 1.0000000000000013 or 
repr = "(member length (parameter 0 (member access (return (member noConflict (return (parameter 2 (member define (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member eq (member fn (return (member noConflict (return (parameter 2 (member define (global))))))))))" and t = "san" and result = 1.0000000000000107 or 
repr = "(member length (return (member map (parameter 2 (member call (return (member Function *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member each (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member indexOf *)))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 2 (member ATTR (member filter (member selectors (member find (return (parameter 2 *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (instance *))))" and t = "san" and result = 0.9999999999999629 or 
repr = "(parameter 0 (member slice (parameter 0 (member select (member find *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member map (parameter 2 (member call (return (member Function (global))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 1 (member matchesSelector (member find *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member sortedIndex (parameter 2 (member call (return (member Function (global))))))))" and t = "san" and result = 0.9999999999999937 or 
repr = "(member length (parameter 1 (member compile (member find (return (parameter 2 *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member eq (member fn (return (parameter 2 (member define (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member forEach (member exports *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length (member length (instance (member RegExp *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member tokenize (member find (return (parameter 2 (member define (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member props (instance *)))" and t = "san" and result = 1.0 or 
repr = "(member html2canvas (global))" and t = "san" and result = 1.000000000000001 or 
repr = "(member html2canvas (member undefined (global)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member map (parameter 1 (return (member Function *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member slice (parameter 0 (member tokenize *))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (parameter 0 (member template (parameter 1 (return (member Function (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member get (member fn (return (parameter 2 (member define (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member setting (member body (parameter 0 (parameter 1 (member put (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "snk" and result = 1.0 or 
repr = "(member length (return (member match (parameter 1 (member add (member event (return (parameter 2 (member define *)))))))))" and t = "san" and result = 1.0000000000000013 or 
repr = "(member length (instance (member get (member fn (member constructor (member fn (return *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member map (parameter 2 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member get (member fn (return (parameter 2 (member define *)))))))" and t = "san" and result = 1.0 or 
repr = "(member newID (member body (parameter 0 (parameter 1 (member put (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "snk" and result = 1.0 or 
repr = "(member length (instance (member eq (member fn (return (member noConflict *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member match (parameter 1 (member remove (member event *))))))" and t = "san" and result = 1.0 or 
repr = "(member newID (member body (parameter 0 (parameter 1 (member put (return (member Router *)))))))" and t = "snk" and result = 1.0 or 
repr = "(member length (parameter 0 (member tokenize (member find *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member RegExp (global))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member range *))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member compile (member find (return (member noConflict (return *)))))))" and t = "san" and result = 1.0000000000000107 or 
repr = "(parameter 0 (member template *))" and t = "san" and result = 1.000000000000001 or 
repr = "(member length (instance (member eq (member fn (return (parameter 2 (member define *)))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (parameter 0 (member template (parameter 1 (instance (member Function (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member map (parameter 2 (member call (instance (member Function (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member get (member fn (member constructor (member fn (return (parameter 2 *))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member slice (member selector *)))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member each (parameter 1 (return (member Function (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member collect (parameter 1 (instance *)))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member getAttribute (parameter 1 (member find (return (parameter 2 (member define (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member eq (member fn (return (member noConflict (return *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (parameter 0 (member tokenize (member find *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member map (parameter 2 (member call (instance (member Function *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member indexOf (member exports (global)))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (parameter 0 (member template (member exports (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member each (parameter 2 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length (member length (return *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (return (member RegExp (global))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member match (parameter 1 (member add (member event (return *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member collect (parameter 2 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length (member length (member length (member length (return *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member collect (parameter 2 (member call *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member access (member constructor (member fn (return (parameter 2 (member define (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member slice (parameter 0 (member tokenize (member find *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member map (member exports *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (return *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member map (parameter 1 (instance *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member get (member fn (return (member noConflict (return (parameter 2 (member define *)))))))))" and t = "san" and result = 1.0000000000000107 or 
repr = "(member newID *)" and t = "snk" and result = 1.0 or 
repr = "(member length (instance (member eq (member fn (member constructor *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member push (parameter 2 *)))" and t = "snk" and result = 0.5374348422496571 or 
repr = "(member length (member length (member length (member length (instance (member RegExp *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member eq (member fn (member constructor (member fn (return (parameter 2 (member define (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member slice (parameter 0 (member tokenize (member find (return (parameter 2 *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length (return (member RegExp *))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member getAttribute (parameter 1 (member find (return (parameter 2 (member define *)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member querySelectorAll (parameter 1 *)))" and t = "snk" and result = 1.0 or 
repr = "(member length (parameter 0 (member access (return (parameter 2 *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member map (parameter 2 (member call (instance (member Function (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member each (parameter 2 (member call (return (member Function *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member indexOf (parameter 1 (instance (member Function (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member RegExp *)))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member indexOf (parameter 1 (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (parameter 0 (member tokenize *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member RegExp (global))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member indexOf (parameter 1 (return (member Function *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member sortedIndex (parameter 1 (instance *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member compile (member find (return (parameter 2 (member define (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member sortedIndex (parameter 2 (member call (instance *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member sortedIndex (parameter 2 (member call *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member slice (member selector (parameter 0 (member select *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member compile (member find (member constructor (member fn (return (parameter 2 *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member collect (parameter 1 (instance (member Function *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member sortedIndex (parameter 1 (instance (member Function (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member map (parameter 1 (instance (member Function (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length (instance (member RegExp (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member shift (return (member exec (instance *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length (member length (member length (member length (return (member RegExp *)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member querySelectorAll (parameter 1 (member find *))))" and t = "snk" and result = 1.0 or 
repr = "(member length (parameter 1 (member compile *)))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member access (member constructor (member fn (return (parameter 2 *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member compile (member find (member constructor (member fn (return (parameter 2 (member define *)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member map (parameter 2 (member call (return *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member tokenize (member find (return (member noConflict (return (parameter 2 *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member map (member exports *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member undefined *))" and t = "san" and result = 1.0000000000000004 or 
repr = "(member length (parameter 0 (member forEach (parameter 2 (member call *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member props *))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member shift (return (member exec (return (member RegExp (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member get *)))" and t = "san" and result = 1.0 or 
repr = "(return (member match (parameter 1 *)))" and t = "src" and result = 0.20833333333333537 or 
repr = "(member length (parameter 1 (member compile (member find (member constructor *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member slice (parameter 0 (member select *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member range *))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member eq (member fn (member constructor (member fn *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length (member length (return (member RegExp (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member match (parameter 1 (member add (member event (return (parameter 2 (member define (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member collect (parameter 1 (return (member Function (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (instance (member RegExp *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member collect (parameter 1 (instance (member Function (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member eq (member fn (member constructor (member fn (return *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (return (member RegExp (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member shift (return (member exec (instance (member RegExp (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member tokenize (member find (return (parameter 2 (member define *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member tokenize (member find (return (member noConflict (return (parameter 2 (member define *)))))))))" and t = "san" and result = 1.0 or 
repr = "(member newID (member body (parameter 0 *)))" and t = "snk" and result = 1.0 or 
repr = "(member length (parameter 0 (member each (parameter 1 (return *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member slice (parameter 0 (member select (member find (return *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member get (member fn (return (member noConflict (return (parameter 2 (member define (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length (member length (member length (member length (instance *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member get (member fn (member constructor (member fn (return (parameter 2 (member define (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member slice (parameter 0 (member select (member find (return (parameter 2 *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member lastIndexOf (parameter 2 (member call *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member access (member constructor (member fn (return (parameter 2 (member define *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member tokenize (member find (member constructor (member fn (return (parameter 2 (member define *)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member forEach *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length (member length *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member forEach (parameter 1 (instance (member Function *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member props (instance (member fix (member event (return (parameter 2 *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length (member length (member length (return (member RegExp *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member lastIndexOf (parameter 2 (member call (instance *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member sortedIndex (parameter 1 (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member match (parameter 1 (member add (member event *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member collect (parameter 2 (member call (return (member Function *)))))))" and t = "san" and result = 1.0 or 
repr = "(member html2canvas (member window (global)))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member indexOf (parameter 2 (member call (instance *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member get (member fn (member constructor *)))))" and t = "san" and result = 1.0 or 
repr = "(member newID (member body (parameter 0 (parameter 1 *))))" and t = "snk" and result = 1.0 or 
repr = "(member length (return (member match (parameter 1 (member remove (member event (return *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member tokenize (member find (member constructor (member fn (return *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member wrap *))" and t = "snk" and result = 1.0 or 
repr = "(member length (return (member slice (parameter 0 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member match (parameter 1 (member add *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member match (parameter 1 (member remove (member event (return (parameter 2 (member define (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length (member length (return (member RegExp *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member collect (parameter 2 (member call (instance (member Function *)))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 1 (member matchesSelector (member find (return (parameter 2 *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member compile (member find (return (member noConflict (return (parameter 2 *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member eq *)))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member sortedIndex (parameter 1 (return (member Function *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member get (member fn (return (member noConflict (return *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member slice (member selector (parameter 0 (member select (member find *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member each (parameter 1 (return (member Function *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member slice (parameter 0 (member tokenize (member find (return (parameter 2 (member define *))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member getAttribute (parameter 1 (member find *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member lastIndexOf (parameter 1 (instance (member Function *))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 1 (member matchesSelector (member find (return (parameter 2 (member define *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 2 (member ATTR (member filter *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member push (instance *)))" and t = "snk" and result = 0.5374348422496582 or 
repr = "(member length (parameter 0 (member access (return (member noConflict (return (parameter 2 *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member map (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member collect *)))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (parameter 0 (member template (parameter 1 *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member indexOf (parameter 1 (instance (member Function *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length (member length (instance *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length (member length (instance (member RegExp (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member lastIndexOf (member exports *))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member compile (member find *))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member lastIndexOf (parameter 2 (member call (return (member Function (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member html2canvas (member undefined *))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member collect (parameter 2 (member call (return (member Function (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member map (parameter 1 (instance (member Function *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member Function (global)))" and t = "snk" and result = 0.277777777777778 or 
repr = "(member length (parameter 0 (member access (return (member noConflict *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member sortedIndex (member exports (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member lastIndexOf (parameter 2 (member call (instance (member Function *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member lastIndexOf (member exports (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member compile (member find (return (parameter 2 (member define *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member match (parameter 1 (member add (member event (return (parameter 2 *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member access (member constructor *))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member lastIndexOf (parameter 2 (member call (instance (member Function (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member collect (parameter 1 (instance (member Function *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member map (parameter 2 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member access (return *))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member each (parameter 1 (instance (member Function (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member sortedIndex (parameter 2 (member call (instance (member Function (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member map (parameter 1 (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member collect (parameter 1 (return (member Function (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member collect (parameter 2 (member call (return (member Function (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member shift (return *))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member forEach (parameter 1 (instance (member Function (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (instance (member RegExp *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member map (parameter 2 (member call *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member each (parameter 1 (instance *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member tokenize (member find (member constructor *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member eq (member fn *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (instance (member RegExp (global))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member slice (parameter 0 (member tokenize (member find (return *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member props (instance (member fix (member event (return *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member slice (member selector (parameter 0 (member select (member find (return (parameter 2 (member define *)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member collect (member exports (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (return (member RegExp *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member lastIndexOf (parameter 1 (return (member Function (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member collect (parameter 1 (instance (member Function (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member tokenize (member find (return (parameter 2 *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member sortedIndex *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member map (parameter 1 (instance (member Function *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member sortedIndex (member exports *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (instance (member RegExp (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member lastIndexOf (parameter 2 (member call (return *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member map (parameter 2 (member call (instance *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 2 (member ATTR *)))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member eq (member fn (return (member noConflict (return (parameter 2 (member define *)))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (parameter 0 (member template (parameter 1 (instance (member Function *)))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (parameter 0 *)))))" and t = "san" and result = 1.0000000000000033 or 
repr = "(member length (parameter 0 (member sortedIndex (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member map (parameter 2 (member call (return (member Function *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length (return (member RegExp (global)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member slice (member selector (parameter 0 (member select (member find (return (parameter 2 *))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 1 (member matchesSelector (member find (return (parameter 2 (member define (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member matchesSelector (member find (member constructor (member fn (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member length (parameter 1 (member compile (member find (return (member noConflict (return (parameter 2 (member define (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member indexOf (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member matchesSelector (member find (member constructor (member fn *)))))" and t = "src" and result = 1.0 or 
repr = "(member length (parameter 0 (member access (return (parameter 2 (member define *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member matchesSelector (member find (member constructor *))))" and t = "src" and result = 1.0 or 
repr = "(return (member replace (return (member replace (return (member replace *))))))" and t = "san" and result = 0.9999999999999969 or 
repr = "(member length (parameter 0 (member collect (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 2 (member ATTR (member filter (member selectors (member find *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member forEach (parameter 1 (instance *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member each (parameter 2 (member call (return (member Function (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member html2canvas *)" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member collect *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member collect (parameter 2 (member call (instance *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member access (return (member noConflict (return *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member sortedIndex (parameter 2 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member access (member constructor (member fn (return *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (parameter 0 (member tokenize (member find (return *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member get (member fn (return (member noConflict (return (parameter 2 *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member lastIndexOf (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member forEach (parameter 2 (member call (return (member Function *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member forEach (member exports (global)))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (return (member replace (parameter 0 *)))))))" and t = "snk" and result = 1.0 or 
repr = "(member length (return (member map (parameter 2 (member call (instance *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member slice (member selector (parameter 0 (member select (member find (return *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member match (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member match (parameter 1 (member remove (member event (return (parameter 2 *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member each (parameter 2 (member call (return *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member forEach (parameter 1 (return (member Function *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member get (member fn (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length (member length (member length (member length (instance (member RegExp *)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member each (member exports *))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member collect (parameter 2 (member call (instance *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member html (return *)))" and t = "snk" and result = 1.0000000000000004 or 
repr = "(member length (member length (member length (return *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member RegExp *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (instance *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member map (parameter 1 (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member collect (parameter 2 (member call (instance (member Function (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (parameter 0 (member tokenize (member find (return (parameter 2 *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member tokenize *)))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member getAttribute (parameter 1 (member find (return (parameter 2 *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (parameter 0 (member tokenize (member find (return (parameter 2 (member define *)))))))))" and t = "san" and result = 1.0 or 
repr = "(member newID (member body (parameter 0 (parameter 1 (member put (return *))))))" and t = "snk" and result = 1.0 or 
repr = "(member length (parameter 2 (member ATTR (member filter (member selectors (member find (return *)))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 1 *)))" and t = "san" and result = 0.9999999999999942 or 
repr = "(member length (parameter 0 (member sortedIndex (parameter 2 (member call (instance (member Function *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member slice (member selector (parameter 0 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length (member length (member length (return (member RegExp (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member collect (parameter 2 (member call (return (member Function *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 2 (member ATTR (member filter (member selectors (member find (return (parameter 2 (member define (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member push (parameter 2 (member find *))))" and t = "snk" and result = 1.0 or 
repr = "(member length (parameter 0 (member indexOf (parameter 1 (instance *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member each *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (return (member RegExp *))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member map (parameter 1 (return (member Function *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length (member length (member length (instance *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member map (parameter 2 (member call *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member shift *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member map (parameter 2 (member call (return (member Function (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member props (instance (member fix (member event (return (parameter 2 (member define (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member eq (member fn (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length (member length (member length (member length (return (member RegExp (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member sortedIndex (parameter 1 (instance (member Function *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member compile (member find (member constructor (member fn (return *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member tokenize (member find (member constructor (member fn (return (parameter 2 *))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (parameter 0 (member template (parameter 1 (instance *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member undefined (global)))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member map (parameter 2 (member call (return *))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (parameter 0 (member template (parameter 1 (return *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member collect (parameter 1 (return (member Function *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member collect (parameter 1 (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member indexOf (parameter 2 (member call *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member tokenize (member find (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member collect (parameter 1 (instance *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member eq (member fn (return (parameter 2 *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member collect (parameter 1 (return (member Function *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member eq (member fn (member constructor (member fn (return (parameter 2 *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member sortedIndex (parameter 1 (return (member Function (global)))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member getAttribute *))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member lastIndexOf *)))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member collect (parameter 2 (member call (instance (member Function *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member collect (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member props (instance (member fix (member event (return (parameter 2 (member define *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member tokenize (member find (return (member noConflict (return *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length (member length (member length (member length (instance (member RegExp (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member tokenize (member find (return (member noConflict *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member collect (member exports (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member sortedIndex (parameter 2 (member call (return (member Function *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member map *)))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member getAttribute (parameter 1 *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member collect (parameter 2 (member call (instance (member Function (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member eq (member fn (member constructor (member fn (return (parameter 2 (member define *)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member sortedIndex (parameter 2 (member call (return *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member props (instance (member fix *))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (parameter 0 (member template (member exports *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member map (parameter 1 (return (member Function (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member get (member fn (return (member noConflict *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length (member length (member length (instance (member RegExp (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member lastIndexOf (parameter 1 (return (member Function *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member map (parameter 1 (instance (member Function (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member map (parameter 1 (instance *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member indexOf (parameter 1 (return (member Function (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member get (member fn (member constructor (member fn (return (parameter 2 (member define *)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member indexOf (parameter 2 (member call (return *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member matchesSelector (member find *)))" and t = "src" and result = 0.9251303155006858 or 
repr = "(member setting (member body (parameter 0 (parameter 1 (member put (return (member Router *)))))))" and t = "snk" and result = 1.0 or 
repr = "(member length (instance (member get (member fn (member constructor (member fn *))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 1 (member matchesSelector *))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member indexOf (member exports *))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member forEach (parameter 2 (member call (instance (member Function (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member map (parameter 1 (return (member Function (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member collect (member exports *))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member each (parameter 2 (member call (instance (member Function (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member indexOf (parameter 2 (member call (instance (member Function (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length (member length (member length (member length *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member forEach (member angular (global))))" and t = "snk" and result = 1.0 or 
repr = "(member length (parameter 0 (member access (member constructor (member fn *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member forEach (parameter 2 (member call (return (member Function (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member map (parameter 2 (member call (instance (member Function *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member indexOf (parameter 2 (member call (instance (member Function *)))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 1 (member matchesSelector (member find (return *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member indexOf (parameter 2 (member call (return (member Function *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member matchesSelector *))" and t = "src" and result = 1.0000000000000009 or 
repr = "(member length (parameter 0 (member collect (parameter 2 (member call (return *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member slice (member selector (parameter 0 (member select (member find (return (parameter 2 (member define (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member lastIndexOf (parameter 1 (return *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member slice (parameter 0 (member tokenize (member find (return (parameter 2 (member define (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length (instance *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member compile (member find (member constructor (member fn (return (parameter 2 (member define (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member forEach (parameter 2 (member call (return *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member access (return (member noConflict (return (parameter 2 (member define *))))))))" and t = "san" and result = 1.0 or 
repr = "(member setting (member body (parameter 0 *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 1 (member copy *))" and t = "san" and result = 1.0000000000000016 or 
repr = "(member length (return (member collect (parameter 1 (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member lastIndexOf (parameter 1 (instance *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member slice (parameter 0 (member select (member find (return (parameter 2 (member define (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(member newID (member body (parameter 0 (parameter 1 (member put *)))))" and t = "snk" and result = 1.0 or 
repr = "(member setting (member body (parameter 0 (parameter 1 (member put (return *))))))" and t = "snk" and result = 1.0 or 
repr = "(member length (parameter 0 (member tokenize (member find (member constructor (member fn *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member shift (return (member exec (return (member RegExp *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member forEach (parameter 2 (member call (instance (member Function *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member eq (member fn (return (member noConflict (return (parameter 2 *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member each (parameter 2 (member call (instance *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member match *)))" and t = "san" and result = 1.0 or 
repr = "(member setting (member body *))" and t = "snk" and result = 1.0 or 
repr = "(member length (member length (member length (member length (member length (member length (return *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 2 (member ATTR (member filter (member selectors *)))))" and t = "san" and result = 1.0 or 
repr = "(member html2canvas (member window *))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member collect (member exports *))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member each (parameter 1 (instance (member Function *))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (parameter 0 (member template *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member tokenize (member find (return (member noConflict (return (parameter 2 (member define (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member compile (member find (return (member noConflict (return (parameter 2 (member define *)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member match (parameter 1 (member remove (member event (return (parameter 2 (member define *)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member forEach (parameter 2 (member call (instance *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member map (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member props (instance (member fix (member event *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member lastIndexOf (parameter 2 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length (member length (member length *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member lastIndexOf (parameter 2 (member call (return (member Function *)))))))" and t = "san" and result = 1.0 or 
repr = "(member setting (member body (parameter 0 (parameter 1 (member put *)))))" and t = "snk" and result = 1.0 or 
repr = "(member length (parameter 0 (member forEach (parameter 2 *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member html (return (member jQuery *))))" and t = "snk" and result = 0.857142857142857 or 
repr = "(member length (return (member slice (parameter 0 (member tokenize (member find (return (parameter 2 (member define (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member access *)))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member compile (member find (return (member noConflict *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member length (member length (member length (member length (member length (instance (member RegExp *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member forEach (parameter 1 (return (member Function (global)))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (parameter 0 (member template (parameter 1 (return (member Function *)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member matchesSelector (member find (return *))))" and t = "src" and result = 1.0 or 
repr = "(member getElementsByClassName *)" and t = "snk" and result = 0.07486968449931375 or 
repr = "(member length (parameter 0 (member indexOf (parameter 2 (member call (return (member Function (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 2 *))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member forEach (parameter 1 (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (member map (member exports (global)))))" and t = "san" and result = 1.0 or 
repr = "(member userID (member query (parameter 0 (parameter 1 *))))" and t = "src" and result = 1.0000000000000016 or 
repr = "(member userID (member query (parameter 0 (parameter 1 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member userID (member query (parameter 0 (parameter 1 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(member userID (member query *))" and t = "src" and result = 1.0 or 
repr = "(member userID *)" and t = "src" and result = 1.0 or 
repr = "(member userID (member query (parameter 0 (parameter 1 (member get (return (root https://www.npmjs.com/package/express)))))))" and t = "src" and result = 1.0 or 
repr = "(member settings *)" and t = "src" and result = 0.2500000000000001 or 
repr = "(member userID (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member extend (member angular *)))" and t = "src" and result = 1.0 or 
repr = "(return (member getData *))" and t = "src" and result = 0.48522633744855975 or 
repr = "(return (member extend (member angular (global))))" and t = "san" and result = 1.0 or 
repr = "(member events *)" and t = "src" and result = 0.20567901234567781 or 
repr = "(parameter 0 (member isFunction (member angular *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member isDefined (member angular (global))))" and t = "san" and result = 1.0 or 
repr = "(member result (return *))" and t = "snk" and result = 0.48106995884773684 or 
repr = "(member version *)" and t = "snk" and result = 0.25 or 
repr = "(parameter 1 (member extend (parameter 0 (parameter 1 (member define (global))))))" and t = "src" and result = 0.12379972565157767 or 
repr = "(parameter 0 (member isDefined *))" and t = "san" and result = 1.0 or 
repr = "(return (member extend (member angular *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member extend (member angular (global))))" and t = "snk" and result = 0.027777777777781315 or 
repr = "(parameter 0 (member isFunction (member angular (global))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member extend (member angular *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member isDefined (member angular *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member extend (member angular (global))))" and t = "src" and result = 1.0 or 
repr = "(member id (member query (parameter 0 (parameter 1 (member put *)))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member ObjectId *))" and t = "src" and result = 1.0 or 
repr = "(member jugend (member query (parameter 0 (parameter 1 (member post (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member jugend (member query (parameter 0 (parameter 1 *))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member readFile (root https://www.npmjs.com/package/fs)))" and t = "san" and result = 1.0 or 
repr = "(member id (member query *))" and t = "src" and result = 1.0 or 
repr = "(member template (parameter 4 (parameter 1 (member require *))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(parameter 1 (member info (return (member get (member loggers *)))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(member hash (parameter 1 (parameter 1 (member registerHelper (parameter 1 (parameter 1 (member define *)))))))" and t = "san" and result = 0.9999999999999984 or 
repr = "(member template (parameter 4 (parameter 1 (member require (global)))))" and t = "san" and result = 1.0 or 
repr = "(member id (member query (parameter 0 (parameter 1 (member delete *)))))" and t = "src" and result = 0.999999999999999 or 
repr = "(member hash (parameter 1 (parameter 1 (member registerHelper (parameter 1 *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member ObjectId (member Types *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member info (return *)))" and t = "san" and result = 1.0 or 
repr = "(member jugend *)" and t = "src" and result = 0.9999999999999972 or 
repr = "(return (member closest *))" and t = "src" and result = 0.16666666666666685 or 
repr = "(member hash (parameter 1 (parameter 1 (member registerHelper (parameter 1 (parameter 1 (member define (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member template (parameter 4 (parameter 1 *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member warn *))" and t = "snk" and result = 0.7500000000000022 or 
repr = "(member length (return (member find (return *))))" and t = "san" and result = 1.000000000000001 or 
repr = "(parameter 0 (root https://www.npmjs.com/package/moment))" and t = "src" and result = 0.9999999999999984 or 
repr = "(member jugend (member query (parameter 0 (parameter 1 (member post *)))))" and t = "src" and result = 1.0 or 
repr = "(member hash (parameter 1 (parameter 1 (member registerHelper (parameter 1 (parameter 1 *))))))" and t = "san" and result = 1.0 or 
repr = "(member template *)" and t = "san" and result = 1.0 or 
repr = "(member id (member query (parameter 0 (parameter 1 (member put (return *))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member ObjectId (member Types (root https://www.npmjs.com/package/mongoose))))" and t = "src" and result = 1.0 or 
repr = "(member length (return (member find *)))" and t = "san" and result = 1.0 or 
repr = "(member id (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(member hash (parameter 1 *))" and t = "san" and result = 1.0 or 
repr = "(member hash (parameter 1 (parameter 1 *)))" and t = "san" and result = 1.0 or 
repr = "(member hash (parameter 1 (parameter 1 (member registerHelper (root https://www.npmjs.com/package/handlebars)))))" and t = "san" and result = 1.0 or 
repr = "(return (parameter 0 (parameter 1 (member define (global)))))" and t = "src" and result = 0.2915752171925001 or 
repr = "(parameter 1 (member info (return (member get *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member info (return (member get (member loggers (root https://www.npmjs.com/package/winston))))))" and t = "san" and result = 1.0 or 
repr = "(member jugend (member query (parameter 0 (parameter 1 (member post (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(member id (member query (parameter 0 (parameter 1 (member put (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(member jugend (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member error (return *)))" and t = "src" and result = 1.0 or 
repr = "(member hash (parameter 1 (parameter 1 (member registerHelper *))))" and t = "san" and result = 1.0 or 
repr = "(member id (member query (parameter 0 (parameter 1 (member delete (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(member jugend (member query *))" and t = "src" and result = 1.0 or 
repr = "(member id (member query (parameter 0 (parameter 1 (member put (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(member template (parameter 4 *))" and t = "san" and result = 1.0 or 
repr = "(member id (member query (parameter 0 (parameter 1 (member delete (return *))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (parameter 2 (member readFile (root https://www.npmjs.com/package/fs))))" and t = "src" and result = 0.5000000000000011 or 
repr = "(parameter 0 (parameter 0 (parameter 1 (member define (global)))))" and t = "san" and result = 1.0000000000000004 or 
repr = "(member id (member query (parameter 0 (parameter 1 *))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member includes (root https://www.npmjs.com/package/lodash)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (parameter 0 (parameter 1 (member define *))))" and t = "san" and result = 1.0 or 
repr = "(member id (member query (parameter 0 (parameter 1 (member delete (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (root https://www.npmjs.com/package/jquery))" and t = "san" and result = 1.0 or 
repr = "(member slug *)" and t = "src" and result = 1.0 or 
repr = "(member jugend (member query (parameter 0 (parameter 1 (member post (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(member cookies *)" and t = "src" and result = 1.0 or 
repr = "(member cookies (parameter 0 *))" and t = "src" and result = 1.0 or 
repr = "(member length (return (member getElementsByTagName (return (member ActiveXObject *)))))" and t = "san" and result = 0.9999999999999944 or 
repr = "(member slide *)" and t = "src" and result = 0.2142857142857139 or 
repr = "(return (member replace (parameter 0 (parameter 1 (member addMethod (member validator (root https://www.npmjs.com/package/jquery)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member concat (member props (instance (member fix (member event *)))))))" and t = "san" and result = 1.000000000000021 or 
repr = "(member length (parameter 1 (member compile (member find (member constructor (member fn (member constructor *)))))))" and t = "san" and result = 1.0000000000000109 or 
repr = "(member length (parameter 1 (member compile (member find (member constructor (member fn (member jQuery (global))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 0 (member processHTML (parameter 1 (member create *))))))" and t = "san" and result = 1.0000000000000004 or 
repr = "(return (member replace (parameter 1 (member matchesSelector (member find (member jQuery *))))))" and t = "san" and result = 1.0 or 
repr = "(return (member g (global)))" and t = "src" and result = 0.49999999999999944 or 
repr = "(return (member substring (return (member replace (parameter 0 *)))))" and t = "src" and result = 1.0 or 
repr = "(member resource *)" and t = "src" and result = 0.5833333333333333 or 
repr = "(member length (instance (member get (member fn (member jQuery (parameter 0 (member call *)))))))" and t = "san" and result = 1.0000000000000109 or 
repr = "(parameter 0 (parameter 1 (member addMethod (member validator (parameter 0 (parameter 1 *))))))" and t = "src" and result = 1.0 or 
repr = "(member length (member props (instance (member fix (member event (member jQuery (parameter 0 *)))))))" and t = "san" and result = 1.0 or 
repr = "(member iframeHTML (instance (member init *)))" and t = "san" and result = 1.0000000000000016 or 
repr = "(return (member encode (instance *)))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member get (member fn (member jQuery *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 3 (parameter 1 (member define (global)))))" and t = "san" and result = 1.0 or 
repr = "(return (member ajax (parameter 0 *)))" and t = "san" and result = 0.025877166729018464 or 
repr = "(parameter 0 (member push (parameter 2 (member find (member constructor (member fn (member constructor *)))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 1 (member replace (return (member String (global)))))" and t = "src" and result = 0.22841563786007635 or 
repr = "(member length (parameter 2 (member ATTR (member filter (member selectors (member find (member constructor *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member compile (member find (member jQuery (parameter 0 (member call (member eval (member window (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member jQuery (global))))" and t = "san" and result = 1.000000000000001 or 
repr = "(parameter 0 (member append (instance (member init (member fn (member constructor (member fn (member jQuery *))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member match (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(member length (instance (member init (member fn (member constructor *)))))" and t = "san" and result = 1.0000000000000109 or 
repr = "(return (member replace (parameter 0 (parameter 1 (member addMethod (member validator (parameter 0 *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member get (member fn (member jQuery (parameter 0 (member call (member eval *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 2 (member ATTR (member filter (member selectors (member find (member constructor (member fn (member jQuery (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member concat (member props (instance *)))))" and t = "san" and result = 1.0 or 
repr = "(member direction *)" and t = "src" and result = 1.0 or 
repr = "(member length (instance (member init (member fn (member constructor (member fn (member constructor *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member concat (member props (instance (member fix *))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 0 (member processHTML (parameter 1 (member create (member tinymce *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getElementsByName (member document (member window *)))))" and t = "san" and result = 1.0000000000000016 or 
repr = "(parameter 1 (member matchesSelector (member find (member jQuery (parameter 0 (member call (member eval (global))))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member find (member jQuery (global))))" and t = "src" and result = 0.6940803030448864 or 
repr = "(parameter 0 (member append (instance (member init (member fn (member jQuery (parameter 0 (member call (member eval *)))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 1 (member matchesSelector (member find (member jQuery (parameter 0 *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member init (member fn (member jQuery (parameter 0 *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member append (instance (member init (member fn (member constructor (member fn (member jQuery (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member init (member fn (member constructor (member fn (return (parameter 2 (member define *)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member addMethod *)))" and t = "src" and result = 0.7499999999999999 or 
repr = "(member length (parameter 1 (member compile (member find (member constructor (member fn (member constructor (member fn (member jQuery *)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member substring *))" and t = "src" and result = 0.04938271604938485 or 
repr = "(parameter 1 (member substring *))" and t = "snk" and result = 0.5981481481481615 or 
repr = "(member length (instance (member init (member fn (member jQuery *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member compile (member find (member jQuery (parameter 0 (member call (member eval (member window *)))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member getAttribute (parameter 1 (member find (member constructor *)))))))" and t = "san" and result = 1.0000000000000118 or 
repr = "(return (member apply (member min (member Math *))))" and t = "snk" and result = 0.5886419753086415 or 
repr = "(member length (instance (member get (member fn (member jQuery (parameter 0 (member call (member eval (member window (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member get (member fn (member jQuery (global))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member push (parameter 2 (member find (member jQuery (parameter 0 *))))))" and t = "snk" and result = 1.0 or 
repr = "(member length (instance (member get (member fn (member constructor (member fn (member jQuery *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getElementsByName (member document (member window (global))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member compile (member find (member constructor (member fn (member constructor (member fn (member jQuery (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member querySelectorAll (parameter 1 (member find (member jQuery (global))))))" and t = "snk" and result = 1.0 or 
repr = "(member innerHTML (return (member createElement (member document (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member String (global))))" and t = "san" and result = 1.0000000000000016 or 
repr = "(return (member charAt *))" and t = "src" and result = 0.4444444444444449 or 
repr = "(member length (return (member String (global))))" and t = "san" and result = 1.0 or 
repr = "(member context (parameter 0 *))" and t = "src" and result = 0.8254458161865574 or 
repr = "(parameter 1 (member setItem (member localStorage (global))))" and t = "snk" and result = 0.4999999999999997 or 
repr = "(member length (member values *))" and t = "san" and result = 0.9999999999999972 or 
repr = "(member iframeHTML (instance (member init (parameter 1 (member create *)))))" and t = "san" and result = 1.0 or 
repr = "(member iframeHTML (instance (member init (parameter 1 (member create (member tinymce (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member compile (member find (member jQuery (parameter 0 *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member concat *)))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member init (member fn (member jQuery (global))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member merge *))" and t = "src" and result = 1.0 or 
repr = "(return (member replace (parameter 1 (member matchesSelector (member find (member constructor (member fn *)))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (member hash (member location *))))" and t = "src" and result = 1.0 or 
repr = "(member length (instance (member init (member fn (return (parameter 2 (member define *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getElementsByName *)))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member init (member fn *))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member init *)))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member getAttribute (member document *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 2 (member ATTR (member filter (member selectors (member find (member constructor (member fn *))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (return (member require *)))" and t = "san" and result = 1.0 or 
repr = "(member innerHTML (parameter 0 *))" and t = "san" and result = 1.0000000000000044 or 
repr = "(parameter 0 (member append (instance (member init (member fn (return (parameter 2 (member define *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 2 (member ATTR (member filter (member selectors (member find (member jQuery *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getElementsByTagName (return *))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (parameter 0 (member processHTML (parameter 1 (member create *))))))))" and t = "san" and result = 0.9999999999999937 or 
repr = "(member length (instance (member init (member fn (member jQuery (parameter 0 (member call (member eval (member window (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member props (instance (member fix (member event (member jQuery (parameter 0 (member call *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member get (member fn (member constructor (member fn (member constructor (member fn (member jQuery (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member param *))" and t = "src" and result = 1.0000000000000016 or 
repr = "(member items (parameter 0 (member _protect *)))" and t = "snk" and result = 0.2620438957476003 or 
repr = "(parameter 0 (member append (instance (member init (member fn (member constructor *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member append (instance (member init (member fn (member jQuery (parameter 0 *)))))))" and t = "san" and result = 1.0 or 
repr = "(return (member encode (member DOM *)))" and t = "san" and result = 0.9999999999999984 or 
repr = "(member length (return (member map (parameter 0 (parameter 1 (member define (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member init (member fn (member constructor (member fn (member constructor (member fn (member jQuery (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getElementsByTagName (return (member parseFromString (return *))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 1 (member matchesSelector (member find (member constructor (member fn (member jQuery (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member extend (parameter 0 (parameter 1 (member define (global))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (parameter 0 (member processHTML (parameter 1 *)))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 0 (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member onError *))" and t = "src" and result = 0.021696387745770318 or 
repr = "(parameter 1 (member matchesSelector (member find (member constructor (member fn (member constructor (member fn (member jQuery *))))))))" and t = "src" and result = 0.04096175908016933 or 
repr = "(return (member replace (return (member replace (parameter 0 (member processHTML (parameter 1 (member create (member tinymce (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member strictEqual *))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member get (member fn (member jQuery (parameter 0 (member call (member eval (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getElementsByName (member document *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member props (instance (member fix (member event (member constructor (member fn (member jQuery (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member props (instance (member fix (member event (member jQuery (global)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (return *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member writeAttribute *))" and t = "snk" and result = 0.41666666666666674 or 
repr = "(member length (instance (member init (member fn (member jQuery (parameter 0 (member call *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member values (instance (member Donut *))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 1 (member matchesSelector (member find (member constructor (member fn (member jQuery *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member init (member fn (member constructor (member fn *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member init *))" and t = "snk" and result = 0.4166666666666674 or 
repr = "(member length (return (member getElementsByTagName (return (member parseFromString (instance (member DOMParser (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member String *)))" and t = "san" and result = 1.0 or 
repr = "(member forced_root_block (member settings *))" and t = "src" and result = 0.5000000000000002 or 
repr = "(return (member replace (parameter 0 (parameter 1 (member addMethod (member validator (parameter 0 (parameter 1 (member define *)))))))))" and t = "san" and result = 1.0 or 
repr = "(member fn (parameter 0 *))" and t = "src" and result = 0.4809425827944362 or 
repr = "(return (member encode (member DOM (member tinymce *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member define (global))))" and t = "src" and result = 0.5504801097393688 or 
repr = "(parameter 1 (member setItem *))" and t = "snk" and result = 0.24999999999999983 or 
repr = "(return (member escape (global)))" and t = "src" and result = 0.9409053497942375 or 
repr = "(member classList (return (member querySelector (member document (global)))))" and t = "snk" and result = 0.25000000000000244 or 
repr = "(member documentBaseURL (member tinymce (global)))" and t = "src" and result = 0.5000000000000009 or 
repr = "(member length (parameter 1 (member compile (member find (member jQuery (global))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getElementsByTagName (instance (member ActiveXObject *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getElementsByTagName (return (member parseFromString (return (member DOMParser *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member values (instance (member redraw (instance (member Donut *))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 1 (member matchesSelector (member find (member constructor *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member append (return (parameter 0 *))))" and t = "snk" and result = 1.0 or 
repr = "(member length (return (member map (root https://www.npmjs.com/package/jquery))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (parameter 0 (member processHTML *))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 1 (member matchesSelector (member find (member jQuery (parameter 0 (member call (member eval *)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member append (return (root https://www.npmjs.com/package/jquery))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member removeClass (return *)))" and t = "snk" and result = 0.7500000000000013 or 
repr = "(member length (instance (member get (member fn (member jQuery (parameter 0 (member call (member eval (member window *)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member map (parameter 0 (parameter 1 (member define *))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (return (member replace (return *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member append (instance (member init (member fn (member jQuery *))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 1 (member matchesSelector (member find (member jQuery (parameter 0 (member call *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member values (instance (member redraw (instance (member Donut (member Morris (global))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member querySelectorAll (parameter 1 (member find (member jQuery *)))))" and t = "snk" and result = 0.4173786150429809 or 
repr = "(member values *)" and t = "snk" and result = 0.1132144490169193 or 
repr = "(member length (member props (instance (member fix (member event (member jQuery *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member ok *))" and t = "san" and result = 1.0 or 
repr = "(return (member extend (parameter 0 (parameter 1 (member define *)))))" and t = "san" and result = 0.12379972565157743 or 
repr = "(member length (instance (member init (member fn (member constructor (member fn (member constructor (member fn (member jQuery *)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member props (instance (member fix (member event (member jQuery (parameter 0 (member call (member eval *)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member init (member fn (member jQuery (parameter 0 (member call (member eval *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member init (member fn (member constructor (member fn (return (parameter 2 (member define (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member init (member fn (return (parameter 2 (member define (global))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member getAttribute (parameter 1 (member find (member constructor (member fn *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member get (member fn (member constructor (member fn (member constructor *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 2 (member ATTR (member filter (member selectors (member find (member jQuery (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member values (instance (member redraw *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member values (instance *)))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member getAttribute (parameter 1 (member find (member jQuery *)))))))" and t = "san" and result = 1.0 or 
repr = "(return (member encode (member DOM (member tinymce (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member props (instance (member fix (member event (member constructor (member fn *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member init (member fn (member constructor (member fn (return (parameter 2 *))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member getAttribute (parameter 1 (member find (member jQuery (global))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member append (instance (member init (member fn (member jQuery (parameter 0 (member call *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getElementsByTagName (member undefined *))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 0 (parameter 1 (member addMethod (member validator (parameter 0 (parameter 1 *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member get (member fn (member constructor (member fn (member constructor (member fn *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member init (member fn (member jQuery (parameter 0 (member call (member eval (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 0 (member processHTML *))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (member hash *)))" and t = "src" and result = 0.5000000000000031 or 
repr = "(return (member replace (return (member getAttribute (member document (member window (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member concat (member props (instance (member fix (member event (member jQuery *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member compile (member find (member constructor (member fn (member constructor (member fn *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member String *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member strictEqual *))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member init (member fn (member jQuery (parameter 0 (member call (member eval (member window *)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member values (instance (member Donut (member Morris *)))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member getAttribute (member document (member window *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getElementsByTagName (instance (member ActiveXObject (global))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member addClass (return (root https://www.npmjs.com/package/jquery))))" and t = "snk" and result = 0.7500000000000013 or 
repr = "(member length (parameter 1 (member compile (member find (member jQuery (parameter 0 (member call (member eval *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 2 (member ATTR (member filter (member selectors (member find (member constructor (member fn (member jQuery *)))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (parameter 0 (member processHTML (parameter 1 (member create (member tinymce *)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member append (instance (member init (member fn (return (parameter 2 (member define (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member get (member fn (member constructor (member fn (member jQuery (global))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member append (instance (member init (member fn (member constructor (member fn *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member props (instance (member fix (member event (member constructor *))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 1 (member matchesSelector (member find (member jQuery (parameter 0 (member call (member eval (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 3 (parameter 1 (member define *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member append (instance (member init (member fn (member jQuery (parameter 0 (member call (member eval (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member toString *))))" and t = "san" and result = 1.0000000000000007 or 
repr = "(return (member replace (return (member getAttribute (parameter 1 (member find (member constructor (member fn (member jQuery *)))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member getAttribute (member document (global))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member compile (member find (member jQuery (parameter 0 (member call *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member jQuery *)))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 0 (parameter 1 (member addMethod (member validator *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member compile (member find (member constructor (member fn (member jQuery *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member appendTo *))" and t = "snk" and result = 0.9999999999999984 or 
repr = "(member length (instance (member init (member fn (member constructor (member fn (return *)))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 1 (member matchesSelector (member find (member jQuery (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getElementsByTagName (return (member ActiveXObject (global))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member append (instance (member init (member fn (return *))))))" and t = "san" and result = 1.0 or 
repr = "(member className (return *))" and t = "snk" and result = 0.5000000000000004 or 
repr = "(parameter 0 (member append (instance (member init (member fn (member jQuery (global)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member writeText *))" and t = "snk" and result = 0.549999999999998 or 
repr = "(return (member replace (parameter 0 (member processHTML (parameter 1 *)))))" and t = "san" and result = 1.0 or 
repr = "(member iframeHTML (instance (member init (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 0 (parameter 1 (member each *)))))" and t = "src" and result = 1.0 or 
repr = "(member length (return (member getElementsByTagName (return (member parseFromString (instance *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member compile (member find (member jQuery (parameter 0 (member call (member eval (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(member urls *)" and t = "src" and result = 0.6666666666666679 or 
repr = "(member length (member props (instance (member fix (member event (member jQuery (parameter 0 (member call (member eval (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (global)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member append (instance (member init *))))" and t = "san" and result = 1.0 or 
repr = "(return (member extend (parameter 0 (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member append (instance (member init (member fn *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member values (instance (member redraw (instance *)))))" and t = "san" and result = 1.0 or 
repr = "(member iframeHTML (instance *))" and t = "san" and result = 1.0 or 
repr = "(member length (member props (instance (member fix (member event (member constructor (member fn (member jQuery *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member init (member fn (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member concat (member props *))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 0 (parameter 1 (member addMethod (member validator (parameter 0 (parameter 1 (member define (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 0 (member processHTML (parameter 1 (member create (member tinymce (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member get (member fn (member jQuery (parameter 0 *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member init (member fn (member constructor (member fn (member constructor (member fn *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member values (instance (member Donut (member Morris (global))))))" and t = "san" and result = 1.0 or 
repr = "(member iframeHTML *)" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member get (member fn (member constructor (member fn (member constructor (member fn (member jQuery *)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member append (instance (member init (member fn (return (parameter 2 *)))))))" and t = "san" and result = 1.0 or 
repr = "(member innerText *)" and t = "snk" and result = 1.0 or 
repr = "(member length (return (member getElementsByTagName (member undefined (global)))))" and t = "san" and result = 1.0 or 
repr = "(member ThemeManager (member tinymce (global)))" and t = "src" and result = 0.5000000000000009 or 
repr = "(parameter 0 (member push (parameter 2 (member find (member constructor (member fn (member constructor (member fn *))))))))" and t = "snk" and result = 1.0 or 
repr = "(member length (instance (member init (member fn (member constructor (member fn (member jQuery (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member compile (member find (member jQuery *)))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 0 (parameter 1 (member addMethod *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getElementsByName (member document (global)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member push (parameter 2 (member find (member constructor (member fn (member constructor (member fn (member jQuery *)))))))))" and t = "snk" and result = 0.7500000000000078 or 
repr = "(return (member replace (return (member getAttribute (parameter 1 (member find (member constructor (member fn (member jQuery (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member init (member fn (return (parameter 2 *))))))" and t = "san" and result = 1.0 or 
repr = "(member iframeHTML (instance (member init (parameter 1 (member create (member tinymce *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getElementsByTagName (instance *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getElementsByTagName (return (member parseFromString *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member concat (member props (instance (member fix (member event (member jQuery (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member values (instance (member redraw (instance (member Donut (member Morris *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member init (member fn (member constructor (member fn (member jQuery *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member map (parameter 0 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getElementsByTagName (return (member parseFromString (return (member DOMParser (global))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member push (parameter 2 (member find (member jQuery (parameter 0 (member call (member eval (member window *)))))))))" and t = "snk" and result = 1.0 or 
repr = "(member length (return (member getElementsByTagName (return (member parseFromString (instance (member DOMParser *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (return (member require (global))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member map (parameter 0 (parameter 1 *)))))" and t = "san" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 2 (member put *)))))" and t = "src" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 2 (member put (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 2 (member put (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 2 (member put (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member equal (root https://www.npmjs.com/package/assert)))" and t = "san" and result = 1.0 or 
repr = "(return (member substring (return (member replace (parameter 0 (member token (instance (member Lexer *))))))))" and t = "src" and result = 0.19581618655692126 or 
repr = "(member stdout (return *))" and t = "snk" and result = 1.0 or 
repr = "(member length (return (member listeners (return (member EventEmitter *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getOwnPropertyNames *)))" and t = "san" and result = 1.0000000000000002 or 
repr = "(member length (instance (member Buffer *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member max (member Math (member Object (member self *)))))" and t = "san" and result = 0.9999999999999895 or 
repr = "(member length (member _bufs (instance (parameter 0 *))))" and t = "san" and result = 0.9999999999999972 or 
repr = "(member length (return (member listeners (return *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (instance (member constructor *)))))" and t = "san" and result = 0.9999999999999937 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance (member InlineLexer (member parse (return (member options (root https://www.npmjs.com/package/marked))))))))))" and t = "san" and result = 1.0000000000000318 or 
repr = "(return (member replace (return (member stringify *))))" and t = "san" and result = 1.0 or 
repr = "(member email (member query (parameter 0 (parameter 1 *))))" and t = "src" and result = 1.0 or 
repr = "(member length (return (member slice (member _buf *))))" and t = "san" and result = 0.9999999999999969 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance (member InlineLexer (member parse (return (member setOptions (root https://www.npmjs.com/package/marked))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member listeners (instance (member EventEmitter *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (root https://www.npmjs.com/package/bl)))" and t = "san" and result = 1.0000000000000013 or 
repr = "(member length (instance (member Buffer (global))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member min (member Math (member window (global)))))" and t = "san" and result = 0.9999999999999895 or 
repr = "(parameter 0 (member Array (member Object (global))))" and t = "san" and result = 0.9999999999999937 or 
repr = "(parameter 0 (member Array (member Object *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (member _buf (return (member BerReader *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member cmp (return *)))" and t = "snk" and result = 0.5000000000000016 or 
repr = "(parameter 0 (member max (member Math (member self *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (return (member replace (parameter 0 (member token (instance *)))))))" and t = "san" and result = 1.0000000000000013 or 
repr = "(parameter 0 (member min (member Math (member Object (member window (global))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member max (member Math (member global *))))" and t = "san" and result = 1.0 or 
repr = "(return (member substr (return (member trim (parameter 0 (member parse (instance *)))))))" and t = "snk" and result = 0.4988477366255103 or 
repr = "(member length (return (member listeners (return (return (member require *))))))" and t = "san" and result = 0.9999999999999895 or 
repr = "(member length (member _bufs (instance (root https://www.npmjs.com/package/bl))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance (member InlineLexer (return (member options (member parse *)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 3 (member format *))" and t = "snk" and result = 0.5000000000000004 or 
repr = "(parameter 0 (member Array (member global (global))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member toString (instance (member constructor *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member strictEqual (member assert *)))" and t = "san" and result = 1.000000000000001 or 
repr = "(parameter 1 (member min (member Math (member window (global)))))" and t = "san" and result = 0.9999999999999892 or 
repr = "(parameter 1 (member min (member Math (member self (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (member _buf (instance *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member prerelease (instance (member SemVer (member SemVer (member SemVer (member SemVer (member SemVer *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member BN *)))" and t = "san" and result = 0.9999999999999944 or 
repr = "(parameter 0 (member max (member Math (member window *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member same (parameter 0 (parameter 1 (member test *)))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(member email (member query *))" and t = "src" and result = 1.0 or 
repr = "(parameter 2 (member extend (parameter 1 *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member on (return (member request (root https://www.npmjs.com/package/http))))))" and t = "src" and result = 1.0 or 
repr = "(member _wcurpath *)" and t = "src" and result = 1.0 or 
repr = "(member length (instance (member constructor (return (member _augment *)))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (return (member replace (return (member stringify *))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (return (member replace (parameter 0 *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (parameter 0 (parameter 1 (root https://www.npmjs.com/package/tape)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member Array (member Object (member global (global)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member max (member Math (member self (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member toString (member size (member buffer (return (member Uint8Array *)))))))" and t = "san" and result = 1.0000000000000107 or 
repr = "(parameter 0 (member max (member Math (member module (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member _bufs (instance (parameter 0 (member inherits *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (root https://www.npmjs.com/package/minimalistic-assert)))" and t = "san" and result = 1.0 or 
repr = "(member protocol (member location (member global (global))))" and t = "san" and result = 0.9999999999999984 or 
repr = "(member email (member query (parameter 0 (parameter 1 (member get (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member slice (instance (member Buffer *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member min (member Math (member Object (member self *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member constructor (return *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member Buffer *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member same (parameter 0 (parameter 1 (member test (root https://www.npmjs.com/package/tap))))))" and t = "san" and result = 1.0 or 
repr = "(member name (member query (parameter 0 (parameter 1 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(return (member replace (return (member replace (return (member replace (return (member stringify (member JSON *)))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member encode (return (parameter 0 (parameter 0 (return (root https://www.npmjs.com/package/amdefine)))))))" and t = "san" and result = 0.9999999999999993 or 
repr = "(member length (return (member slice (return (member slice (instance *))))))" and t = "san" and result = 1.0000000000000109 or 
repr = "(parameter 0 (member literal (member builders (member types *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member prerelease *))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member stringify (member JSON (global))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member BN (member BN (member BN (member BN (member BN (member BN *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member toString (member byteLength (member buffer (instance (member Uint8Array *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (return (member slice (return (member slice *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member min (member Math (member Object (member global *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member min (member Math (member Object (member global *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (return *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member Array (member window (global))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member listeners (return (member EventEmitter (return *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance (member InlineLexer (member parse (member parse *))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member equals (parameter 0 (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(return (member encode (return *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member Object (global))))" and t = "san" and result = 1.0 or 
repr = "(member path (return (member parse *)))" and t = "src" and result = 0.12500000000000122 or 
repr = "(parameter 0 (member substring (return (member replace (parameter 0 (member token (instance (member Lexer (root https://www.npmjs.com/package/marked)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (return (member substring (parameter 0 (member output (instance *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member literal (member builders (member types (root https://www.npmjs.com/package/recast)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member same (parameter 0 (parameter 1 (root https://www.npmjs.com/package/tape)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member prerelease (instance *)))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member copy *)))" and t = "san" and result = 0.999999999999999 or 
repr = "(parameter 1 (member copy (return (member Buffer (global)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance (member InlineLexer (member parse (return *))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member deepEqual (parameter 0 (parameter 1 (member test *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member plan (parameter 0 (parameter 1 (member test (parameter 0 (parameter 1 (root https://www.npmjs.com/package/tape))))))))" and t = "san" and result = 1.0000000000000016 or 
repr = "(parameter 0 (member push (instance (parameter 0 *))))" and t = "snk" and result = 0.352263374485597 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance (member InlineLexer (root https://www.npmjs.com/package/marked)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member max (member Math (member Object (member global *)))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (return (member String *))))))" and t = "san" and result = 0.9999999999999988 or 
repr = "(member length (return (member dump (instance *))))" and t = "san" and result = 1.0000000000000013 or 
repr = "(member length (instance (member constructor (return (member _augment (member Buffer *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member extend (parameter 1 (parameter 2 (member define *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member writeFile (root https://www.npmjs.com/package/fs)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member max (member Math (member global (global)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member min (member Math (member Object (member global (global))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (return (member toFunction (return (return (return (root https://www.npmjs.com/package/generate-function)))))))" and t = "san" and result = 1.000000000000001 or 
repr = "(parameter 0 (member max (member Math (member Object (member global (global))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member min (member Math (member global (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (return (member slice (return (member Buffer *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member writeUInt32BE *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member Array (member Object (member self *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member toString (member size (member buffer (instance *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member strictEqual (root https://www.npmjs.com/package/assert)))" and t = "san" and result = 1.0 or 
repr = "(member length (member prerelease (instance (member SemVer (member SemVer (member SemVer (member SemVer *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (return (member substring *))))" and t = "san" and result = 1.0 or 
repr = "(return (member parse (root https://www.npmjs.com/package/url)))" and t = "src" and result = 0.3396433470507554 or 
repr = "(parameter 0 (member runInNewContext *))" and t = "snk" and result = 0.20683127572016968 or 
repr = "(parameter 0 (member plan (parameter 0 (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member prerelease (instance (member SemVer (member SemVer (member SemVer (member SemVer (member SemVer (member SemVer *)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member plan (parameter 0 (parameter 1 (member test (parameter 0 *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member prerelease (instance (member SemVer (root https://www.npmjs.com/package/semver)))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member BN (member BN (global)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member strictEqual (parameter 0 (parameter 1 (root https://www.npmjs.com/package/tape)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member normalize (root https://www.npmjs.com/package/path)))" and t = "src" and result = 0.02457647462277357 or 
repr = "(member length (return (member listeners (instance (member EventEmitter (return *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member fixedTimeComparison (root https://www.npmjs.com/package/cryptiles)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (instance (member constructor (return (member _augment (member Buffer *))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member max (member Math (member Object (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member listeners (return (return *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance (member InlineLexer (member parse (member parse (member parse (root https://www.npmjs.com/package/marked))))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member deepEqual (member assert *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member slice (instance (member Buffer (global)))))" and t = "san" and result = 1.0000000000000047 or 
repr = "(parameter 1 (member copy (return (member Buffer *))))" and t = "san" and result = 1.0 or 
repr = "(member name (member query (parameter 0 (parameter 1 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member writeUInt32BE (return (member Buffer (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (root https://www.npmjs.com/package/lru-cache)))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (return (member toFunction (return *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 0 (member every *)))" and t = "src" and result = 0.2500000000000001 or 
repr = "(parameter 0 (member ok (parameter 0 (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance (member InlineLexer (member parse (return (member options *)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member Buffer (root https://www.npmjs.com/package/buffer))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member toString (instance *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (instance (member constructor (return (member _augment (member Buffer (root https://www.npmjs.com/package/buffer)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member equals (parameter 0 *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (return (member Buffer *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (parameter 0 *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member plan (parameter 0 (parameter 1 (member test (root https://www.npmjs.com/package/tap))))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(parameter 0 (member substring (return (member replace (parameter 0 (member token (instance (member Lexer (member parse (root https://www.npmjs.com/package/marked))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member BN (member BN (member BN (member BN (member BN (member BN (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (return (member slice (return (member slice (instance *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member toString (instance (member Buffer *)))))" and t = "san" and result = 1.0000000000000122 or 
repr = "(parameter 0 (member info *))" and t = "snk" and result = 0.25000000000000155 or 
repr = "(parameter 0 (member min (member Math (member global *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member min (member Math (member Object (member self *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (return (member toFunction (return (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member condition *)" and t = "src" and result = 0.022949245541839774 or 
repr = "(member condition *)" and t = "snk" and result = 0.037434842249658734 or 
repr = "(member length (return (member slice (instance (member Buffer (global))))))" and t = "san" and result = 1.0 or 
repr = "(member name (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member copy (instance *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (return (root https://www.npmjs.com/package/debug)))" and t = "src" and result = 1.0 or 
repr = "(member length (instance (parameter 0 (member inherits *))))" and t = "san" and result = 1.0 or 
repr = "(return (member concat (member Buffer *)))" and t = "src" and result = 0.40178571428571536 or 
repr = "(parameter 0 (member same *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (return (member replace (parameter 0 (member token *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member dump *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member on (return (member request (root https://www.npmjs.com/package/https))))))" and t = "src" and result = 1.0 or 
repr = "(return (member replace (return (member toString (return *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member min (member Math (member window *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member apply (member fromCharCode (member String (global)))))" and t = "snk" and result = 0.3534156378600779 or 
repr = "(parameter 0 (member substring (return (member replace (parameter 0 (member token (instance (member Lexer *))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member writeUInt32BE (instance (member Buffer *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member removeComments *))" and t = "snk" and result = 0.2500000000000003 or 
repr = "(return (member replace (return (member replace (return (member String (global)))))))" and t = "san" and result = 1.0 or 
repr = "(return (member mont *))" and t = "san" and result = 1.000000000000003 or 
repr = "(parameter 0 (member min (member Math (member Object (global)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member equals (parameter 0 (parameter 1 (member test (parameter 0 (parameter 1 (member test (root https://www.npmjs.com/package/tap)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member min (member Math (member Object (member window *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member notEqual (root https://www.npmjs.com/package/assert)))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member toString *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member extend (parameter 1 (parameter 2 *))))" and t = "san" and result = 1.0 or 
repr = "(member set (instance *))" and t = "src" and result = 0.4999999999999971 or 
repr = "(member length (return (member toString (member size (member buffer (instance (member Uint8Array *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member min (member Math (member Object *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member pipe *))" and t = "snk" and result = 0.25000000000000044 or 
repr = "(parameter 4 (member format *))" and t = "snk" and result = 0.5000000000000004 or 
repr = "(parameter 0 (member realpath (root https://www.npmjs.com/package/fs)))" and t = "snk" and result = 0.12880658436214376 or 
repr = "(parameter 0 (member min (member Math (member self *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance (member InlineLexer (return (member setOptions (member parse *)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member min (member Math (member module (global)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (parameter 0 (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (return (member toFunction (return (return (return *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member Array (member module *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member _bufs (instance (parameter 0 (member inherits (root https://www.npmjs.com/package/util))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member Array (member exports (global))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (return (member substring (parameter 0 (member output *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member writeUInt32BE (instance (member Buffer (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member write *)))" and t = "san" and result = 0.999999999999999 or 
repr = "(member length (member prerelease (instance (member SemVer (member SemVer (member SemVer (member SemVer (member SemVer (member SemVer (root https://www.npmjs.com/package/semver))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (return (member slice *)))))" and t = "san" and result = 1.0 or 
repr = "(return (member toString (return (member concat (member Buffer (global))))))" and t = "src" and result = 0.7500000000000033 or 
repr = "(parameter 1 (member equals (parameter 0 (parameter 1 (member test *)))))" and t = "san" and result = 1.0 or 
repr = "(return (member toString (return (member readFileSync (root https://www.npmjs.com/package/fs)))))" and t = "src" and result = 0.5000000000000047 or 
repr = "(member length (return (member slice (return (member slice (return *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member deepEqual (member assert (root https://www.npmjs.com/package/chai))))" and t = "san" and result = 1.0 or 
repr = "(member protocol (member location (member global *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member copy (return *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member Array (member Object (member window (global)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member toString (instance (member constructor (return *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member min (member Math (member module *))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member constructor (return (member _augment (member constructor *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member plan (parameter 0 *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member prerelease (instance (member SemVer (member SemVer (member SemVer *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member writeUInt32BE (return *)))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (return (member stringify *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member write (instance *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member info (return (member Logger (root https://www.npmjs.com/package/eazy-logger)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member plan (parameter 0 (parameter 1 (member test (parameter 0 (parameter 1 *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member push (instance (parameter 0 (root https://www.npmjs.com/package/through2)))))" and t = "snk" and result = 1.0 or 
repr = "(member filter *)" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member min (member Math (member Object *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member spawn *))" and t = "snk" and result = 0.49999999999999956 or 
repr = "(parameter 0 (member all (root https://www.npmjs.com/package/q)))" and t = "snk" and result = 0.5568312757201831 or 
repr = "(return (member format (root https://www.npmjs.com/package/util)))" and t = "snk" and result = 0.49999999999999933 or 
repr = "(parameter 0 (member strictEqual (parameter 0 (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member Array (member self *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member slice (return (member Buffer (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member toString *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member writeUInt32BE (instance *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member listeners (instance (return (member require *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member max (member Math (member exports *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member toString (member byteLength (member buffer *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member same (parameter 0 *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member min (member Math (member Object (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member toString (member byteLength (member buffer (instance *))))))" and t = "san" and result = 1.0 or 
repr = "(member name (member query (parameter 0 (parameter 1 (member get (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(member length (member prerelease (instance (member SemVer (member SemVer *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member listeners (return (member EventEmitter (return (member require *)))))))" and t = "san" and result = 1.0 or 
repr = "(member protocol (member location (member self (global))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member BN (member BN (member BN (member BN *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member plan *))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member listeners (return (member EventEmitter (return (member require (global))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 3 (member copy *))" and t = "san" and result = 1.0000000000000047 or 
repr = "(parameter 0 (member spawn *))" and t = "san" and result = 1.0 or 
repr = "(return (member encode (return (parameter 0 *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (parameter 0 *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member toString (member size (member buffer (return (member Uint8Array (global))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member min (member Math (member self *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member toString (member size (member buffer *)))))" and t = "san" and result = 1.0 or 
repr = "(return (member toString (parameter 0 (parameter 1 *))))" and t = "san" and result = 1.0000000000000018 or 
repr = "(member length (return (member Buffer (root https://www.npmjs.com/package/buffer))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member toString (instance (member constructor (return (member _augment (member Buffer (root https://www.npmjs.com/package/buffer))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (instance (member constructor (return (member _augment *)))))))" and t = "san" and result = 1.0 or 
repr = "(member email (member query (parameter 0 (parameter 1 (member get (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(member protocol (member location (member self *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance (member InlineLexer (return (member options (member parse (root https://www.npmjs.com/package/marked))))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (parameter 0 (parameter 1 (member test *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member Array (member window *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (parameter 0 (parameter 1 (member test (parameter 0 (parameter 1 (root https://www.npmjs.com/package/tape))))))))" and t = "san" and result = 1.0000000000000016 or 
repr = "(parameter 0 (member max (member Math (member Object *))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member BN (member BN (member BN (member BN (member BN *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member toString (instance (member constructor (return (member _augment *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 3 (member copy (instance (member Buffer *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 3 (member copy (instance *)))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member constructor *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (parameter 0 (parameter 1 (member test (root https://www.npmjs.com/package/tap))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 3 (member copy (return (member Buffer (global)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member fixedTimeComparison *))" and t = "san" and result = 1.0 or 
repr = "(member length (member prerelease (instance (member SemVer *))))" and t = "san" and result = 1.0 or 
repr = "(member buffer *)" and t = "src" and result = 0.25000000000000006 or 
repr = "(parameter 0 (member max (member Math (member Object (member self (global))))))" and t = "san" and result = 1.0 or 
repr = "(return (member encode (return (parameter 0 (parameter 0 (return *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member literal (member builders *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member readdir *))" and t = "snk" and result = 0.02273662551440525 or 
repr = "(member length (instance (member BN (member BN (member BN (member BN (member BN (member BN (member BN (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member deepEqual (parameter 0 (parameter 1 (member test (root https://www.npmjs.com/package/tap))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance (member InlineLexer (member parse (member parse (member parse *)))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (return (member replace (return (member stringify (member JSON (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (return (member slice (instance (member Buffer *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getOwnPropertyNames (member Object (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member copy (instance *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member equals (parameter 0 (parameter 1 (member test (parameter 0 (parameter 1 (member test *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member prerelease (instance (member SemVer (member SemVer (root https://www.npmjs.com/package/semver))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member slice (return (member Buffer *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member format *))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member extend (parameter 1 (parameter 2 (member define (global))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (return (member replace (parameter 0 (member token (instance (member Lexer (member parse *)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member Array (member exports *)))" and t = "san" and result = 1.0 or 
repr = "(member source (parameter 0 *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member equal (parameter 0 (parameter 1 (member test (parameter 0 *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member Object *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member max (member Math (member exports (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member constructor (return (member _augment (member constructor (return *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (instance *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member deepEqual (root https://www.npmjs.com/package/assert)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getOwnPropertyNames (member Object *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance (member InlineLexer (return (member setOptions *))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member max (member Math (member Object (member window *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member ok (parameter 0 *)))" and t = "san" and result = 1.0 or 
repr = "(member name (member query *))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member Buffer *))" and t = "snk" and result = 0.49999999999999956 or 
repr = "(parameter 0 (member max (member Math (member window (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (member _buf (return (member BerReader (root https://www.npmjs.com/package/asn1)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member max (member Math (member Object (member window (global))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance (member InlineLexer (member parse (root https://www.npmjs.com/package/marked))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member toString (instance (member Buffer (root https://www.npmjs.com/package/buffer)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (return (member slice (return (member slice (instance (member Buffer (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member BN (member BN *))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member BN (member BN (member BN *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member min (member Math (member exports (global)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member writeFile (root https://www.npmjs.com/package/fs)))" and t = "snk" and result = 0.8000000000000006 or 
repr = "(parameter 3 (member copy (instance (member Buffer (global)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance (member InlineLexer (member parse (return (member setOptions *)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member copy (instance (member Buffer *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (return (member slice (return (member slice (instance (member Buffer *)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member constructor (return (member _augment (member constructor (return (member _augment (member Buffer *)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member literal *))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member toString (member byteLength (member buffer (return *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member listeners (return (return (member require (global)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance (member InlineLexer (member parse (member parse (root https://www.npmjs.com/package/marked)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance (member InlineLexer (return (member setOptions (root https://www.npmjs.com/package/marked)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member Array (member Object (member self (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member BN (member BN (member BN (global))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member min (member Math (member global *))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member toString (instance (member constructor (return *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member dump (instance (root https://www.npmjs.com/package/lru-cache)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member listeners (instance (return *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (return (member replace *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member strictEqual (root https://www.npmjs.com/package/assert)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member listeners (instance *))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (return (member stringify (member JSON (global))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (return (member substring (parameter 0 (member output (instance (member InlineLexer (member parse *)))))))))" and t = "san" and result = 1.0 or 
repr = "(member category *)" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member Buffer (global)))" and t = "snk" and result = 0.2999999999999977 or 
repr = "(parameter 0 (member Buffer (global)))" and t = "san" and result = 0.29999999999999727 or 
repr = "(return (member toRed (return *)))" and t = "snk" and result = 0.30000000000000093 or 
repr = "(parameter 0 (member equal (parameter 0 (parameter 1 (member test (parameter 0 (parameter 1 *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member toString (instance (member constructor (return (member _augment (member Buffer (root https://www.npmjs.com/package/buffer)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member constructor (return (member _augment (member Buffer (root https://www.npmjs.com/package/buffer)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member ArrayBuffer (global)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member on (return (member request *)))))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member slice (instance *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (instance (member Buffer (root https://www.npmjs.com/package/buffer))))))" and t = "san" and result = 1.0 or 
repr = "(member _wcurpath (instance *))" and t = "src" and result = 0.25000000000000244 or 
repr = "(member length (member prerelease (instance (member SemVer (member SemVer (member SemVer (root https://www.npmjs.com/package/semver)))))))" and t = "san" and result = 1.0 or 
repr = "(member host (return (root https://www.npmjs.com/package/parseuri)))" and t = "snk" and result = 0.8750000000000049 or 
repr = "(parameter 0 (member Array (member Object (member global *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member min (member Math (member Object (member global (global))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member ArrayBuffer *))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (return (member toFunction *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member info (return (member Logger *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member listeners (instance (member EventEmitter (return (member require *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member BN (member BN (member BN (member BN (member BN (global))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member slice (return (member Buffer (root https://www.npmjs.com/package/buffer)))))" and t = "san" and result = 1.0000000000000047 or 
repr = "(parameter 2 (member toString (instance (member constructor (return (member _augment *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member toString (instance (member constructor *)))))" and t = "san" and result = 1.0 or 
repr = "(member argnames *)" and t = "snk" and result = 0.23128257887517148 or 
repr = "(parameter 1 (member min (member Math (member Object (member window *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member _bufs *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member pipe (return (member createReadStream *))))" and t = "snk" and result = 0.5000000000000009 or 
repr = "(member email (member query (parameter 0 (parameter 1 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member min (member Math (member self (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member toString (member size (member buffer (instance (member Uint8Array (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (parameter 0 (member inherits (root https://www.npmjs.com/package/util)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member Array (member self (global))))" and t = "san" and result = 1.0 or 
repr = "(member name (member query (parameter 0 (parameter 1 (member get (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member substring (return (member substring (parameter 0 (member output (instance (member InlineLexer (member parse (root https://www.npmjs.com/package/marked))))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member toString (instance *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (return (member substring (parameter 0 *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member BN (global))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member min (member Math (member module *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (return (member substring (parameter 0 (member output (instance (member InlineLexer (root https://www.npmjs.com/package/marked)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member min (member Math (member Object (member self (global))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member listeners *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (return (return (return (root https://www.npmjs.com/package/generate-function)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member toString (instance (member Buffer *))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member constructor (return (member _augment (member constructor (return (member _augment (member Buffer (root https://www.npmjs.com/package/buffer))))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member substring (return (member replace (parameter 0 (member token (instance *)))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member strictEqual (parameter 0 *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member toString (instance (member constructor (return (member _augment (member Buffer *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance (member InlineLexer (return (member setOptions (member parse (root https://www.npmjs.com/package/marked))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member listeners (instance (return (member require (global)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance (member InlineLexer (return (member options *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (return (member slice (return (member slice (return (member Buffer (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member readFileSync (root https://www.npmjs.com/package/fs)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member toString (member size *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member min (member Math (member exports (global)))))" and t = "san" and result = 1.0 or 
repr = "(member name (member query (parameter 0 (parameter 1 *))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member min (member Math (member module (global)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member plan (parameter 0 (parameter 1 (root https://www.npmjs.com/package/tape)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (instance (member Buffer *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member min (member Math (member exports *))))" and t = "san" and result = 1.0 or 
repr = "(member email (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member Array (member global *)))" and t = "san" and result = 1.0 or 
repr = "(return (member normalize *))" and t = "src" and result = 0.2795473251028814 or 
repr = "(parameter 2 (member toString *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member min (member Math (member exports *))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member toString (instance (member Buffer (root https://www.npmjs.com/package/buffer))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (member _buf (instance (member BerReader (root https://www.npmjs.com/package/asn1)))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member stringify (member JSON *)))))" and t = "san" and result = 1.0 or 
repr = "(return (member readdirSync (root https://www.npmjs.com/package/fs)))" and t = "src" and result = 0.49999999999999845 or 
repr = "(parameter 0 (member toRed (return *)))" and t = "snk" and result = 0.5000000000000016 or 
repr = "(member length (return (member slice (member _buf (return *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member equals (parameter 0 (parameter 1 (member test (parameter 0 (parameter 1 *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member constructor (return (member _augment (member constructor (return (member _augment *))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member writeUInt32BE (return (member Buffer *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance (member InlineLexer (return (member options (root https://www.npmjs.com/package/marked)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member same (parameter 0 (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member assert (root https://www.npmjs.com/package/hoek)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (return (member slice (return (member Buffer (global))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member equals (parameter 0 (parameter 1 (member test (root https://www.npmjs.com/package/tap))))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(parameter 0 (member exists *))" and t = "src" and result = 0.4500000000000003 or 
repr = "(parameter 0 (member ok (parameter 0 (parameter 1 (root https://www.npmjs.com/package/tape)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member min (member Math (member Object (member window (global))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member RangeError (global)))" and t = "snk" and result = 0.5000000000000031 or 
repr = "(parameter 1 (member min (member Math (member global (global)))))" and t = "san" and result = 1.0 or 
repr = "(instance (member Buffer (global)))" and t = "snk" and result = 1.0 or 
repr = "(member length (return (member slice (return (member Buffer (global))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 3 (member copy (return (member Buffer *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member toString (member byteLength (member buffer (return (member Uint8Array (global))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member notEqual *))" and t = "san" and result = 1.0 or 
repr = "(return (member encode (return (parameter 0 (parameter 0 *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member prerelease (instance (member SemVer (member SemVer (member SemVer (member SemVer (member SemVer (root https://www.npmjs.com/package/semver)))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member toString (parameter 0 (parameter 1 (member on *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 3 (member copy (return *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (member _buf (instance (member BerReader *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member toString (member byteLength (member buffer (return (member Uint8Array *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member Buffer (global))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member toString (instance (member constructor (return (member _augment (member Buffer *))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member plan (parameter 0 (parameter 1 (member test *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (parameter 0 (member output (instance (member InlineLexer (member parse *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member BN (member BN (member BN (member BN (global)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member max (member Math (member module *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member min (member Math (member window *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member writeUInt32BE *))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member splice *))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (return (member slice (instance (member Buffer (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member _bufs (instance *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member toString (member byteLength *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member slice (instance (member Buffer (root https://www.npmjs.com/package/buffer)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member Array (member Object (member window *))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (return (member stringify (member JSON *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member equals (parameter 0 (parameter 1 (member test (parameter 0 *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (return (member slice (return (member slice (return (member Buffer *)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (return (member substring (parameter 0 (member output (instance (member InlineLexer *))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member copy (instance (member Buffer (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (return (member slice (return (member slice (return *))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member json (parameter 1 (parameter 2 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member prerelease (instance (root https://www.npmjs.com/package/semver))))" and t = "san" and result = 1.0 or 
repr = "(member email (member query (parameter 0 (parameter 1 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member min (member Math (member Object (member self (global))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (member assert *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member slice (instance (member constructor (return *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member prerelease (instance (member SemVer (member SemVer (member SemVer (member SemVer (root https://www.npmjs.com/package/semver))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member listeners (instance (member EventEmitter (return (member require (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member toString (member size (member buffer (return *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member Array (member module (global))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member update *))" and t = "snk" and result = 1.0 or 
repr = "(member length (return (member toString (member byteLength (member buffer (instance (member Uint8Array (global))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member substring (return (member replace (parameter 0 (member token (instance (member Lexer (root https://www.npmjs.com/package/marked)))))))))" and t = "src" and result = 1.0 or 
repr = "(member length (instance (member BN (member BN (member BN (member BN (member BN (member BN (member BN *)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member spawn (root https://www.npmjs.com/package/child_process)))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member copy (instance (parameter 0 (member defineProperty (member Object (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member picture_id (member params (parameter 0 (parameter 2 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member length (instance (member write (instance (parameter 0 *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member json (parameter 1 (parameter 2 (member get (return (root https://www.npmjs.com/package/express)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member fill (instance (parameter 0 (member defineProperty (member Object *)))))))" and t = "san" and result = 0.999999999999999 or 
repr = "(parameter 1 (member extend (member angular (member window (global)))))" and t = "src" and result = 1.0 or 
repr = "(member length (instance (member fill *)))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member write (instance (parameter 0 (member defineProperty (member Object (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member picture_id (member params (parameter 0 (parameter 2 (member get (return (root https://www.npmjs.com/package/express)))))))" and t = "src" and result = 1.0 or 
repr = "(member picture_id (member params (parameter 0 (parameter 2 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member extend (member angular (member window *))))" and t = "src" and result = 1.0 or 
repr = "(member length (instance (member write (instance (parameter 0 (member defineProperty *))))))" and t = "san" and result = 1.0 or 
repr = "(member picture_id (member params *))" and t = "src" and result = 1.0 or 
repr = "(member picture_id (member params (parameter 0 (parameter 2 *))))" and t = "src" and result = 1.0 or 
repr = "(member picture_id (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(member length (instance (member fill (instance (parameter 0 (member defineProperty *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member fill (instance (parameter 0 (member defineProperty (member Object (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member picture_id (member query (parameter 0 (parameter 2 (member delete (return (root https://www.npmjs.com/package/express)))))))" and t = "src" and result = 1.0000000000000016 or 
repr = "(parameter 0 (member json (parameter 1 (parameter 2 (member get (return *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member toString (instance (parameter 0 (member defineProperty (member Object *)))))))" and t = "san" and result = 0.999999999999999 or 
repr = "(member picture_id (member query (parameter 0 (parameter 2 (member get *)))))" and t = "src" and result = 1.0000000000000016 or 
repr = "(member picture_id (member params (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(member length (instance (member copy (instance (parameter 0 *)))))" and t = "san" and result = 1.0 or 
repr = "(member search (member query (parameter 0 (parameter 1 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member picture_id (member query (parameter 0 (parameter 2 (member get (return (root https://www.npmjs.com/package/express)))))))" and t = "src" and result = 1.0 or 
repr = "(member search (member query (parameter 0 (parameter 1 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member isDefined (member angular (member window *))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(member length (instance (member toString (instance (parameter 0 *)))))" and t = "san" and result = 1.0 or 
repr = "(member search (member query (parameter 0 (parameter 1 (member get (return (root https://www.npmjs.com/package/express)))))))" and t = "src" and result = 1.0 or 
repr = "(member length (instance (member fill (instance (parameter 0 *)))))" and t = "san" and result = 1.0 or 
repr = "(member picture_id (member query *))" and t = "src" and result = 1.0 or 
repr = "(member length (instance (member write (instance (parameter 0 (member defineProperty (member Object *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member isDefined (member angular (member window (global)))))" and t = "san" and result = 1.0 or 
repr = "(member picture_id (member query (parameter 0 (parameter 2 (member delete (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member search (member query (parameter 0 (parameter 1 *))))" and t = "src" and result = 1.0 or 
repr = "(member length (instance (member toString (instance (parameter 0 (member defineProperty (member Object (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member copy (instance (parameter 0 (member defineProperty *))))))" and t = "san" and result = 1.0 or 
repr = "(member picture_id (member query (parameter 0 (parameter 2 *))))" and t = "src" and result = 1.0 or 
repr = "(member search (member query *))" and t = "src" and result = 1.0 or 
repr = "(member length (instance (member fill (instance *))))" and t = "san" and result = 1.0 or 
repr = "(member picture_id *)" and t = "src" and result = 1.0 or 
repr = "(member length (instance (member toString (instance (parameter 0 (member defineProperty *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (instance (member copy (instance (parameter 0 (member defineProperty (member Object *)))))))" and t = "san" and result = 1.0 or 
repr = "(member search (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(member picture_id (member query (parameter 0 (parameter 2 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member picture_id (member query (parameter 0 (parameter 2 (member delete *)))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member json (parameter 1 (parameter 2 (member get *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getServiceReferences (instance (member ServiceRegistry (return (parameter 1 (member define *))))))))" and t = "san" and result = 0.9999999999999913 or 
repr = "(member length (return (member getServiceReferences (instance (member ServiceRegistry (parameter 1 (parameter 1 *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member setSafeAttribute (parameter 1 (parameter 1 *))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(member length (member prefix (parameter 1 *)))" and t = "san" and result = 0.9999999999999984 or 
repr = "(return (member changedItem (instance *)))" and t = "src" and result = 0.434444444444444 or 
repr = "(member length (return (member resolveRelativeFiles (instance (member ScriptResolver (parameter 1 (parameter 1 (member define *))))))))" and t = "san" and result = 0.9999999999999913 or 
repr = "(parameter 0 (member createContextualFragment (return (member createRange (member document (global))))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(member length (member childNodes (return (member createElement (member document (global))))))" and t = "san" and result = 0.999999999999999 or 
repr = "(member template (parameter 0 (parameter 0 (member forEach (return *)))))" and t = "san" and result = 1.0000000000000013 or 
repr = "(parameter 0 (member callback (parameter 0 (member Command (parameter 5 (parameter 1 *))))))" and t = "src" and result = 0.7500000000000001 or 
repr = "(parameter 0 (parameter 15 (parameter 1 (member define (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member findStyleBlocks *)))" and t = "san" and result = 1.0000000000000036 or 
repr = "(member length (return (member resolveRelativeFiles (return *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (member pathname (instance (member URL (global))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member findScriptBlocks *)))" and t = "san" and result = 1.0000000000000036 or 
repr = "(member length (member host (member location *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member host (member location (member parent (global)))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(member length (return (member getServiceReferences (instance *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (member pathname (return (member URL (global))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member formatMessage (parameter 1 *)))" and t = "san" and result = 1.0000000000000002 or 
repr = "(member template (parameter 0 (parameter 0 (member forEach (return (member findTemplatesForKind *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member template (return (parameter 0 (parameter 0 *)))))" and t = "san" and result = 1.000000000000001 or 
repr = "(member length (return (member resolveRelativeFiles (instance *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member formatMessage (parameter 6 (parameter 1 (member define (global))))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(parameter 1 (member getAnnotations (instance (member AnnotationModel (parameter 2 (parameter 1 (member define (global))))))))" and t = "san" and result = 0.9999999999999969 or 
repr = "(return (member replace (return (member replace (parameter 0 (member encode (member he (global))))))))" and t = "san" and result = 0.9999999999999923 or 
repr = "(parameter 0 (parameter 7 (parameter 1 (member define (global)))))" and t = "snk" and result = 0.23809523809523814 or 
repr = "(member length (return (member resolveRelativeFiles (instance (member ScriptResolver (return (parameter 1 (member define *))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member strictEqual (member assert (parameter 1 (parameter 1 (member define *))))))" and t = "san" and result = 1.000000000000001 or 
repr = "(member length (return (member findScriptBlocks (parameter 1 (parameter 1 (member define (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member parents (return (member findNode (parameter 1 (parameter 1 *))))))" and t = "san" and result = 1.0000000000000047 or 
repr = "(member length (return (member getSettings (instance *))))" and t = "san" and result = 1.0000000000000115 or 
repr = "(return (member showWhile (return (member getService *))))" and t = "snk" and result = 1.0 or 
repr = "(member hash (instance *))" and t = "san" and result = 1.0000000000000016 or 
repr = "(member hash (return *))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 0 (member encode (return (parameter 0 (member define (global))))))))" and t = "san" and result = 0.9999999999999971 or 
repr = "(member length (return (member resolveRelativeFiles (instance (member ScriptResolver (parameter 1 (parameter 1 (member define (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (member assert (parameter 2 (parameter 1 (member define *))))))" and t = "san" and result = 1.000000000000001 or 
repr = "(member parameters (parameter 0 *))" and t = "src" and result = 1.0 or 
repr = "(member length (member childNodes *))" and t = "san" and result = 1.0 or 
repr = "(member template (parameter 0 (parameter 0 (member forEach (return (member findTemplatesForKind (parameter 1 (parameter 1 (member define (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member equal (member assert (parameter 0 *))))" and t = "snk" and result = 0.25000000000000044 or 
repr = "(member length (member parents (return *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getPlugins (return (member PluginRegistry (parameter 2 (parameter 1 (member define (global)))))))))" and t = "san" and result = 0.9999999999999913 or 
repr = "(parameter 1 (member toDom (return (parameter 0 (parameter 0 (member define *))))))" and t = "san" and result = 1.000000000000001 or 
repr = "(member length (member prefix (parameter 1 (member computeContentAssist *))))" and t = "san" and result = 1.0 or 
repr = "(member innerHTML (parameter 0 (parameter 2 (member makeRenderFunction (parameter 2 (parameter 1 (member define (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getAttributesForNode (instance (member HTMLContentAssistProvider (parameter 1 (parameter 1 (member define (global)))))))))" and t = "san" and result = 1.0000000000000107 or 
repr = "(parameter 1 (member formatMessage (parameter 1 (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member formatMessage (parameter 6 (parameter 2 *))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(member parameters (parameter 0 (member callback (parameter 0 (member Command *)))))" and t = "src" and result = 0.2500000000000001 or 
repr = "(parameter 1 (member getAnnotations (instance (member AnnotationModel *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getSettings (instance (return (parameter 1 (member define *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member mkdirSync (root https://www.npmjs.com/package/fs)))" and t = "snk" and result = 0.05909465020576454 or 
repr = "(member length (member prefix (parameter 1 (member computeContentAssist (member contentAssistImpl (return (parameter 1 (member define (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member localStorage *))" and t = "san" and result = 0.9999999999999984 or 
repr = "(member innerHTML (parameter 0 (parameter 2 (member makeRenderFunction (parameter 2 (parameter 1 (member define *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member resolveRelativeFiles (instance (member ScriptResolver (return (parameter 1 *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member removeEventListener (global))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member formatMarkdownHover *))" and t = "src" and result = 0.21256515775034274 or 
repr = "(parameter 0 (member getValue (instance (return (parameter 1 *)))))" and t = "src" and result = 0.3958847736625495 or 
repr = "(parameter 0 (member template (return (parameter 0 (parameter 0 *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member host (member location (member self *))))" and t = "san" and result = 1.000000000000001 or 
repr = "(parameter 0 (member equal (member assert (parameter 4 (parameter 1 *)))))" and t = "san" and result = 1.000000000000001 or 
repr = "(parameter 1 (member formatMessage (parameter 3 (parameter 1 (member define *)))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(member length (return (member getPlugins (return (member PluginRegistry (parameter 2 *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member toDom (return *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member prefix (parameter 1 (member computeContentAssist (member contentAssistImpl (return (parameter 1 (member define *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member childNodes (return (member createElement *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getAttributesForNode (instance (member HTMLContentAssistProvider *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member formatMessage (parameter 3 *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member template (return *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member getAnnotations (instance (member AnnotationModel (parameter 2 (parameter 1 (member define *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member getAnnotations (instance (member AnnotationModel (parameter 2 (parameter 1 *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member template (return *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member getAnnotations (instance (member AnnotationModel (return *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (member assert (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member logEvent *))" and t = "snk" and result = 0.7499999999999988 or 
repr = "(parameter 0 (member createContextualFragment *))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member getAnnotations (return (member AnnotationModel *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member setSafeAttribute (parameter 1 *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (member assert (parameter 2 (parameter 1 (member define (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getSettings (instance (return (parameter 1 *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member equal (member assert (parameter 0 (parameter 1 (member define *))))))" and t = "snk" and result = 1.0 or 
repr = "(member length (return (member getAttributesForNode (instance (member HTMLContentAssistProvider (parameter 1 (parameter 1 *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member getAnnotations (return (member AnnotationModel (parameter 2 (parameter 1 (member define *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (member pathname (instance (member URL *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member template (return (parameter 0 (parameter 0 (member define (global)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member formatMessage (parameter 6 (parameter 2 (member define *)))))" and t = "san" and result = 1.0 or 
repr = "(member hash (return (member URL *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getPlugins (instance (member PluginRegistry (parameter 2 *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getAttributesForNode (instance (member HTMLContentAssistProvider (parameter 1 (parameter 1 (member define *))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member formatMessage (parameter 4 (parameter 1 (member define (global))))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(member length (return (member findStyleBlocks (parameter 0 (parameter 1 (member define (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getPlugins (return *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member querySelectorAll (member body *))))" and t = "san" and result = 0.999999999999999 or 
repr = "(return (member replace (return (member replace (parameter 0 (member encode *))))))" and t = "san" and result = 1.0 or 
repr = "(member Name *)" and t = "snk" and result = 0.01577503429355276 or 
repr = "(return (member createElementNS (member document *)))" and t = "src" and result = 1.0 or 
repr = "(return (member encode (instance (member TextEncoder *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member setSafeInnerHTML *))" and t = "san" and result = 1.0 or 
repr = "(member innerHTML (parameter 0 (parameter 2 (member makeRenderFunction (parameter 2 *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member strictEqual (member assert (parameter 0 (parameter 1 (member define (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member resolveRelativeFiles (instance (member ScriptResolver (return (parameter 1 (member define (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member setSafeInnerHTML (parameter 8 (parameter 2 (member define *)))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(member originalUrl (parameter 0 (parameter 0 (member use (return (member use (return (member Router *))))))))" and t = "src" and result = 0.9999999999999984 or 
repr = "(member length (return (member getSettings (return *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member logEvent (return *)))" and t = "snk" and result = 1.0 or 
repr = "(member length (return (member getServiceReferences (instance (member ServiceRegistry (parameter 1 (parameter 1 (member define (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member resolveRelativeFiles (instance (member ScriptResolver *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getPlugins (instance (member PluginRegistry (return (parameter 1 (member define *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getPlugins *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (member assert (parameter 2 *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member generateSearchHelper *))" and t = "src" and result = 0.24999999999999922 or 
repr = "(member length (return (member findScriptBlocks (parameter 1 (parameter 1 (member define *))))))" and t = "san" and result = 1.0 or 
repr = "(member tags (return *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member existsSync (return *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member equal (member assert (parameter 3 *))))" and t = "san" and result = 1.000000000000001 or 
repr = "(parameter 1 (member formatMessage (parameter 1 (parameter 1 (member define *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getAttributesForNode (instance (member HTMLContentAssistProvider (parameter 1 *))))))" and t = "san" and result = 1.0 or 
repr = "(member hash (instance (member URL *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member toDom *))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member equal (member assert (parameter 0 (parameter 1 (member define (global)))))))" and t = "snk" and result = 1.0 or 
repr = "(member length (return (member getAttributesForNode *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getPlugins (instance (member PluginRegistry (parameter 2 (parameter 1 (member define *))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (member assert (parameter 3 (parameter 1 (member define *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (member assert (parameter 3 (parameter 1 *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member formatMessage (parameter 4 *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member Conversion *))" and t = "snk" and result = 0.5574417009602194 or 
repr = "(member length (return (member getAttributesForNode (instance (member HTMLContentAssistProvider (return (parameter 1 *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getSettings *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member formatMessage (parameter 6 (parameter 1 (member define *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (member assert (parameter 2 (parameter 1 *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member resolveRelativeFiles (return (member ScriptResolver (parameter 1 *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member host (member location (member parent *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getSettings (return (parameter 3 (parameter 1 *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member strictEqual (member assert (parameter 0 (parameter 1 (member define *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getServiceReferences (instance (member ServiceRegistry (parameter 1 *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member querySelectorAll (member body (member document *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getPlugins (return (member PluginRegistry *)))))" and t = "san" and result = 1.0 or 
repr = "(member template (parameter 0 (parameter 0 *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member findScriptBlocks (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(member hash (instance (member URL (global))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 21 (parameter 1 (member define (global)))))" and t = "snk" and result = 0.23809523809523814 or 
repr = "(member length (member parents (return (member findNode (parameter 1 *)))))" and t = "san" and result = 1.0 or 
repr = "(member hash (return (member URL (global))))" and t = "san" and result = 1.0 or 
repr = "(member template (parameter 0 *))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member resolveRelativeFiles (instance (member ScriptResolver (parameter 1 (parameter 1 *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getServiceReferences (instance (member ServiceRegistry (return (parameter 1 (member define (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member strictEqual (member assert *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member parents *))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 0 (member encode (member he *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getServiceReferences *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member parents (return (member findNode (parameter 1 (parameter 1 (member define (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getServiceReferences (instance (member ServiceRegistry *)))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 0 (member encode (return *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member toDom (return (parameter 0 (parameter 0 (member define (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getAttributesForNode (instance (member HTMLContentAssistProvider (return (parameter 1 (member define *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member params (return (member parse *))))" and t = "san" and result = 1.0000000000000047 or 
repr = "(parameter 1 (member formatMessage (parameter 3 (parameter 1 (member define (global))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getSettings (instance (return (parameter 1 (member define (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member params (return (member parse (parameter 1 (parameter 1 (member define *)))))))" and t = "san" and result = 1.0 or 
repr = "(member template (parameter 0 (parameter 0 (member forEach *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member findStyleBlocks (parameter 0 (parameter 1 *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member setSafeInnerHTML (parameter 8 *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getPlugins (return (member PluginRegistry (parameter 2 (parameter 1 *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member template (return (parameter 0 (parameter 0 (member define *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member setSafeAttribute (parameter 4 (parameter 1 (member define *)))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 2 (member template (return (parameter 0 (parameter 0 (member define *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member toDom (return (parameter 0 (parameter 0 *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (member pathname *)))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (parameter 0 (member encode (return (parameter 0 (member define *)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member setSafeInnerHTML (parameter 1 (parameter 1 *))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(member length (return (member getSettings (instance (parameter 3 (parameter 1 (member define (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member prefix *))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getServiceReferences (return (member ServiceRegistry (parameter 1 (parameter 1 *)))))))" and t = "san" and result = 1.0 or 
repr = "(member originalUrl (parameter 0 (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(return (member replace (parameter 0 (member encode (return (parameter 0 (member define *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member strictEqual (member assert (parameter 1 (parameter 1 *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member findStyleBlocks (parameter 0 (parameter 1 (member define *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member formatMessage *))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getPlugins (instance (member PluginRegistry (return (parameter 1 *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (member assert (parameter 0 (parameter 1 (member define *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getServiceReferences (instance (member ServiceRegistry (return *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member setSafeInnerHTML (parameter 1 (parameter 1 (member define (global))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member childNodes (return *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member lookupFormat *))" and t = "snk" and result = 1.0 or 
repr = "(member length (return (member getAttributesForNode (instance (member HTMLContentAssistProvider (return *))))))" and t = "san" and result = 1.0 or 
repr = "(return (member encode (instance (member TextEncoder (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member prefix (parameter 1 (member computeContentAssist (member contentAssistImpl (return (parameter 1 *)))))))" and t = "san" and result = 1.0 or 
repr = "(return (member getModel *))" and t = "src" and result = 0.4999999999999992 or 
repr = "(member length (return (member findStyleBlocks (parameter 0 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member host (member location (global))))" and t = "san" and result = 1.0 or 
repr = "(member length (member parents (return (member findNode *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member showWhile (return (member getService (parameter 0 (member createFileCommands (return (parameter 1 (member define *)))))))))" and t = "snk" and result = 0.2500000000000001 or 
repr = "(member length (return (member getAttributesForNode (return (member HTMLContentAssistProvider *)))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 0 (member encode *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member lookupFormat (return (parameter 0 (parameter 0 *)))))" and t = "snk" and result = 0.03120027434842254 or 
repr = "(parameter 0 (member equal (member assert (parameter 4 (parameter 1 (member define (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member item *)" and t = "src" and result = 0.3396433470507537 or 
repr = "(member length (return (member getAttributesForNode (return (member HTMLContentAssistProvider (parameter 1 *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getSettings (return (parameter 3 (parameter 1 (member define *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getServiceReferences (return (member ServiceRegistry (parameter 1 *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member params *))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getAttributesForNode (return (member HTMLContentAssistProvider (parameter 1 (parameter 1 *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (member pathname (return *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member setSafeInnerHTML (parameter 8 (parameter 2 *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member error (return (member getLogger *))))" and t = "src" and result = 1.0 or 
repr = "(member originalUrl *)" and t = "src" and result = 1.0 or 
repr = "(member length (return (member getServiceReferences (instance (member ServiceRegistry (return (parameter 1 *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getAttributesForNode (return (member HTMLContentAssistProvider (parameter 1 (parameter 1 (member define (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member status *))" and t = "snk" and result = 0.24053497942386853 or 
repr = "(return (member encode (return (member TextEncoder (global)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (member assert (parameter 4 *))))" and t = "san" and result = 1.0 or 
repr = "(member query (instance (member URL (global))))" and t = "src" and result = 0.875 or 
repr = "(return (member replace (return (member replace (parameter 0 (member encode (return (parameter 0 *))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (member pathname (return (member URL *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member setSafeInnerHTML (parameter 8 (parameter 2 (member define (global))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member params (return *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getServiceReferences (return (member ServiceRegistry (parameter 1 (parameter 1 (member define (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member resolveRelativeFiles *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member error (return (member getLogger (root https://www.npmjs.com/package/log4js)))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member createContextualFragment (return *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member existsSync (return (member promisifyAll *))))" and t = "snk" and result = 0.09094650205761878 or 
repr = "(member length (member childNodes (return (member createElement (member document *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member template *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member template (return (parameter 0 (parameter 0 (member define (global)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member formatMessage (parameter 6 (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getPlugins (instance (member PluginRegistry (return (parameter 1 (member define (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member getAnnotations *))" and t = "san" and result = 1.0 or 
repr = "(member length (member parents (return (member findNode (parameter 1 (parameter 1 (member define *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member template (return (parameter 0 *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member setSafeInnerHTML (parameter 1 *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member setSafeAttribute (parameter 4 *)))" and t = "snk" and result = 0.4999999999999999 or 
repr = "(return (member createElementNS *))" and t = "src" and result = 0.13919753086420067 or 
repr = "(return (member getText *))" and t = "src" and result = 0.0738683127572054 or 
repr = "(parameter 0 (member equal (member assert (parameter 1 (parameter 1 (member define *))))))" and t = "san" and result = 1.0 or 
repr = "(member template (parameter 0 (parameter 0 (member forEach (return (member findTemplatesForKind (parameter 1 *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member params (return (member parse (parameter 1 (parameter 1 *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getSettings (instance (parameter 3 (parameter 1 (member define *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member formatMessage (parameter 3 (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getPlugins (instance (member PluginRegistry (return *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member querySelectorAll (member body (member document (global))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getServiceReferences (return (member ServiceRegistry (parameter 1 (parameter 1 (member define *))))))))" and t = "san" and result = 1.0 or 
repr = "(member originalUrl (parameter 0 (parameter 0 (member use *))))" and t = "src" and result = 1.0 or 
repr = "(member template (parameter 0 (parameter 0 (member forEach (return (member findTemplatesForKind (parameter 1 (parameter 1 (member define *)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member findScriptBlocks (parameter 1 (parameter 1 *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getServiceReferences (return (member ServiceRegistry *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getAttributesForNode (return (member HTMLContentAssistProvider (parameter 1 (parameter 1 (member define *))))))))" and t = "san" and result = 1.0 or 
repr = "(member innerHTML (parameter 0 (parameter 2 (member makeRenderFunction *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (member assert (parameter 4 (parameter 1 (member define *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member setSafeAttribute (parameter 4 (parameter 1 *))))" and t = "snk" and result = 1.0 or 
repr = "(member originalUrl (parameter 0 (parameter 0 (member use (return (member use *))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member equal (member assert (parameter 3 (parameter 1 (member define (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getPlugins (instance (member PluginRegistry *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member params (return (member parse (parameter 1 (parameter 1 (member define (global))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (member assert (parameter 0 (parameter 1 (member define (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getServiceReferences (instance (member ServiceRegistry (parameter 1 (parameter 1 (member define *))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 15 (parameter 1 (member define *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getPlugins (instance *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member resolveRelativeFiles (return (member ScriptResolver (parameter 1 (parameter 1 (member define (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (member assert (parameter 1 (parameter 1 (member define (global)))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (parameter 0 (member encode (return (parameter 0 (member define (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member showWhile (return *)))" and t = "snk" and result = 1.0000000000000002 or 
repr = "(parameter 1 (member toDom (return (parameter 0 *))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (parameter 0 (member encode (member he *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member substring (member pathname (instance *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member formatMessage (parameter 1 (parameter 1 (member define (global))))))" and t = "san" and result = 1.0 or 
repr = "(member originalUrl (parameter 0 (parameter 0 (member use (return (member use (return (member Router (root https://www.npmjs.com/package/express)))))))))" and t = "src" and result = 1.0 or 
repr = "(member length (member params (return (member parse (parameter 1 *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member resolveRelativeFiles (return (member ScriptResolver (parameter 1 (parameter 1 *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (member assert (parameter 0 *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 3 (member Conversion (return (parameter 0 (parameter 0 (member define *))))))" and t = "snk" and result = 0.9425582990397807 or 
repr = "(parameter 1 (member getAnnotations (instance *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member get (return (member use (return *))))))" and t = "src" and result = 0.25000000000000233 or 
repr = "(member length (return (member getAttributesForNode (instance *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getAttributesForNode (instance (member HTMLContentAssistProvider (return (parameter 1 (member define (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 3 (member Conversion *))" and t = "snk" and result = 0.5574417009602194 or 
repr = "(member length (return (member getSettings (instance (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member host *))" and t = "san" and result = 1.0 or 
repr = "(member originalUrl (parameter 0 *))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member getAnnotations (return (member AnnotationModel (parameter 2 (parameter 1 *))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 0 (member encode (return (parameter 0 *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member prefix (parameter 1 (member computeContentAssist (member contentAssistImpl *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member resolveRelativeFiles (instance (member ScriptResolver (return *))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (parameter 0 (member encode (return *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member resolveRelativeFiles (return (member ScriptResolver (parameter 1 (parameter 1 (member define *))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member equal (member assert (parameter 0 (parameter 1 *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member getAnnotations (instance (member AnnotationModel (return (parameter 2 *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member resolveRelativeFiles (return (member ScriptResolver *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member showWhile (return (member getService (parameter 0 *)))))" and t = "snk" and result = 1.0 or 
repr = "(member originalUrl (parameter 0 (parameter 0 (member use (return *)))))" and t = "src" and result = 1.0 or 
repr = "(member innerHTML (parameter 0 (parameter 2 *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member getAnnotations (instance (member AnnotationModel (return (parameter 2 (member define *)))))))" and t = "san" and result = 1.0 or 
repr = "(member innerHTML (parameter 0 (parameter 2 (member makeRenderFunction (parameter 2 (parameter 1 *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member getAnnotations (return *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member getAnnotations (instance (member AnnotationModel (return (parameter 2 (member define (global))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member strictEqual (member assert (parameter 1 (parameter 1 (member define (global)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member formatMessage (parameter 6 *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member localStorage (global)))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member getAnnotations (return (member AnnotationModel (parameter 2 (parameter 1 (member define (global))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member formatMessage (parameter 6 (parameter 2 (member define (global))))))" and t = "san" and result = 1.0 or 
repr = "(member template (parameter 0 (parameter 0 (member forEach (return (member findTemplatesForKind (parameter 1 (parameter 1 *))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member formatMessage (parameter 4 (parameter 1 (member define *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member template (return (parameter 0 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getSettings (instance (parameter 3 *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member setSafeInnerHTML (parameter 1 (parameter 1 (member define *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member prefix (parameter 1 (member computeContentAssist (member contentAssistImpl (return *))))))" and t = "san" and result = 1.0 or 
repr = "(member keyword *)" and t = "src" and result = 0.24999999999999922 or 
repr = "(parameter 0 (member getValue (instance (return (parameter 1 (member define (global)))))))" and t = "src" and result = 1.0 or 
repr = "(member originalUrl (parameter 0 (parameter 0 (member use (return (member use (return *)))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 2 (member setSafeAttribute (parameter 1 (parameter 1 (member define *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getPlugins (instance (member PluginRegistry (parameter 2 (parameter 1 *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getPlugins (return (member PluginRegistry (parameter 2 (parameter 1 (member define *))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member showWhile *))" and t = "snk" and result = 0.25 or 
repr = "(parameter 1 (member getAnnotations (instance (member AnnotationModel (parameter 2 *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getPlugins (instance (member PluginRegistry (parameter 2 (parameter 1 (member define (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getSettings (return (parameter 3 *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member formatMessage (parameter 4 (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getAttributesForNode (return *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member createContextualFragment (return (member createRange (member document *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member showWhile (return (member getService (parameter 0 (member createFileCommands (return (parameter 1 *))))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 2 (member setSafeAttribute *))" and t = "san" and result = 1.0 or 
repr = "(return (member encode (return (member TextEncoder *))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (parameter 0 (member encode (member he (global))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getSettings (instance (parameter 3 (parameter 1 *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member createContextualFragment (return (member createRange *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getSettings (return (parameter 3 (parameter 1 (member define (global))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member setSafeAttribute (parameter 1 (parameter 1 (member define (global))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member resolveRelativeFiles (instance (member ScriptResolver (parameter 1 *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member get (return (parameter 1 (member define (global))))))" and t = "src" and result = 0.2500000000000041 or 
repr = "(parameter 0 (member strictEqual (member assert (parameter 0 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getServiceReferences (return *))))" and t = "san" and result = 1.0 or 
repr = "(return (member toUrl (parameter 1 *)))" and t = "src" and result = 0.5000000000000016 or 
repr = "(parameter 0 (member equal (member assert (parameter 1 (parameter 1 *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member getAnnotations (return (member AnnotationModel (parameter 2 *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member strictEqual (member assert (parameter 0 (parameter 1 *)))))" and t = "san" and result = 1.0 or 
repr = "(member html *)" and t = "san" and result = 1.0 or 
repr = "(member length (member host (member location (member self (global)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member strictEqual (member assert (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 1 (member get (instance (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 0.9999999999999972 or 
repr = "(member id (member params (parameter 0 (parameter 1 (member get (instance (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(member id (member params (parameter 0 (parameter 1 (member get (instance *))))))" and t = "src" and result = 1.0 or 
repr = "(member HTMLElement *)" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getElementsByTagName (member document (global)))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(parameter 0 (member assert (global)))" and t = "san" and result = 1.0 or 
repr = "(member HTMLElement (global))" and t = "san" and result = 1.0 or 
repr = "(member innerHTML (return (member createElementNS (member document (global)))))" and t = "san" and result = 1.0 or 
repr = "(member innerHTML (return (member createElementNS (member document *))))" and t = "san" and result = 1.0 or 
repr = "(member HTMLElement (member window *))" and t = "san" and result = 1.0 or 
repr = "(member length (member items *))" and t = "san" and result = 1.0000000000000013 or 
repr = "(member innerHTML (return (member createElementNS *)))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (return (member replace (return (member String *))))))))" and t = "san" and result = 1.0000000000000033 or 
repr = "(member HTMLElement (member window (global)))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace (return (member replace (return (member String (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member call (member hasOwnProp *)))" and t = "snk" and result = 0.7056790123456794 or 
repr = "(member Html5 (member vjs (global)))" and t = "san" and result = 1.0000000000000004 or 
repr = "(member Html5 (member vjs *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member aggregate (member Play *)))" and t = "snk" and result = 1.0000000000000004 or 
repr = "(parameter 0 (member get (root https://www.npmjs.com/package/restler)))" and t = "snk" and result = 1.0000000000000004 or 
repr = "(member Html5 *)" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member union *))" and t = "snk" and result = 0.1250000000000011 or 
repr = "(return (member get (root https://www.npmjs.com/package/restler)))" and t = "snk" and result = 0.5 or 
repr = "(parameter 0 (member aggregate (member Play (global))))" and t = "snk" and result = 1.0 or 
repr = "(member length (return (member querySelectorAll (return (member createElement (member document *))))))" and t = "san" and result = 0.9999999999999984 or 
repr = "(member length (return (member filter (return *))))" and t = "san" and result = 1.0000000000000016 or 
repr = "(member length (return (member querySelectorAll (return (member createElement *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member filter (return (member keys (member Object *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member from *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 0 (member callFake (member and (return (member spyOnDevAndProd *))))))" and t = "src" and result = 0.7500000000000029 or 
repr = "(parameter 0 (member from (member Buffer *)))" and t = "snk" and result = 0.21135802469134712 or 
repr = "(parameter 0 (member execSync (root https://www.npmjs.com/package/child_process)))" and t = "snk" and result = 0.05909465020576454 or 
repr = "(member length (return (member filter (return (member keys *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 0 (member callFake (member and (return *)))))" and t = "src" and result = 1.0 or 
repr = "(member length (return (member from (member Array *))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(parameter 0 (parameter 1 (member removeEventListener (member window *))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member toBe (return (member expect (global)))))" and t = "san" and result = 0.9999999999999984 or 
repr = "(member length (return (member filter (return (member keys (member Object (global)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member toBe (return *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member toBe (return (member expect *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 0 (member callFake (member and *))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member toBe *))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member querySelectorAll (return (member createElement (member document (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member from (member Array (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member querySelectorAll (return *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member filter *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member removeEventListener (member window (global)))))" and t = "src" and result = 1.0 or 
repr = "(return (member createElement (root https://www.npmjs.com/package/react)))" and t = "snk" and result = 0.10000000000000023 or 
repr = "(member email (parameter 0 *))" and t = "san" and result = 0.2500000000000002 or 
repr = "(member email (parameter 0 (member stringify (member JSON *))))" and t = "san" and result = 1.0 or 
repr = "(return (member trim (parameter 0 (parameter 1 (member define (global))))))" and t = "san" and result = 0.002400548696843696 or 
repr = "(parameter 1 (member attr (return (member element (member angular *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member attr (return (member element *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member attr (return (member element (member angular (global))))))" and t = "san" and result = 1.0 or 
repr = "(member innerHTML (member el (global)))" and t = "san" and result = 1.0 or 
repr = "(return (member XRegExp (global)))" and t = "snk" and result = 0.9444444444444449 or 
repr = "(member innerHTML (member el *))" and t = "san" and result = 1.0 or 
repr = "(member length (member children (parameter 0 (parameter 1 (member map (member jQuery *))))))" and t = "san" and result = 1.0000000000000016 or 
repr = "(return (member unescape (global)))" and t = "src" and result = 0.5000000000000007 or 
repr = "(member length (member rows (member data *)))" and t = "san" and result = 1.0000000000000016 or 
repr = "(parameter 1 (member splice (member selectedRows (return (member data (member jQuery (global)))))))" and t = "san" and result = 0.999999999999999 or 
repr = "(member length (member children (parameter 0 (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member rows (member data (return *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member update (return (member model *))))" and t = "snk" and result = 1.0 or 
repr = "(member length (member checkedRows (return (member data (member jQuery *)))))" and t = "san" and result = 0.999999999999999 or 
repr = "(member length (member selectedRows (return (member data *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member rows *))" and t = "san" and result = 1.0 or 
repr = "(member length (member frozenColumns (member options (return (member data *)))))" and t = "san" and result = 1.0000000000000016 or 
repr = "(parameter 0 (member html (return (member find (return *)))))" and t = "snk" and result = 1.0 or 
repr = "(return (member replace (return (member trim (member jQuery (global))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member update (return (member model (root https://www.npmjs.com/package/mongoose)))))" and t = "snk" and result = 1.0 or 
repr = "(member length (return (member find (return (member jQuery (global))))))" and t = "san" and result = 1.0 or 
repr = "(member total (member options (return (member data *))))" and t = "src" and result = 1.0 or 
repr = "(member length (return (member datagrid (return (member jQuery *)))))" and t = "san" and result = 1.000000000000001 or 
repr = "(member length (member selectedRows (return *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member frozenColumns (member options *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member frozenColumns *))" and t = "san" and result = 1.0 or 
repr = "(return (member numberbox (return (member jQuery (global)))))" and t = "src" and result = 0.5902925756807033 or 
repr = "(member length (member selectedRows (return (member data (member jQuery (global))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member update (return *)))" and t = "snk" and result = 1.0 or 
repr = "(member length (member children (return (member treegrid (return (member jQuery (global)))))))" and t = "san" and result = 1.0000000000000016 or 
repr = "(parameter 1 (member splice (member selectedRows (return *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member frozenColumns (member options (return (member data (member jQuery (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member text (member options (return *)))" and t = "src" and result = 0.9999999999999998 or 
repr = "(member length (member rows (member data (return (member data *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member children (parameter 0 *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member children (parameter 0 (parameter 1 (member map (member jQuery (global)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member textbox (return (member jQuery *))))" and t = "snk" and result = 1.0000000000000022 or 
repr = "(member tools *)" and t = "src" and result = 1.0 or 
repr = "(member length (member checkedRows (return (member data *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member rows (member data (return (member data (member jQuery *))))))" and t = "san" and result = 1.0 or 
repr = "(return (member passwordbox (return (member jQuery *))))" and t = "src" and result = 1.0000000000000004 or 
repr = "(parameter 1 (member splice (member checkedRows (return (member data *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member datagrid (return *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member find (return (member jQuery *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member splice (member selectedRows (return (member data *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member count (return (member model (root https://www.npmjs.com/package/mongoose)))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member html (return (member find *))))" and t = "snk" and result = 0.5000000000000022 or 
repr = "(member length (return (member datagrid *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member checkedRows *))" and t = "san" and result = 1.0 or 
repr = "(member length (member selectedRows (return (member data (member jQuery *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member rows (member data (return (member data (member jQuery (global)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member count (return (member model *))))" and t = "snk" and result = 1.0 or 
repr = "(return (member replace (return (member trim *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member splice (member checkedRows *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member splice (member checkedRows (return *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member datagrid (return (member jQuery (global))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member splice (member selectedRows *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member selectedRows *))" and t = "san" and result = 1.0 or 
repr = "(member length (member children (return (member treegrid *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member frozenColumns (member options (return (member data (member jQuery *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member splice (member selectedRows (return (member data (member jQuery *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member checkedRows (return *)))" and t = "san" and result = 1.0 or 
repr = "(return (member textbox (return (member jQuery *))))" and t = "src" and result = 1.0000000000000013 or 
repr = "(member length (member children (return (member treegrid (return *)))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member trim (member jQuery *)))))" and t = "san" and result = 1.0 or 
repr = "(member options (return (member data (member jQuery *))))" and t = "src" and result = 0.4166666666666674 or 
repr = "(member total (member options *))" and t = "src" and result = 0.5000000000000018 or 
repr = "(member length (member frozenColumns (member options (return *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member children (return (member treegrid (return (member jQuery *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member children (parameter 0 (parameter 1 (member map *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member checkedRows (return (member data (member jQuery (global))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member splice (member checkedRows (return (member data (member jQuery *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member textbox (return *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 1 (member splice (member checkedRows (return (member data (member jQuery (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member curDragNodes *))" and t = "san" and result = 1.0000000000000004 or 
repr = "(member length (return (member getElementsByTagName (member root (instance (parameter 1 (member register (member parse (member UE *)))))))))" and t = "san" and result = 1.0000000000000013 or 
repr = "(member length (return (member decodeURIComponent *)))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member encodeURIComponent *))))" and t = "san" and result = 0.9999999999999996 or 
repr = "(parameter 0 (member append (return (parameter 0 (parameter 2 (member define (global)))))))" and t = "snk" and result = 0.04166666666667128 or 
repr = "(member htmlState (parameter 1 (member token (return (member startState (return (parameter 1 (member defineMode *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getElementsByTagName (member root (instance (parameter 1 (member register *)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member indent *))" and t = "san" and result = 1.0000000000000029 or 
repr = "(parameter 0 (member createFromHtml (member element (member dom *))))" and t = "snk" and result = 1.0 or 
repr = "(member hash (return (member createElement (member document *))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(member oClasses (parameter 0 *))" and t = "src" and result = 0.9404761904761902 or 
repr = "(parameter 0 (member setHtml *))" and t = "snk" and result = 0.26477366255144036 or 
repr = "(instance (parameter 0 (member setTimeout (member tools (member CKEDITOR *)))))" and t = "src" and result = 1.0 or 
repr = "(parameter 2 (member uiElement (member dialog (member ui (member CKEDITOR *)))))" and t = "snk" and result = 0.17613168724279898 or 
repr = "(member fixDomain (member tools (member CKEDITOR *)))" and t = "src" and result = 1.0000000000000004 or 
repr = "(member length (return (member getElementsByTagName (member root (instance (parameter 1 (member register (member parse (member UE (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member encodeURIComponent (global)))))" and t = "san" and result = 1.0 or 
repr = "(member htmlState (parameter 1 (member token (return (member startState (return (parameter 1 (member defineMode (member CodeMirror (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member append (return (parameter 0 (parameter 2 (member define *))))))" and t = "snk" and result = 1.0 or 
repr = "(member length (return (member jQuery (member window (global)))))" and t = "san" and result = 1.0 or 
repr = "(return (member search *))" and t = "src" and result = 1.0 or 
repr = "(return (member htmlEncode (member tools (member CKEDITOR *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getElementsByTagName (member root (instance (parameter 1 *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member contains (return (member array (member lang (member wysihtml5 (global)))))))" and t = "src" and result = 0.5000000000000149 or 
repr = "(parameter 0 (member each (member HighchartsAdapter (global))))" and t = "snk" and result = 0.7777777777777845 or 
repr = "(member length (return (member decodeURIComponent (global))))" and t = "san" and result = 1.0 or 
repr = "(member htmlState (parameter 1 (member token (return (member startState (return *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member each (member HighchartsAdapter (global)))))" and t = "src" and result = 0.9198216735253869 or 
repr = "(parameter 1 (member canvg *))" and t = "san" and result = 1.0000000000000013 or 
repr = "(instance (parameter 0 (member setTimeout *)))" and t = "src" and result = 1.000000000000001 or 
repr = "(member htmlParser (member CKEDITOR (global)))" and t = "san" and result = 1.0000000000000004 or 
repr = "(member hostname (member location (member document *)))" and t = "san" and result = 1.0 or 
repr = "(member wysihtml5 (global))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member indent (return (member getMode *))))" and t = "san" and result = 1.0 or 
repr = "(member hostname (member location (member document (global))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member indent (return (member getMode (member CodeMirror *)))))" and t = "san" and result = 1.0 or 
repr = "(member htmlParser *)" and t = "san" and result = 1.0 or 
repr = "(member jqXHR *)" and t = "snk" and result = 0.14581556303778642 or 
repr = "(member jqXHR *)" and t = "san" and result = 0.054657064471881456 or 
repr = "(parameter 0 (member indent (return (member getMode (member CodeMirror (global))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member append (return (parameter 0 (parameter 2 *)))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member getUrl (member CKEDITOR *)))" and t = "snk" and result = 0.3500000000000024 or 
repr = "(parameter 2 (member extend (parameter 0 (parameter 2 (member define (global))))))" and t = "src" and result = 0.07142857142857525 or 
repr = "(member length (return (member getElementsByTagName (member root (instance (parameter 1 (member register (member parse *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getElementsByTagName (member root *))))" and t = "san" and result = 1.0 or 
repr = "(member wysihtml5 *)" and t = "san" and result = 1.0 or 
repr = "(member htmlParser (member CKEDITOR *))" and t = "san" and result = 1.0 or 
repr = "(return (member htmlEncode *))" and t = "san" and result = 1.0 or 
repr = "(member fixDomain *)" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member canvg (global)))" and t = "san" and result = 1.0 or 
repr = "(member htmlState (parameter 1 (member token (return (member startState *)))))" and t = "san" and result = 1.0 or 
repr = "(return (member htmlEncode (member tools (member CKEDITOR (global)))))" and t = "san" and result = 1.0 or 
repr = "(member htmlState (parameter 1 (member token (return (member startState (return (parameter 1 *)))))))" and t = "san" and result = 1.0 or 
repr = "(member hash (return (member createElement *)))" and t = "san" and result = 1.0 or 
repr = "(member htmlState *)" and t = "san" and result = 1.0 or 
repr = "(member htmlState (parameter 1 (member token (return *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member jQuery (member window *))))" and t = "san" and result = 1.0 or 
repr = "(return (member htmlEncode (member tools *)))" and t = "san" and result = 1.0 or 
repr = "(member oLanguage *)" and t = "src" and result = 0.9404761904761902 or 
repr = "(parameter 0 (member createFromHtml (member element (member dom (member CKEDITOR (global))))))" and t = "snk" and result = 1.0 or 
repr = "(member htmlState (parameter 1 *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member getUrl *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member createFromHtml (member element (member dom (member CKEDITOR *)))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member createFromHtml *))" and t = "snk" and result = 0.7500000000000001 or 
repr = "(member tools (member CKEDITOR (global)))" and t = "src" and result = 0.5000000000000002 or 
repr = "(member length (return (member getElementsByTagName (member root (instance *)))))" and t = "san" and result = 1.0 or 
repr = "(member hash (return (member createElement (member document (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member curDragNodes (global)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member setData *))" and t = "snk" and result = 0.25000000000000044 or 
repr = "(member htmlState (parameter 1 (member token (return (member startState (return (parameter 1 (member defineMode (member CodeMirror *)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member uiElement (member dialog (member ui *))))" and t = "snk" and result = 1.0 or 
repr = "(return (member trim (member tools (member CKEDITOR *))))" and t = "san" and result = 0.1902377686328316 or 
repr = "(parameter 0 (member indent (return *)))" and t = "san" and result = 1.0 or 
repr = "(member htmlState (parameter 1 (member token *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member activeViewDescriptors *))" and t = "san" and result = 0.9999999999999972 or 
repr = "(parameter 2 (member clamp *))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getReplElements (instance *))))" and t = "san" and result = 0.9999999999999972 or 
repr = "(member length (member visibleViewDescriptors (return (member getViewContainerModel (return (member createInstance (return *)))))))" and t = "san" and result = 0.9999999999999972 or 
repr = "(parameter 0 (member getParseErrorMessage (root https://www.npmjs.com/package/vs/base/common/jsonErrorMessages)))" and t = "src" and result = 0.38678555098308093 or 
repr = "(member length (parameter 0 (parameter 0 (member then (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member get (return (member DiagnosticCollection (root https://www.npmjs.com/package/vs/workbench/api/common/extHostDiagnostics))))))" and t = "san" and result = 0.9999999999999972 or 
repr = "(return (member join (root https://www.npmjs.com/package/vs/base/common/path)))" and t = "san" and result = 0.5000000000000016 or 
repr = "(return (member replace (return (member toString (return (member readFileSync *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member requestsWithAllHeaders (return *)))" and t = "san" and result = 1.0000000000000013 or 
repr = "(member length (parameter 0 (parameter 0 (member then (return (member executeCommand *))))))" and t = "san" and result = 1.0000000000000047 or 
repr = "(parameter 0 (member writeText (member clipboard *)))" and t = "snk" and result = 1.0 or 
repr = "(member length (member folders (return *)))" and t = "san" and result = 1.0 or 
repr = "(member environmentService (instance (parameter 0 *)))" and t = "src" and result = 0.41508916323731054 or 
repr = "(return (member relativePath (root https://www.npmjs.com/package/vs/base/common/resources)))" and t = "src" and result = 0.49999999999999845 or 
repr = "(parameter 0 (member getConfigurationValue (root https://www.npmjs.com/package/vs/platform/configuration/common/configuration)))" and t = "snk" and result = 0.5000000000000001 or 
repr = "(member length (member editors (instance (member EditorsObserver (root https://www.npmjs.com/package/vs/workbench/browser/parts/editor/editorsObserver)))))" and t = "san" and result = 1.0000000000000013 or 
repr = "(parameter 0 (member containsPosition (member Range *)))" and t = "snk" and result = 0.04687500000000193 or 
repr = "(return (member createCancelablePromise (root https://www.npmjs.com/package/vs/base/common/async)))" and t = "src" and result = 0.3035714285714306 or 
repr = "(member length (return (member coalesce (root https://www.npmjs.com/package/vs/base/common/arrays))))" and t = "san" and result = 1.000000000000001 or 
repr = "(parameter 1 (member replace (parameter 0 (parameter 0 (member edit (member activeTextEditor *))))))" and t = "snk" and result = 0.7236831275720217 or 
repr = "(member html (member settings (parameter 0 (parameter 0 (member onDidChangeConfiguration (return (member createConnection *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getLineDecorations *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getDirty *)))" and t = "san" and result = 0.9999999999999972 or 
repr = "(member length (return (member from (member Buffer (global)))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(member length (member items (instance (member CompletionModel (root https://www.npmjs.com/package/vs/editor/contrib/suggest/completionModel)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getUntitledWorkspacesSync (instance (member WorkspacesMainService (root https://www.npmjs.com/package/vs/platform/workspaces/electron-main/workspacesMainService))))))" and t = "san" and result = 0.9999999999999972 or 
repr = "(member length (return (member getUntitledWorkspacesSync (instance *))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (parameter 0 (member then (return (member executeCommand (instance *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member elements *))" and t = "san" and result = 0.999999999999999 or 
repr = "(member None (member CancellationToken (root https://www.npmjs.com/package/vs/base/common/cancellation)))" and t = "src" and result = 0.6000000000000059 or 
repr = "(member length (member folders (return (member getWorkspace (instance (member WorkspaceService *))))))" and t = "san" and result = 0.999999999999999 or 
repr = "(parameter 0 (member parse (member Uri *)))" and t = "snk" and result = 0.27839506172839185 or 
repr = "(member length (member items (instance *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member children (return (member parse (instance (member SnippetParser *))))))" and t = "san" and result = 0.999999999999999 or 
repr = "(member length (member placeholders (return (member parse (instance (member SnippetParser *))))))" and t = "san" and result = 0.999999999999999 or 
repr = "(member length (member placeholders *))" and t = "san" and result = 1.0 or 
repr = "(member innerHTML (member element (return *)))" and t = "san" and result = 1.000000000000001 or 
repr = "(parameter 2 (member localize *))" and t = "san" and result = 1.0 or 
repr = "(member length (member previousNode (return (member getLocation (root https://www.npmjs.com/package/jsonc-parser)))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(member length (member folders (return (member getWorkspace (return (member WorkspaceService (root https://www.npmjs.com/package/vs/workbench/services/configuration/browser/configurationService)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member file (member URI *)))" and t = "snk" and result = 0.7499999999999983 or 
repr = "(member innerHTML (return (member renderMarkdown (root https://www.npmjs.com/package/vs/base/browser/markdownRenderer))))" and t = "san" and result = 1.0000000000000007 or 
repr = "(member length (member previousNode (return *)))" and t = "san" and result = 1.0 or 
repr = "(member innerHTML (member element (instance (member HighlightedLabel (root https://www.npmjs.com/package/vs/base/browser/ui/highlightedlabel/highlightedLabel)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 3 (member Range (root https://www.npmjs.com/package/vscode)))" and t = "san" and result = 1.0 or 
repr = "(member length (member items (return (member CompletionModel (root https://www.npmjs.com/package/vs/editor/contrib/suggest/completionModel)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getLeadingWhitespace (root https://www.npmjs.com/package/vs/base/common/strings))))" and t = "san" and result = 1.0 or 
repr = "(member length (member editors (instance (member EditorsObserver *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member activeViewDescriptors (return (member getViewContainerModel (return (member createInstance (return (member workbenchInstantiationService *))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member normalize (root https://www.npmjs.com/package/vs/base/common/path)))" and t = "src" and result = 0.2204526748971175 or 
repr = "(member length (return (member getUntitledWorkspacesSync (instance (member WorkspacesMainService *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member editors (return *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member folders (return (member parse (member JSON *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member visibleViewDescriptors (return (member getViewContainerModel (return (member createInstance (return (member workbenchInstantiationService (root https://www.npmjs.com/package/vs/workbench/test/browser/workbenchTestServices)))))))))" and t = "san" and result = 1.0 or 
repr = "(member html (member settings (parameter 0 (parameter 0 (member onDidChangeConfiguration *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member pad *))" and t = "san" and result = 1.0 or 
repr = "(return (member map (return (member getSelections *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member addEventListener (member self *))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member isNonEmptyArray (root https://www.npmjs.com/package/vs/base/common/arrays)))" and t = "snk" and result = 0.15624999999999636 or 
repr = "(member length (member placeholders (return *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 3 (member Range (root https://www.npmjs.com/package/vs/workbench/api/common/extHostTypes)))" and t = "san" and result = 1.0 or 
repr = "(member html (return (member renderViewLine2 *)))" and t = "san" and result = 1.000000000000001 or 
repr = "(member length (parameter 0 (parameter 0 (member then (return (member findFiles *))))))" and t = "san" and result = 1.0000000000000013 or 
repr = "(member length (return (member getBreakpoints (return (member createMockDebugModel *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member intersect (member Range *)))" and t = "snk" and result = 0.18749999999999617 or 
repr = "(member length (member suggestions (parameter 0 (parameter 0 (member then (return (member provideCompletionItems (instance (member SnippetCompletionProvider *)))))))))" and t = "san" and result = 1.0000000000000029 or 
repr = "(return (member from (member Buffer *)))" and t = "snk" and result = 0.35000000000001696 or 
repr = "(member length (member items (instance (member CompletionModel *))))" and t = "san" and result = 1.0 or 
repr = "(return (member localize (root https://www.npmjs.com/package/vs/nls)))" and t = "snk" and result = 0.3867855509830794 or 
repr = "(member length (member activeViewDescriptors (return (member getViewContainerModel *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member convertToEndOffset (member LineTokens (root https://www.npmjs.com/package/vs/editor/common/core/lineTokens))))" and t = "san" and result = 1.0000000000000004 or 
repr = "(member length (parameter 0 (parameter 0 (member then *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member visibleViewDescriptors (return (member getViewContainerModel (return (member createInstance (return (member workbenchInstantiationService *))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member writeUInt32BE (root https://www.npmjs.com/package/vs/base/common/buffer)))" and t = "san" and result = 1.0 or 
repr = "(member length (member cells (member document (member activeNotebookEditor (member notebook *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getDirty (member workingCopyFileService (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member format *)))" and t = "san" and result = 1.0 or 
repr = "(return (parameter 0 (member map (return (member getSelections *)))))" and t = "src" and result = 0.75 or 
repr = "(member length (member folders (return (member getWorkspace *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member distinct (root https://www.npmjs.com/package/vs/base/common/objects)))" and t = "snk" and result = 0.5000000000000002 or 
repr = "(member length (member suggestions (parameter 0 (parameter 0 (member then (return (member provideCompletionItems (return (member SnippetCompletionProvider (root https://www.npmjs.com/package/vs/workbench/contrib/snippets/browser/snippetCompletionProvider))))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member dispose (root https://www.npmjs.com/package/vs/base/common/lifecycle)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getLeadingWhitespace *)))" and t = "san" and result = 1.0 or 
repr = "(return (member createCancelablePromise *))" and t = "src" and result = 1.0 or 
repr = "(member length (member folders (return (member getWorkspace (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member suggestions (parameter 0 (parameter 0 *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member Selection *))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getLineDecorations (return (member createTextModel *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member placeholders (return (member parse (instance *)))))" and t = "san" and result = 1.0 or 
repr = "(member outerHTML (return (member linkify (return (member createInstance (return (member workbenchInstantiationService (root https://www.npmjs.com/package/vs/workbench/test/browser/workbenchTestServices))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (parameter 0 (member then (return (member executeCommand (return *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getReplElements *)))" and t = "san" and result = 1.0 or 
repr = "(return (member findThemeById *))" and t = "src" and result = 0.1933927754915405 or 
repr = "(member length (member elements (return (member add *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member suggestions (parameter 0 (parameter 0 (member then *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member visibleViewDescriptors (return (member getViewContainerModel (return (member createInstance *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 3 (member localize (root https://www.npmjs.com/package/vs/nls)))" and t = "san" and result = 1.0 or 
repr = "(member length (member children (return (member parse (instance *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member localize (root https://www.npmjs.com/package/vs/nls)))" and t = "san" and result = 1.0 or 
repr = "(member length (member requestsWithAllHeaders (instance *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 4 (member findPrevBracketInRange *))" and t = "san" and result = 1.0000000000000004 or 
repr = "(member outerHTML (return (member linkify (return *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member children (return (member parse (return (member SnippetParser *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 0 (member map (parameter 1 (parameter 2 *)))))" and t = "src" and result = 0.26419753086419573 or 
repr = "(member length (return (member get (return *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 3 (return (member loadMessageBundle (root https://www.npmjs.com/package/vscode-nls))))" and t = "san" and result = 1.0 or 
repr = "(member html (member settings (parameter 0 (parameter 0 (member onDidChangeConfiguration (return *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member requestsWithAllHeaders (return (member UserDataSyncTestServer (root https://www.npmjs.com/package/vs/platform/userDataSync/test/common/userDataSyncClient)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member basename (root https://www.npmjs.com/package/vs/base/common/path)))" and t = "san" and result = 1.0 or 
repr = "(member outerHTML (return *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member normalizeDriveLetter (root https://www.npmjs.com/package/vs/base/common/labels)))" and t = "src" and result = 0.3333333333333368 or 
repr = "(member length (member suggestions (parameter 0 (parameter 0 (member then (return *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member Uint16Array (global)))" and t = "san" and result = 1.0 or 
repr = "(member length (member suggestions (parameter 0 (parameter 0 (member then (return (member provideCompletionItems *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member from (member Buffer *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member models (return (member createInstance (return (member workbenchInstantiationService (root https://www.npmjs.com/package/vs/workbench/test/browser/workbenchTestServices)))))))" and t = "san" and result = 0.9999999999999984 or 
repr = "(member length (member editors (return (member EditorsObserver *))))" and t = "san" and result = 1.0 or 
repr = "(return (member alloc (member VSBuffer *)))" and t = "src" and result = 0.3750000000000001 or 
repr = "(member length (member editors (return (member EditorsObserver (root https://www.npmjs.com/package/vs/workbench/browser/parts/editor/editorsObserver)))))" and t = "san" and result = 1.0 or 
repr = "(return (member getSelections *))" and t = "src" and result = 0.5666666666666657 or 
repr = "(member innerHTML (member element (instance *)))" and t = "san" and result = 1.0 or 
repr = "(return (member getModel (member _editor *)))" and t = "src" and result = 1.0 or 
repr = "(member innerHTML (member element (instance (member HighlightedLabel *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member get (instance (member DiagnosticCollection *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member placeholders (return (member parse (instance (member SnippetParser (root https://www.npmjs.com/package/vs/editor/contrib/snippet/snippetParser)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member models (return (member createInstance (return (member workbenchInstantiationService *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getReplElements (return *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member placeholders (return (member parse (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getReplElements (instance (member ReplModel (root https://www.npmjs.com/package/vs/workbench/contrib/debug/common/replModel))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getBreakpoints (return (member createMockDebugModel (root https://www.npmjs.com/package/vs/workbench/contrib/debug/test/common/mockDebug))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member children (return (member parse (return *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member replace (parameter 0 (parameter 0 (member edit (member activeTextEditor (member window *)))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 1 (parameter 2 (root https://www.npmjs.com/package/glob)))" and t = "src" and result = 0.25473251028806637 or 
repr = "(member length (return (member read (instance *))))" and t = "san" and result = 0.9999999999999972 or 
repr = "(member innerHTML (return (member renderMarkdown *)))" and t = "san" and result = 1.0 or 
repr = "(return (member readFile (root https://www.npmjs.com/package/vs/base/node/pfs)))" and t = "src" and result = 0.08106995884773643 or 
repr = "(member html (return *))" and t = "san" and result = 1.0 or 
repr = "(member length (member folders (return (member getWorkspace (instance (member WorkspaceService (root https://www.npmjs.com/package/vs/workbench/services/configuration/browser/configurationService)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member get *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member suggestions (parameter 0 (parameter 0 (member then (return (member provideCompletionItems (return (member SnippetCompletionProvider *)))))))))" and t = "san" and result = 1.0 or 
repr = "(member resource (member undefined *))" and t = "src" and result = 0.9166666666666667 or 
repr = "(member length (return (member getDirty (member workingCopyFileService (return (member createInstance (return *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (parameter 0 (member then (return (member findFiles (member workspace *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member toWorkspaceFolders (root https://www.npmjs.com/package/vs/platform/workspace/common/workspace))))" and t = "san" and result = 1.000000000000001 or 
repr = "(member outerHTML (return (member linkify (return (member createInstance *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member addEventListener (member self (global)))))" and t = "src" and result = 1.0 or 
repr = "(member length (return (member getLineDecorations (return *))))" and t = "san" and result = 1.0 or 
repr = "(return (member sync (root https://www.npmjs.com/package/glob)))" and t = "src" and result = 0.35226337448559486 or 
repr = "(return (member lift *))" and t = "snk" and result = 0.04687500000000193 or 
repr = "(member outerHTML (return (member linkify (return (member createInstance (return (member workbenchInstantiationService *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member suggestions (parameter 0 (parameter 0 (member then (return (member provideCompletionItems (return *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (parameter 0 (member then (return (member executeCommand (instance (member ExtHostCommands *))))))))" and t = "san" and result = 1.0 or 
repr = "(member innerHTML (return (member renderFormattedText *)))" and t = "san" and result = 1.0000000000000007 or 
repr = "(member length (member conflictsSettings *))" and t = "san" and result = 1.0000000000000016 or 
repr = "(member length (member requestsWithAllHeaders *))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member detectLinks (member OutputLinkComputer *))))" and t = "san" and result = 1.0000000000000016 or 
repr = "(member length (member conflictsSettings (return (member merge (root https://www.npmjs.com/package/vs/platform/userDataSync/common/settingsMerge)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member coalesce *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member parse (member URI (root https://www.npmjs.com/package/vs/base/common/uri))))" and t = "snk" and result = 0.5283950617283935 or 
repr = "(member length (return (member read (instance (member MarkerService *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member children (return (member parse (instance (member SnippetParser (root https://www.npmjs.com/package/vs/editor/contrib/snippet/snippetParser)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member folders (return (member getWorkspace (return (member WorkspaceService *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (parameter 0 (member then (return (member executeCommand (return (member ExtHostCommands (root https://www.npmjs.com/package/vs/workbench/api/common/extHostCommands)))))))))" and t = "san" and result = 1.0 or 
repr = "(member html (return (member renderViewLine2 (root https://www.npmjs.com/package/vs/editor/common/viewLayout/viewLineRenderer))))" and t = "san" and result = 1.0 or 
repr = "(parameter 4 (member findPrevBracketInRange (member BracketsUtils *)))" and t = "san" and result = 1.0 or 
repr = "(member html (member settings (parameter 0 (parameter 0 (member onDidChangeConfiguration (return (member createConnection (root https://www.npmjs.com/package/vscode-languageserver))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member read (instance (member MarkerService (root https://www.npmjs.com/package/vs/platform/markers/common/markerService))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member read (return (member MarkerService *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getUntitledWorkspacesSync (return *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member placeholders (return (member parse (return (member SnippetParser (root https://www.npmjs.com/package/vs/editor/contrib/snippet/snippetParser)))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member file *))" and t = "snk" and result = 0.7500000000000007 or 
repr = "(parameter 1 (member convertToEndOffset *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member range (root https://www.npmjs.com/package/vs/base/common/arrays)))" and t = "san" and result = 1.0 or 
repr = "(member length (member requestsWithAllHeaders (instance (member UserDataSyncTestServer (root https://www.npmjs.com/package/vs/platform/userDataSync/test/common/userDataSyncClient)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (return (member loadMessageBundle *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getUntitledWorkspacesSync *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getReplElements (instance (member ReplModel *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getReplElements (return (member createMockSession (root https://www.npmjs.com/package/vs/workbench/contrib/debug/test/browser/callStack.test))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member convertToEndOffset (member LineTokens *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member readdirSync (root https://www.npmjs.com/package/fs))))" and t = "san" and result = 1.000000000000001 or 
repr = "(member length (member elements (return (member add (instance (member DisposableStore (root https://www.npmjs.com/package/vs/base/common/lifecycle)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member requestsWithAllHeaders (return (member UserDataSyncTestServer *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 4 (member localize *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member lift *))" and t = "snk" and result = 0.04687500000000193 or 
repr = "(member length (member placeholders (return (member parse *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member folders (return (member parse (member JSON (global))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member folders (return (member getWorkspace (instance *)))))" and t = "san" and result = 1.0 or 
repr = "(member uri (parameter 0 (parameter 0 (member map *))))" and t = "src" and result = 0.9242798353909394 or 
repr = "(member length (return (member read (return *))))" and t = "san" and result = 1.0 or 
repr = "(member innerHTML (return (member renderFormattedText (root https://www.npmjs.com/package/vs/base/browser/formattedTextRenderer))))" and t = "san" and result = 1.0 or 
repr = "(member length (member suggestions (parameter 0 (parameter 0 (member then (return (member provideCompletionItems (instance *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member elements (return (member add (return (member DisposableStore (root https://www.npmjs.com/package/vs/base/common/lifecycle)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member placeholders (return (member parse (return (member SnippetParser *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getDirty (member workingCopyFileService (return (member createInstance *))))))" and t = "san" and result = 1.0 or 
repr = "(member outerHTML (return (member linkify (return (member createInstance (return *))))))" and t = "san" and result = 1.0 or 
repr = "(return (member generateUuid (root https://www.npmjs.com/package/vs/base/common/uuid)))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member getConfigurationValue *))" and t = "snk" and result = 1.0 or 
repr = "(member length (return (member getLineDecorations (return (member createTextModel (root https://www.npmjs.com/package/vs/editor/test/common/editorTestUtils))))))" and t = "san" and result = 1.0 or 
repr = "(member innerHTML (member element (return (member HighlightedLabel *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member folders (return (member parse *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member models (return *)))" and t = "san" and result = 1.0 or 
repr = "(member html (member settings *))" and t = "san" and result = 1.0 or 
repr = "(member length (member elements (return (member add (instance (member DisposableStore *))))))" and t = "san" and result = 1.0 or 
repr = "(return (member distinct (root https://www.npmjs.com/package/vs/base/common/objects)))" and t = "san" and result = 0.5000000000000002 or 
repr = "(member length (member requestsWithAllHeaders (instance (member UserDataSyncTestServer *))))" and t = "san" and result = 1.0 or 
repr = "(return (member getSelections (member editor (instance (parameter 1 *)))))" and t = "src" and result = 0.9333333333333343 or 
repr = "(return (member distinctParents *))" and t = "src" and result = 0.20000000000000295 or 
repr = "(member length (member cells (member document (member activeNotebookEditor (member notebook (root https://www.npmjs.com/package/vscode))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member get (instance (member DiagnosticCollection (root https://www.npmjs.com/package/vs/workbench/api/common/extHostDiagnostics))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member previousNode *))" and t = "san" and result = 1.0 or 
repr = "(member length (member visibleViewDescriptors (return *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member visibleViewDescriptors (return (member getViewContainerModel *))))" and t = "san" and result = 1.0 or 
repr = "(member identifier (parameter 0 *))" and t = "src" and result = 1.000000000000003 or 
repr = "(member html (member settings (parameter 0 (parameter 0 *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member detectLinks (member OutputLinkComputer (root https://www.npmjs.com/package/vs/workbench/contrib/output/common/outputLinkComputer)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getUntitledWorkspacesSync (return (member WorkspacesMainService *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member elements (return *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getUntitledWorkspacesSync (return (member WorkspacesMainService (root https://www.npmjs.com/package/vs/platform/workspaces/electron-main/workspacesMainService))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (member clamp (root https://www.npmjs.com/package/vs/base/common/numbers)))" and t = "san" and result = 1.0 or 
repr = "(parameter 3 (member localize *))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getDirty (member workingCopyFileService (return (member createInstance (return (member workbenchInstantiationService *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member get (return (member DiagnosticCollection *)))))" and t = "san" and result = 1.0 or 
repr = "(member CancellationToken *)" and t = "src" and result = 0.4000000000000039 or 
repr = "(parameter 0 (member task *))" and t = "snk" and result = 0.9999999999999989 or 
repr = "(member first *)" and t = "src" and result = 1.0 or 
repr = "(return (member replace (return (member toString (return (member readFileSync (root https://www.npmjs.com/package/fs)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getBreakpoints *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getBreakpoints (return *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member toWorkspaceFolders *)))" and t = "san" and result = 1.0 or 
repr = "(member outerHTML (return (member linkify *)))" and t = "san" and result = 1.0 or 
repr = "(member origin (member location (member window (global))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(member length (member conflictsSettings (return (member merge *))))" and t = "san" and result = 1.0 or 
repr = "(member html (member settings (parameter 0 *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member visibleViewDescriptors *))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member pad (root https://www.npmjs.com/package/vs/base/common/strings)))" and t = "san" and result = 1.0 or 
repr = "(member length (member children (return (member parse *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member format (root https://www.npmjs.com/package/vs/base/common/strings)))" and t = "san" and result = 1.0 or 
repr = "(member length (member items (return *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member cells (member document (member activeNotebookEditor *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member suggestions *))" and t = "san" and result = 1.0 or 
repr = "(parameter 4 (member localize (root https://www.npmjs.com/package/vs/nls)))" and t = "san" and result = 1.0 or 
repr = "(member innerHTML (member element *))" and t = "san" and result = 1.0 or 
repr = "(member length (member activeViewDescriptors (return (member getViewContainerModel (return (member createInstance *))))))" and t = "san" and result = 1.0 or 
repr = "(member origin (member location (member window *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 4 (member findPrevBracketInRange (member BracketsUtils (root https://www.npmjs.com/package/vs/editor/common/modes/supports/richEditBrackets))))" and t = "san" and result = 1.0 or 
repr = "(member length (member editors (instance *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member conflictsSettings (return *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getDirty (member workingCopyFileService (return (member createInstance (return (member workbenchInstantiationService (root https://www.npmjs.com/package/vs/workbench/test/browser/workbenchTestServices)))))))))" and t = "san" and result = 1.0 or 
repr = "(return (member getModel (member _editor (instance *))))" and t = "src" and result = 0.09375000000000519 or 
repr = "(member length (parameter 0 (parameter 0 (member then (return (member findFiles (member workspace (root https://www.npmjs.com/package/vscode))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member activeViewDescriptors (return (member getViewContainerModel (return (member createInstance (return (member workbenchInstantiationService (root https://www.npmjs.com/package/vs/workbench/test/browser/workbenchTestServices)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member visibleViewDescriptors (return (member getViewContainerModel (return *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member Uint16Array *))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member read *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member Position *))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member detectLinks *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member suggestions (parameter 0 *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member elements (return (member add (instance *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getReplElements (return (member createMockSession *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member models *))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getReplElements (return (member ReplModel (root https://www.npmjs.com/package/vs/workbench/contrib/debug/common/replModel))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member Position (root https://www.npmjs.com/package/vscode)))" and t = "san" and result = 1.0 or 
repr = "(member length (member activeViewDescriptors (return (member getViewContainerModel (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member models (return (member createInstance (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member cells (member document *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 2 (return (member loadMessageBundle (root https://www.npmjs.com/package/vscode-nls))))" and t = "san" and result = 1.0 or 
repr = "(member length (member children (return (member parse (return (member SnippetParser (root https://www.npmjs.com/package/vs/editor/contrib/snippet/snippetParser)))))))" and t = "san" and result = 1.0 or 
repr = "(member fsPath (member resource *))" and t = "src" and result = 1.0 or 
repr = "(member length (member items (return (member CompletionModel *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member editors *))" and t = "san" and result = 1.0 or 
repr = "(member innerHTML (member element (return (member HighlightedLabel (root https://www.npmjs.com/package/vs/base/browser/ui/highlightedlabel/highlightedLabel)))))" and t = "san" and result = 1.0 or 
repr = "(return (member deepClone (root https://www.npmjs.com/package/vs/base/common/objects)))" and t = "san" and result = 0.5000000000000002 or 
repr = "(member length (return (member readdirSync *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member parse (member Uri (root https://www.npmjs.com/package/vscode))))" and t = "snk" and result = 1.0 or 
repr = "(member length (return (member getReplElements (return (member ReplModel *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member models (return (member createInstance *))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (parameter 0 (member then (return (member executeCommand (return (member ExtHostCommands *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member elements (return (member add (return (member DisposableStore *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 3 (return (member loadMessageBundle *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member Selection (root https://www.npmjs.com/package/vscode)))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 0 (parameter 0 (member then (return (member executeCommand (instance (member ExtHostCommands (root https://www.npmjs.com/package/vs/workbench/api/common/extHostCommands)))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member range (root https://www.npmjs.com/package/vs/base/common/arrays)))" and t = "san" and result = 1.0 or 
repr = "(member length (member folders *))" and t = "san" and result = 1.0 or 
repr = "(member length (member elements (return (member add (return *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getDirty (member workingCopyFileService *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member suggestions (parameter 0 (parameter 0 (member then (return (member provideCompletionItems (instance (member SnippetCompletionProvider (root https://www.npmjs.com/package/vs/workbench/contrib/snippets/browser/snippetCompletionProvider))))))))))" and t = "san" and result = 1.0 or 
repr = "(return (parameter 0 (member map (return (member reverse *)))))" and t = "src" and result = 0.544320987654325 or 
repr = "(parameter 0 (parameter 0 (member map (return (member getSelections *)))))" and t = "src" and result = 0.12500000000000105 or 
repr = "(parameter 0 (member isIRange (member Range (root https://www.npmjs.com/package/vs/editor/common/core/range))))" and t = "snk" and result = 0.04687500000000193 or 
repr = "(return (member toResource *))" and t = "src" and result = 0.32386831275720185 or 
repr = "(member value (parameter 0 (parameter 0 (member then *))))" and t = "snk" and result = 0.20452674897119294 or 
repr = "(member length (return (member get (instance *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member format (root https://www.npmjs.com/package/vs/base/common/strings))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member replace (parameter 0 (parameter 0 (member edit (member activeTextEditor (member window (root https://www.npmjs.com/package/vscode))))))))" and t = "src" and result = 0.10341563786008484 or 
repr = "(member length (member activeViewDescriptors (return *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member rewriteWorkspaceFileForNewLocation (root https://www.npmjs.com/package/vs/platform/workspaces/common/workspaces)))" and t = "snk" and result = 0.3522633744855964 or 
repr = "(member length (member activeViewDescriptors (return (member getViewContainerModel (return (member createInstance (return *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (member previousNode (return (member getLocation *))))" and t = "san" and result = 1.0 or 
repr = "(member length (member cells *))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member read (return (member MarkerService (root https://www.npmjs.com/package/vs/platform/markers/common/markerService))))))" and t = "san" and result = 1.0 or 
repr = "(member textEditorModel *)" and t = "snk" and result = 0.07386831275720179 or 
repr = "(member length (member changedTouches (member event (parameter 0 (parameter 1 (member define *))))))" and t = "san" and result = 1.0000000000000016 or 
repr = "(member filter (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(member slug (member params (parameter 0 (parameter 1 (member get (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(member length (member changedTouches (member event (parameter 0 *))))" and t = "san" and result = 1.0 or 
repr = "(member slug (member params (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(member slug (member params *))" and t = "src" and result = 1.0 or 
repr = "(member slug (member params (parameter 0 (parameter 1 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member filter (member query (parameter 0 (parameter 2 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member length (member changedTouches (member event (parameter 0 (parameter 1 (member define (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member slug (member params (parameter 0 (parameter 1 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(member length (member changedTouches *))" and t = "san" and result = 1.0 or 
repr = "(member filter (member query (parameter 0 (parameter 2 (member get (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(member filter (member query (parameter 0 (parameter 2 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(member slug (member params (parameter 0 (parameter 1 *))))" and t = "src" and result = 1.0 or 
repr = "(member filter (member query (parameter 0 (parameter 2 (member get (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(member length (member changedTouches (member event *)))" and t = "san" and result = 1.0 or 
repr = "(member filter (member query *))" and t = "src" and result = 1.0 or 
repr = "(member slug (member params (parameter 0 (parameter 1 (member get (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(member length (member changedTouches (member event (parameter 0 (parameter 1 *)))))" and t = "san" and result = 1.0 or 
repr = "(member filter (member query (parameter 0 (parameter 2 *))))" and t = "src" and result = 1.0 or 
repr = "(member cookies (parameter 0 (parameter 1 (member get (return *)))))" and t = "src" and result = 1.0000000000000016 or 
repr = "(member cookies (parameter 0 (parameter 1 (member get *))))" and t = "src" and result = 1.0 or 
repr = "(return (member param (parameter 0 (parameter 1 (member get (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(member cookies (parameter 0 (parameter 1 (member get (return (member Router (root https://www.npmjs.com/package/express)))))))" and t = "src" and result = 1.0 or 
repr = "(member cookies (parameter 0 (parameter 1 (member post (return (member Router (root https://www.npmjs.com/package/express)))))))" and t = "src" and result = 1.0000000000000016 or 
repr = "(member cookies (parameter 0 (parameter 1 (member post *))))" and t = "src" and result = 1.0 or 
repr = "(member cookies (parameter 0 (parameter 1 (member post (return (member Router *))))))" and t = "src" and result = 1.0 or 
repr = "(return (member param (parameter 0 (parameter 1 (member get (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(return (member param (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(return (member param (parameter 0 (parameter 1 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(member cookies (parameter 0 (parameter 1 *)))" and t = "src" and result = 1.0 or 
repr = "(return (member param (parameter 0 (parameter 1 *))))" and t = "src" and result = 1.0 or 
repr = "(member cookies (parameter 0 (parameter 1 (member get (return (member Router *))))))" and t = "src" and result = 1.0 or 
repr = "(member cookies (parameter 0 (parameter 1 (member post (return *)))))" and t = "src" and result = 1.0 or 
repr = "(return (member param (parameter 0 (parameter 1 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member length (return (member getElementById (member document (global)))))" and t = "san" and result = 1.0000000000000002 or 
repr = "(member length (return (member getElementById *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member getElementById (member document *))))" and t = "san" and result = 1.0 or 
repr = "(member id (member query (parameter 0 (parameter 1 (member get (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(member id (member query (parameter 0 (parameter 1 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(member id (member query (parameter 0 (parameter 1 (member get (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(member id (member query (parameter 0 (parameter 1 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member iDisplayStart (member query (parameter 0 (parameter 1 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member recordsTotal (parameter 0 *))" and t = "san" and result = 0.9999999999999984 or 
repr = "(member iDisplayStart (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member htmlparser *))" and t = "san" and result = 1.0000000000000004 or 
repr = "(member category (member params (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(member recordsTotal (parameter 0 (member send (parameter 1 (parameter 1 (member get (return *)))))))" and t = "san" and result = 1.0 or 
repr = "(member first (member params *))" and t = "src" and result = 1.0 or 
repr = "(return (member htmlencode (global)))" and t = "san" and result = 1.0 or 
repr = "(member iDisplayStart (member query (parameter 0 (parameter 1 (member get (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(member iDisplayStart (member query (parameter 0 (parameter 1 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(return (member trim (member utils (global))))" and t = "src" and result = 0.5806790123456782 or 
repr = "(member category (member params (parameter 0 (parameter 1 (member get (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(member protocol (member location (member document (global))))" and t = "san" and result = 1.0 or 
repr = "(member first (member params (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(member first (member params (parameter 0 (parameter 1 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(member iDisplayStart (member query *))" and t = "src" and result = 1.0 or 
repr = "(member first (member params (parameter 0 (parameter 1 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member category (member params (parameter 0 (parameter 1 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(member hostname (member location (member self *)))" and t = "san" and result = 1.0000000000000016 or 
repr = "(member recordsTotal (parameter 0 (member send (parameter 1 (parameter 1 *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member htmlparser (member UM (global))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member get (return (member array (member lang (member wysihtml5 *)))))))" and t = "san" and result = 1.0 or 
repr = "(member first (member params (parameter 0 (parameter 1 (member get (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(member length (return (member get (return (member array (member lang *))))))" and t = "san" and result = 1.0 or 
repr = "(member protocol (member location (member document *)))" and t = "san" and result = 1.0 or 
repr = "(member recordsTotal (parameter 0 (member send *)))" and t = "san" and result = 1.0 or 
repr = "(member recordsTotal (parameter 0 (member send (parameter 1 (parameter 1 (member get *))))))" and t = "san" and result = 1.0 or 
repr = "(return (member htmlencode *))" and t = "san" and result = 1.0 or 
repr = "(member category (member params (parameter 0 (parameter 1 (member get (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(member first (member params (parameter 0 (parameter 1 *))))" and t = "src" and result = 1.0 or 
repr = "(member category (member params *))" and t = "src" and result = 1.0 or 
repr = "(member recordsTotal (parameter 0 (member send (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(member recordsTotal *)" and t = "san" and result = 1.0 or 
repr = "(member hostname (member location (member self (global))))" and t = "san" and result = 1.0 or 
repr = "(member category (member params (parameter 0 (parameter 1 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member length (return (member get (return (member array *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member htmlparser (member UM *)))" and t = "san" and result = 1.0 or 
repr = "(member first (member params (parameter 0 (parameter 1 (member get (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(member length (return (member get (return (member array (member lang (member wysihtml5 (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member iDisplayStart (member query (parameter 0 (parameter 1 *))))" and t = "src" and result = 1.0 or 
repr = "(member iDisplayStart (member query (parameter 0 (parameter 1 (member get (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(member recordsTotal (parameter 0 (member send (parameter 1 (parameter 1 (member get (return (member Router (root https://www.npmjs.com/package/express)))))))))" and t = "san" and result = 1.0 or 
repr = "(member iDisplayStart *)" and t = "src" and result = 1.0 or 
repr = "(member category (member params (parameter 0 (parameter 1 *))))" and t = "src" and result = 1.0 or 
repr = "(member recordsTotal (parameter 0 (member send (parameter 1 (parameter 1 (member get (return (member Router *))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member createSimpleLexer (return (parameter 2 *)))))" and t = "san" and result = 0.9999999999999972 or 
repr = "(member length (parameter 1 (member createSimpleLexer (return (parameter 2 (member define (member window (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member concat (parameter 0 (member createSimpleLexer (return *))))))" and t = "san" and result = 1.0000000000000036 or 
repr = "(member length (parameter 1 (member registerLangHandler (member PR (global)))))" and t = "san" and result = 0.9999999999999972 or 
repr = "(member length (return (member concat (parameter 0 (member createSimpleLexer *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member createSimpleLexer (return (parameter 2 (member define (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member createSimpleLexer (return (parameter 2 (member define (member window *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member registerLangHandler (return (parameter 2 *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member match (member a (parameter 0 *)))))" and t = "san" and result = 0.9999999999999984 or 
repr = "(member length (parameter 1 (member createSimpleLexer (member PR *))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member createSimpleLexer *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member match (member a (parameter 0 (return (member createSimpleLexer (member PR *))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member html (return (member find (return (parameter 0 (parameter 1 (member define (global)))))))))" and t = "snk" and result = 0.4999999999999991 or 
repr = "(member length (return (member match (member a (parameter 0 (return (member createSimpleLexer (member PR (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member match (member a *))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member createSimpleLexer (return *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member concat (parameter 0 (member createSimpleLexer (return (parameter 2 (member define (global)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member concat (parameter 0 (member createSimpleLexer (return (parameter 2 (member define (member window *)))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member concat (parameter 0 (member createSimpleLexer (return (parameter 2 (member define (member window (global))))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member registerLangHandler *)))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member concat (parameter 0 (member createSimpleLexer (member PR (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member registerLangHandler (return (parameter 2 (member define (member window (global))))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member registerLangHandler (return (parameter 2 (member define (global)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member concat (parameter 0 (member createSimpleLexer (member PR *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member concat (parameter 0 (member createSimpleLexer (return (parameter 2 *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member concat (parameter 0 (member createSimpleLexer (return (parameter 2 (member define *))))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member validate (root https://www.npmjs.com/package/joi)))" and t = "snk" and result = 0.5000000000000003 or 
repr = "(member length (parameter 1 (member createSimpleLexer (return (parameter 2 (member define *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member match (member a (parameter 0 (return *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member union (root https://www.npmjs.com/package/lodash)))" and t = "snk" and result = 1.0 or 
repr = "(member length (parameter 1 (member registerLangHandler (return (parameter 2 (member define *))))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member match (member a (parameter 0 (return (member createSimpleLexer *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member registerLangHandler (return *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member html (return (member find (return (parameter 0 (parameter 1 *)))))))" and t = "snk" and result = 1.0 or 
repr = "(member length (parameter 1 (member registerLangHandler (return (parameter 2 (member define (member window *)))))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member createSimpleLexer (member PR (global)))))" and t = "san" and result = 1.0 or 
repr = "(member length (parameter 1 (member registerLangHandler (member PR *))))" and t = "san" and result = 1.0 or 
repr = "(member length (return (member concat (parameter 0 *))))" and t = "san" and result = 1.0 or 
repr = "(member tags (return (member assign (member Object (global)))))" and t = "snk" and result = 0.25000000000000056 or 
repr = "(member direction (member query *))" and t = "src" and result = 1.0 or 
repr = "(member request_id (member params *))" and t = "src" and result = 1.0 or 
repr = "(member end_date (member query (parameter 0 (parameter 1 (member get (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(member direction (member query (parameter 0 (parameter 1 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member page (member query (parameter 0 (parameter 1 *))))" and t = "src" and result = 1.0 or 
repr = "(member end_date (member query (parameter 0 (parameter 1 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(member start_date (member query (parameter 0 (parameter 1 *))))" and t = "src" and result = 1.0 or 
repr = "(member page (member query (parameter 0 (parameter 1 (member get (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(member direction (member query (parameter 0 (parameter 1 (member get (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(member status (member query (parameter 0 (parameter 1 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(member end_date *)" and t = "src" and result = 1.0 or 
repr = "(member request_id (member params (parameter 0 (parameter 1 (member post (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(member status (member query (parameter 0 (parameter 1 (member get (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(member start_date (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(member end_date (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(member end_date (member query (parameter 0 (parameter 1 *))))" and t = "src" and result = 1.0 or 
repr = "(member start_date (member query *))" and t = "src" and result = 1.0 or 
repr = "(member end_date (member query (parameter 0 (parameter 1 (member get (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(member direction (member query (parameter 0 (parameter 1 (member get (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(member start_date (member query (parameter 0 (parameter 1 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member page (member query (parameter 0 (parameter 1 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(member page (member query (parameter 0 (parameter 1 (member get (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(member status (member query (parameter 0 (parameter 1 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member end_date (member query *))" and t = "src" and result = 1.0 or 
repr = "(member status (member query *))" and t = "src" and result = 1.0 or 
repr = "(member start_date (member query (parameter 0 (parameter 1 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(member direction (member query (parameter 0 (parameter 1 (member get *)))))" and t = "src" and result = 1.0 or 
repr = "(member request_id (member params (parameter 0 (parameter 1 (member post (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member request_id *)" and t = "src" and result = 1.0 or 
repr = "(member direction (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(member start_date (member query (parameter 0 (parameter 1 (member get (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(member status (member query (parameter 0 (parameter 1 *))))" and t = "src" and result = 1.0 or 
repr = "(member request_id (member params (parameter 0 (parameter 1 (member post (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(member request_id (member params (parameter 0 (parameter 1 *))))" and t = "src" and result = 1.0 or 
repr = "(member status (member query (parameter 0 (parameter 1 (member get (return (member Router *)))))))" and t = "src" and result = 1.0 or 
repr = "(member end_date (member query (parameter 0 (parameter 1 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member page (member query (parameter 0 (parameter 1 (member get (return *))))))" and t = "src" and result = 1.0 or 
repr = "(member status (member query (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(member start_date *)" and t = "src" and result = 1.0 or 
repr = "(member request_id (member params (parameter 0 *)))" and t = "src" and result = 1.0 or 
repr = "(member request_id (member params (parameter 0 (parameter 1 (member post *)))))" and t = "src" and result = 1.0 or 
repr = "(member start_date (member query (parameter 0 (parameter 1 (member get (return (member Router (root https://www.npmjs.com/package/express))))))))" and t = "src" and result = 1.0 or 
repr = "(member direction (member query (parameter 0 (parameter 1 *))))" and t = "src" and result = 1.0 or 
repr = "(member nodeTemplateMap (return (member make (member GraphObject *))))" and t = "san" and result = 1.000000000000001 or 
repr = "(parameter 0 (member indexOf (member longname (parameter 0 (parameter 1 (member each *))))))" and t = "snk" and result = 1.0 or 
repr = "(return (member search (parameter 11 (parameter 1 *))))" and t = "src" and result = 1.0 or 
repr = "(member activity (parameter 0 *))" and t = "src" and result = 0.6745541838134452 or 
repr = "(return (member search (parameter 11 (parameter 1 (member controller (return (member module *)))))))" and t = "src" and result = 1.0 or 
repr = "(member nodeTemplateMap *)" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member merge (root https://www.npmjs.com/package/lodash)))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member indexOf (member longname (parameter 0 (parameter 1 *)))))" and t = "snk" and result = 0.576989026063092 or 
repr = "(member length (member activity (parameter 0 (parameter 1 (member each (root https://www.npmjs.com/package/lodash))))))" and t = "san" and result = 1.000000000000001 or 
repr = "(return (member search (parameter 11 (parameter 1 (member controller (return (member module (member angular (global)))))))))" and t = "src" and result = 1.0 or 
repr = "(member length (member activity (parameter 0 (parameter 1 *))))" and t = "san" and result = 1.0 or 
repr = "(return (member search (parameter 11 (parameter 1 (member controller *)))))" and t = "src" and result = 1.0 or 
repr = "(member length (member activity (parameter 0 *)))" and t = "san" and result = 1.0 or 
repr = "(member nodeTemplateMap (return *))" and t = "san" and result = 1.0 or 
repr = "(return (member search (parameter 11 (parameter 1 (member controller (return *))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member indexOf (member context (parameter 0 (parameter 1 (member filter *))))))" and t = "snk" and result = 1.0 or 
repr = "(member nodeTemplateMap (return (member make (member GraphObject (member go (global))))))" and t = "san" and result = 1.0 or 
repr = "(return (member search (parameter 11 (parameter 1 (member controller (return (member module (member angular *))))))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member indexOf (member activity (parameter 0 *))))" and t = "snk" and result = 1.0 or 
repr = "(member nodeTemplateMap (return (member make (member GraphObject (member go *)))))" and t = "san" and result = 1.0 or 
repr = "(member nodeTemplateMap (return (member make *)))" and t = "san" and result = 1.0 or 
repr = "(member length (member activity (parameter 0 (parameter 1 (member each *)))))" and t = "san" and result = 1.0 or 
repr = "(member length (member activity *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member indexOf (member activity (parameter 0 (parameter 1 (member filter *))))))" and t = "snk" and result = 0.8121284865112067 or 
repr = "(return (member search (parameter 11 *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member each (member _ (global)))))" and t = "src" and result = 0.16982167352537994 or 
repr = "(parameter 0 (member indexOf (member context (parameter 0 *))))" and t = "snk" and result = 0.9378715134888002 or 
repr = "(parameter 0 (parameter 1 (member each (member _ *))))" and t = "src" and result = 1.0 or 
repr = "(member length (return (member filter (root https://www.npmjs.com/package/lodash))))" and t = "san" and result = 1.0 
                 
        
    }    
}