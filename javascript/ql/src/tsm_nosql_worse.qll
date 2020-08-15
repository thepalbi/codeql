
import javascript

import NodeRepresentation

module TSMNoSqlWorse{
    string rep(DataFlow::Node node){
         result = candidateRep(node, _) //and
         //isFilteredRep(result, _)
          //and
        // count(DataFlow::Node n | candidateRep(n, _) = result) < 100
    }

    string rep2(DataFlow::Node node, int occ, float weight){
        result = candidateRep(node, _) and
        occ = count(DataFlow::Node n | candidateRep(n, _) = result) and
        weight = 1.0 and
        occ <= 50
    }

    // predicate goodRep(string repr){        
    //     count(DataFlow::Node node | rep(node) = repr)  < 166
    // }

    float getSum(DataFlow::Node n){
        result = sum(float k, float w | k = getReprScore(rep2(n, _, w ), "snk") | k*w )
    }

    predicate isSink2(DataFlow::Node node, float score){
        exists(rep(node)) and   score = getSum(node)/count(rep(node)) or
        not exists(rep(node)) and score = 0
    }

    predicate isSink(DataFlow::Node node, float score){
        exists(rep(node)) and   score = sum(getReprScore(rep(node), "snk"))/count(rep(node)) or
        not exists(rep(node)) and score = 0
    }

    predicate isSource(DataFlow::Node node, float score){
        exists(rep(node)) and   score = sum(getReprScore(rep(node), "src"))/count(rep(node)) or
        not exists(rep(node)) and score = 0
    }

    predicate isSanitizer(DataFlow::Node node, float score){
        exists(rep(node)) and
        score = sum(getReprScore(rep(node), "san"))/count(rep(node)) or
        not exists(rep(node)) and score = 0
    }

    // string rep(DataFlow::Node nd) {
    //     exists(Portal p | nd = p.getAnExitNode(_) or nd = p.getAnEntryNode(_) |
    //       exists(int i, string prefix |
    //         prefix = p.getBasePortal(i).toString() and
    //         result = p.toString().replaceAll(prefix, "*") and
    //         // ensure the suffix isn't entirely composed of `parameter` and `return` steps
    //         result.regexpMatch(".*\\((global|member|root).*")
    //       )
    //       or
    //       result = p.toString()
    //     )
    // }

    predicate isFilteredRep(string k, int s){
        k="(parameter 0 (return (member make_get_request (global))))" and s=6 or
        k="(parameter 2 (return (member make_get_request (global))))" and s=6 or
        k="(parameter 0 (return (member findOne *)))" and s=5 or
        k="(parameter 0 (return (member postMessage *)))" and s=2 or
        k="(member deps *)" and s=2 or
        k="(parameter 0 (return (member userAssert *)))" and s=3 or
        k="(parameter 0 (return (member getValueForExpr *)))" and s=5 or
        k="(parameter 0 (return (member getPrototypeOf (member Object (global)))))" and s=5 or
        k="(return (member deleteOne *))" and s=1 or
        k="(parameter 0 (return (member blockStatement *)))" and s=1 or
        k="(parameter 1 (return (member findAndModify *)))" and s=1 or
        k="(parameter 0 (return (member findOne (return (member collection *)))))" and s=5 or
        k="(parameter 0 (return (member findOneAndUpdate *)))" and s=6 or
        k="(parameter 1 (return (parameter 1 (return (member getUser *)))))" and s=5 or
        k="(parameter 0 (return (member merge *)))" and s=1 or
        k="(parameter 1 (parameter 1 (return (member getFile *))))" and s=5 or
        k="(parameter 0 (return (member getWorkspace *)))" and s=5 or
        k="(member parentNode *)" and s=1 or
        k="(return (member findOne (member Playlist (global))))" and s=5 or
        k="(parameter 0 (return (member findOne (member Playlist (global)))))" and s=5 or
        k="(parameter 0 (return (member getPostByPermalink (return (member PostsDAO *)))))" and s=5 or
        k="(parameter 0 (return (member getPostByPermalink (instance (member PostsDAO *)))))" and s=5 or
        k="(parameter 0 (return (member getPostByPermalink *)))" and s=5 or
        k="(return (member getCursorStates *))" and s=5 or
        k="(parameter 0 (return (member findRange *)))" and s=1 or
        k="(member _process *)" and s=4 or
        k="(parameter 0 (return (member getStartLineNumber (member regions *))))" and s=5 or
        k="(parameter 0 (return (member findSkillByName *)))" and s=1 or
        k="(parameter 1 (return (member findOneAndUpdate *)))" and s=6 or
        k="(parameter 0 (return (member findOne (member Node *))))" and s=5 or
        k="(return (member findOneAndUpdate *))" and s=6 or
        k="(parameter 0 (return (member getAttribute *)))" and s=6 or
        k="(member nodeName (parameter target *))" and s=1 or
        k="(parameter 0 (return (member insertNode *)))" and s=1 or
        k="(return (member getPlotLinePath *))" and s=5 
    }

    float getReprScore(string repr, string t){
        repr = "(member _id (member items *))" and t = "src" and result = 1.0 or
repr = "(member body (parameter 0 (member loginUser *)))" and t = "src" and result = 1.0 or
repr = "(member _id *)" and t = "src" and result = 0.9711538461538461 or
repr = "(parameter 0 (return (member test *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter req *))" and t = "src" and result = 1.0 or
repr = "(member name (member window (global)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter 0 (member createSecure *)))" and t = "src" and result = 1.0 or
repr = "(member name (parameter window *))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member log *)))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (member president (parameter 0 (return (member json *)))))" and t = "src" and result = 1.0 or
repr = "(member id (member params (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (parameter 2 (return (member post *)))))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member findByIdAndRemove *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter request (parameter 1 (return (member post *)))))" and t = "src" and result = 1.0 or
repr = "(member body *)" and t = "src" and result = 1.0 or
repr = "(member body (parameter 0 (parameter 1 (return (member patch *)))))" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (parameter 1 (return (member post *)))))" and t = "src" and result = 1.0 or
repr = "(member id (member params *))" and t = "src" and result = 1.0 or
repr = "(member body (parameter 0 (member updatePresident *)))" and t = "src" and result = 1.0 or
repr = "(parameter 1 (return (member log (member console (global)))))" and t = "src" and result = 1.0 or
repr = "(member id *)" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member findByIdAndUpdate *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter request *))" and t = "src" and result = 1.0 or
repr = "(member userId (member params *))" and t = "src" and result = 1.0 or
repr = "(member _id (parameter 0 (return (member update *))))" and t = "src" and result = 1.0 or
repr = "(member body (parameter request (member updatePresident *)))" and t = "src" and result = 1.0 or
repr = "(member name *)" and t = "src" and result = 0.9215243016308736 or
repr = "(member body (parameter 0 (parameter 2 (return (member post *)))))" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (parameter 1 (return (member patch *)))))" and t = "src" and result = 1.0 or
repr = "(parameter 1 (return (member update *)))" and t = "src" and result = 1.0 or
repr = "(member userId (member params (parameter request *)))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member log (member console (global)))))" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (member createSecure *)))" and t = "src" and result = 1.0 or
repr = "(member _id (member items (member $pull *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (member loginUser *)))" and t = "src" and result = 1.0 or
repr = "(member name (member params (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member userId (member params (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter 0 (parameter 1 (return (member post *)))))" and t = "src" and result = 1.0 or
repr = "(member name (global))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (member criminal (parameter 0 (return (member json *)))))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (member criminal *))" and t = "src" and result = 1.0 or
repr = "(parameter 1 (return (member log *)))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member findById *)))" and t = "src" and result = 1.0 or
repr = "(member name (member params *))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member create *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter request (parameter 1 (return (member patch *)))))" and t = "src" and result = 1.0 or
repr = "(parameter 1 (return (member findByIdAndUpdate *)))" and t = "src" and result = 1.0 or
repr = "(member userId *)" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (parameter 1 (return (member put *)))))" and t = "src" and result = 1.0 or
repr = "(member id (member params (parameter request *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter 0 (parameter 1 (return (member put *)))))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (member president *))" and t = "src" and result = 1.0 or
repr = "(member _id (parameter 0 (return (member findById *))))" and t = "src" and result = 1.0 or
repr = "(member _id (parameter 0 (return (member remove *))))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member getRecordByZonePromise *)))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member parseInt (global))))" and t = "src" and result = 0.6223434343434342 or
repr = "(member algorithm *)" and t = "src" and result = 1.0 or
repr = "(member range (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member value *)" and t = "src" and result = 0.5354545454545454 or
repr = "(member limit (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member port (member query *))" and t = "src" and result = 1.0 or
repr = "(member source *)" and t = "src" and result = 1.0 or
repr = "(member zone (member params (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member dnsType (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member zone *)" and t = "src" and result = 1.0 or
repr = "(member algorithm (member params (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter 0 (parameter 0 (return (member patch *)))))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member inRange (root https://www.npmjs.com/package/range_check))))" and t = "src" and result = 1.0 or
repr = "(member ip (member query *))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member addNetworkClass *)))" and t = "src" and result = 1.0 or
repr = "(member limit (member query *))" and t = "src" and result = 1.0 or
repr = "(member p443.https.tls.certificate.parsed.subject.common_name *)" and t = "src" and result = 0.5537190082644624 or
repr = "(parameter 0 (return (member contains *)))" and t = "src" and result = 1.0 or
repr = "(parameter org *)" and t = "src" and result = 0.5 or
repr = "(member domain (member query *))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member contains (return (root https://www.npmjs.com/package/cidr-matcher)))))" and t = "src" and result = 1.0 or
repr = "(member ip *)" and t = "src" and result = 1.0 or
repr = "(member source (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member source (member query *))" and t = "src" and result = 1.0 or
repr = "(member range (member query *))" and t = "src" and result = 1.0 or
repr = "(member page (member query *))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member inRange *)))" and t = "src" and result = 1.0 or
repr = "(parameter zone *)" and t = "src" and result = 0.27272727272727254 or
repr = "(parameter 0 (return (member getRecordByIPPromise *)))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member addNetworkClass (instance (root https://www.npmjs.com/package/cidr-matcher)))))" and t = "src" and result = 1.0 or
repr = "(parameter 1 (return (member inRange *)))" and t = "src" and result = 1.0 or
repr = "(member port (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (parameter 0 (return (member post *)))))" and t = "src" and result = 1.0 or
repr = "(member range *)" and t = "src" and result = 1.0 or
repr = "(parameter 1 (return (member inRange (root https://www.npmjs.com/package/range_check))))" and t = "src" and result = 1.0 or
repr = "(member dnsType (member query *))" and t = "src" and result = 1.0 or
repr = "(member domain *)" and t = "src" and result = 1.0 or
repr = "(member algorithm (member params *))" and t = "src" and result = 1.0 or
repr = "(member zone (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member value (member query *))" and t = "src" and result = 1.0 or
repr = "(member page *)" and t = "src" and result = 1.0 or
repr = "(member dnsType *)" and t = "src" and result = 1.0 or
repr = "(member body (parameter 0 (parameter 0 (return (member post *)))))" and t = "src" and result = 1.0 or
repr = "(member limit *)" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (parameter 0 (return (member patch *)))))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member addNetworkClass (return (root https://www.npmjs.com/package/cidr-matcher)))))" and t = "src" and result = 1.0 or
repr = "(member zone (member params *))" and t = "src" and result = 1.0 or
repr = "(member page (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member ip (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member getZoneByNamePromise *)))" and t = "src" and result = 1.0 or
repr = "(member port *)" and t = "src" and result = 1.0 or
repr = "(member value (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member zone (member query *))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member contains (instance (root https://www.npmjs.com/package/cidr-matcher)))))" and t = "src" and result = 1.0 or
repr = "(member domain (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (parameter 2 (return (member put *)))))" and t = "src" and result = 1.0 or
repr = "(member body (parameter 0 (parameter 2 (return (member put *)))))" and t = "src" and result = 1.0 or
repr = "(member field *)" and t = "src" and result = 0.05722891566265063 or
repr = "(parameter 0 (parameter 1 (return (member addEventListener *))))" and t = "src" and result = 1.0 or
repr = "(member host *)" and t = "src" and result = 1.0 or
repr = "(member host (member headers *))" and t = "src" and result = 0.625 or
repr = "(parameter event (parameter 1 (return (member addEventListener (global)))))" and t = "src" and result = 1.0 or
repr = "(parameter ctor *)" and t = "src" and result = 0.0231180555555556 or
repr = "(parameter str *)" and t = "src" and result = 0.048535152250221966 or
repr = "(member afterSpacers_ *)" and t = "src" and result = 0.07574494949494952 or
repr = "(parameter win *)" and t = "src" and result = 0.15097499999999986 or
repr = "(parameter e *)" and t = "src" and result = 0.568343689683931 or
repr = "(return (parameter 0 (return (member map *))))" and t = "src" and result = 0.16034592917123033 or
repr = "(parameter t *)" and t = "src" and result = 0.4842794999741455 or
repr = "(return (member String (global)))" and t = "src" and result = 0.27597499999999997 or
repr = "(parameter 0 (parameter 0 (return (member map *))))" and t = "src" and result = 0.3557162534435261 or
repr = "(return (member listen *))" and t = "src" and result = 0.15097499999999986 or
repr = "(return (member split *))" and t = "src" and result = 0.0712646734401212 or
repr = "(member video_ *)" and t = "src" and result = 0.04690230416107636 or
repr = "(return (member dict *))" and t = "src" and result = 0.11223068181818213 or
repr = "(return (member maybeToEsmName *))" and t = "src" and result = 0.07048872180451128 or
repr = "(member host (member headers (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member parseJson *)))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (parameter 1 (return (member addEventListener (global)))))" and t = "src" and result = 1.0 or
repr = "(parameter data *)" and t = "src" and result = 0.40817113571802693 or
repr = "(member win *)" and t = "src" and result = 0.14531684918630738 or
repr = "(parameter node *)" and t = "src" and result = 0.17343750000000002 or
repr = "(parameter 1 (return (member setHeader (parameter res *))))" and t = "src" and result = 1.0 or
repr = "(return (member replace *))" and t = "src" and result = 0.12338716232418867 or
repr = "(member href *)" and t = "src" and result = 0.02573512906846248 or
repr = "(member element *)" and t = "src" and result = 0.13681329973805542 or
repr = "(parameter 0 (return (member push *)))" and t = "src" and result = 0.1344111882483374 or
repr = "(return (member get *))" and t = "src" and result = 0.3416641373967977 or
repr = "(parameter event (parameter 1 (return (member addEventListener *))))" and t = "src" and result = 1.0 or
repr = "(return (member cloneNode *))" and t = "src" and result = 0.01646249999999995 or
repr = "(parameter event *)" and t = "src" and result = 1.0 or
repr = "(return (member duplicate *))" and t = "src" and result = 0.17168674698795194 or
repr = "(return (member getStdout *))" and t = "src" and result = 0.0625 or
repr = "(parameter 1 (return (member setHeader *)))" and t = "src" and result = 1.0 or
repr = "(return (member filter *))" and t = "src" and result = 0.15097499999999997 or
repr = "(parameter input *)" and t = "src" and result = 0.07156640669678033 or
repr = "(return (parameter t *))" and t = "src" and result = 0.25 or
repr = "(parameter 0 (return (member assertElement (return (member dev *)))))" and t = "src" and result = 0.012898301193755533 or
repr = "(return (member slice *))" and t = "src" and result = 0.11142238000910525 or
repr = "(parameter url *)" and t = "src" and result = 0.14608553946425432 or
repr = "(parameter variant *)" and t = "src" and result = 0.0231180555555556 or
repr = "(parameter props *)" and t = "src" and result = 0.18235833333333346 or
repr = "(parameter global *)" and t = "src" and result = 0.04400000000000004 or
repr = "(member titulo *)" and t = "src" and result = 1.0 or
repr = "(member autor (member query *))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member findById (return (member model *)))))" and t = "src" and result = 1.0 or
repr = "(member sort (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member sort *)" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member equals *)))" and t = "src" and result = 1.0 or
repr = "(member titulo (member query *))" and t = "src" and result = 1.0 or
repr = "(member autor *)" and t = "src" and result = 1.0 or
repr = "(member titulo (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member equals (return (member where *)))))" and t = "src" and result = 1.0 or
repr = "(member usuarioId (member params *))" and t = "src" and result = 1.0 or
repr = "(member usuarioId (member params (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member usuarioId *)" and t = "src" and result = 1.0 or
repr = "(member sort (member query *))" and t = "src" and result = 1.0 or
repr = "(member autor (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter 0 (parameter 1 (return (member delete *)))))" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (parameter 1 (return (member delete *)))))" and t = "src" and result = 1.0 or
repr = "(member userID (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member userID (member query *))" and t = "src" and result = 1.0 or
repr = "(member userID *)" and t = "src" and result = 1.0 or
repr = "(parameter 1 (return (member findOneAndUpdate *)))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (return (member model (root https://www.npmjs.com/package/mongoose)))))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member ObjectId (member Types *))))" and t = "src" and result = 1.0 or
repr = "(parameter 2 (return (parameter 0 (return (member run *)))))" and t = "src" and result = 1.0 or
repr = "(member fromB *)" and t = "src" and result = 0.6060606060606061 or
repr = "(parameter 0 (instance (return (member model (root https://www.npmjs.com/package/mongoose)))))" and t = "src" and result = 1.0 or
repr = "(member id (member query *))" and t = "src" and result = 1.0 or
repr = "(parameter 1 (return (member warn *)))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (instance (return (member model *))))" and t = "src" and result = 1.0 or
repr = "(member jugend (return (return (member model (root https://www.npmjs.com/package/mongoose)))))" and t = "src" and result = 1.0 or
repr = "(member jugend *)" and t = "src" and result = 1.0 or
repr = "(parameter spiel *)" and t = "src" and result = 0.2 or
repr = "(parameter 2 (return (member removeEntityBy *)))" and t = "src" and result = 1.0 or
repr = "(member jugend (instance (return (member model *))))" and t = "src" and result = 1.0 or
repr = "(member fromA *)" and t = "src" and result = 0.15151515151515138 or
repr = "(parameter 0 (member _id *))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (member _id (parameter 0 (return (member findOne *)))))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member ObjectId *)))" and t = "src" and result = 1.0 or
repr = "(member jugend (member query *))" and t = "src" and result = 1.0 or
repr = "(member id (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member spielplanEnabled *)" and t = "src" and result = 0.1966903817714963 or
repr = "(parameter 0 (return (return (member model *))))" and t = "src" and result = 1.0 or
repr = "(member jugend (return (return (member model *))))" and t = "src" and result = 1.0 or
repr = "(parameter 1 (return (member findOneAndUpdate (return (member model *)))))" and t = "src" and result = 1.0 or
repr = "(member jugend (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member ObjectId (member Types (root https://www.npmjs.com/package/mongoose)))))" and t = "src" and result = 1.0 or
repr = "(parameter 1 (return (member calcSpielDateTime *)))" and t = "src" and result = 1.0 or
repr = "(parameter 1 (return (member warn (return (member get *)))))" and t = "src" and result = 1.0 or
repr = "(member jugend (instance (return (member model (root https://www.npmjs.com/package/mongoose)))))" and t = "src" and result = 1.0 or
repr = "(member _id (parameter 0 (return (member findOne *))))" and t = "src" and result = 1.0 or
repr = "(member noop (parameter $ *))" and t = "src" and result = 0.4310344827586206 or
repr = "(parameter selector *)" and t = "src" and result = 0.07275849273506473 or
repr = "(return (member getElement *))" and t = "src" and result = 0.06910228776324058 or
repr = "(return (member exec *))" and t = "src" and result = 0.02068367255157379 or
repr = "(parameter $ *)" and t = "src" and result = 0.15445402298850575 or
repr = "(parameter opts *)" and t = "src" and result = 0.07588976596039326 or
repr = "(member url (parameter 0 (return (member ajax *))))" and t = "src" and result = 0.5050505050505051 or
repr = "(return (member indexOf *))" and t = "src" and result = 0.17771002062180016 or
repr = "(member body (parameter 0 (parameter 2 (return (member delete *)))))" and t = "src" and result = 1.0 or
repr = "(member username *)" and t = "src" and result = 0.5625 or
repr = "(member body (parameter req (parameter 2 (return (member delete *)))))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (parameter 1 (return (member on *))))" and t = "src" and result = 1.0 or
repr = "(member url (parameter 0 (return (member ajax (member jQuery *)))))" and t = "src" and result = 1.0 or
repr = "(member statusCode *)" and t = "src" and result = 0.3573619277108434 or
repr = "(return (member readFileSync (root https://www.npmjs.com/package/fs)))" and t = "src" and result = 0.12099518072289173 or
repr = "(member email *)" and t = "src" and result = 0.7316666666666668 or
repr = "(parameter error (parameter 1 (return (member on *))))" and t = "src" and result = 1.0 or
repr = "(member question *)" and t = "src" and result = 1.0 or
repr = "(member email (parameter 0 (return (member findOne *))))" and t = "src" and result = 1.0 or
repr = "(member props *)" and t = "src" and result = 0.03947635555776882 or
repr = "(parameter err (parameter 1 (return (member on *))))" and t = "src" and result = 1.0 or
repr = "(parameter res (parameter 1 (return (member on *))))" and t = "src" and result = 1.0 or
repr = "(parameter parent *)" and t = "src" and result = 0.05284638554216886 or
repr = "(parameter err *)" and t = "src" and result = 1.0 or
repr = "(parameter buf (parameter 0 (return (root https://www.npmjs.com/package/through2))))" and t = "src" and result = 0.09422014218382613 or
repr = "(parameter 0 (return (member variableDeclarator *)))" and t = "src" and result = 0.17591740294511396 or
repr = "(parameter 1 (return (member slice *)))" and t = "src" and result = 0.3266809697473658 or
repr = "(member uid *)" and t = "src" and result = 0.005694727628462629 or
repr = "(return (member flatten *))" and t = "src" and result = 0.25 or
repr = "(member content-type *)" and t = "src" and result = 1.0 or
repr = "(member ids *)" and t = "src" and result = 0.9049230254350736 or
repr = "(member name (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(parameter code *)" and t = "src" and result = 0.01277911646586336 or
repr = "(member contentType *)" and t = "src" and result = 1.0 or
repr = "(parameter namespace *)" and t = "src" and result = 0.24356425702811257 or
repr = "(member content-type (member headers *))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member flatten *)))" and t = "src" and result = 0.09507697456492636 or
repr = "(return (member apply *))" and t = "src" and result = 0.10395973269644865 or
repr = "(root https://www.npmjs.com/package/path)" and t = "src" and result = 0.002438567187681942 or
repr = "(parameter 1 (return (member slice (member url *))))" and t = "src" and result = 0.7227099480554693 or
repr = "(parameter path *)" and t = "src" and result = 0.045860152250222025 or
repr = "(member email (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member name (parameter 0 (return (member findOne *))))" and t = "src" and result = 1.0 or
repr = "(member content-type (member headers (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member length *)" and t = "src" and result = 0.1135763052208833 or
repr = "(parameter res *)" and t = "src" and result = 1.0 or
repr = "(member url (parameter 0 (return (member ajax (member $ *)))))" and t = "src" and result = 0.42755783132530084 or
repr = "(return (member indexOf (member url *)))" and t = "src" and result = 0.8213023581907437 or
repr = "(member argumentsId *)" and t = "src" and result = 0.4202874163319945 or
repr = "(member name (member query *))" and t = "src" and result = 1.0 or
repr = "(member 0 (return (member filter *)))" and t = "src" and result = 0.06294840270171609 or
repr = "(member email (member query *))" and t = "src" and result = 1.0 or
repr = "(return (member describe *))" and t = "src" and result = 0.0810910759450012 or
repr = "(parameter error *)" and t = "src" and result = 1.0 or
repr = "(parameter string *)" and t = "src" and result = 0.07869522453937894 or
repr = "(parameter file *)" and t = "src" and result = 0.0077904869286303975 or
repr = "(parameter cmd *)" and t = "src" and result = 0.18431708652792989 or
repr = "(parameter 0 (parameter 2 (return (member get *))))" and t = "src" and result = 1.0 or
repr = "(member picture *)" and t = "src" and result = 1.0 or
repr = "(parameter 0 (member picture_id (parameter 0 (return (member find *)))))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (member _id (parameter 0 (return (member remove *)))))" and t = "src" and result = 1.0 or
repr = "(member query (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member user_id *)" and t = "src" and result = 1.0 or
repr = "(return (member trim *))" and t = "src" and result = 0.14647333489583692 or
repr = "(parameter req (parameter 2 (return (member get *))))" and t = "src" and result = 0.5151515151515149 or
repr = "(parameter 0 (member picture_id *))" and t = "src" and result = 1.0 or
repr = "(member search (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member picture_id (member query *))" and t = "src" and result = 1.0 or
repr = "(parameter r *)" and t = "src" and result = 0.125 or
repr = "(member picture (member params (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member picture_id (parameter 0 (return (member insert *))))" and t = "src" and result = 1.0 or
repr = "(parameter n *)" and t = "src" and result = 1.0 or
repr = "(member search *)" and t = "src" and result = 1.0 or
repr = "(return (parameter r *))" and t = "src" and result = 0.12878787878787878 or
repr = "(member query *)" and t = "src" and result = 0.5416666666666666 or
repr = "(member tight *)" and t = "src" and result = 0.3856480254630295 or
repr = "(member query (member query *))" and t = "src" and result = 1.0 or
repr = "(member picture_id *)" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member stringify (member JSON (global)))))" and t = "src" and result = 1.0 or
repr = "(member picture_id (member params *))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member stringify *)))" and t = "src" and result = 1.0 or
repr = "(member picture (member params *))" and t = "src" and result = 1.0 or
repr = "(member nextSibling *)" and t = "src" and result = 0.25 or
repr = "(member scheme *)" and t = "src" and result = 0.29184549356223144 or
repr = "(parameter 0 (return (member Number (global))))" and t = "src" and result = 1.0 or
repr = "(member picture_id (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member picture_id (member params (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (member _id (parameter 0 (return (member findOneAndUpdate *)))))" and t = "src" and result = 1.0 or
repr = "(member search (member query *))" and t = "src" and result = 1.0 or
repr = "(member body (member req *))" and t = "src" and result = 1.0 or
repr = "(member if-match *)" and t = "src" and result = 1.0 or
repr = "(member body (parameter 0 (parameter 5 (return (member put *)))))" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (parameter 4 (return (member post *)))))" and t = "src" and result = 1.0 or
repr = "(member originalUrl *)" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member parse (member JSON (global)))))" and t = "src" and result = 1.0 or
repr = "(parameter 1 (return (member getFile *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter 0 (parameter 4 (return (member post *)))))" and t = "src" and result = 1.0 or
repr = "(return (parameter 0 (return (member then *))))" and t = "src" and result = 0.022949464989026374 or
repr = "(parameter 1 (return (member assign *)))" and t = "src" and result = 1.0 or
repr = "(member GitRepoDir *)" and t = "src" and result = 0.05499999999999999 or
repr = "(member Target (member query *))" and t = "src" and result = 1.0 or
repr = "(member filter (member query *))" and t = "src" and result = 1.0 or
repr = "(member Target (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(return (member pop *))" and t = "src" and result = 0.1299999999999999 or
repr = "(return (member get (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(parameter evnt *)" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (parameter 5 (return (member put *)))))" and t = "src" and result = 1.0 or
repr = "(return (member parseInt (global)))" and t = "src" and result = 0.177102744786846 or
repr = "(parameter 1 (return (member assign (member Object (global)))))" and t = "src" and result = 1.0 or
repr = "(return (member toURLPath *))" and t = "src" and result = 0.024500000000000022 or
repr = "(member current_line *)" and t = "src" and result = 0.0037233999999999635 or
repr = "(parameter 0 (parameter 0 (return (member then *))))" and t = "src" and result = 0.030202444014245693 or
repr = "(member branchName (member params *))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member parse (root https://www.npmjs.com/package/url))))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member parse *)))" and t = "src" and result = 1.0 or
repr = "(return (member shorthand *))" and t = "src" and result = 0.09461727210414725 or
repr = "(parameter projects *)" and t = "src" and result = 0.22774999999999995 or
repr = "(member 0 (member params (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member if-match (member headers (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(parameter filePath *)" and t = "src" and result = 0.24000000000000005 or
repr = "(member originalUrl (parameter req *))" and t = "src" and result = 1.0 or
repr = "(member filter *)" and t = "src" and result = 1.0 or
repr = "(parameter req *)" and t = "src" and result = 0.31693224319244134 or
repr = "(member branchName (member params (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member Target *)" and t = "src" and result = 1.0 or
repr = "(member 0 (member params *))" and t = "src" and result = 1.0 or
repr = "(member filter (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member branchName *)" and t = "src" and result = 1.0 or
repr = "(member if-match (member headers *))" and t = "src" and result = 1.0 or
repr = "(return (member getCaret *))" and t = "src" and result = 0.132 or
repr = "(parameter 0 (return (member decodeURIComponent *)))" and t = "src" and result = 1.0 or
repr = "(parameter req (parameter 1 (return (member get *))))" and t = "src" and result = 0.26515151515151486 or
repr = "(parameter 0 (return (member indexOf *)))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member indexOf (member boards *))))" and t = "src" and result = 1.0 or
repr = "(member chat (parameter data *))" and t = "src" and result = 1.0 or
repr = "(parameter 1 (parameter 0 (return (member exec *))))" and t = "src" and result = 0.4518939393939395 or
repr = "(member count *)" and t = "src" and result = 0.5227272727272727 or
repr = "(parameter e (parameter 1 (return (member on *))))" and t = "src" and result = 1.0 or
repr = "(member chat *)" and t = "src" and result = 1.0 or
repr = "(parameter 0 (parameter 1 (return (member get *))))" and t = "src" and result = 1.0 or
repr = "(member sku (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member currency (member session *))" and t = "src" and result = 1.0 or
repr = "(member vacation (member params (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member sku (parameter 1 (return (member render *))))" and t = "src" and result = 1.0 or
repr = "(member slug *)" and t = "src" and result = 1.0 or
repr = "(member authRedirect (member session (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member currency (member session (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member currency *)" and t = "src" and result = 1.0 or
repr = "(member sku *)" and t = "src" and result = 1.0 or
repr = "(member vacation *)" and t = "src" and result = 1.0 or
repr = "(member sku (parameter 0 (return (member findOne *))))" and t = "src" and result = 1.0 or
repr = "(member sku (member query *))" and t = "src" and result = 1.0 or
repr = "(member sku (parameter 1 (return (member render (parameter res *)))))" and t = "src" and result = 1.0 or
repr = "(member slug (parameter 0 (return (member findOne *))))" and t = "src" and result = 1.0 or
repr = "(member authRedirect *)" and t = "src" and result = 1.0 or
repr = "(member vacation (member params *))" and t = "src" and result = 1.0 or
repr = "(member authRedirect (member session *))" and t = "src" and result = 1.0 or
repr = "(member currency (member params (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member redirect (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member redirect (member query *))" and t = "src" and result = 1.0 or
repr = "(member redirect *)" and t = "src" and result = 1.0 or
repr = "(member currency (member params *))" and t = "src" and result = 1.0 or
repr = "(return (member param (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(return (member param (parameter 0 (member list *))))" and t = "src" and result = 1.0 or
repr = "(parameter x (parameter 0 (member $in (member _id *))))" and t = "src" and result = 1.0 or
repr = "(return (member param *))" and t = "src" and result = 1.0 or
repr = "(parameter playlists *)" and t = "src" and result = 0.2849173553719006 or
repr = "(parameter 0 (parameter 0 (return (member use *))))" and t = "src" and result = 0.16666666666666669 or
repr = "(return (member param (parameter req (member view *))))" and t = "src" and result = 1.0 or
repr = "(return (member param (parameter req (member create *))))" and t = "src" and result = 1.0 or
repr = "(member 0 (return (member split *)))" and t = "src" and result = 0.028787878787878862 or
repr = "(parameter collected (parameter 1 (return (member aggregate *))))" and t = "src" and result = 0.29843893480257117 or
repr = "(member slugs *)" and t = "src" and result = 1.0 or
repr = "(member headers *)" and t = "src" and result = 0.25000000000000006 or
repr = "(member _id (parameter x *))" and t = "src" and result = 0.13636363636363616 or
repr = "(return (member param (parameter 0 (member edit *))))" and t = "src" and result = 1.0 or
repr = "(return (member param (parameter 0 (member create *))))" and t = "src" and result = 1.0 or
repr = "(member name (parameter 1 (parameter 0 (return (member exec *)))))" and t = "src" and result = 1.0 or
repr = "(member name (parameter artist (parameter 0 (return (member exec *)))))" and t = "src" and result = 1.0 or
repr = "(member name (parameter artist *))" and t = "src" and result = 1.0 or
repr = "(parameter x *)" and t = "src" and result = 0.3650137741046836 or
repr = "(return (member param (parameter req (member list *))))" and t = "src" and result = 1.0 or
repr = "(return (member param (parameter req (member edit *))))" and t = "src" and result = 1.0 or
repr = "(member room *)" and t = "src" and result = 0.2212121212121212 or
repr = "(member app *)" and t = "src" and result = 0.22121212121212117 or
repr = "(parameter 1 (parameter 1 (return (member get *))))" and t = "src" and result = 0.49000000000000005 or
repr = "(return (member param (parameter 0 (member view *))))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (parameter 0 (member $in (member _id *))))" and t = "src" and result = 0.868358913813459 or
repr = "(member body (parameter 0 (member handleNewPost *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter 0 (member handleNewComment *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (member handleLoginRequest *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (member handleNewComment *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter 0 (member handleSignup *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (member handleNewPost *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter 0 (member handleLoginRequest *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (member handleSignup *)))" and t = "src" and result = 1.0 or
repr = "(parameter options *)" and t = "src" and result = 0.1774343838758789 or
repr = "(parameter match *)" and t = "src" and result = 0.033333333333333284 or
repr = "(member body (parameter 0 (parameter 2 (return (member use *)))))" and t = "src" and result = 1.0 or
repr = "(member noop *)" and t = "src" and result = 0.16666666666666669 or
repr = "(member fn (parameter $ *))" and t = "src" and result = 0.33333333333333337 or
repr = "(member body (parameter request (parameter 2 (return (member use *)))))" and t = "src" and result = 1.0 or
repr = "(return (member concat *))" and t = "src" and result = 0.08004105000202134 or
repr = "(member 0 (return (member apply *)))" and t = "src" and result = 0.16666666666666666 or
repr = "(return (member indexOf (parameter url *)))" and t = "src" and result = 0.6122222222222222 or
repr = "(parameter div *)" and t = "src" and result = 0.25 or
repr = "(member body (parameter req (parameter 2 (return (member use *)))))" and t = "src" and result = 1.0 or
repr = "(member bu *)" and t = "src" and result = 1.0 or
repr = "(member vno (member query (parameter req (member getDataForExcel *))))" and t = "src" and result = 1.0 or
repr = "(member outlet *)" and t = "src" and result = 1.0 or
repr = "(member outlet (member query (parameter 0 (member getData *))))" and t = "src" and result = 1.0 or
repr = "(member outlet (member query (parameter req (member getDataHistoryForExcel *))))" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (member savecase4Version *)))" and t = "src" and result = 1.0 or
repr = "(member vno (member query (parameter 0 (member getData *))))" and t = "src" and result = 1.0 or
repr = "(member type (member query (parameter 0 (member getDataForExcel *))))" and t = "src" and result = 1.0 or
repr = "(member bu (member query (parameter 0 (member getDataHistory *))))" and t = "src" and result = 1.0 or
repr = "(member outlet (member query (parameter 0 (member getDataForExcel *))))" and t = "src" and result = 1.0 or
repr = "(member vno (member query (parameter req (member getDataHistoryForExcel *))))" and t = "src" and result = 1.0 or
repr = "(member period (member query (parameter req (member getData *))))" and t = "src" and result = 1.0 or
repr = "(member docs *)" and t = "src" and result = 0.08333333333333327 or
repr = "(member type (member query (parameter 0 (member getData *))))" and t = "src" and result = 1.0 or
repr = "(member period (member query (parameter req (member getDataHistory *))))" and t = "src" and result = 1.0 or
repr = "(member vno (member query (parameter req (member getData *))))" and t = "src" and result = 1.0 or
repr = "(member period (member query *))" and t = "src" and result = 1.0 or
repr = "(member loc (member query (parameter req (member getDataForExcel *))))" and t = "src" and result = 1.0 or
repr = "(member ?? *)" and t = "src" and result = 1.0 or
repr = "(member sku (member query (parameter req (member getDataForExcel *))))" and t = "src" and result = 1.0 or
repr = "(parameter _28 *)" and t = "src" and result = 0.04496402877697843 or
repr = "(member period (member query (parameter req (member getCalcResult *))))" and t = "src" and result = 1.0 or
repr = "(member period (member query (parameter 0 (member getGrid *))))" and t = "src" and result = 1.0 or
repr = "(member vno (member query (parameter req (member getDataHistory *))))" and t = "src" and result = 1.0 or
repr = "(member body (parameter 0 (member savecase4Version *)))" and t = "src" and result = 1.0 or
repr = "(member name (member query (parameter 0 (member getDataHistory *))))" and t = "src" and result = 1.0 or
repr = "(return (member eval (global)))" and t = "src" and result = 0.25000000000000006 or
repr = "(member outlet (member query (parameter req (member getDataHistory *))))" and t = "src" and result = 1.0 or
repr = "(member rules *)" and t = "src" and result = 0.044964028776978415 or
repr = "(parameter result *)" and t = "src" and result = 0.7575757575757576 or
repr = "(member bu (member query (parameter 0 (member getData *))))" and t = "src" and result = 1.0 or
repr = "(member loc *)" and t = "src" and result = 1.0 or
repr = "(member period (member query (parameter req (member getGrid *))))" and t = "src" and result = 1.0 or
repr = "(member vno (member query (parameter 0 (member getDataHistory *))))" and t = "src" and result = 1.0 or
repr = "(member body (parameter 0 (member saveNonKaVersion *)))" and t = "src" and result = 1.0 or
repr = "(member loc (member query (parameter 0 (member getDataHistory *))))" and t = "src" and result = 1.0 or
repr = "(member sku (member query (parameter 0 (member getData *))))" and t = "src" and result = 1.0 or
repr = "(member name (member query (parameter 0 (member getDataForExcel *))))" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (member checkVersion *)))" and t = "src" and result = 1.0 or
repr = "(member bu (member query (parameter req (member getData *))))" and t = "src" and result = 1.0 or
repr = "(member ?? (parameter 0 (return (member find *))))" and t = "src" and result = 1.0 or
repr = "(member period (member query (parameter 0 (member getDataHistory *))))" and t = "src" and result = 1.0 or
repr = "(member bu (member query *))" and t = "src" and result = 1.0 or
repr = "(member page (member query (parameter req (member getData *))))" and t = "src" and result = 1.0 or
repr = "(member name (member query (parameter 0 (member getDataHistoryForExcel *))))" and t = "src" and result = 1.0 or
repr = "(member loc (member query (parameter 0 (member getDataForExcel *))))" and t = "src" and result = 1.0 or
repr = "(member outlet (member query (parameter req (member getData *))))" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (member getCalcResult *)))" and t = "src" and result = 1.0 or
repr = "(member name (member query (parameter 0 (member getData *))))" and t = "src" and result = 1.0 or
repr = "(member period (member query (parameter 0 (member getData *))))" and t = "src" and result = 1.0 or
repr = "(member type *)" and t = "src" and result = 1.0 or
repr = "(member rows (member query *))" and t = "src" and result = 1.0 or
repr = "(member vno (member query (parameter 0 (member getGrid *))))" and t = "src" and result = 1.0 or
repr = "(member type (member query (parameter req (member getDataHistory *))))" and t = "src" and result = 1.0 or
repr = "(member period (member query (parameter req (member getDataForExcel *))))" and t = "src" and result = 1.0 or
repr = "(member type (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member outlet (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member loc (member query (parameter req (member getDataHistory *))))" and t = "src" and result = 1.0 or
repr = "(member bu (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member bu (member query (parameter 0 (member getDataForExcel *))))" and t = "src" and result = 1.0 or
repr = "(member period (member query (parameter 0 (member getDataHistoryForExcel *))))" and t = "src" and result = 1.0 or
repr = "(member period (member query (parameter 0 (member getDataForExcel *))))" and t = "src" and result = 1.0 or
repr = "(parameter docs *)" and t = "src" and result = 0.18796992481203006 or
repr = "(member sku (member query (parameter 0 (member getDataForExcel *))))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member eval (global))))" and t = "src" and result = 0.044964028776978415 or
repr = "(member vno (member query *))" and t = "src" and result = 1.0 or
repr = "(member message *)" and t = "src" and result = 0.044964028776978415 or
repr = "(member outlet (member query (parameter 0 (member getDataHistoryForExcel *))))" and t = "src" and result = 1.0 or
repr = "(member type (member query (parameter req (member getDataForExcel *))))" and t = "src" and result = 1.0 or
repr = "(member body (parameter 0 (member getCalcResult *)))" and t = "src" and result = 1.0 or
repr = "(member bu (member query (parameter req (member getDataForExcel *))))" and t = "src" and result = 1.0 or
repr = "(member loc (member query (parameter req (member getDataHistoryForExcel *))))" and t = "src" and result = 1.0 or
repr = "(member outlet (member query (parameter 0 (member getDataHistory *))))" and t = "src" and result = 1.0 or
repr = "(member sku (member query (parameter req (member getData *))))" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (member getDataForExcel *)))" and t = "src" and result = 1.0 or
repr = "(return (member getFullYear *))" and t = "src" and result = 0.7575757575757576 or
repr = "(member name (member query (parameter req (member getDataHistoryForExcel *))))" and t = "src" and result = 1.0 or
repr = "(member rows (member query (parameter 0 (member getData *))))" and t = "src" and result = 1.0 or
repr = "(member page (member query (parameter 0 (member getData *))))" and t = "src" and result = 1.0 or
repr = "(member outlet (member query *))" and t = "src" and result = 1.0 or
repr = "(member vno (member query (parameter req (member getGrid *))))" and t = "src" and result = 1.0 or
repr = "(member outlet (member query (parameter req (member getDataForExcel *))))" and t = "src" and result = 1.0 or
repr = "(member bu (member query (parameter req (member getDataHistory *))))" and t = "src" and result = 1.0 or
repr = "(member vno (member query (parameter 0 (member getDataForExcel *))))" and t = "src" and result = 1.0 or
repr = "(member loc (member query *))" and t = "src" and result = 1.0 or
repr = "(member period (member query (parameter 0 (member getCalcResult *))))" and t = "src" and result = 1.0 or
repr = "(member loc (member query (parameter 0 (member getDataHistoryForExcel *))))" and t = "src" and result = 1.0 or
repr = "(member type (member query *))" and t = "src" and result = 1.0 or
repr = "(member loc (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member loc (member query (parameter req (member getData *))))" and t = "src" and result = 1.0 or
repr = "(parameter _27 *)" and t = "src" and result = 0.044964028776978415 or
repr = "(member rows *)" and t = "src" and result = 1.0 or
repr = "(member body (parameter 0 (member getDataForExcel *)))" and t = "src" and result = 1.0 or
repr = "(parameter fields (parameter 1 (return (member paramNoDb *))))" and t = "src" and result = 0.42424242424242425 or
repr = "(member type (member query (parameter 0 (member getDataHistory *))))" and t = "src" and result = 1.0 or
repr = "(return (member getMonth (instance (member Date (global)))))" and t = "src" and result = 0.7575757575757576 or
repr = "(member name (member query (parameter req (member getDataHistory *))))" and t = "src" and result = 1.0 or
repr = "(member rows (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member rows (member query (parameter req (member getData *))))" and t = "src" and result = 1.0 or
repr = "(member period (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member name (member query (parameter req (member getData *))))" and t = "src" and result = 1.0 or
repr = "(member vno (member query (parameter 0 (member getDataHistoryForExcel *))))" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (member saveNonKaVersion *)))" and t = "src" and result = 1.0 or
repr = "(parameter fields *)" and t = "src" and result = 0.3333333333333333 or
repr = "(member period (member query (parameter req (member getDataHistoryForExcel *))))" and t = "src" and result = 1.0 or
repr = "(member type (member query (parameter req (member getData *))))" and t = "src" and result = 1.0 or
repr = "(member bu (member query (parameter 0 (member getDataHistoryForExcel *))))" and t = "src" and result = 1.0 or
repr = "(member body (parameter 0 (member checkVersion *)))" and t = "src" and result = 1.0 or
repr = "(member vno (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member vno *)" and t = "src" and result = 1.0 or
repr = "(member loc (member query (parameter 0 (member getData *))))" and t = "src" and result = 1.0 or
repr = "(parameter _20 *)" and t = "src" and result = 0.044964028776978415 or
repr = "(member period *)" and t = "src" and result = 1.0 or
repr = "(member name (member query (parameter req (member getDataForExcel *))))" and t = "src" and result = 1.0 or
repr = "(member bu (member query (parameter req (member getDataHistoryForExcel *))))" and t = "src" and result = 1.0 or
repr = "(member x-forwarded-for (member headers (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member x-forwarded-for *)" and t = "src" and result = 1.0 or
repr = "(member x-forwarded-for (member headers *))" and t = "src" and result = 1.0 or
repr = "(member url *)" and t = "src" and result = 1.0 or
repr = "(parameter buff *)" and t = "src" and result = 1.0 or
repr = "(member container *)" and t = "src" and result = 0.03487937223474408 or
repr = "(parameter sessionId *)" and t = "src" and result = 0.1875 or
repr = "(parameter files *)" and t = "src" and result = 0.125 or
repr = "(parameter 0 (return (member get (member options (member configuration *)))))" and t = "src" and result = 0.04166666666666661 or
repr = "(parameter e (parameter 1 (return (member addEventListener *))))" and t = "src" and result = 1.0 or
repr = "(parameter 1 (return (member createInstance *)))" and t = "src" and result = 0.1363636363636363 or
repr = "(parameter color *)" and t = "src" and result = 0.14759036144578314 or
repr = "(parameter e (parameter 1 (return (member addEventListener (global)))))" and t = "src" and result = 1.0 or
repr = "(parameter colorType *)" and t = "src" and result = 0.10499269806498707 or
repr = "(member url (parameter req *))" and t = "src" and result = 0.8787878787878788 or
repr = "(return (member match *))" and t = "src" and result = 0.08568753472469723 or
repr = "(parameter 7 (return (member createInstance *)))" and t = "src" and result = 0.05681818181818185 or
repr = "(parameter 1 (return (member setTimeout (global))))" and t = "src" and result = 0.0625 or
repr = "(return (member keys *))" and t = "src" and result = 0.125 or
repr = "(parameter container *)" and t = "src" and result = 0.33 or
repr = "(member innerHTML (return (member createElement (member document (global)))))" and t = "src" and result = 0.24242424242424246 or
repr = "(member EditorOption *)" and t = "src" and result = 0.1383333333333334 or
repr = "(member referer *)" and t = "src" and result = 1.0 or
repr = "(member X-Forwarded-For (member headers *))" and t = "src" and result = 1.0 or
repr = "(member referer (member headers (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member username (parameter 0 (return (member findOne (member Account *)))))" and t = "src" and result = 1.0 or
repr = "(member username (parameter 0 (return (member findOne *))))" and t = "src" and result = 1.0 or
repr = "(member username (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member REMOTE_ADDR *)" and t = "src" and result = 1.0 or
repr = "(member username (member query *))" and t = "src" and result = 1.0 or
repr = "(member referer (member headers *))" and t = "src" and result = 1.0 or
repr = "(member REMOTE_ADDR (member headers *))" and t = "src" and result = 1.0 or
repr = "(member X-Forwarded-For *)" and t = "src" and result = 1.0 or
repr = "(parameter a *)" and t = "src" and result = 0.75 or
repr = "(parameter specifier *)" and t = "src" and result = 0.25 or
repr = "(member category (member session *))" and t = "src" and result = 1.0 or
repr = "(member y *)" and t = "src" and result = 0.016284144654088076 or
repr = "(member slug (member params *))" and t = "src" and result = 1.0 or
repr = "(parameter id *)" and t = "src" and result = 0.24999999999999822 or
repr = "(member category *)" and t = "src" and result = 1.0 or
repr = "(member slug (member params (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member length (parameter a *))" and t = "src" and result = 0.2565530303030302 or
repr = "(member body (parameter 0 (parameter 1 (return (member get *)))))" and t = "src" and result = 1.0 or
repr = "(member x *)" and t = "src" and result = 0.01015671069182391 or
repr = "(return (member call *))" and t = "src" and result = 0.09206835200413509 or
repr = "(member category (member session (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (parameter 1 (return (member get *)))))" and t = "src" and result = 1.0 or
repr = "(member cookies (parameter req (parameter 1 (return (member get *)))))" and t = "src" and result = 1.0 or
repr = "(member cookies (parameter 0 (parameter 1 (return (member post *)))))" and t = "src" and result = 1.0 or
repr = "(member cookies (parameter req *))" and t = "src" and result = 1.0 or
repr = "(member cookies (parameter req (parameter 1 (return (member post *)))))" and t = "src" and result = 1.0 or
repr = "(member cookies (parameter 0 (parameter 1 (return (member get *)))))" and t = "src" and result = 1.0 or
repr = "(member cookies *)" and t = "src" and result = 1.0 or
repr = "(return (member find *))" and t = "src" and result = 0.03125 or
repr = "(member _id (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member _id (member query *))" and t = "src" and result = 1.0 or
repr = "(member count (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member _id (parameter 0 (return (member findOneAndUpdate *))))" and t = "src" and result = 1.0 or
repr = "(member count (member query *))" and t = "src" and result = 1.0 or
repr = "(return (member test *))" and t = "src" and result = 0.060290335017779875 or
repr = "(member _id (parameter 0 (return (member findOneAndRemove *))))" and t = "src" and result = 1.0 or
repr = "(member first *)" and t = "src" and result = 1.0 or
repr = "(member category (member params *))" and t = "src" and result = 1.0 or
repr = "(member iDisplayStart *)" and t = "src" and result = 1.0 or
repr = "(member password *)" and t = "src" and result = 0.37878787878787873 or
repr = "(member className *)" and t = "src" and result = 0.11465774826677083 or
repr = "(member height (return (member extend *)))" and t = "src" and result = 0.3012048192771084 or
repr = "(member product_id *)" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member each *)))" and t = "src" and result = 1.0 or
repr = "(member product_id (parameter 0 (return (member find *))))" and t = "src" and result = 1.0 or
repr = "(member first (member params *))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member each (root https://www.npmjs.com/package/lodash))))" and t = "src" and result = 1.0 or
repr = "(member firstTitle *)" and t = "src" and result = 1.0 or
repr = "(member product_id (parameter 0 (return (member find (member products *)))))" and t = "src" and result = 1.0 or
repr = "(member category (member params (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member first (member params (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member iDisplayStart (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member iDisplayStart (member query *))" and t = "src" and result = 1.0 or
repr = "(member firstTitle (member prev_category (parameter 1 (return (member render *)))))" and t = "src" and result = 1.0 or
repr = "(return (member getById (instance (member document *))))" and t = "src" and result = 0.25252525252525243 or
repr = "(member firstTitle (member prev_category *))" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (member getSwixDetails *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (member registerNode *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter 0 (member getSwixDetails *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (member tokenSwapRawTransaction *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter 0 (member payVpnUsage *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (member payVpnUsage *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter 0 (member registerNode *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter 0 (member tokenSwapRawTransaction *)))" and t = "src" and result = 1.0 or
repr = "(parameter token *)" and t = "src" and result = 0.3867673179396092 or
repr = "(return (member escapeRegex *))" and t = "src" and result = 0.2684119091492726 or
repr = "(member breakpoints *)" and t = "src" and result = 0.16685377978374968 or
repr = "(return (member _findActive *))" and t = "src" and result = 0.028403577598896876 or
repr = "(member segs *)" and t = "src" and result = 0.1358057654871439 or
repr = "(parameter 1 (return (member emit (return (member to *)))))" and t = "src" and result = 1.0 or
repr = "(member legend *)" and t = "src" and result = 0.06060606060606061 or
repr = "(parameter element *)" and t = "src" and result = 0.009096291511922205 or
repr = "(member options *)" and t = "src" and result = 0.164789779528847 or
repr = "(return (member toLowerCase *))" and t = "src" and result = 0.27808278163517947 or
repr = "(member el *)" and t = "src" and result = 0.052967593183353985 or
repr = "(parameter that *)" and t = "src" and result = 0.2581170805750619 or
repr = "(return (member querySelector *))" and t = "src" and result = 0.023691281919781274 or
repr = "(return (member getAttribute *))" and t = "src" and result = 0.17260874553503586 or
repr = "(parameter style *)" and t = "src" and result = 0.04225336425923027 or
repr = "(parameter 1 (return (member emit *)))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member exec *)))" and t = "src" and result = 0.2270865891558556 or
repr = "(parameter b *)" and t = "src" and result = 0.10879218472468932 or
repr = "(parameter c *)" and t = "src" and result = 0.21913854351687378 or
repr = "(parameter settings *)" and t = "src" and result = 0.09624532263582708 or
repr = "(member offset (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member offset *)" and t = "src" and result = 1.0 or
repr = "(member offset (member query *))" and t = "src" and result = 1.0 or
repr = "(return (member now (member Date (global))))" and t = "src" and result = 1.0 or
repr = "(member request_id (parameter 0 (return (member findOne *))))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member removeParticipantByRequestId *)))" and t = "src" and result = 1.0 or
repr = "(member $search *)" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (root https://www.npmjs.com/package/moment)))" and t = "src" and result = 1.0 or
repr = "(parameter 1 (return (member debug *)))" and t = "src" and result = 1.0 or
repr = "(member id_project *)" and t = "src" and result = 1.0 or
repr = "(member request_id (member params (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member request_id (parameter 0 (return (member findOneAndUpdate *))))" and t = "src" and result = 1.0 or
repr = "(member status (member query *))" and t = "src" and result = 1.0 or
repr = "(member recipient *)" and t = "src" and result = 1.0 or
repr = "(member pendinginvitationid (member params *))" and t = "src" and result = 1.0 or
repr = "(member resetpswrequestid (member params (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member body (member req (parameter 1 (return (member emit *)))))" and t = "src" and result = 1.0 or
repr = "(member pendinginvitationid (member params (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member token (parameter 0 (return (member json (parameter res *)))))" and t = "src" and result = 1.0 or
repr = "(member pendinginvitationid *)" and t = "src" and result = 1.0 or
repr = "(member status (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member body (parameter req (parameter 2 (return (member patch *)))))" and t = "src" and result = 1.0 or
repr = "(member status *)" and t = "src" and result = 1.0 or
repr = "(member start_date (member query *))" and t = "src" and result = 1.0 or
repr = "(return (member signup *))" and t = "src" and result = 0.02999999999999986 or
repr = "(member token (parameter 0 (return (member json *))))" and t = "src" and result = 1.0 or
repr = "(member recipient (parameter 0 (return (member find *))))" and t = "src" and result = 1.0 or
repr = "(member start_date *)" and t = "src" and result = 1.0 or
repr = "(member body (parameter 0 (parameter 2 (return (member patch *)))))" and t = "src" and result = 1.0 or
repr = "(member end_date (member query *))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member closeRequestByRequestId *)))" and t = "src" and result = 1.0 or
repr = "(member resetpswrequestid *)" and t = "src" and result = 1.0 or
repr = "(member id_project (parameter 0 (return (member find *))))" and t = "src" and result = 1.0 or
repr = "(member projectid (member params (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member request_id (member params *))" and t = "src" and result = 1.0 or
repr = "(member authorization (member headers *))" and t = "src" and result = 1.0 or
repr = "(member resetpswrequestid (member params *))" and t = "src" and result = 1.0 or
repr = "(member projectid (member params *))" and t = "src" and result = 1.0 or
repr = "(parameter 2 (return (member create *)))" and t = "src" and result = 1.0 or
repr = "(member authorization *)" and t = "src" and result = 1.0 or
repr = "(member $search (member $text *))" and t = "src" and result = 1.0 or
repr = "(member authorization (member headers (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member requestid (member params *))" and t = "src" and result = 1.0 or
repr = "(member direction *)" and t = "src" and result = 1.0 or
repr = "(parameter 0 (parameter 1 (return (member debug *))))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member sign (root https://www.npmjs.com/package/jsonwebtoken))))" and t = "src" and result = 1.0 or
repr = "(member authorization (member headers (member req *)))" and t = "src" and result = 1.0 or
repr = "(member end_date *)" and t = "src" and result = 1.0 or
repr = "(member requestid *)" and t = "src" and result = 1.0 or
repr = "(member end_date (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member sign *)))" and t = "src" and result = 1.0 or
repr = "(member request_id *)" and t = "src" and result = 1.0 or
repr = "(member direction (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (parameter 1 (return (member log *))))" and t = "src" and result = 1.0 or
repr = "(member token *)" and t = "src" and result = 1.0 or
repr = "(member full_text *)" and t = "src" and result = 1.0 or
repr = "(return (member now *))" and t = "src" and result = 0.04000000000000026 or
repr = "(member requestid (member params (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member direction (member query *))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member debug *)))" and t = "src" and result = 1.0 or
repr = "(member projectid *)" and t = "src" and result = 1.0 or
repr = "(member full_text (member query *))" and t = "src" and result = 1.0 or
repr = "(member start_date (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member full_text (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member activity (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(parameter data (parameter 1 (return (member on (parameter socket *)))))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (return (member String (global))))" and t = "src" and result = 1.0 or
repr = "(member activity *)" and t = "src" and result = 1.0 or
repr = "(member activity (return (member toObject (parameter kpi *))))" and t = "src" and result = 1.0 or
repr = "(member userId (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(parameter 1 (return (member merge *)))" and t = "src" and result = 1.0 or
repr = "(parameter 1 (return (member merge (root https://www.npmjs.com/package/lodash))))" and t = "src" and result = 1.0 or
repr = "(return (member search *))" and t = "src" and result = 1.0 or
repr = "(member userId (member query *))" and t = "src" and result = 1.0 or
repr = "(member activity (member query *))" and t = "src" and result = 1.0 or
repr = "(parameter data (parameter 1 (return (member on *))))" and t = "src" and result = 1.0 or
repr = "(member activity (return (member toObject *)))" and t = "src" and result = 1.0 or
repr = "(member list *)" and t = "src" and result = 1.0 or
repr = "(return (member search (parameter $location *)))" and t = "src" and result = 1.0 or
repr = "(parameter 0 (parameter 1 (return (member on (parameter socket *)))))" and t = "src" and result = 1.0 or
repr = "(member src (member query (parameter req *)))" and t = "src" and result = 1.0 or
repr = "(member src *)" and t = "src" and result = 1.0 or
repr = "(member src (member query *))" and t = "src" and result = 1.0 or
repr = "(parameter seed *)" and t = "src" and result = 0.051936098099513606 or
repr = "(member tools (member CKEDITOR (global)))" and t = "src" and result = 0.267652550963525 or
repr = "(parameter src *)" and t = "src" and result = 0.23912671712599798 or
repr = "(member body (parameter 0 (parameter 1 (return (member use *)))))" and t = "src" and result = 1.0 or
repr = "(return (member getParent *))" and t = "src" and result = 0.014696434541412038 or
repr = "(parameter 2 (parameter 1 (return (member replace *))))" and t = "src" and result = 0.09852117355471257 or
repr = "(return (member getOptions *))" and t = "src" and result = 0.10675136619145595 or
repr = "(member body (parameter req (parameter 1 (return (member use *)))))" and t = "src" and result = 1.0 or
repr = "(member max *)" and t = "src" and result = 0.15245131860003608 or
repr = "(parameter list *)" and t = "src" and result = 0.01844823494454545 or
repr = "(parameter opt *)" and t = "src" and result = 0.022423724518237487 or
repr = "(member fixDomain (member tools *))" and t = "src" and result = 0.10961734702496186 or
repr = "(parameter value *)" and t = "src" and result = 0.11363636363636404 or
repr = "(return (member longDateFormat *))" and t = "src" and result = 0.0246041598650924 or
repr = "(member prototype *)" and t = "src" and result = 0.014126734676246994 or
repr = "(parameter segs *)" and t = "src" and result = 0.040737751173458736 or
repr = "(member fixDomain (member tools (member CKEDITOR (global))))" and t = "src" and result = 1.0 or
repr = "(return (member attr *))" and t = "src" and result = 0.1254884071540807 or
repr = "(member classes *)" and t = "src" and result = 0.3122660352573666 or
repr = "(member fruitsForm *)" and t = "src" and result = 0.011363636363635965 or
repr = "(return (parameter $ *))" and t = "src" and result = 0.07872932583865541 or
repr = "(parameter 1 (parameter 0 (return (member each *))))" and t = "src" and result = 0.0006400880799152242 or
repr = "(parameter 1 (member removeAttr *))" and t = "src" and result = 0.1461667261535599 or
repr = "(parameter args *)" and t = "src" and result = 0.2992083197301848 or
repr = "(return (member extend *))" and t = "src" and result = 0.10375734058280077 or
repr = "(parameter val *)" and t = "src" and result = 0.2891899826361102 or
repr = "(member userAgent (member navigator (global)))" and t = "src" and result = 0.05144433618450009 or
repr = "(return (member absUrl *))" and t = "src" and result = 0.2499999999999999 or
repr = "(return (member substring (member text (instance (member constructor *)))))" and t = "src" and result = 0.5589663883965649 or
repr = "(member label *)" and t = "src" and result = 0.0364972676170881 or
repr = "(parameter 2 (return (member extend (parameter $ *))))" and t = "src" and result = 0.08773396474263336 or
repr = "(return (member getElementsByTagName *))" and t = "src" and result = 0.25 or
repr = "(member data *)" and t = "src" and result = 0.25 or
repr = "(parameter name *)" and t = "src" and result = 0.04926058677735623 or
repr = "(parameter axis *)" and t = "src" and result = 0.06691313774088126 or
repr = "(member slide *)" and t = "src" and result = 0.04999999999999999 or
repr = "(member end *)" and t = "src" and result = 0.0840525180439125 or
repr = "(member endContainer *)" and t = "src" and result = 0.026023232434383127 or
repr = "(parameter 0 (parameter 1 (return (member each *))))" and t = "src" and result = 0.12218217677358637
or
repr = "(parameter 1 (return (member put (parameter $http *))))" and t = "snk" and result = 0.25 or
repr = "(return (member call (member slice *)))" and t = "snk" and result = 0.5318917024674571 or
repr = "(member document *)" and t = "snk" and result = 0.19740972003618418 or
repr = "(parameter 0 (return (member splice *)))" and t = "snk" and result = 0.37426252319109465 or
repr = "(return (member put *))" and t = "snk" and result = 0.25 or
repr = "(return (parameter $templateRequest *))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member exec *)))" and t = "snk" and result = 0.18108127848483033 or
repr = "(return (member leave *))" and t = "snk" and result = 0.3333333333333333 or
repr = "(parameter 0 (return (member isArray (return (parameter __webpack_require__ *)))))" and t = "snk" and result = 0.5 or
repr = "(parameter 1 (return (member data *)))" and t = "snk" and result = 0.5779307282415631 or
repr = "(member 0 (return (member match *)))" and t = "snk" and result = 0.7575757575757576 or
repr = "(member location *)" and t = "snk" and result = 0.4416666666666666 or
repr = "(parameter 1 (return (member apply (parameter fn *))))" and t = "snk" and result = 0.5 or
repr = "(member url *)" and t = "snk" and result = 0.4393939393939394 or
repr = "(return (member substr *))" and t = "snk" and result = 0.49632352941176466 or
repr = "(return (member replace (member name *)))" and t = "snk" and result = 0.3385160427807477 or
repr = "(member savedGifs *)" and t = "snk" and result = 0.07499999999999996 or
repr = "(parameter 0 (return (member annotate (member $injector *))))" and t = "snk" and result = 0.7575757575757576 or
repr = "(member noop (member angular (member window (global))))" and t = "snk" and result = 0.3602941176470586 or
repr = "(return (member replace *))" and t = "snk" and result = 0.258596685656963 or
repr = "(parameter 0 (return (member push (member tokens *))))" and t = "snk" and result = 0.6203397711015737 or
repr = "(member gifs (member currentUser *))" and t = "snk" and result = 0.3037878787878788 or
repr = "(parameter 0 (return (member $watch (member $$scope *))))" and t = "snk" and result = 0.7575757575757576 or
repr = "(member console *)" and t = "snk" and result = 0.07999999999999996 or
repr = "(parameter 1 (return (member post (parameter $http *))))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member removeChild *)))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member push *)))" and t = "snk" and result = 0.3879054475229313 or
repr = "(parameter 0 (return (member find *)))" and t = "snk" and result = 1.0 or
repr = "(member instance *)" and t = "snk" and result = 0.4999999999999999 or
repr = "(parameter 0 (return (member find (member zgrab80Model *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member indexOf *)))" and t = "snk" and result = 0.2926402908183315 or
repr = "(member count (parameter 0 (return (member json *))))" and t = "snk" and result = 0.5454545454545452 or
repr = "(member length (member count (parameter 0 (return (member json *)))))" and t = "snk" and result = 0.6212121212121215 or
repr = "(parameter 0 (return (member find (member VirustotalModel *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member find (member zgrabPortModel *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member find (member DeadDnsModel *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member find (return (member model *)))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member find (member AllDnsModel *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member find (member CertTransModel *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member find (member IPAddrModel *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member find (member censysModel *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member find (member zgrab2_80_model *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member find (member ipv6AddrModel *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member json (return (member status *)))))" and t = "snk" and result = 0.020000000000000018 or
repr = "(member length (member count *))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member find (member zgrab443Model *))))" and t = "snk" and result = 1.0 or
repr = "(member count *)" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member find (member zgrab2PortModel *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member json *)))" and t = "snk" and result = 0.75 or
repr = "(parameter 0 (return (member find (member WhoisModel *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member find (member RdnsModel *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member find (member zgrab2_443_model *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member isNaN (global))))" and t = "snk" and result = 0.25716090514919626 or
repr = "(parameter 0 (return (member find (member HostModel *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member make_get_request (global))))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member find (member AllIPsModel *))))" and t = "snk" and result = 1.0 or
repr = "(member length (parameter 0 (parameter 0 (return (member then *)))))" and t = "snk" and result = 1.0 or
repr = "(parameter 2 (return (member make_get_request (global))))" and t = "snk" and result = 0.25 or
repr = "(member indent *)" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member accept *)))" and t = "snk" and result = 0.29882165142215783 or
repr = "(parameter 0 (return (member findOne *)))" and t = "snk" and result = 0.2746805325000813 or
repr = "(member documentsPriv *)" and t = "snk" and result = 1.0 or
repr = "(return (member call *))" and t = "snk" and result = 0.45914362426542155 or
repr = "(member remove (return (member test *)))" and t = "snk" and result = 0.5590277777777778 or
repr = "(parameter 0 (return (member each *)))" and t = "snk" and result = 0.12499999999999994 or
repr = "(return (member fetchJson (return (member xhrFor (member Services *)))))" and t = "snk" and result = 0.5576515151515155 or
repr = "(parameter 0 (return (member isBlocked *)))" and t = "snk" and result = 0.12651383333333333 or
repr = "(parameter 0 (return (member child (return (parameter t *)))))" and t = "snk" and result = 0.2500000000000001 or
repr = "(parameter 0 (return (member dict *)))" and t = "snk" and result = 0.3924621212121213 or
repr = "(parameter 1 (return (member replace *)))" and t = "snk" and result = 0.31666666666666665 or
repr = "(parameter 0 (return (member postMessage *)))" and t = "snk" and result = 0.4375 or
repr = "(parameter 0 (return (member field *)))" and t = "snk" and result = 0.75 or
repr = "(parameter 0 (return (member redispatch *)))" and t = "snk" and result = 0.294 or
repr = "(member deps *)" and t = "snk" and result = 0.5 or
repr = "(parameter 2 (return (member createElement (member default *))))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member render *)))" and t = "snk" and result = 0.25714062500000007 or
repr = "(return (member idFilter *))" and t = "snk" and result = 0.125 or
repr = "(parameter 0 (return (parameter r *)))" and t = "snk" and result = 0.3712121212121212 or
repr = "(parameter 0 (return (member Date (global))))" and t = "snk" and result = 0.5075757575757575 or
repr = "(return (member array *))" and t = "snk" and result = 0.567375 or
repr = "(parameter 0 (parameter 1 (return (root https://www.npmjs.com/package/fancy-log))))" and t = "snk" and result = 0.11145833333333333 or
repr = "(parameter 5 (return (member call *)))" and t = "snk" and result = 0.3183060109289617 or
repr = "(parameter 1 (return (member Function (global))))" and t = "snk" and result = 0.75 or
repr = "(member params *)" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member contains *)))" and t = "snk" and result = 0.30376893939393934 or
repr = "(parameter 1 (return (member signal *)))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member hasAttribute (parameter element *))))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member appendChild *)))" and t = "snk" and result = 0.3123423511312055 or
repr = "(parameter 0 (return (member reportError *)))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (parameter n *)))" and t = "snk" and result = 0.017500000000000016 or
repr = "(return (member zeros *))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (parameter 2 (return (member createCustomEvent *))))" and t = "snk" and result = 0.4665778787878787 or
repr = "(return (member bind *))" and t = "snk" and result = 0.1205694399100616 or
repr = "(parameter 0 (return (member hasOwnProperty (member prototype *))))" and t = "snk" and result = 0.76655469122556 or
repr = "(parameter 1 (return (member hasOwn *)))" and t = "snk" and result = 0.25 or
repr = "(return (member map *))" and t = "snk" and result = 0.2327523557486305 or
repr = "(member fontSize *)" and t = "snk" and result = 0.25 or
repr = "(member accessor *)" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member isValid (return (parameter t *)))))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (parameter 1 (return (member sendMessage *))))" and t = "snk" and result = 0.10753787878787868 or
repr = "(member ds *)" and t = "snk" and result = 0.3787878787878788 or
repr = "(parameter 4 (return (member call *)))" and t = "snk" and result = 0.24625000000000002 or
repr = "(return (member concat *))" and t = "snk" and result = 0.24802777777777782 or
repr = "(return (member listen *))" and t = "snk" and result = 0.25 or
repr = "(parameter 2 (return (member createError *)))" and t = "snk" and result = 0.5 or
repr = "(parameter 1 (return (member fireEvent *)))" and t = "snk" and result = 0.125 or
repr = "(member info *)" and t = "snk" and result = 0.9076136363636363 or
repr = "(parameter 1 (return (member setAttribute (return (member child *)))))" and t = "snk" and result = 0.25000000000000006 or
repr = "(member max *)" and t = "snk" and result = 0.12400000000000005 or
repr = "(parameter 0 (return (member devAssert *)))" and t = "snk" and result = 0.125 or
repr = "(parameter 1 (return (member loadScript *)))" and t = "snk" and result = 0.29400000000000004 or
repr = "(parameter 0 (return (member scale *)))" and t = "snk" and result = 0.125 or
repr = "(parameter 0 (return (member indexOf (member value *))))" and t = "snk" and result = 0.5241871212121211 or
repr = "(parameter 0 (return (member data (member _graph *))))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member getParentWindowFrameElement *)))" and t = "snk" and result = 0.15 or
repr = "(parameter 0 (return (member appendChild (return (member getElementById *)))))" and t = "snk" and result = 0.5998791666666666 or
repr = "(parameter 0 (return (member decodeURIComponent (global))))" and t = "snk" and result = 0.40097499999999997 or
repr = "(parameter 0 (return (member encodeURIComponent (global))))" and t = "snk" and result = 0.24105965909090898 or
repr = "(parameter 0 (return (member matches *)))" and t = "snk" and result = 0.3137689393939392 or
repr = "(parameter 1 (return (parameter e *)))" and t = "snk" and result = 0.4375 or
repr = "(return (member assign (member Object (global))))" and t = "snk" and result = 0.22058823529411717 or
repr = "(parameter 0 (return (member String (global))))" and t = "snk" and result = 0.25099999999999995 or
repr = "(parameter 0 (return (member map (parameter t *))))" and t = "snk" and result = 0.995 or
repr = "(member signals *)" and t = "snk" and result = 0.5 or
repr = "(member pathname *)" and t = "snk" and result = 0.002514097744360886 or
repr = "(parameter 0 (return (member userAssert *)))" and t = "snk" and result = 0.25 or
repr = "(return (member Number (global)))" and t = "snk" and result = 0.04515999999999984 or
repr = "(parameter 0 (return (member insertBefore *)))" and t = "snk" and result = 0.5021590909090909 or
repr = "(member 0 (return (member exec *)))" and t = "snk" and result = 0.359725 or
repr = "(member win *)" and t = "snk" and result = 0.08190099607182927 or
repr = "(parameter 0 (return (member keys (member Object (global)))))" and t = "snk" and result = 0.5422626262626263 or
repr = "(member data *)" and t = "snk" and result = 0.5833333333333334 or
repr = "(member stream *)" and t = "snk" and result = 0.07836915631121513 or
repr = "(member push *)" and t = "snk" and result = 0.08584337349397594 or
repr = "(member allowedFor *)" and t = "snk" and result = 0.12599999999999995 or
repr = "(parameter 2 (return (member createElementWithAttributes *)))" and t = "snk" and result = 0.08333333333333331 or
repr = "(return (member field (return (parameter t *))))" and t = "snk" and result = 0.75 or
repr = "(parameter 0 (return (member hasOwn *)))" and t = "snk" and result = 0.25 or
repr = "(member m *)" and t = "snk" and result = 0.15502525252525245 or
repr = "(parameter 0 (return (member abs (member Math (global)))))" and t = "snk" and result = 0.13157894736842105 or
repr = "(member 0 (member items *))" and t = "snk" and result = 0.12500000000000006 or
repr = "(parameter 0 (return (member test *)))" and t = "snk" and result = 0.27948246059098714 or
repr = "(member _data *)" and t = "snk" and result = 0.11441116666666663 or
repr = "(member index *)" and t = "snk" and result = 0.3999999999999999 or
repr = "(parameter 0 (return (member dispatchEvent *)))" and t = "snk" and result = 0.26221131772268136 or
repr = "(parameter 0 (return (member value *)))" and t = "snk" and result = 0.75 or
repr = "(member m (parameter n *))" and t = "snk" and result = 0.3938285353535354 or
repr = "(parameter 0 (return (member getValueForExpr *)))" and t = "snk" and result = 0.375 or
repr = "(parameter 1 (return (member slice *)))" and t = "snk" and result = 0.25894313404609376 or
repr = "(parameter 0 (return (member fireEvent *)))" and t = "snk" and result = 0.125 or
repr = "(parameter 0 (return (return (member withStyles *))))" and t = "snk" and result = 0.08500000000000008 or
repr = "(member value *)" and t = "snk" and result = 0.34933333333333333 or
repr = "(parameter 1 (return (member apply *)))" and t = "snk" and result = 0.29043490811765643 or
repr = "(member element *)" and t = "snk" and result = 0.2500846396661113 or
repr = "(return (member replace (return (member join *))))" and t = "snk" and result = 0.4375 or
repr = "(parameter 0 (return (member rootNodeFor *)))" and t = "snk" and result = 0.15 or
repr = "(parameter 0 (return (member isEnabled *)))" and t = "snk" and result = 0.4037689393939393 or
repr = "(member iframeReady_ *)" and t = "snk" and result = 0.25 or
repr = "(return (member parseFloat (global)))" and t = "snk" and result = 0.12425 or
repr = "(member x (parameter e *))" and t = "snk" and result = 0.3787878787878788 or
repr = "(return (member get *))" and t = "snk" and result = 0.46473879050512934 or
repr = "(parameter 1 (return (return (parameter t *))))" and t = "snk" and result = 0.125 or
repr = "(parameter 0 (return (member fetchJson (return (member xhrFor *)))))" and t = "snk" and result = 0.6980500000000003 or
repr = "(parameter 0 (return (member parseInt (global))))" and t = "snk" and result = 0.30717187944914276 or
repr = "(parameter 1 (return (member render *)))" and t = "snk" and result = 0.7294315025252525 or
repr = "(parameter 0 (return (member get *)))" and t = "snk" and result = 0.3782065320849468 or
repr = "(parameter 0 (return (return (parameter _dereq_ *))))" and t = "snk" and result = 0.25 or
repr = "(return (member apply *))" and t = "snk" and result = 0.5170383527399512 or
repr = "(parameter 0 (return (member propagate *)))" and t = "snk" and result = 0.16415662650602403 or
repr = "(return (member replace (return (member replace *))))" and t = "snk" and result = 0.49994742033373357 or
repr = "(parameter 2 (return (member error (return (member user *)))))" and t = "snk" and result = 0.6075378787878787 or
repr = "(parameter 1 (return (parameter 0 (return (member filter *)))))" and t = "snk" and result = 0.25302766666666665 or
repr = "(parameter 0 (return (member isArray *)))" and t = "snk" and result = 0.125 or
repr = "(return (member toString *))" and t = "snk" and result = 0.43333333333333335 or
repr = "(parameter 1 (return (member debug *)))" and t = "snk" and result = 0.25 or
repr = "(parameter 1 (return (member dispatch (member storeService_ *))))" and t = "snk" and result = 0.23097500000000007 or
repr = "(parameter 0 (return (member idFilter *)))" and t = "snk" and result = 0.125 or
repr = "(parameter 2 (return (member triggerAnalyticsEvent *)))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member setTime *)))" and t = "snk" and result = 0.40047006476846625 or
repr = "(parameter 1 (return (member dispatchCustomEvent (member element *))))" and t = "snk" and result = 0.16000000000000003 or
repr = "(return (member join *))" and t = "snk" and result = 0.3580864228640199 or
repr = "(member start *)" and t = "snk" and result = 0.11145833333333333 or
repr = "(parameter 0 (return (member setState *)))" and t = "snk" and result = 0.3090128755364807 or
repr = "(member controller_ *)" and t = "snk" and result = 0.16666666666666669 or
repr = "(return (member exports (parameter module *)))" and t = "snk" and result = 0.08250000000000002 or
repr = "(parameter 0 (return (member addListener *)))" and t = "snk" and result = 0.375 or
repr = "(parameter 1 (return (member call *)))" and t = "snk" and result = 0.3558047650276733 or
repr = "(member style *)" and t = "snk" and result = 0.18750000000000003 or
repr = "(member end *)" and t = "snk" and result = 0.11145833333333333 or
repr = "(parameter 1 (return (member setStyles *)))" and t = "snk" and result = 0.25 or
repr = "(member publisher *)" and t = "snk" and result = 0.13928749999999998 or
repr = "(parameter 0 (return (member concat *)))" and t = "snk" and result = 0.24985816498316496 or
repr = "(member message *)" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member listen *)))" and t = "snk" and result = 0.41809900392817073 or
repr = "(parameter 0 (return (member openWindowDialog *)))" and t = "snk" and result = 0.25 or
repr = "(member w *)" and t = "snk" and result = 0.23994653030303037 or
repr = "(parameter 1 (return (member create *)))" and t = "snk" and result = 0.2995125 or
repr = "(member pathCache *)" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member apply (member push *))))" and t = "snk" and result = 0.3283132530120481 or
repr = "(member context *)" and t = "snk" and result = 0.08999999999999998 or
repr = "(parameter 2 (return (member createCustomEvent *)))" and t = "snk" and result = 0.027537878787878667 or
repr = "(member document_ *)" and t = "snk" and result = 0.16666666666666669 or
repr = "(parameter 0 (return (member expect (global))))" and t = "snk" and result = 0.01777777777777778 or
repr = "(parameter 3 (return (return (parameter t *))))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member assertElement (return (member dev *)))))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member report (parameter context *))))" and t = "snk" and result = 0.7770833333333333 or
repr = "(parameter 2 (return (member call *)))" and t = "snk" and result = 0.30927275347104294 or
repr = "(parameter 1 (return (member writeScript *)))" and t = "snk" and result = 0.07839678030303052 or
repr = "(member y (parameter e *))" and t = "snk" and result = 0.12878787878787876 or
repr = "(parameter 0 (return (member tryDecodeUriComponent *)))" and t = "snk" and result = 0.07900000000000007 or
repr = "(parameter 0 (return (member push (return (member slice *)))))" and t = "snk" and result = 0.34902500000000003 or
repr = "(return (member expr *))" and t = "snk" and result = 0.236 or
repr = "(parameter 0 (return (member includes *)))" and t = "snk" and result = 0.125 or
repr = "(parameter 1 (return (member createError *)))" and t = "snk" and result = 0.14999999999999997 or
repr = "(parameter 0 (return (return (member $ *))))" and t = "snk" and result = 0.0625 or
repr = "(parameter 1 (return (member debug (return (parameter t *)))))" and t = "snk" and result = 1.0 or
repr = "(member path *)" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member removeElement *)))" and t = "snk" and result = 0.16666666666666666 or
repr = "(return (member fetchJson *))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member clear (return (parameter t *)))))" and t = "snk" and result = 0.2500000000000001 or
repr = "(member nextHandlers *)" and t = "snk" and result = 0.16625 or
repr = "(parameter 0 (return (member getPrototypeOf (member Object (global)))))" and t = "snk" and result = 0.45749999999999996 or
repr = "(parameter 1 (return (member createElement (member default *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member set *)))" and t = "snk" and result = 0.11801078282828281 or
repr = "(member login *)" and t = "snk" and result = 0.125 or
repr = "(return (member post *))" and t = "snk" and result = 0.25757575757575757 or
repr = "(member temporaryToken *)" and t = "snk" and result = 0.125 or
repr = "(member token *)" and t = "snk" and result = 0.125 or
repr = "(parameter 1 (return (member put *)))" and t = "snk" and result = 0.32878787878787874 or
repr = "(return (member put (member http *)))" and t = "snk" and result = 0.25757575757575757 or
repr = "(member platz (return (member calcSpielDateTime *)))" and t = "snk" and result = 0.27322404371584696 or
repr = "(member date *)" and t = "snk" and result = 0.41397582381188947 or
repr = "(member x *)" and t = "snk" and result = 0.1 or
repr = "(member teams *)" and t = "snk" and result = 0.17669347184720305 or
repr = "(parameter 0 (return (member mapToIds *)))" and t = "snk" and result = 0.1785714285714286 or
repr = "(parameter 0 (return (member extend *)))" and t = "snk" and result = 0.49546861116515306 or
repr = "(member platz (parameter spiel *))" and t = "snk" and result = 0.8983275376718001 or
repr = "(member be (member to (return (member expect *))))" and t = "snk" and result = 0.7575757575757576 or
repr = "(member values (parameter t (parameter 0 (return (member forEach *)))))" and t = "snk" and result = 0.7142857142857142 or
repr = "(member spielplan *)" and t = "snk" and result = 0.19999999999999998 or
repr = "(parameter 0 (return (parameter 0 (return (member run *)))))" and t = "snk" and result = 0.02626057141430277 or
repr = "(member uhrzeit (parameter spiel *))" and t = "snk" and result = 0.03957608875641627 or
repr = "(member be (member to (return (member expect (root https://www.npmjs.com/package/chai)))))" and t = "snk" and result = 1.0 or
repr = "(member gruppen *)" and t = "snk" and result = 0.2 or
repr = "(parameter 0 (return (member get (return (root https://www.npmjs.com/package/supertest)))))" and t = "snk" and result = 0.9999999999999997 or
repr = "(return (member sortBy (member _ (global))))" and t = "snk" and result = 0.17669347184720313 or
repr = "(member nummer *)" and t = "snk" and result = 0.2732240437158471 or
repr = "(parameter 0 (return (member close *)))" and t = "snk" and result = 0.19999999999999998 or
repr = "(member y *)" and t = "snk" and result = 0.09999999999999998 or
repr = "(member veranstaltung *)" and t = "snk" and result = 0.19999999999999998 or
repr = "(return (member mapToIds *))" and t = "snk" and result = 0.17857142857142863 or
repr = "(member uhrzeit *)" and t = "snk" and result = 0.41397582381188947 or
repr = "(return (member get (return (root https://www.npmjs.com/package/supertest))))" and t = "snk" and result = 0.6490751410097862 or
repr = "(parameter 0 (return (member call *)))" and t = "snk" and result = 0.17780236133006877 or
repr = "(return (member create *))" and t = "snk" and result = 0.15000000000000002 or
repr = "(return (member then *))" and t = "snk" and result = 0.6435890207723652 or
repr = "(member username *)" and t = "snk" and result = 0.375 or
repr = "(parameter 0 (return (member json (parameter res *))))" and t = "snk" and result = 0.7015151515151515 or
repr = "(parameter 0 (return (member assign (member Object (global)))))" and t = "snk" and result = 0.21428571428571425 or
repr = "(parameter 0 (return (member get (member DOM *))))" and t = "snk" and result = 0.6753246753246753 or
repr = "(parameter 0 (return (member removeClass (member DOM *))))" and t = "snk" and result = 0.24242424242424254 or
repr = "(parameter 0 (return (member hasClass (member DOM *))))" and t = "snk" and result = 0.005050505050504972 or
repr = "(member 1 (return (member match *)))" and t = "snk" and result = 0.21103463587921845 or
repr = "(member 1 (return (member exec *)))" and t = "snk" and result = 0.19539380778674606 or
repr = "(parameter 2 (return (member setStyle (member DOM *))))" and t = "snk" and result = 0.2799999999999999 or
repr = "(parameter 0 (return (member add (member DOM *))))" and t = "snk" and result = 0.005050505050504972 or
repr = "(parameter 2 (return (member eve (parameter R *))))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member addClass (member DOM *))))" and t = "snk" and result = 0.24242424242424254 or
repr = "(parameter 0 (return (member setAttrib *)))" and t = "snk" and result = 0.002525252525252486 or
repr = "(parameter 0 (return (member unshift *)))" and t = "snk" and result = 0.1348917748917749 or
repr = "(member $http *)" and t = "snk" and result = 0.15000000000000002 or
repr = "(parameter 0 (return (member setStyles *)))" and t = "snk" and result = 0.21333333333333335 or
repr = "(parameter 1 (return (member setAttribute (member node *))))" and t = "snk" and result = 0.6802698590447517 or
repr = "(member settings *)" and t = "snk" and result = 0.5 or
repr = "(member hex (return (member getRGB *)))" and t = "snk" and result = 0.71301247771836 or
repr = "(member $store *)" and t = "snk" and result = 0.06266233766233764 or
repr = "(parameter 1 (return (member setAttribute *)))" and t = "snk" and result = 0.3266965768290314 or
repr = "(parameter 1 (return (member setStyles (member DOM *))))" and t = "snk" and result = 0.5 or
repr = "(member seller *)" and t = "snk" and result = 0.3246753246753248 or
repr = "(parameter 0 (return (member create *)))" and t = "snk" and result = 0.25 or
repr = "(return (member then (return (member then *))))" and t = "snk" and result = 0.6528835311585478 or
repr = "(return (member deleteOne *))" and t = "snk" and result = 0.25 or
repr = "(return (member toLocaleLowerCase *))" and t = "snk" and result = 0.13120481927710842 or
repr = "(member 0 (return (member concat *)))" and t = "snk" and result = 0.625 or
repr = "(parameter 1 (return (parameter cb *)))" and t = "snk" and result = 0.045860152250222 or
repr = "(parameter 1 (member _update *))" and t = "snk" and result = 0.07843137254901945 or
repr = "(parameter 0 (return (member visit (root https://www.npmjs.com/package/recast))))" and t = "snk" and result = 0.33333333333333337 or
repr = "(return (member Array (global)))" and t = "snk" and result = 0.20833333333333331 or
repr = "(member not *)" and t = "snk" and result = 0.31120481927710836 or
repr = "(parameter 0 (return (member localeCompare *)))" and t = "snk" and result = 0.4712048192771084 or
repr = "(member cookie *)" and t = "snk" and result = 1.0000000000000002 or
repr = "(parameter 1 (return (member deepEqual (global))))" and t = "snk" and result = 0.25 or
repr = "(parameter 2 (return (member handleCallback *)))" and t = "snk" and result = 0.0726154618473896 or
repr = "(parameter 0 (return (member captureStackTrace (member Error (global)))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member update *)))" and t = "snk" and result = 0.11607142857142858 or
repr = "(return (member format *))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member Error (global))))" and t = "snk" and result = 0.2930989628514055 or
repr = "(return (member call (member toString *)))" and t = "snk" and result = 0.5380463434497169 or
repr = "(member body (member toplevel *))" and t = "snk" and result = 0.3333333333333333 or
repr = "(parameter 0 (return (member blockStatement *)))" and t = "snk" and result = 0.6666666666666666 or
repr = "(parameter 0 (member _update *))" and t = "snk" and result = 0.125 or
repr = "(parameter 0 (return (member dirname (root https://www.npmjs.com/package/path))))" and t = "snk" and result = 0.16666666666666663 or
repr = "(return (member map (return (member slice *))))" and t = "snk" and result = 0.25239585140562226 or
repr = "(parameter 0 (return (member captureStackTrace *)))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (member path *))" and t = "snk" and result = 0.7575757575757576 or
repr = "(parameter 0 (return (member push (member body (member body *)))))" and t = "snk" and result = 0.2707117378605328 or
repr = "(member ts *)" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member debug (member logger (parameter self *)))))" and t = "snk" and result = 0.7268805585980287 or
repr = "(parameter 1 (return (member update *)))" and t = "snk" and result = 0.4083333333333333 or
repr = "(parameter 1 (return (member deepEqual (parameter t *))))" and t = "snk" and result = 0.8149016246805406 or
repr = "(parameter 0 (return (member readFileSync (root https://www.npmjs.com/package/fs))))" and t = "snk" and result = 0.6621821518900024 or
repr = "(return (member map (return (member keys *))))" and t = "snk" and result = 0.4414006706827307 or
repr = "(return (member dirname *))" and t = "snk" and result = 0.16666666666666663 or
repr = "(parameter 0 (instance (member Error (global))))" and t = "snk" and result = 0.30587841196604604 or
repr = "(member depMaps *)" and t = "snk" and result = 0.41500000000000004 or
repr = "(parameter 1 (return (member variableDeclaration *)))" and t = "snk" and result = 0.3685642570281126 or
repr = "(parameter 1 (return (member setHeader *)))" and t = "snk" and result = 0.25 or
repr = "(member ext *)" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member ObjectId (member Types *))))" and t = "snk" and result = 0.3246753246753247 or
repr = "(member expression *)" and t = "snk" and result = 0.12619792570281113 or
repr = "(parameter 0 (return (root https://www.npmjs.com/package/escape-html)))" and t = "snk" and result = 0.16999999999999998 or
repr = "(parameter 0 (return (member check *)))" and t = "snk" and result = 0.5050505050505051 or
repr = "(parameter 0 (return (member log (member console (global)))))" and t = "snk" and result = 0.4508032128514056 or
repr = "(parameter 0 (return (member toExpression *)))" and t = "snk" and result = 0.65 or
repr = "(parameter 0 (return (parameter resolve *)))" and t = "snk" and result = 0.3012048192771084 or
repr = "(parameter 1 (return (member findAndModify *)))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member error (member console (global)))))" and t = "snk" and result = 0.16000000000000003 or
repr = "(member should (return (member String (global))))" and t = "snk" and result = 0.6224096385542167 or
repr = "(parameter 0 (return (member all *)))" and t = "snk" and result = 0.573621443349154 or
repr = "(parameter 0 (return (member generate *)))" and t = "snk" and result = 0.09488565842316624 or
repr = "(parameter 0 (return (member run (member prototype *))))" and t = "snk" and result = 0.22499999999999964 or
repr = "(member body (member body (parameter self *)))" and t = "snk" and result = 0.16666666666666682 or
repr = "(member main *)" and t = "snk" and result = 0.41910523385434867 or
repr = "(parameter 0 (return (member splice (member MAP (global)))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member greaterThan *)))" and t = "snk" and result = 0.5 or
repr = "(return (member memberExpression *))" and t = "snk" and result = 0.112692436412316 or
repr = "(return (root https://www.npmjs.com/package/escape-html))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member send (member xhr *))))" and t = "snk" and result = 0.16666666666666652 or
repr = "(member $in *)" and t = "snk" and result = 0.1237373737373737 or
repr = "(member body (member body *))" and t = "snk" and result = 0.33333333333333337 or
repr = "(return (member variableDeclaration *))" and t = "snk" and result = 0.3685642570281126 or
repr = "(parameter 2 (return (member traverse *)))" and t = "snk" and result = 0.7002498904709744 or
repr = "(parameter 1 (return (root https://www.npmjs.com/package/xtend)))" and t = "snk" and result = 0.08000000000000002 or
repr = "(parameter 2 (return (member notEnumerableProp *)))" and t = "snk" and result = 0.3333333333333333 or
repr = "(return (member format (root https://www.npmjs.com/package/util)))" and t = "snk" and result = 0.536863417305586 or
repr = "(member expression (member expression *))" and t = "snk" and result = 0.17500689357429727 or
repr = "(parameter 1 (return (member emit *)))" and t = "snk" and result = 0.23530789825970558 or
repr = "(parameter 2 (return (member calculateMac *)))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member end *)))" and t = "snk" and result = 0.6454975903614458 or
repr = "(parameter 0 (return (member parseJSON *)))" and t = "snk" and result = 0.4295381526104416 or
repr = "(parameter 0 (return (member equals *)))" and t = "snk" and result = 0.5 or
repr = "(return (member call (member toString (member prototype *))))" and t = "snk" and result = 0.28620481927710806 or
repr = "(parameter 0 (return (member existsSync (root https://www.npmjs.com/package/fs))))" and t = "snk" and result = 0.6310910759450012 or
repr = "(parameter 0 (return (member ReferenceError (global))))" and t = "snk" and result = 0.31099518072289156 or
repr = "(return (member concat (member body *)))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (parameter 2 (return (member functionExpression *))))" and t = "snk" and result = 0.08333333333333337 or
repr = "(member hoistDeclarators *)" and t = "snk" and result = 0.05340995532128521 or
repr = "(parameter 0 (return (member info (member logger (parameter state *)))))" and t = "snk" and result = 0.7268805585980287 or
repr = "(parameter 1 (return (member emit (parameter _this *))))" and t = "snk" and result = 0.6124096385542166 or
repr = "(parameter 0 (return (member get (parameter $http *))))" and t = "snk" and result = 0.3333333333333333 or
repr = "(parameter 0 (return (member isArray (member Array (global)))))" and t = "snk" and result = 0.6432403433476395 or
repr = "(return (member __empty (member prototype *)))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member default *)))" and t = "snk" and result = 0.42703862660944214 or
repr = "(parameter 2 (return (member defineProperty (member Object (global)))))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member hasOwnProperty *)))" and t = "snk" and result = 0.20815450643776856 or
repr = "(member file *)" and t = "snk" and result = 0.33333333333333337 or
repr = "(member body (return (member buildRequest (member self *))))" and t = "snk" and result = 0.685559257586025 or
repr = "(parameter 0 (return (parameter e *)))" and t = "snk" and result = 0.5457434458865507 or
repr = "(parameter 1 (return (member slice (parameter e *))))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (return (parameter n *))))" and t = "snk" and result = 0.25 or
repr = "(member compiledImplicit *)" and t = "snk" and result = 0.08333333333333333 or
repr = "(parameter 2 (return (return (parameter n *))))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member error *)))" and t = "snk" and result = 0.47740963855421686 or
repr = "(parameter 0 (return (member findOne (return (member collection *)))))" and t = "snk" and result = 0.6145386266094421 or
repr = "(member tokens (parameter 0 (member exports (parameter e *))))" and t = "snk" and result = 0.2174705899296672 or
repr = "(return (member default *))" and t = "snk" and result = 0.10752950643776849 or
repr = "(parameter 0 (return (member push (member tokens (parameter e *)))))" and t = "snk" and result = 0.8470560532304054 or
repr = "(member osversion (return (member _detect (return (member _detect *)))))" and t = "snk" and result = 0.5738717648588892 or
repr = "(parameter 0 (return (member write *)))" and t = "snk" and result = 0.1448651664118985 or
repr = "(parameter 1 (return (return (parameter n *))))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (instance (return (parameter n *))))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member release *)))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (parameter 0 (return (member then *)))))" and t = "snk" and result = 0.2518939393939394 or
repr = "(return (member push *))" and t = "snk" and result = 0.6770386266094421 or
repr = "(member length (return (member exports *)))" and t = "snk" and result = 0.011795810453528328 or
repr = "(member defaultValue *)" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member accumulateTwoPhaseDispatches *)))" and t = "snk" and result = 0.3959227467811157 or
repr = "(member title *)" and t = "snk" and result = 0.2951977401129943 or
repr = "(parameter 1 (return (parameter i *)))" and t = "snk" and result = 0.25 or
repr = "(member version (return (member _detect (return (member _detect *)))))" and t = "snk" and result = 0.5738717648588894 or
repr = "(parameter 1 (return (member reduce *)))" and t = "snk" and result = 0.5209227467811157 or
repr = "(return (parameter n *))" and t = "snk" and result = 0.44796137339055786 or
repr = "(parameter 0 (return (member createElement *)))" and t = "snk" and result = 0.7575757575757576 or
repr = "(parameter 0 (return (member render (parameter 0 (member default *)))))" and t = "snk" and result = 1.0 or
repr = "(parameter 1 (return (member call (parameter e *))))" and t = "snk" and result = 1.0 or
repr = "(member path (parameter t *))" and t = "snk" and result = 0.8540772532188843 or
repr = "(parameter 0 (return (member find (return (member collection *)))))" and t = "snk" and result = 1.0 or
repr = "(parameter 2 (return (member default *)))" and t = "snk" and result = 0.0364806866952789 or
repr = "(parameter 1 (return (member defineProperties (member Object (global)))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member findOneAndUpdate *)))" and t = "snk" and result = 0.66 or
repr = "(return (member call (parameter t *)))" and t = "snk" and result = 0.43757575757575745 or
repr = "(member props *)" and t = "snk" and result = 0.3 or
repr = "(parameter 0 (parameter 0 (return (member push *))))" and t = "snk" and result = 0.368499659352687 or
repr = "(parameter 0 (return (member from *)))" and t = "snk" and result = 0.1327789699570816 or
repr = "(member 1 (parameter e *))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member remove (return (member collection *)))))" and t = "snk" and result = 0.5000000000000002 or
repr = "(parameter 0 (return (member insert *)))" and t = "snk" and result = 0.6145386266094421 or
repr = "(member length (return (member exports (parameter e *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 1 (return (member batchedUpdates *)))" and t = "snk" and result = 0.42703862660944214 or
repr = "(parameter 2 (member exports (parameter e *)))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member reduce *)))" and t = "snk" and result = 1.0 or
repr = "(member fullPath *)" and t = "snk" and result = 0.25 or
repr = "(member domain *)" and t = "snk" and result = 0.4950059936365276 or
repr = "(parameter 3 (member exports *))" and t = "snk" and result = 0.2500000000000002 or
repr = "(member implicit *)" and t = "snk" and result = 0.08333333333333333 or
repr = "(member compiledExplicit *)" and t = "snk" and result = 0.08333333333333337 or
repr = "(member path (return (member getFile *)))" and t = "snk" and result = 0.5 or
repr = "(return (member access *))" and t = "snk" and result = 0.26 or
repr = "(parameter 0 (return (member encodeSlug *)))" and t = "snk" and result = 0.29304 or
repr = "(member fetch *)" and t = "snk" and result = 0.42 or
repr = "(parameter 0 (return (member pipe *)))" and t = "snk" and result = 0.25 or
repr = "(member error *)" and t = "snk" and result = 0.30303030303030304 or
repr = "(member pathname (return (member parse (root https://www.npmjs.com/package/url))))" and t = "snk" and result = 0.0924242424242425 or
repr = "(return (member slice (return (member split *))))" and t = "snk" and result = 0.2800000000000001 or
repr = "(parameter 0 (return (member info *)))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member resolve (return (root https://www.npmjs.com/package/orion/Deferred)))))" and t = "snk" and result = 0.8441220399729278 or
repr = "(return (member then (return (member resolve (root https://www.npmjs.com/package/bluebird)))))" and t = "snk" and result = 1.0 or
repr = "(parameter 1 (return (member checkRights (member user (parameter req *)))))" and t = "snk" and result = 1.0 or
repr = "(return (member catch (return (member then *))))" and t = "snk" and result = 0.9724609172256453 or
repr = "(parameter 1 (return (parameter 1 (return (member getUser *)))))" and t = "snk" and result = 0.2 or
repr = "(member occurrences *)" and t = "snk" and result = 0.2416666666666666 or
repr = "(parameter 0 (return (member resolve *)))" and t = "snk" and result = 0.2 or
repr = "(member FriendlyPath *)" and t = "snk" and result = 0.14 or
repr = "(parameter 0 (return (member format (root https://www.npmjs.com/package/url))))" and t = "snk" and result = 0.09246969696969698 or
repr = "(member Mappings (member siteConfiguration *))" and t = "snk" and result = 0.16000000000000003 or
repr = "(parameter 0 (return (member setProgressResult (return (member getService *)))))" and t = "snk" and result = 0.52 or
repr = "(return (member formatMessage (root https://www.npmjs.com/package/orion/i18nUtil)))" and t = "snk" and result = 0.30303030303030304 or
repr = "(parameter 1 (return (member checkRights *)))" and t = "snk" and result = 0.4015151515151515 or
repr = "(parameter 0 (return (member setSelection *)))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member setSelections *)))" and t = "snk" and result = 0.07232566630157 or
repr = "(member classList *)" and t = "snk" and result = 0.19172932330827064 or
repr = "(return (member stringify (member JSON (global))))" and t = "snk" and result = 0.424 or
repr = "(member id (return (member parse *)))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member writeError *)))" and t = "snk" and result = 0.07801999999999998 or
repr = "(parameter 2 (return (member setText *)))" and t = "snk" and result = 0.13661202185792348 or
repr = "(return (member then (return (member getRepo *))))" and t = "snk" and result = 0.29953660370427304 or
repr = "(member query *)" and t = "snk" and result = 0.5312925 or
repr = "(parameter 0 (return (member map (root https://www.npmjs.com/package/bluebird))))" and t = "snk" and result = 0.7575757575757576 or
repr = "(parameter 2 (return (member join *)))" and t = "snk" and result = 0.30774999999999997 or
repr = "(parameter 3 (return (member writeResponse *)))" and t = "snk" and result = 0.3845 or
repr = "(member checked *)" and t = "snk" and result = 0.33 or
repr = "(parameter 0 (return (member reject (parameter promise *))))" and t = "snk" and result = 0.1399999999999999 or
repr = "(parameter 2 (return (member writeError *)))" and t = "snk" and result = 0.3845 or
repr = "(member query (return (member URL (global))))" and t = "snk" and result = 0.4525665151515149 or
repr = "(parameter 1 (return (member setSelection *)))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member createWriteStream *)))" and t = "snk" and result = 0.04999999999999999 or
repr = "(member workspaceId (return (member getFile *)))" and t = "snk" and result = 0.5956287878787877 or
repr = "(parameter 0 (return (parameter edit *)))" and t = "snk" and result = 0.062460000000000016 or
repr = "(return (member split *))" and t = "snk" and result = 0.04840877286667892 or
repr = "(parameter 0 (return (member done (instance (member Task *)))))" and t = "snk" and result = 0.5 or
repr = "(parameter 1 (return (member checkRights (member user *))))" and t = "snk" and result = 0.1136363636363634 or
repr = "(member Message (return (member parse (member JSON (global)))))" and t = "snk" and result = 0.3000000000000001 or
repr = "(parameter 0 (return (member merge *)))" and t = "snk" and result = 0.1004016064257028 or
repr = "(member status *)" and t = "snk" and result = 0.64198 or
repr = "(parameter 0 (parameter 0 (return (member then *))))" and t = "snk" and result = 0.66 or
repr = "(member scriptResolver *)" and t = "snk" and result = 0.33 or
repr = "(parameter 0 (return (member handler *)))" and t = "snk" and result = 0.10000000000000003 or
repr = "(parameter 0 (return (member appendChild (return (member createElement *)))))" and t = "snk" and result = 0.16999999999999998 or
repr = "(parameter 0 (return (member info (return (member getLogger *)))))" and t = "snk" and result = 0.038000000000000034 or
repr = "(parameter 0 (return (member join (root https://www.npmjs.com/package/path))))" and t = "snk" and result = 0.11549999999999994 or
repr = "(member selectedGroupIndex *)" and t = "snk" and result = 0.2732240437158471 or
repr = "(member Message (return (member parse *)))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member withStatsAndETag *)))" and t = "snk" and result = 0.5 or
repr = "(parameter 1 (return (member setText *)))" and t = "snk" and result = 0.13661202185792354 or
repr = "(parameter 1 (parameter 1 (return (member getFile *))))" and t = "snk" and result = 0.6154999999999999 or
repr = "(member checked (return (member createElement *)))" and t = "snk" and result = 0.18515151515151507 or
repr = "(parameter 0 (return (member parseFloat (global))))" and t = "snk" and result = 0.3316255881542976 or
repr = "(parameter 0 (return (member stringify (member JSON (global)))))" and t = "snk" and result = 0.4746666666666666 or
repr = "(parameter 1 (return (member put (member cache *))))" and t = "snk" and result = 0.26470236802165786 or
repr = "(member query (instance (member URL (global))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member mixin (parameter util *))))" and t = "snk" and result = 0.2008032128514056 or
repr = "(member services *)" and t = "snk" and result = 0.1 or
repr = "(parameter 0 (return (member delete *)))" and t = "snk" and result = 0.3090576146532057 or
repr = "(parameter 0 (return (member each (root https://www.npmjs.com/package/async))))" and t = "snk" and result = 0.83 or
repr = "(member offset (member position *))" and t = "snk" and result = 0.2732240437158471 or
repr = "(member now *)" and t = "snk" and result = 0.5309333333333334 or
repr = "(parameter 0 (return (member join *)))" and t = "snk" and result = 0.3845 or
repr = "(return (member split (return (member substring *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member freeRepo *)))" and t = "snk" and result = 0.36811522930641133 or
repr = "(parameter 0 (return (member existsSync *)))" and t = "snk" and result = 0.4 or
repr = "(parameter 0 (return (member encodeURIComponent *)))" and t = "snk" and result = 0.1 or
repr = "(member search *)" and t = "snk" and result = 0.6154999999999999 or
repr = "(parameter 0 (return (member getWorkspace *)))" and t = "snk" and result = 0.19225 or
repr = "(member Source *)" and t = "snk" and result = 0.41999999999999993 or
repr = "(return (member then (return (member resolve *))))" and t = "snk" and result = 0.3390925316870514 or
repr = "(member name *)" and t = "snk" and result = 0.2295600358269529 or
repr = "(member mediaElement *)" and t = "snk" and result = 1.0 or
repr = "(member userid (parameter e *))" and t = "snk" and result = 0.3333333333333333 or
repr = "(member extra *)" and t = "snk" and result = 0.16666666666666669 or
repr = "(member data (parameter e *))" and t = "snk" and result = 0.08333333333333337 or
repr = "(member src *)" and t = "snk" and result = 0.11445783132530121 or
repr = "(parameter 0 (return (member stringify *)))" and t = "snk" and result = 0.6983333333333334 or
repr = "(member mediaElement (parameter e (member onstreamended (parameter connection *))))" and t = "snk" and result = 0.6666666666666661 or
repr = "(parameter 0 (return (member appendChild (member body *))))" and t = "snk" and result = 0.4893235213190271 or
repr = "(member parentNode *)" and t = "snk" and result = 0.20694444444444446 or
repr = "(parameter 0 (return (member getElementById (member document (global)))))" and t = "snk" and result = 0.5050505050505051 or
repr = "(parameter 1 (return (member union (root https://www.npmjs.com/package/underscore))))" and t = "snk" and result = 0.25 or
repr = "(member slug (member _artist *))" and t = "snk" and result = 0.5 or
repr = "(parameter 1 (return (member log (member console (global)))))" and t = "snk" and result = 0.5 or
repr = "(member name (member _artist *))" and t = "snk" and result = 0.5 or
repr = "(return (member findOne (member Playlist (global))))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member find (member Person (global)))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member findOne (member Playlist (global)))))" and t = "snk" and result = 0.20000000000000007 or
repr = "(parameter 0 (return (member find (member Playlist (global)))))" and t = "snk" and result = 1.0 or
repr = "(return (member union (root https://www.npmjs.com/package/underscore)))" and t = "snk" and result = 0.3787878787878788 or
repr = "(parameter 0 (return (member find (member Play (global)))))" and t = "snk" and result = 1.0 or
repr = "(return (member count *))" and t = "snk" and result = 0.2500000000000001 or
repr = "(parameter 0 (return (member count *)))" and t = "snk" and result = 0.8333333333333334 or
repr = "(parameter 0 (return (member redirect (parameter res *))))" and t = "snk" and result = 0.75 or
repr = "(parameter 0 (return (member find (member Track (global)))))" and t = "snk" and result = 1.0 or
repr = "(member playlist *)" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member find (member Chat (global)))))" and t = "snk" and result = 1.0 or
repr = "(member host *)" and t = "snk" and result = 0.25 or
repr = "(member current *)" and t = "snk" and result = 0.75 or
repr = "(parameter 1 (return (member log *)))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (parameter fn *)))" and t = "snk" and result = 0.25 or
repr = "(member search (member location (global)))" and t = "snk" and result = 0.5000000000000004 or
repr = "(parameter 1 (return (member default *)))" and t = "snk" and result = 0.458403165735568 or
repr = "(member _dispatchListeners *)" and t = "snk" and result = 0.4189944134078213 or
repr = "(member _dispatchInstances (parameter event *))" and t = "snk" and result = 0.3357598329665369 or
repr = "(return (member stringify *))" and t = "snk" and result = 1.0 or
repr = "(return (member unstable_createEventHandle *))" and t = "snk" and result = 0.4999999999999999 or
repr = "(member controller *)" and t = "snk" and result = 0.08909090909090944 or
repr = "(parameter 0 (return (member $watch (parameter scope *))))" and t = "snk" and result = 0.5 or
repr = "(parameter 1 (return (parameter fn *)))" and t = "snk" and result = 0.5 or
repr = "(member $$state *)" and t = "snk" and result = 0.20833333333333331 or
repr = "(member exp *)" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member getPostByPermalink (return (member PostsDAO *)))))" and t = "snk" and result = 0.5151515151515149 or
repr = "(parameter 0 (return (member getPostByPermalink (instance (member PostsDAO *)))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member getPostByPermalink *)))" and t = "snk" and result = 0.5151515151515149 or
repr = "(parameter 0 (return (member html *)))" and t = "snk" and result = 0.24816495110102935 or
repr = "(parameter 0 (return (member $watch (parameter scope (member pre *)))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member css *)))" and t = "snk" and result = 0.4999999999999999 or
repr = "(parameter 1 (return (member $on *)))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (member data *))" and t = "snk" and result = 0.25 or
repr = "(parameter 2 (return (member set *)))" and t = "snk" and result = 0.25 or
repr = "(member old (return (member speed *)))" and t = "snk" and result = 0.5102040816326531 or
repr = "(parameter 0 (return (member max *)))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member trim (return (member noConflict *)))))" and t = "snk" and result = 0.8750000000000004 or
repr = "(member location (parameter window *))" and t = "snk" and result = 0.20000000000000007 or
repr = "(parameter 0 (return (member cancel (parameter $timeout *))))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member trim (member $ *))))" and t = "snk" and result = 1.0 or
repr = "(member namespace *)" and t = "snk" and result = 0.17088491430596695 or
repr = "(parameter 0 (member className *))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member clearTimeout (global))))" and t = "snk" and result = 0.4029270799325462 or
repr = "(member elem *)" and t = "snk" and result = 0.8608333333333333 or
repr = "(parameter 1 (return (member open *)))" and t = "snk" and result = 0.8035407520519183 or
repr = "(return (member build *))" and t = "snk" and result = 0.09369972459302485 or
repr = "(member name (parameter el *))" and t = "snk" and result = 0.41887764840618447 or
repr = "(member _dom *)" and t = "snk" and result = 0.09369972459302484 or
repr = "(parameter 0 (return (member send *)))" and t = "snk" and result = 0.29684986229651245 or
repr = "(parameter 0 (return (member build *)))" and t = "snk" and result = 0.09369972459302484 or
repr = "(return (member sort (return (member find *))))" and t = "snk" and result = 0.44999999999999996 or
repr = "(parameter 1 (return (member menu *)))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member _outerWidth (return (member find *)))))" and t = "snk" and result = 0.09999999999999964 or
repr = "(return (member slice *))" and t = "snk" and result = 0.1722225165185692 or
repr = "(parameter 0 (return (parameter cb *)))" and t = "snk" and result = 0.5620300751879699 or
repr = "(parameter 3 (instance (member Date (global))))" and t = "snk" and result = 0.40000000000000036 or
repr = "(member text *)" and t = "snk" and result = 0.576271186440678 or
repr = "(parameter 4 (instance (member Date (global))))" and t = "snk" and result = 0.40000000000000036 or
repr = "(parameter 1 (return (member where *)))" and t = "snk" and result = 0.16666666666666663 or
repr = "(member validator *)" and t = "snk" and result = 0.0737410071942446 or
repr = "(parameter 5 (return (member Date (global))))" and t = "snk" and result = 0.40000000000000036 or
repr = "(parameter 0 (return (member count (return (member model *)))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member add (return (member Schema *)))))" and t = "snk" and result = 1.0 or
repr = "(member onBeforeValidate *)" and t = "snk" and result = 0.0737410071942446 or
repr = "(parameter 0 (return (member eval (global))))" and t = "snk" and result = 0.24999999999999997 or
repr = "(parameter 0 (return (parameter cb (member getDataForExcel *))))" and t = "snk" and result = 0.1955456823877877 or
repr = "(return (member limit *))" and t = "snk" and result = 0.265 or
repr = "(parameter 1 (return (member extend (root https://www.npmjs.com/package/underscore))))" and t = "snk" and result = 0.6262711864406781 or
repr = "(parameter 0 (return (member limit *)))" and t = "snk" and result = 0.3091571190449645 or
repr = "(return (member _outerWidth *))" and t = "snk" and result = 0.40000000000000036 or
repr = "(member onValidate *)" and t = "snk" and result = 0.0737410071942446 or
repr = "(member _verticalScrollbar *)" and t = "snk" and result = 0.5 or
repr = "(member _historyService *)" and t = "snk" and result = 0.055617352614015556 or
repr = "(member fire *)" and t = "snk" and result = 0.16666666666666669 or
repr = "(parameter 0 (return (root https://www.npmjs.com/package/fancy-log)))" and t = "snk" and result = 0.25 or
repr = "(member initialTarget *)" and t = "snk" and result = 0.5139210284664829 or
repr = "(member className *)" and t = "snk" and result = 0.2904375082944362 or
repr = "(parameter 0 (return (member writeFile (member fileService *))))" and t = "snk" and result = 0.5 or
repr = "(member _remoteAgentService *)" and t = "snk" and result = 0.055617352614015556 or
repr = "(member _textAreaInput *)" and t = "snk" and result = 0.75 or
repr = "(parameter 0 (return (member all (member Promise (global)))))" and t = "snk" and result = 0.5 or
repr = "(member _onProcessReady *)" and t = "snk" and result = 0.055617352614015556 or
repr = "(return (member getCursorStates *))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member emitViewEvent *)))" and t = "snk" and result = 0.16000000000000003 or
repr = "(member mouseColumn *)" and t = "snk" and result = 0.1171875 or
repr = "(member installed *)" and t = "snk" and result = 0.034090909090909075 or
repr = "(parameter 0 (return (parameter 0 (return (member forEach *)))))" and t = "snk" and result = 0.2291184573002755 or
repr = "(member _horizontalScrollbar *)" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member dispose (root https://www.npmjs.com/package/vs/base/common/lifecycle))))" and t = "snk" and result = 0.4097587444694881 or
repr = "(return (parameter event *))" and t = "snk" and result = 0.16666666666666674 or
repr = "(parameter 1 (return (member executeCommand (member commands (root https://www.npmjs.com/package/vscode)))))" and t = "snk" and result = 0.7575757575757576 or
repr = "(parameter 0 (return (member setDragImage (member dataTransfer *))))" and t = "snk" and result = 0.3 or
repr = "(parameter 0 (return (member add (instance (member DisposableStore *)))))" and t = "snk" and result = 0.5075757575757575 or
repr = "(parameter 0 (return (member removeChild (member body *))))" and t = "snk" and result = 0.3 or
repr = "(member _onProcessOverrideDimensions *)" and t = "snk" and result = 0.055617352614015556 or
repr = "(parameter 0 (return (member setCollapsed *)))" and t = "snk" and result = 0.1875 or
repr = "(parameter 0 (return (member fromString *)))" and t = "snk" and result = 0.75 or
repr = "(member _onProcessData *)" and t = "snk" and result = 0.055617352614015556 or
repr = "(parameter 0 (return (member onHide *)))" and t = "snk" and result = 1.0 or
repr = "(member emitter *)" and t = "snk" and result = 0.16666666666666669 or
repr = "(member position *)" and t = "snk" and result = 0.1171875 or
repr = "(parameter 0 (return (member findRange *)))" and t = "snk" and result = 0.06250000000000003 or
repr = "(parameter 0 (return (member addChild *)))" and t = "snk" and result = 0.25 or
repr = "(member cursorState *)" and t = "snk" and result = 1.0 or
repr = "(member _process *)" and t = "snk" and result = 0.055617352614015556 or
repr = "(member encoding *)" and t = "snk" and result = 0.125 or
repr = "(parameter 0 (return (member splice (return (member get *)))))" and t = "snk" and result = 0.5000000000000001 or
repr = "(member resource *)" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (parameter 0 (return (member isNaN (global)))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member defineProperty (member Object (global)))))" and t = "snk" and result = 0.49000000000000016 or
repr = "(member className (parameter e *))" and t = "snk" and result = 0.9623950346841907 or
repr = "(member _instantiationService *)" and t = "snk" and result = 0.055617352614015556 or
repr = "(parameter 0 (return (member add *)))" and t = "snk" and result = 0.39625 or
repr = "(member inputEventListener *)" and t = "snk" and result = 0.16666666666666666 or
repr = "(return (member all (member Promise (global))))" and t = "snk" and result = 0.5 or
repr = "(member stack (parameter err *))" and t = "snk" and result = 0.5 or
repr = "(member userHome *)" and t = "snk" and result = 0.11123470522803111 or
repr = "(parameter 0 (return (member call (member toString *))))" and t = "snk" and result = 0.7575757575757576 or
repr = "(member timestamp *)" and t = "snk" and result = 0.125 or
repr = "(parameter 0 (return (member call (member hasOwnProperty (member prototype *)))))" and t = "snk" and result = 0.7424242424242427 or
repr = "(parameter 0 (return (member showSaveDialog *)))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (parameter 1 (return (member withProgress *)))))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member getStartLineNumber (member regions *))))" and t = "snk" and result = 0.375 or
repr = "(member callstack *)" and t = "snk" and result = 0.38876529477196886 or
repr = "(parameter 0 (return (return (member defaults (root https://www.npmjs.com/package/request)))))" and t = "snk" and result = 0.9600000000000002 or
repr = "(return (member eq *))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member on *)))" and t = "snk" and result = 0.1256210318865208 or
repr = "(parameter 0 (instance (member RegExp (global))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member eq *)))" and t = "snk" and result = 0.5 or
repr = "(member requestAnimationFrame (parameter e *))" and t = "snk" and result = 0.7575757575757576 or
repr = "(member size *)" and t = "snk" and result = 0.25 or
repr = "(member cancelAnimationFrame (global))" and t = "snk" and result = 0.7575757575757576 or
repr = "(member skills *)" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member findSkillByName *)))" and t = "snk" and result = 0.125 or
repr = "(parameter 1 (return (return (parameter _dereq_ *))))" and t = "snk" and result = 0.08333333333333337 or
repr = "(member _dispatchListeners (parameter event *))" and t = "snk" and result = 0.25252525252525265 or
repr = "(return (member then (return (member populate *))))" and t = "snk" and result = 0.5 or
repr = "(member SSN *)" and t = "snk" and result = 0.25 or
repr = "(member 0 (parameter 0 (parameter 0 (return (member then *)))))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member find (member ModelMarker *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 1 (return (member extend (root https://www.npmjs.com/package/jquery))))" and t = "snk" and result = 0.7575757575757576 or
repr = "(member query (parameter req *))" and t = "snk" and result = 1.0 or
repr = "(member query (parameter 0 (parameter 1 (return (member get *)))))" and t = "snk" and result = 1.0 or
repr = "(parameter 3 (return (member extend *)))" and t = "snk" and result = 0.33999999999999997 or
repr = "(parameter 0 (return (member insertAfter *)))" and t = "snk" and result = 0.05133470225872694 or
repr = "(member query (parameter req (parameter 2 (return (member get *)))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member _addClass *)))" and t = "snk" and result = 0.05133470225872694 or
repr = "(member tablist *)" and t = "snk" and result = 0.051334702258726606 or
repr = "(member tabs *)" and t = "snk" and result = 0.05133470225872694 or
repr = "(member query (parameter req (parameter 1 (return (member get *)))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member limit (return (member sort *)))))" and t = "snk" and result = 0.16999999999999998 or
repr = "(return (member on *))" and t = "snk" and result = 0.05133470225872694 or
repr = "(member anchors *)" and t = "snk" and result = 0.05133470225872694 or
repr = "(return (member limit (return (member sort *))))" and t = "snk" and result = 0.1499999999999999 or
repr = "(member query (parameter 0 (parameter 2 (return (member get *)))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member style *)))" and t = "snk" and result = 0.3200000000000001 or
repr = "(parameter 1 (return (member findOneAndUpdate *)))" and t = "snk" and result = 0.2925 or
repr = "(parameter 1 (return (member apply (member handle (member event *)))))" and t = "snk" and result = 1.0 or
repr = "(member tbodyEl *)" and t = "snk" and result = 0.1717171717171717 or
repr = "(parameter 0 (return (member setHtml *)))" and t = "snk" and result = 0.27999999999999997 or
repr = "(parameter 0 (return (member append (return (root https://www.npmjs.com/package/jquery)))))" and t = "snk" and result = 0.11616161616161604 or
repr = "(return (member eq (return (member $ (global)))))" and t = "snk" and result = 0.3750000000000001 or
repr = "(member from *)" and t = "snk" and result = 0.5050505050505051 or
repr = "(member cols *)" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member trim *)))" and t = "snk" and result = 0.8279464896006249 or
repr = "(member firstCategory *)" and t = "snk" and result = 0.16666666666666669 or
repr = "(parameter 0 (return (member append *)))" and t = "snk" and result = 0.3888888888888889 or
repr = "(parameter 0 (return (member find (member products *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member wrap *)))" and t = "snk" and result = 0.25 or
repr = "(return (member append *))" and t = "snk" and result = 0.505050505050505 or
repr = "(parameter 0 (return (member drawCircle *)))" and t = "snk" and result = 0.3 or
repr = "(member to *)" and t = "snk" and result = 0.5050505050505049 or
repr = "(parameter 0 (return (member appendTo (return (member css *)))))" and t = "snk" and result = 0.5 or
repr = "(member el *)" and t = "snk" and result = 0.16666666666666666 or
repr = "(member belong_category *)" and t = "snk" and result = 0.996987951807229 or
repr = "(parameter 0 (return (member extend (root https://www.npmjs.com/package/jquery))))" and t = "snk" and result = 0.6462080591030299 or
repr = "(parameter 0 (return (member setAttributes *)))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member trim (member constructor (member prototype *)))))" and t = "snk" and result = 0.14209224359600334 or
repr = "(parameter 0 (return (member isNumeric (member $ (global)))))" and t = "snk" and result = 0.5 or
repr = "(member de_firstCategory *)" and t = "snk" and result = 0.16666666666666669 or
repr = "(parameter 0 (return (member find (member users *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (member from *))" and t = "snk" and result = 0.5050505050505049 or
repr = "(member lastShapeId *)" and t = "snk" and result = 0.15 or
repr = "(return (member wrap *))" and t = "snk" and result = 0.25 or
repr = "(member rows *)" and t = "snk" and result = 0.5 or
repr = "(parameter 2 (return (member style (member constructor *))))" and t = "snk" and result = 0.04166666666666763 or
repr = "(parameter 0 (return (member find (member banners *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (member to *))" and t = "snk" and result = 0.5050505050505049 or
repr = "(parameter 1 (return (member push *)))" and t = "snk" and result = 0.13524948602952677 or
repr = "(parameter 1 (return (member apply (member handle *))))" and t = "snk" and result = 0.510433470038733 or
repr = "(parameter 0 (parameter 0 (return (member exec *))))" and t = "snk" and result = 0.46880952380952395 or
repr = "(parameter 1 (return (member drawCircle (member target *))))" and t = "snk" and result = 0.29999999999999993 or
repr = "(parameter 2 (return (member style (member exports *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 1 (return (member update (member default *))))" and t = "snk" and result = 1.0 or
repr = "(member symbol *)" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member exchange (member tokens *))))" and t = "snk" and result = 1.0 or
repr = "(member to_symbol *)" and t = "snk" and result = 0.4848484848484849 or
repr = "(parameter 0 (return (member findOne (member Node *))))" and t = "snk" and result = 0.617424242424243 or
repr = "(member symbol (return (member getToken *)))" and t = "snk" and result = 0.5151515151515151 or
repr = "(member from_symbol *)" and t = "snk" and result = 0.48484848484848486 or
repr = "(parameter 2 (return (member update (member default *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 1 (return (member exchange (member tokens *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member log *)))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member open *)))" and t = "snk" and result = 0.25 or
repr = "(parameter 1 (return (member write *)))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (instance (member model *)))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member model *)))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member find (member model *))))" and t = "snk" and result = 1.0 or
repr = "(member focusArea *)" and t = "snk" and result = 0.0762124711316397 or
repr = "(member skillNames *)" and t = "snk" and result = 0.0762124711316397 or
repr = "(member description *)" and t = "snk" and result = 0.0762124711316397 or
repr = "(member trainings *)" and t = "snk" and result = 0.04041570438799086 or
repr = "(parameter 0 (return (member ltrim *)))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member pow (member Math (global)))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member load (member scriptLoader *))))" and t = "snk" and result = 0.6668769676510942 or
repr = "(parameter 2 (return (member splice *)))" and t = "snk" and result = 0.25 or
repr = "(member frontier *)" and t = "snk" and result = 1.0 or
repr = "(parameter 2 (return (member _trigger *)))" and t = "snk" and result = 0.07865713200265831 or
repr = "(parameter 0 (return (member setStartAfter *)))" and t = "snk" and result = 0.4393939393939394 or
repr = "(parameter 0 (return (member removeClass (return (member children *)))))" and t = "snk" and result = 0.21067143399867078 or
repr = "(member attributes *)" and t = "snk" and result = 0.31641583658406824 or
repr = "(member header *)" and t = "snk" and result = 0.10852770842355772 or
repr = "(parameter 0 (instance (member element (member htmlParser *))))" and t = "snk" and result = 0.4466746581820369 or
repr = "(member gutters (parameter a *))" and t = "snk" and result = 0.3681035009579131 or
repr = "(member id *)" and t = "snk" and result = 0.13526050410268942 or
repr = "(member firstChild *)" and t = "snk" and result = 0.2870080111459422 or
repr = "(parameter 1 (return (member setCustomData *)))" and t = "snk" and result = 0.75 or
repr = "(member elements *)" and t = "snk" and result = 0.37297402309058614 or
repr = "(member offsetHeight (member $ *))" and t = "snk" and result = 0.30331095886362275 or
repr = "(return (member abs *))" and t = "snk" and result = 0.1127841797380344 or
repr = "(parameter 2 (return (member on *)))" and t = "snk" and result = 0.1614560630164668 or
repr = "(parameter 1 (return (member inArray (root https://www.npmjs.com/package/jquery))))" and t = "snk" and result = 0.7575757575757576 or
repr = "(member distance *)" and t = "snk" and result = 0.5 or
repr = "(member range *)" and t = "snk" and result = 0.19680849442702894 or
repr = "(parameter 0 (return (member RegExp (global))))" and t = "snk" and result = 0.2529410424578467 or
repr = "(member name (member attributes *))" and t = "snk" and result = 0.28409090909090906 or
repr = "(member helper (member current (member ddmanager (member ui (parameter $ *)))))" and t = "snk" and result = 0.5322580645161289 or
repr = "(parameter 0 (return (member addClass (return (member removeClass *)))))" and t = "snk" and result = 0.21067143399867078 or
repr = "(parameter 1 (return (member fire (parameter b *))))" and t = "snk" and result = 0.6066219177272455 or
repr = "(member mainContainer (instance (member ToolbarModifier (member ToolbarConfigurator (global)))))" and t = "snk" and result = 0.3787878787878788 or
repr = "(parameter 0 (return (member append (return (member find *)))))" and t = "snk" and result = 0.0050505050505049425 or
repr = "(parameter 0 (return (root https://www.npmjs.com/package/jquery)))" and t = "snk" and result = 0.34051724137931033 or
repr = "(return (member output (return (member addTemplate *))))" and t = "snk" and result = 0.21166207529843878 or
repr = "(member startContainer (parameter a *))" and t = "snk" and result = 0.6796055717487857 or
repr = "(parameter 1 (return (member setAttribute (parameter a *))))" and t = "snk" and result = 0.31361012433392543 or
repr = "(parameter 1 (return (member extend *)))" and t = "snk" and result = 0.44383443672964107 or
repr = "(parameter 3 (return (member push *)))" and t = "snk" and result = 0.07291212603293365 or
repr = "(member view (member display (instance (member constructor (member prototype *)))))" and t = "snk" and result = 0.45103502892127684 or
repr = "(member refresh *)" and t = "snk" and result = 0.2747513424644876 or
repr = "(member preview *)" and t = "snk" and result = 0.22569595798902212 or
repr = "(member elem (member currentActive (instance (member ToolbarModifier *))))" and t = "snk" and result = 0.25757575757575757 or
repr = "(member 0 (parameter a *))" and t = "snk" and result = 0.3525973627999278 or
repr = "(parameter 1 (return (member build *)))" and t = "snk" and result = 0.3549159011431952 or
repr = "(parameter 0 (return (member attachListener (return (member editable *)))))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member show *)))" and t = "snk" and result = 0.25 or
repr = "(return (root https://www.npmjs.com/package/jquery))" and t = "snk" and result = 0.5 or
repr = "(parameter 1 (return (member setAttribute (instance (member element *)))))" and t = "snk" and result = 0.3061838415977133 or
repr = "(member editor *)" and t = "snk" and result = 0.13935556113634998 or
repr = "(parameter 0 (return (member bind *)))" and t = "snk" and result = 0.0558541598650924 or
repr = "(return (member extend *))" and t = "snk" and result = 0.5878805710323686 or
repr = "(member href *)" and t = "snk" and result = 0.7575757575757575 or
repr = "(parameter 0 (return (member selectPage *)))" and t = "snk" and result = 0.050260504102689424 or
repr = "(parameter 1 (return (member bind *)))" and t = "snk" and result = 0.0558541598650924 or
repr = "(return (member append (return (root https://www.npmjs.com/package/jquery))))" and t = "snk" and result = 0.5050505050505051 or
repr = "(parameter 0 (return (member setAttribute *)))" and t = "snk" and result = 0.13676731793960922 or
repr = "(member next *)" and t = "snk" and result = 0.0854004063112151 or
repr = "(parameter 0 (return (member extend (member tools *))))" and t = "snk" and result = 0.6108551075350784 or
repr = "(member active *)" and t = "snk" and result = 0.06060606060606055 or
repr = "(member map *)" and t = "snk" and result = 0.16420992277012214 or
repr = "(member sel (member doc (parameter a *)))" and t = "snk" and result = 0.7575757575757573 or
repr = "(member $ *)" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (parameter a *)))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member slice *)))" and t = "snk" and result = 0.22490145819093194 or
repr = "(member headers *)" and t = "snk" and result = 0.07865713200265831 or
repr = "(parameter 0 (return (member Pos *)))" and t = "snk" and result = 0.5594128787878787 or
repr = "(parameter 0 (return (member trigger (member element *))))" and t = "snk" and result = 0.5 or
repr = "(parameter 1 (return (member setStyle *)))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (return (member bookmark (member walker *)))))" and t = "snk" and result = 1.0 or
repr = "(member dataTransfer *)" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member addFeature *)))" and t = "snk" and result = 0.25 or
repr = "(return (member extend (member tools (member CKEDITOR (global)))))" and t = "snk" and result = 0.9318181818181819 or
repr = "(member length (member 0 (return (member match *))))" and t = "snk" and result = 0.5031550841418094 or
repr = "(member cc *)" and t = "snk" and result = 0.0854004063112151 or
repr = "(parameter 0 (return (parameter $ *)))" and t = "snk" and result = 0.31896551724137934 or
repr = "(parameter 0 (return (member fn *)))" and t = "snk" and result = 0.2782704623823329 or
repr = "(member localVars *)" and t = "snk" and result = 0.08333333333333333 or
repr = "(parameter 1 (return (member fire *)))" and t = "snk" and result = 0.3933780822727545 or
repr = "(member endContainer *)" and t = "snk" and result = 0.5 or
repr = "(return (member setTimeout (global)))" and t = "snk" and result = 0.0558541598650924 or
repr = "(parameter 0 (return (member setStartBefore (instance (member range *)))))" and t = "snk" and result = 0.5 or
repr = "(member data-cke-saved-href (member set *))" and t = "snk" and result = 0.4053030303030304 or
repr = "(parameter 0 (return (member setStartAt *)))" and t = "snk" and result = 0.5 or
repr = "(member dataValue (member data (parameter a *)))" and t = "snk" and result = 0.7575757575757576 or
repr = "(parameter 0 (return (member output *)))" and t = "snk" and result = 0.4393939393939394 or
repr = "(parameter 0 (return (member moveToElementEditStart *)))" and t = "snk" and result = 0.125 or
repr = "(parameter 1 (return (member data (parameter $ *))))" and t = "snk" and result = 0.3517143010926313 or
repr = "(member frontier (member doc *))" and t = "snk" and result = 0.24999999999999994 or
repr = "(parameter 0 (parameter 0 (return (member createFromHtml *))))" and t = "snk" and result = 0.3181818181818181 or
repr = "(parameter 1 (return (member exec *)))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member push (member items *))))" and t = "snk" and result = 0.47646536412078155 or
repr = "(parameter 2 (return (member push (member map *))))" and t = "snk" and result = 0.17577286879894533 or
repr = "(return (member replace (member className *)))" and t = "snk" and result = 0.4700493833695867 or
repr = "(parameter 0 (return (member abs *)))" and t = "snk" and result = 0.07417778836987596 or
repr = "(return (member replace (parameter a *)))" and t = "snk" and result = 0.25757575757575757 or
repr = "(parameter 0 (return (member indexOf (member tools *))))" and t = "snk" and result = 0.3667561645455092 or
repr = "(parameter 0 (return (member isFunction (member constructor (member prototype *)))))" and t = "snk" and result = 0.23181818181818212 or
repr = "(parameter 0 (return (member isFunction (member $ *))))" and t = "snk" and result = 1.0 or
repr = "(member complete *)" and t = "snk" and result = 0.04499999999999993 or
repr = "(parameter 0 (return (member apply *)))" and t = "snk" and result = 0.25 or
repr = "(parameter 1 (return (member distinct (return (member collection *)))))" and t = "snk" and result = 1.0 or
repr = "(parameter 1 (return (member distinct *)))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member isFunction (return (member noConflict *)))))" and t = "snk" and result = 1.0 or
repr = "(member to (return (member expect (root https://www.npmjs.com/package/chai))))" and t = "snk" and result = 1.0 or
repr = "(return (member sort *))" and t = "snk" and result = 1.0 or
repr = "(return (member set *))" and t = "snk" and result = 0.1487878787878789 or
repr = "(member to (return (member expect *)))" and t = "snk" and result = 0.5151515151515149 or
repr = "(parameter 0 (return (parameter 1 (return (member findOne *)))))" and t = "snk" and result = 1.0 or
repr = "(parameter 1 (return (member info *)))" and t = "snk" and result = 0.375 or
repr = "(member data (parameter label *))" and t = "snk" and result = 1.0 or
repr = "(member not (member to (return (member expect (root https://www.npmjs.com/package/chai)))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member get (return (member request *)))))" and t = "snk" and result = 0.1200000000000001 or
repr = "(parameter 0 (return (member add (member items *))))" and t = "snk" and result = 1.0 or
repr = "(return (root https://www.npmjs.com/package/moment))" and t = "snk" and result = 0.125 or
repr = "(return (member toLowerCase *))" and t = "snk" and result = 0.5761241446725317 or
repr = "(member nextTasks *)" and t = "snk" and result = 0.1499999999999999 or
repr = "(member KPI *)" and t = "snk" and result = 0.2500000000000001 or
repr = "(return (member compact (root https://www.npmjs.com/package/lodash)))" and t = "snk" and result = 0.06212121212121251 or
repr = "(parameter 0 (return (member filter (member _ (global)))))" and t = "snk" and result = 0.5 or
repr = "(member repeatOn *)" and t = "snk" and result = 0.125 or
repr = "(member filterClosed *)" and t = "snk" and result = 0.04486803519061567 or
repr = "(member metrics (parameter 0 (parameter 1 (return (member each *)))))" and t = "snk" and result = 0.2584307359307358 or
repr = "(member metrics *)" and t = "snk" and result = 0.12035714285714286 or
repr = "(member from_id *)" and t = "snk" and result = 0.515151515151515 or
repr = "(return (member findOneAndUpdate *))" and t = "snk" and result = 0.25 or
repr = "(member _id (parameter article (parameter 0 (return (member then *)))))" and t = "snk" and result = 0.9848484848484851 or
repr = "(member _id (parameter 0 (parameter 0 (return (member then *)))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (parameter 0 (return (member createFromHtml (member element *)))))" and t = "snk" and result = 0.8200000000000003 or
repr = "(parameter 0 (return (member setStartAt (return (member clone *)))))" and t = "snk" and result = 0.5 or
repr = "(member data-cke-saved-href *)" and t = "snk" and result = 1.0 or
repr = "(member console (global))" and t = "snk" and result = 0.5633333333333334 or
repr = "(parameter 1 (return (member data (member $element *))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member toValue *)))" and t = "snk" and result = 1.0 or
repr = "(parameter 1 (return (member max *)))" and t = "snk" and result = 0.6699999999999999 or
repr = "(member type *)" and t = "snk" and result = 0.24181994562899423 or
repr = "(parameter 0 (return (member appendTo *)))" and t = "snk" and result = 0.489126717125998 or
repr = "(parameter 1 (return (member isInsidePlot *)))" and t = "snk" and result = 0.4189944134078212 or
repr = "(parameter 0 (return (member slice (return (member slice *)))))" and t = "snk" and result = 0.875 or
repr = "(parameter 0 (return (member isFinite (global))))" and t = "snk" and result = 0.25 or
repr = "(member document (member window (global)))" and t = "snk" and result = 0.4885138932609648 or
repr = "(parameter 1 (return (member replaceRange *)))" and t = "snk" and result = 0.1813186813186813 or
repr = "(parameter 0 (return (member translate *)))" and t = "snk" and result = 0.3 or
repr = "(parameter 0 (return (member pow *)))" and t = "snk" and result = 1.0 or
repr = "(member createElement *)" and t = "snk" and result = 0.15822784810126583 or
repr = "(return (member load *))" and t = "snk" and result = 0.13661202185792354 or
repr = "(member sel (member doc *))" and t = "snk" and result = 0.5075757575757573 or
repr = "(return (member transformToArrayFormat *))" and t = "snk" and result = 1.0 or
repr = "(member line (return (member getCursor (parameter cm *))))" and t = "snk" and result = 0.15445054945054937 or
repr = "(parameter 0 (return (member getAttribute *)))" and t = "snk" and result = 0.15624999999999997 or
repr = "(return (member eq (return (member jQuery (global)))))" and t = "snk" and result = 1.0 or
repr = "(member sel *)" and t = "snk" and result = 0.25 or
repr = "(member hints *)" and t = "snk" and result = 0.5050505050505052 or
repr = "(member plugin *)" and t = "snk" and result = 0.625 or
repr = "(parameter 0 (return (member warn *)))" and t = "snk" and result = 0.125 or
repr = "(parameter 2 (return (member replaceRange *)))" and t = "snk" and result = 0.18131868131868134 or
repr = "(parameter 1 (return (member bind (return (member bind *)))))" and t = "snk" and result = 0.0492083197301848 or
repr = "(parameter 0 (return (member reject *)))" and t = "snk" and result = 0.13661202185792354 or
repr = "(parameter 1 (return (member min (member Math (global)))))" and t = "snk" and result = 0.1600000000000001 or
repr = "(parameter 1 (return (member apply (member push *))))" and t = "snk" and result = 0.25097681430816143 or
repr = "(return (member $ (member tools *)))" and t = "snk" and result = 0.5026061676456787 or
repr = "(member nodeName (parameter target *))" and t = "snk" and result = 0.032720217484023095 or
repr = "(member curHoverNode *)" and t = "snk" and result = 0.8928571428571428 or
repr = "(member player *)" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member ltrim (member tools *))))" and t = "snk" and result = 0.5 or
repr = "(member player (return (member w (member Ud *))))" and t = "snk" and result = 1.0 or
repr = "(member address *)" and t = "snk" and result = 1.0 or
repr = "(member startContainer *)" and t = "snk" and result = 0.14963888014473703 or
repr = "(member player (return (member w (member Td (global)))))" and t = "snk" and result = 0.5698158051099218 or
repr = "(return (member then (return (member all *))))" and t = "snk" and result = 0.5 or
repr = "(member address (member email *))" and t = "snk" and result = 0.0517979476592301 or
repr = "(parameter 0 (return (member call (member indexOf (member prototype *)))))" and t = "snk" and result = 1.0 or
repr = "(member path (return (member call *)))" and t = "snk" and result = 1.0 or
repr = "(return (member parseInt (global)))" and t = "snk" and result = 0.04782800711223631 or
repr = "(parameter 0 (return (member transformToArrayFormat (member data *))))" and t = "snk" and result = 0.4042103340678424 or
repr = "(member tagName *)" and t = "snk" and result = 0.24181994562899423 or
repr = "(parameter 1 (return (member $emit *)))" and t = "snk" and result = 1.0 or
repr = "(member old (return (member extend (member $ *))))" and t = "snk" and result = 1.0 or
repr = "(return (member output *))" and t = "snk" and result = 0.15619221554411933 or
repr = "(return (member $ *))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member clearTimeout (parameter window *))))" and t = "snk" and result = 0.5 or
repr = "(parameter 1 (return (member attr *)))" and t = "snk" and result = 0.692401544894962 or
repr = "(member path (return (member applyOptions (member prototype (member Point *)))))" and t = "snk" and result = 1.0 or
repr = "(return (member join (return (member split *))))" and t = "snk" and result = 0.5501411167589166 or
repr = "(parameter 0 (return (member appendChild (member container *))))" and t = "snk" and result = 0.13005050505050503 or
repr = "(parameter 2 (return (member style (member jQuery *))))" and t = "snk" and result = 1.0 or
repr = "(return (member replace (return (member encodeURIComponent (global)))))" and t = "snk" and result = 0.06691313774087981 or
repr = "(member _id *)" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member output (return (member addTemplate *)))))" and t = "snk" and result = 0.5 or
repr = "(member d *)" and t = "snk" and result = 0.10089823391138153 or
repr = "(parameter 1 (return (member trigger *)))" and t = "snk" and result = 0.5 or
repr = "(member left *)" and t = "snk" and result = 0.02693035529678632 or
repr = "(return (member limit (return (member find *))))" and t = "snk" and result = 0.39747135713489345 or
repr = "(parameter 2 (return (member style (member jQuery (parameter window *)))))" and t = "snk" and result = 1.0 or
repr = "(parameter 0 (return (member isInsidePlot (instance (member Series *)))))" and t = "snk" and result = 0.4189944134078212 or
repr = "(return (member invoke (parameter $injector *)))" and t = "snk" and result = 0.7 or
repr = "(return (member jQuery (global)))" and t = "snk" and result = 0.489126717125998 or
repr = "(parameter 2 (return (member style (member $ *))))" and t = "snk" and result = 0.272727272727273 or
repr = "(return (parameter $ *))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member extend (parameter $ *))))" and t = "snk" and result = 0.2030267367231416 or
repr = "(parameter 3 (return (member arc *)))" and t = "snk" and result = 0.25 or
repr = "(parameter 0 (return (member Function (global))))" and t = "snk" and result = 0.25 or
repr = "(parameter 1 (return (member setChkClass (member view (member _z *)))))" and t = "snk" and result = 0.7575757575757576 or
repr = "(member old *)" and t = "snk" and result = 1.0 or
repr = "(parameter 1 (return (member data (root https://www.npmjs.com/package/jquery))))" and t = "snk" and result = 0.5428453372021438 or
repr = "(member path (return (member applyOptions *)))" and t = "snk" and result = 0.20588235294117668 or
repr = "(parameter 0 (return (member clearInterval *)))" and t = "snk" and result = 0.25 or
repr = "(parameter 1 (return (member data (parameter $element *))))" and t = "snk" and result = 0.5151515151515149 or
repr = "(member frag (parameter b *))" and t = "snk" and result = 0.31645569620253156 or
repr = "(member component *)" and t = "snk" and result = 0.2732240437158471 or
repr = "(parameter 0 (return (member append (instance (member documentFragment *)))))" and t = "snk" and result = 0.1338262754817625 or
repr = "(return (member update *))" and t = "snk" and result = 0.4999999999999999 or
repr = "(parameter 0 (return (member insertNode *)))" and t = "snk" and result = 0.08000000000000002 or
repr = "(parameter 0 (return (member attr *)))" and t = "snk" and result = 0.25 or
repr = "(parameter 1 (return (member trigger (member treeObj *))))" and t = "snk" and result = 0.16999999999999998 or
repr = "(member line *)" and t = "snk" and result = 0.395 or
repr = "(parameter 0 (return (member ajax (member jQuery (global)))))" and t = "snk" and result = 0.13636363636363596 or
repr = "(parameter 2 (return (member rect (member renderer (member chart *)))))" and t = "snk" and result = 0.5861657162961826 or
repr = "(parameter 1 (return (member jQuery (global))))" and t = "snk" and result = 0.8474046396794128 or
repr = "(member right *)" and t = "snk" and result = 0.08757575757575768 or
repr = "(parameter 2 (return (member rect *)))" and t = "snk" and result = 0.5501979200674537 or
repr = "(parameter 2 (return (member data *)))" and t = "snk" and result = 0.5 or
repr = "(member old (return (member extend (return (member noConflict *)))))" and t = "snk" and result = 0.29166666666666674 or
repr = "(return (member compressSpaces *))" and t = "snk" and result = 0.11617372451823749 or
repr = "(return (member substr (return (member replace *))))" and t = "snk" and result = 0.4100000000000002 or
repr = "(parameter 0 (parameter 0 (return (member round *))))" and t = "snk" and result = 0.1545454545454545 or
repr = "(parameter 0 (return (member bind (return (member bind *)))))" and t = "snk" and result = 0.0492083197301848 or
repr = "(parameter 0 (return (member setValue *)))" and t = "snk" and result = 0.08000000000000002 or
repr = "(parameter 0 (return (member call (member indexOf *))))" and t = "snk" and result = 0.07947133704953327 or
repr = "(member noop *)" and t = "snk" and result = 0.5 or
repr = "(parameter 1 (return (parameter $ *)))" and t = "snk" and result = 0.1417220774465851 or
repr = "(member elem (member currentActive *))" and t = "snk" and result = 1.0 or
repr = "(return (member extend (member tools *)))" and t = "snk" and result = 0.3277708211307623 or
repr = "(return (member translatePath *))" and t = "snk" and result = 0.353647220634073 or
repr = "(member createDocumentFragment *)" and t = "snk" and result = 0.31645569620253156 or
repr = "(parameter 4 (return (member arc (member symbols *))))" and t = "snk" and result = 0.7575757575757576 or
repr = "(return (member getPlotLinePath *))" and t = "snk" and result = 0.053446334805128094 or
repr = "(parameter 0 (return (member load *)))" and t = "snk" and result = 0.27322404371584696 or
repr = "(member root *)" and t = "snk" and result = 0.034424571945489535 or
repr = "(member noop (member angular (parameter window *)))" and t = "snk" and result = 0.32843137254901955 or
repr = "(member helper (member current (member ddmanager (member ui *))))" and t = "snk" and result = 0.5322580645161289 or
repr = "(parameter 2 (return (member build *)))" and t = "snk" and result = 0.13282709093215106 or
repr = "(member view (member display (parameter a *)))" and t = "snk" and result = 0.3452282925054572 or
repr = "(member init *)" and t = "snk" and result = 0.2516666666666667 or
repr = "(return (member join (parameter a *)))" and t = "snk" and result = 0.8792975688291199 or
repr = "(parameter 0 (return (member setEndAfter (instance (member range *)))))" and t = "snk" and result = 0.5 or
repr = "(parameter 0 (return (member equals (member startContainer *))))" and t = "snk" and result = 0.28613639945804303
or
repr = "(return (member put *))" and t = "san" and result = 0.75 or
repr = "(return (member annotate (member $injector *)))" and t = "san" and result = 0.7575757575757576 or
repr = "(return (member get (parameter $http *)))" and t = "san" and result = 0.4059573199809252 or
repr = "(return (member get *))" and t = "san" and result = 0.35204434772883386 or
repr = "(return (member replace (member name (parameter window *))))" and t = "san" and result = 1.0 or
repr = "(return (member replace (member name (member window (global)))))" and t = "san" and result = 1.0 or
repr = "(return (member recurse *))" and t = "san" and result = 0.18926087325159915 or
repr = "(return (member replace (member name (global))))" and t = "san" and result = 0.6965151515151515 or
repr = "(return (member create *))" and t = "san" and result = 0.5625 or
repr = "(return (member findOne *))" and t = "san" and result = 0.5108874958759485 or
repr = "(return (member getResolvable *))" and t = "san" and result = 0.25 or
repr = "(return (member getRecordByDomainPromise *))" and t = "san" and result = 0.75 or
repr = "(return (member split (member id *)))" and t = "san" and result = 0.25 or
repr = "(return (member replace *))" and t = "san" and result = 0.361836448891001 or
repr = "(return (member getZoneByNamePromise *))" and t = "san" and result = 0.26 or
repr = "(return (member getUserIdPromise *))" and t = "san" and result = 0.25 or
repr = "(return (member getHttpHeaderPromise *))" and t = "san" and result = 0.26999999999999985 or
repr = "(return (member getSSLAlgorithmPromise *))" and t = "san" and result = 0.46399999999999997 or
repr = "(return (member getSSLAlgorithmByZonePromise *))" and t = "san" and result = 0.28600000000000003 or
repr = "(return (member getRecordsByZonePromise *))" and t = "san" and result = 0.26 or
repr = "(return (member html (root https://www.npmjs.com/package/secure-filters)))" and t = "san" and result = 0.5399999999999999 or
repr = "(return (member getRecordByZonePromise *))" and t = "san" and result = 0.5 or
repr = "(return (member replace (parameter zone *)))" and t = "san" and result = 1.0 or
repr = "(return (member toString *))" and t = "san" and result = 0.308008658008658 or
repr = "(return (member getUnknownHttpHeaderPromise *))" and t = "san" and result = 0.26999999999999985 or
repr = "(return (member getRecordByIPPromise *))" and t = "san" and result = 0.76 or
repr = "(return (member split *))" and t = "san" and result = 0.36188289792078904 or
repr = "(return (member parseInt (global)))" and t = "san" and result = 0.3275266672184366 or
repr = "(return (member exec *))" and t = "san" and result = 0.47525393254975157 or
repr = "(member access *)" and t = "san" and result = 1.0 or
repr = "(return (member call *))" and t = "san" and result = 0.29300598670882533 or
repr = "(return (member str (member util *)))" and t = "san" and result = 0.3433734939759038 or
repr = "(return (member param (instance (member exports *))))" and t = "san" and result = 0.2500000000000002 or
repr = "(return (member expr (parameter t *)))" and t = "san" and result = 0.033050000000000024 or
repr = "(return (member render *))" and t = "san" and result = 0.18191041666666666 or
repr = "(return (member join (return (member reverse *))))" and t = "san" and result = 0.39462344696969703 or
repr = "(return (member decodeURIComponent (global)))" and t = "san" and result = 0.023537500000000044 or
repr = "(return (member transform (member prototype (member exports *))))" and t = "san" and result = 1.0 or
repr = "(return (member array *))" and t = "san" and result = 0.75 or
repr = "(return (member config (parameter t *)))" and t = "san" and result = 0.5 or
repr = "(member params *)" and t = "san" and result = 0.25 or
repr = "(return (member slice (parameter t *)))" and t = "san" and result = 0.31938446969696965 or
repr = "(return (member addParamsToUrl *))" and t = "san" and result = 0.5990250000000001 or
repr = "(return (member bind *))" and t = "san" and result = 0.2850000000000001 or
repr = "(return (member h *))" and t = "san" and result = 0.12392045454545453 or
repr = "(return (member duplicate (return (parameter t *))))" and t = "san" and result = 1.0 or
repr = "(return (member comparator *))" and t = "san" and result = 0.5 or
repr = "(return (member map *))" and t = "san" and result = 0.36414112059165366 or
repr = "(return (member indexOf *))" and t = "san" and result = 0.21875 or
repr = "(return (member createElement (member document_ *)))" and t = "san" and result = 0.5811742424242424 or
repr = "(return (member ingest (member Tuple *)))" and t = "san" and result = 1.0 or
repr = "(return (member String (global)))" and t = "san" and result = 0.473117469879518 or
repr = "(return (member concat *))" and t = "san" and result = 0.3228314064181071 or
repr = "(return (member freeze (member Object (global))))" and t = "san" and result = 1.0 or
repr = "(return (member listen *))" and t = "san" and result = 0.5 or
repr = "(return (member signalRef *))" and t = "san" and result = 0.25 or
repr = "(return (member create (member Object (global))))" and t = "san" and result = 0.5 or
repr = "(return (member dict *))" and t = "san" and result = 0.5 or
repr = "(return (member scale (member exports (parameter e *))))" and t = "san" and result = 0.015151515151514913 or
repr = "(member _svg *)" and t = "san" and result = 0.8842045454545455 or
repr = "(return (member start *))" and t = "san" and result = 0.13365833333333332 or
repr = "(return (member child *))" and t = "san" and result = 0.25215909090909094 or
repr = "(return (member m *))" and t = "san" and result = 0.06830601092896174 or
repr = "(parameter 0 (parameter 1 (return (member assign *))))" and t = "san" and result = 0.7575757575757576 or
repr = "(return (member Number (global)))" and t = "san" and result = 0.5494339196418617 or
repr = "(return (member fn *))" and t = "san" and result = 0.5 or
repr = "(member returnValue *)" and t = "san" and result = 0.125 or
repr = "(return (member startOf *))" and t = "san" and result = 0.009174747474747426 or
repr = "(return (member createElementNS *))" and t = "san" and result = 0.24784090909090906 or
repr = "(return (member substr *))" and t = "san" and result = 0.15097499999999997 or
repr = "(return (member ingest *))" and t = "san" and result = 0.15855075757575732 or
repr = "(member maskset (instance (return (member factory (parameter exports *)))))" and t = "san" and result = 0.6401515151515151 or
repr = "(return (member UTC (member Date (global))))" and t = "san" and result = 0.53305 or
repr = "(return (member charCodeAt *))" and t = "san" and result = 0.22671616809116812 or
repr = "(return (member getDetail *))" and t = "san" and result = 0.25 or
repr = "(return (member getByTagSpecId *))" and t = "san" and result = 0.16666666666666666 or
repr = "(member scale (parameter e *))" and t = "san" and result = 0.7575757575757576 or
repr = "(return (member join (return (member map *))))" and t = "san" and result = 0.8125 or
repr = "(return (member sort (return (member map *))))" and t = "san" and result = 0.027083333333333348 or
repr = "(return (member a *))" and t = "san" and result = 0.06830601092896174 or
repr = "(return (member evaluateBindings *))" and t = "san" and result = 0.25 or
repr = "(return (member slice (return (member slice *))))" and t = "san" and result = 0.16901947987871613 or
repr = "(parameter 0 (return (member push *)))" and t = "san" and result = 0.24763457132995165 or
repr = "(return (member max *))" and t = "san" and result = 0.5 or
repr = "(return (member deleteModifier *))" and t = "san" and result = 0.14027499999999998 or
repr = "(return (member round (member Math (global))))" and t = "san" and result = 0.456 or
repr = "(return (member parseFloat (global)))" and t = "san" and result = 0.29244444444444445 or
repr = "(return (member param *))" and t = "san" and result = 1.0 or
repr = "(return (member getData *))" and t = "san" and result = 0.5 or
repr = "(member property *)" and t = "san" and result = 0.44474687048192785 or
repr = "(return (member getParentWindowFrameElement *))" and t = "san" and result = 0.19999999999999998 or
repr = "(return (member scale (member exports *)))" and t = "san" and result = 1.0 or
repr = "(return (member apply *))" and t = "san" and result = 0.2624948640540746 or
repr = "(return (member last *))" and t = "san" and result = 0.375 or
repr = "(return (member replace (return (member replace *))))" and t = "san" and result = 0.5541038191908221 or
repr = "(return (member def *))" and t = "san" and result = 0.3125 or
repr = "(return (member predicate *))" and t = "san" and result = 0.75 or
repr = "(return (member assertElement *))" and t = "san" and result = 0.10753787878787868 or
repr = "(return (member trim *))" and t = "san" and result = 0.6515272556390977 or
repr = "(return (member join *))" and t = "san" and result = 0.2906565656565656 or
repr = "(return (member map (return (member field *))))" and t = "san" and result = 0.75 or
repr = "(return (member from *))" and t = "san" and result = 0.25 or
repr = "(return (parameter _dereq_ *))" and t = "san" and result = 0.25 or
repr = "(return (member filter *))" and t = "san" and result = 0.47941434626685997 or
repr = "(return (member ToPrimitive *))" and t = "san" and result = 0.1907894736842105 or
repr = "(return (member str (member util (member encode *))))" and t = "san" and result = 1.0 or
repr = "(return (member parseJson *))" and t = "san" and result = 0.544 or
repr = "(return (parameter t *))" and t = "san" and result = 0.2858736111111111 or
repr = "(return (member toLocaleLowerCase *))" and t = "san" and result = 0.2801453888888889 or
repr = "(member message *)" and t = "san" and result = 0.3666666666666667 or
repr = "(return (member transform (member prototype *)))" and t = "san" and result = 0.17921686746988005 or
repr = "(member s *)" and t = "san" and result = 0.48607954545454546 or
repr = "(return (member clone *))" and t = "san" and result = 0.27951844444444446 or
repr = "(return (member createElement (member document (global))))" and t = "san" and result = 0.5731522460574797 or
repr = "(return (member pop *))" and t = "san" and result = 0.447577096884181 or
repr = "(return (member assertElement (return (member dev *))))" and t = "san" and result = 1.0 or
repr = "(return (member extend *))" and t = "san" and result = 0.47333333333333333 or
repr = "(member pathCache *)" and t = "san" and result = 0.25 or
repr = "(return (member transform *))" and t = "san" and result = 0.75 or
repr = "(return (member day *))" and t = "san" and result = 0.008461951515151556 or
repr = "(return (return (parameter t *)))" and t = "san" and result = 0.5 or
repr = "(return (member parse (return (parameter t *))))" and t = "san" and result = 0.5395166666666666 or
repr = "(return (member ToNumber *))" and t = "san" and result = 0.08881578947368424 or
repr = "(return (member Array (global)))" and t = "san" and result = 0.31333333333333335 or
repr = "(return (member devAssert *))" and t = "san" and result = 0.19999999999999998 or
repr = "(return (member slice *))" and t = "san" and result = 0.39224823997551267 or
repr = "(return (member parse *))" and t = "san" and result = 0.426748713815736 or
repr = "(return (member expr *))" and t = "san" and result = 0.46695 or
repr = "(return (member valueOf *))" and t = "san" and result = 0.5 or
repr = "(return (parameter n *))" and t = "san" and result = 0.64 or
repr = "(return (member encodeURIComponent (global)))" and t = "san" and result = 0.38071805555555555 or
repr = "(return (member toLowerCase *))" and t = "san" and result = 0.1712928429002156 or
repr = "(return (member createElement *))" and t = "san" and result = 0.27245553895975744 or
repr = "(return (member scale *))" and t = "san" and result = 0.5 or
repr = "(member password *)" and t = "san" and result = 0.25189393939393934 or
repr = "(return (member stringify (member JSON (global))))" and t = "san" and result = 0.6454439393939393 or
repr = "(member temporaryToken *)" and t = "san" and result = 0.125 or
repr = "(member token *)" and t = "san" and result = 0.125 or
repr = "(return (member convertValuesToStep *))" and t = "san" and result = 0.04999999999999999 or
repr = "(member teams *)" and t = "san" and result = 0.16815028201957166 or
repr = "(return (member toString (member jugend (member IDs *))))" and t = "san" and result = 1.0 or
repr = "(return (member calcSpielDateTime *))" and t = "san" and result = 0.38661202185792354 or
repr = "(return (member toString (member _id *)))" and t = "san" and result = 0.6057575757575755 or
repr = "(member spielplan *)" and t = "san" and result = 0.15 or
repr = "(return (member toString (member jugend *)))" and t = "san" and result = 1.0 or
repr = "(return (member map (return (member filter *))))" and t = "san" and result = 0.5808822857285545 or
repr = "(member gruppen *)" and t = "san" and result = 0.23690433272758038 or
repr = "(member unusedTeams *)" and t = "san" and result = 0.24999999999999994 or
repr = "(return (parameter 0 (return (member map *))))" and t = "san" and result = 0.24166666666666664 or
repr = "(return (member expect (root https://www.npmjs.com/package/chai)))" and t = "san" and result = 0.6893939393939394 or
repr = "(member veranstaltung *)" and t = "san" and result = 0.14999999999999997 or
repr = "(member _model *)" and t = "san" and result = 0.35 or
repr = "(return (parameter 0 (return (member then *))))" and t = "san" and result = 0.3279259165053422 or
repr = "(return (member parse (member JSON (global))))" and t = "san" and result = 0.5835748563983659 or
repr = "(return (member post (member $http *)))" and t = "san" and result = 0.4 or
repr = "(member menu *)" and t = "san" and result = 0.25 or
repr = "(return (member extend (member jQuery (global))))" and t = "san" and result = 0.855253742241694 or
repr = "(return (member add *))" and t = "san" and result = 0.32717363137591887 or
repr = "(return (member random (global)))" and t = "san" and result = 0.28733766233766234 or
repr = "(member version *)" and t = "san" and result = 0.6060606060606061 or
repr = "(return (member floor *))" and t = "san" and result = 0.4253246753246753 or
repr = "(return (member get (member DOM *)))" and t = "san" and result = 0.4253246753246753 or
repr = "(return (member add (member Event *)))" and t = "san" and result = 0.5800000000000001 or
repr = "(return (member min (member Math (global))))" and t = "san" and result = 0.47551515151515156 or
repr = "(return (member extend (parameter $ *)))" and t = "san" and result = 0.5109717868338557 or
repr = "(return (member get (member default (root https://www.npmjs.com/package/axios))))" and t = "san" and result = 0.13961038961038966 or
repr = "(member seller *)" and t = "san" and result = 0.541125541125541 or
repr = "(return (member add (member DOM *)))" and t = "san" and result = 0.34522803795531054 or
repr = "(member desc *)" and t = "san" and result = 0.5 or
repr = "(return (parameter stripAndCollapse *))" and t = "san" and result = 0.25 or
repr = "(parameter 0 (return (parameter stripAndCollapse *)))" and t = "san" and result = 0.7575757575757576 or
repr = "(return (member then *))" and t = "san" and result = 0.2290112238214094 or
repr = "(return (member template *))" and t = "san" and result = 0.17953815261044165 or
repr = "(return (member callExpression *))" and t = "san" and result = 0.07746151271753682 or
repr = "(member path (parameter 0 (return (member push *))))" and t = "san" and result = 0.051485943775100296 or
repr = "(return (member stringify *))" and t = "san" and result = 0.36076122672508176 or
repr = "(return (member slice (member url *)))" and t = "san" and result = 0.29943238554216856 or
repr = "(return (member variableDeclarator *))" and t = "san" and result = 0.6185642570281126 or
repr = "(return (member identifier *))" and t = "san" and result = 0.07746151271753682 or
repr = "(return (member blockStatement *))" and t = "san" and result = 0.6589175361445785 or
repr = "(return (member substring *))" and t = "san" and result = 0.45496184738955836 or
repr = "(return (member unique *))" and t = "san" and result = 0.25 or
repr = "(return (member cast (instance (member constructor *))))" and t = "san" and result = 0.9653679653679653 or
repr = "(return (member blockStatement (member builders *)))" and t = "san" and result = 0.42441579718875505 or
repr = "(return (member fromNumber (member Long (member BSON (root https://www.npmjs.com/package/mongodb-core)))))" and t = "san" and result = 1.0 or
repr = "(return (member indexOf (member stack *)))" and t = "san" and result = 0.9999999999999999 or
repr = "(return (member fromNumber (member Long *)))" and t = "san" and result = 1.0 or
repr = "(return (member db *))" and t = "san" and result = 0.3590763052208833 or
repr = "(member name (parameter 0 (return (member push *))))" and t = "san" and result = 0.7181526104417666 or
repr = "(return (member flatten *))" and t = "san" and result = 0.375 or
repr = "(return (member join (root https://www.npmjs.com/package/path)))" and t = "san" and result = 0.24166666666666667 or
repr = "(return (member slice (parameter 0 (member load *))))" and t = "san" and result = 1.0 or
repr = "(return (member toString (parameter err *)))" and t = "san" and result = 0.6666666666666667 or
repr = "(member stack *)" and t = "san" and result = 0.3590763052208833 or
repr = "(return (member parseAuthorizationHeader *))" and t = "san" and result = 0.5 or
repr = "(parameter 0 (return (member parse (member JSON (global)))))" and t = "san" and result = 0.6298032493610812 or
repr = "(parameter 0 (return (member camelCase (return (member noConflict *)))))" and t = "san" and result = 1.0 or
repr = "(return (member literal *))" and t = "san" and result = 0.07746151271753682 or
repr = "(return (member blockStatement (member builders (member types (root https://www.npmjs.com/package/recast)))))" and t = "san" and result = 1.0 or
repr = "(parameter 2 (return (member format (root https://www.npmjs.com/package/util))))" and t = "san" and result = 0.3816447909284196 or
repr = "(parameter 0 (return (member stringify (member JSON (global)))))" and t = "san" and result = 0.6775757575757575 or
repr = "(return (member objectExpression *))" and t = "san" and result = 0.07746151271753682 or
repr = "(return (member split (return (member replace *))))" and t = "san" and result = 0.9004618473895585 or
repr = "(return (member unauthorized *))" and t = "san" and result = 0.5 or
repr = "(return (member slice (parameter e *)))" and t = "san" and result = 0.1713069397590361 or
repr = "(member main *)" and t = "san" and result = 0.17953815261044165 or
repr = "(return (member memberExpression *))" and t = "san" and result = 0.07746151271753682 or
repr = "(return (member ObjectId (member Types (return (member set *)))))" and t = "san" and result = 0.7142857142857143 or
repr = "(member $in *)" and t = "san" and result = 0.75 or
repr = "(return (member parse (return (parameter _dereq_ *))))" and t = "san" and result = 0.1777388761361235 or
repr = "(return (member post *))" and t = "san" and result = 0.5512048192771084 or
repr = "(return (member relative (root https://www.npmjs.com/package/path)))" and t = "san" and result = 1.0 or
repr = "(return (member keys *))" and t = "san" and result = 0.07046184738955841 or
repr = "(member _castError (instance (member constructor (member prototype (member constructor *)))))" and t = "san" and result = 0.2821428571428572 or
repr = "(return (member reduce *))" and t = "san" and result = 0.5419463087248322 or
repr = "(parameter 0 (return (member camelCase (member $ *))))" and t = "san" and result = 0.6249999999999996 or
repr = "(return (member arrayExpression *))" and t = "san" and result = 0.07746151271753682 or
repr = "(parameter 0 (return (member camelCase (member constructor (member prototype *)))))" and t = "san" and result = 1.0 or
repr = "(return (member toHexString *))" and t = "san" and result = 0.05737268346111715 or
repr = "(return (member call (member toString (member prototype *))))" and t = "san" and result = 0.43999999999999995 or
repr = "(return (member concat (member body *)))" and t = "san" and result = 1.0 or
repr = "(return (member parseStackAndMessage *))" and t = "san" and result = 0.25 or
repr = "(return (member fromNumber (member Long (member BSON *))))" and t = "san" and result = 1.0 or
repr = "(member email (parameter 0 (return (member insert *))))" and t = "san" and result = 1.0 or
repr = "(member _id (parameter 0 (return (member find *))))" and t = "san" and result = 1.0 or
repr = "(return (member fetch *))" and t = "san" and result = 0.17703862660944214 or
repr = "(return (member exports *))" and t = "san" and result = 0.3355704697986577 or
repr = "(return (member getComponent (member props *)))" and t = "san" and result = 0.33149678604224037 or
repr = "(return (parameter e *))" and t = "san" and result = 0.4161073825503356 or
repr = "(return (member render (parameter 0 (return (member createClass *)))))" and t = "san" and result = 0.6666666666666669 or
repr = "(parameter 1 (return (member call *)))" and t = "san" and result = 0.20399000268479275 or
repr = "(member creator_id *)" and t = "san" and result = 0.5 or
repr = "(member url *)" and t = "san" and result = 0.8959227467811157 or
repr = "(return (member default *))" and t = "san" and result = 0.506019313304721 or
repr = "(member exports (parameter 1 (return (member call *))))" and t = "san" and result = 0.25000000000000017 or
repr = "(return (member mountComponent (return (parameter n *))))" and t = "san" and result = 0.5 or
repr = "(return (member write *))" and t = "san" and result = 0.20574034334763946 or
repr = "(member osversion (return (member _detect (return (member _detect *)))))" and t = "san" and result = 0.16094420600858358 or
repr = "(return (member end *))" and t = "san" and result = 0.20574034334763946 or
repr = "(return (member getComponent (parameter 1 (return (member createElement *)))))" and t = "san" and result = 1.0 or
repr = "(return (return (member default *)))" and t = "san" and result = 0.66 or
repr = "(return (member resolve *))" and t = "san" and result = 0.375 or
repr = "(member exports (return (return (parameter n *))))" and t = "san" and result = 1.0 or
repr = "(return (parameter r *))" and t = "san" and result = 0.6287878787878788 or
repr = "(member _dispatchInstances *)" and t = "san" and result = 0.12664254274589468 or
repr = "(return (member match (parameter e *)))" and t = "san" and result = 0.25751072961373395 or
repr = "(return (member call (parameter e *)))" and t = "san" and result = 0.9312588977018503 or
repr = "(return (member getNodeFromInstance *))" and t = "san" and result = 0.5 or
repr = "(return (return (parameter n *)))" and t = "san" and result = 0.25 or
repr = "(member version (return (member _detect (return (member _detect *)))))" and t = "san" and result = 0.3901677721420211 or
repr = "(return (member getPooled *))" and t = "san" and result = 0.75 or
repr = "(parameter 0 (return (member concat (return (member concat *)))))" and t = "san" and result = 0.7290772532188843 or
repr = "(member picture_id (parameter 0 (return (member find *))))" and t = "san" and result = 1.0 or
repr = "(return (member getNodeFromInstance (return (parameter n *))))" and t = "san" and result = 1.0 or
repr = "(return (member render (parameter 0 (member default *))))" and t = "san" and result = 1.0 or
repr = "(member email (parameter 0 (return (member findOne *))))" and t = "san" and result = 1.0 or
repr = "(parameter 2 (return (member call *)))" and t = "san" and result = 1.0 or
repr = "(return (member extractEvents *))" and t = "san" and result = 0.30203862660944214 or
repr = "(return (member map (parameter e *)))" and t = "san" and result = 0.5800000000000001 or
repr = "(return (member compose_node (instance (member Composer *))))" and t = "san" and result = 0.35551657272868287 or
repr = "(return (member styles *))" and t = "san" and result = 0.04351931330472111 or
repr = "(return (member construct_object *))" and t = "san" and result = 0.75 or
repr = "(return (member slice (member input *)))" and t = "san" and result = 0.5624999999999999 or
repr = "(return (member access *))" and t = "san" and result = 0.11619047619047616 or
repr = "(return (member getFile *))" and t = "san" and result = 0.5 or
repr = "(return (member keys (member Object (global))))" and t = "san" and result = 0.2008032128514056 or
repr = "(return (member substring (member 0 (member params (parameter req *)))))" and t = "san" and result = 0.0711515151515149 or
repr = "(return (member catch (return (member then *))))" and t = "san" and result = 0.3012048192771084 or
repr = "(member modified *)" and t = "san" and result = 1.0 or
repr = "(return (member substring (member pathname *)))" and t = "san" and result = 0.23099999999999998 or
repr = "(member text *)" and t = "san" and result = 0.8151515151515152 or
repr = "(return (member push *))" and t = "san" and result = 0.013162209344440345 or
repr = "(return (member css *))" and t = "san" and result = 0.3866666666666667 or
repr = "(return (member substring (member originalUrl *)))" and t = "san" and result = 0.4885757575757575 or
repr = "(return (member get (instance (parameter LRU *))))" and t = "san" and result = 1.0 or
repr = "(return (member merge (parameter ConfigOps *)))" and t = "san" and result = 0.5 or
repr = "(return (member lookup (member Reference (root https://www.npmjs.com/package/nodegit))))" and t = "san" and result = 0.15223541675298613 or
repr = "(return (member reject (root https://www.npmjs.com/package/bluebird)))" and t = "san" and result = 0.5512631894849817 or
repr = "(return (member basename (root https://www.npmjs.com/package/path)))" and t = "san" and result = 0.5 or
repr = "(return (member substring (member Location *)))" and t = "san" and result = 0.008575757575757223 or
repr = "(return (member join (return (member slice *))))" and t = "san" and result = 0.15000000000000002 or
repr = "(member Id *)" and t = "san" and result = 0.55775 or
repr = "(return (member cfRequest *))" and t = "san" and result = 0.23623045861282266 or
repr = "(return (member get (return (root https://www.npmjs.com/package/javascript/lru))))" and t = "san" and result = 1.0 or
repr = "(member instances *)" and t = "san" and result = 0.014619082774354641 or
repr = "(return (member name *))" and t = "san" and result = 0.5 or
repr = "(return (member substring (member 0 (member params *))))" and t = "san" and result = 1.0 or
repr = "(return (member parse (root https://www.npmjs.com/package/url)))" and t = "san" and result = 0.7088244079945856 or
repr = "(return (member decodeURIComponent *))" and t = "san" and result = 0.49000000000000005 or
repr = "(return (member getOffsetAtLocation *))" and t = "san" and result = 0.5 or
repr = "(return (member handle *))" and t = "san" and result = 0.040278096810113566 or
repr = "(return (member parseMaybeAssign (instance (member Parser *))))" and t = "san" and result = 0.11912900658432385 or
repr = "(return (member get (return (parameter LRU *))))" and t = "san" and result = 0.33057868691980735 or
repr = "(member callbacks *)" and t = "san" and result = 0.3057670623170956 or
repr = "(return (member assign *))" and t = "san" and result = 0.4345549411049744 or
repr = "(return (member importantChange (parameter jsProject *)))" and t = "san" and result = 0.7575757575757573 or
repr = "(return (member getOffsetAtLocation (instance (member TextView *))))" and t = "san" and result = 1.0 or
repr = "(return (member createTextNode (member document (global))))" and t = "san" and result = 0.16000000000000003 or
repr = "(member now *)" and t = "san" and result = 0.030933333333333368 or
repr = "(member Source *)" and t = "san" and result = 0.6699999999999999 or
repr = "(return (member mapOffset (member editor *)))" and t = "san" and result = 0.7732240437158471 or
repr = "(member mediaElement *)" and t = "san" and result = 0.42 or
repr = "(member convo *)" and t = "san" and result = 0.25 or
repr = "(member mediaElement (parameter 0 (member onstreamended *)))" and t = "san" and result = 1.0 or
repr = "(member count (parameter 0 (return (member find *))))" and t = "san" and result = 1.0 or
repr = "(return (member getElementById (member document (global))))" and t = "san" and result = 0.5 or
repr = "(member data *)" and t = "san" and result = 0.2710843373493975 or
repr = "(member mediaElement (parameter e (member onstreamended *)))" and t = "san" and result = 0.24666666666666648 or
repr = "(member mediaElement (parameter 0 (member onstreamended (member connection *))))" and t = "san" and result = 1.0 or
repr = "(member count *)" and t = "san" and result = 1.0 or
repr = "(member mediaElement (parameter 0 (member onstreamended (parameter connection *))))" and t = "san" and result = 1.0 or
repr = "(return (member toArray *))" and t = "san" and result = 0.4616161616161616 or
repr = "(return (member toObject *))" and t = "san" and result = 0.5 or
repr = "(return (member split (member host *)))" and t = "san" and result = 0.6363636363636364 or
repr = "(return (member map (return (member toArray (root https://www.npmjs.com/package/underscore)))))" and t = "san" and result = 0.2459893048128345 or
repr = "(return (member union (root https://www.npmjs.com/package/underscore)))" and t = "san" and result = 1.0 or
repr = "(return (root https://www.npmjs.com/package/speakingurl))" and t = "san" and result = 1.0 or
repr = "(member room *)" and t = "san" and result = 0.3787878787878788 or
repr = "(member $in (member _id (parameter 0 (return (member find *)))))" and t = "san" and result = 0.8712121212121211 or
repr = "(return (member union *))" and t = "san" and result = 0.5151515151515149 or
repr = "(member value (parameter 0 (return (member setState *))))" and t = "san" and result = 0.16000000000000003 or
repr = "(member pooled *)" and t = "san" and result = 0.5 or
repr = "(member events *)" and t = "san" and result = 0.5 or
repr = "(return (member parse (root https://www.npmjs.com/package/query-string)))" and t = "san" and result = 0.75 or
repr = "(member _dispatchListeners (parameter event *))" and t = "san" and result = 0.0032850854917894144 or
repr = "(return (member replace (member name *)))" and t = "san" and result = 0.8969131377408813 or
repr = "(return (member escape (return (member sanitize (root https://www.npmjs.com/package/validator)))))" and t = "san" and result = 1.0 or
repr = "(return (member escape (return (member sanitize *))))" and t = "san" and result = 0.27272727272727226 or
repr = "(return (member escape *))" and t = "san" and result = 1.0 or
repr = "(return (member camelCase (parameter jQuery *)))" and t = "san" and result = 0.2127777777777778 or
repr = "(return (member build *))" and t = "san" and result = 0.12479889837209936 or
repr = "(return (parameter _super *))" and t = "san" and result = 0.12479889837209938 or
repr = "(return (member datagrid *))" and t = "san" and result = 0.5 or
repr = "(return (member datagrid (return (member $ (global)))))" and t = "san" and result = 1.0 or
repr = "(return (member toString (member period *)))" and t = "san" and result = 1.0 or
repr = "(return (member eval (global)))" and t = "san" and result = 1.0 or
repr = "(return (member toString (member period (member body (parameter req *)))))" and t = "san" and result = 1.0 or
repr = "(return (member toString (member period (member query *))))" and t = "san" and result = 1.0 or
repr = "(member jq *)" and t = "san" and result = 1.0 or
repr = "(return (member extend (root https://www.npmjs.com/package/underscore)))" and t = "san" and result = 0.8333333333333334 or
repr = "(return (member panel (member tab *)))" and t = "san" and result = 0.7796610169491525 or
repr = "(return (parameter $ *))" and t = "san" and result = 0.5033670033670034 or
repr = "(return (member toString (member period (member body *))))" and t = "san" and result = 1.0 or
repr = "(return (member toString (member period (member query (parameter req *)))))" and t = "san" and result = 1.0 or
repr = "(return (member asJson (root https://www.npmjs.com/package/vs/platform/request/common/request)))" and t = "san" and result = 0.16000000000000003 or
repr = "(member textContent *)" and t = "san" and result = 0.5451206277652559 or
repr = "(member className *)" and t = "san" and result = 0.733074035100801 or
repr = "(return (member firstIndex (root https://www.npmjs.com/package/vs/base/common/arrays)))" and t = "san" and result = 0.24999999999999994 or
repr = "(member _modelSelections *)" and t = "san" and result = 0.5 or
repr = "(return (member fromCharCode (member String (global))))" and t = "san" and result = 0.8310544655172363 or
repr = "(return (member toResource (root https://www.npmjs.com/package/vs/workbench/common/editor)))" and t = "san" and result = 0.5 or
repr = "(member extension (parameter 0 (return (member fire *))))" and t = "san" and result = 0.3891184573002754 or
repr = "(member target *)" and t = "san" and result = 0.591796875 or
repr = "(return (member get (member _sessions *)))" and t = "san" and result = 0.625 or
repr = "(return (member toUpperCase *))" and t = "san" and result = 0.75 or
repr = "(return (parameter event *))" and t = "san" and result = 0.8333333333333334 or
repr = "(return (member toErrorMessage (root https://www.npmjs.com/package/vs/base/common/errorMessage)))" and t = "san" and result = 1.0 or
repr = "(member textContent (return (member $ *)))" and t = "san" and result = 0.0609399782953502 or
repr = "(member _selections *)" and t = "san" and result = 0.5 or
repr = "(return (member _createMouseTarget *))" and t = "san" and result = 0.18359375000000003 or
repr = "(return (member toString (parameter e *)))" and t = "san" and result = 0.07000000000000006 or
repr = "(return (member replace (return (member trim *))))" and t = "san" and result = 0.2197938026885395 or
repr = "(return (member createAndFillInContextMenuActions *))" and t = "san" and result = 0.4304407713498623 or
repr = "(return (member createInstance *))" and t = "san" and result = 0.75 or
repr = "(member cursorState *)" and t = "san" and result = 1.0 or
repr = "(member _process *)" and t = "san" and result = 0.17611318973944107 or
repr = "(return (member executeCommand (member _commandService *)))" and t = "san" and result = 1.0 or
repr = "(return (member toEnum (member ScanCodeUtils *)))" and t = "san" and result = 0.7575757575757576 or
repr = "(return (member findAll *))" and t = "san" and result = 0.5 or
repr = "(return (member toString (return (member with *))))" and t = "san" and result = 0.2500000000000001 or
repr = "(member _shouldRender *)" and t = "san" and result = 0.75 or
repr = "(return (member joinPath (root https://www.npmjs.com/package/vs/base/common/resources)))" and t = "san" and result = 0.5 or
repr = "(return (member findRange *))" and t = "san" and result = 0.125 or
repr = "(return (member t *))" and t = "san" and result = 1.0 or
repr = "(return (member join (member posix *)))" and t = "san" and result = 1.0 or
repr = "(member className (parameter e *))" and t = "san" and result = 1.0 or
repr = "(return (member trim (return (member toString *))))" and t = "san" and result = 0.75 or
repr = "(return (member newGestureEvent *))" and t = "san" and result = 0.5069605142332414 or
repr = "(return (member with *))" and t = "san" and result = 0.25 or
repr = "(return (member $ *))" and t = "san" and result = 0.39999999999999997 or
repr = "(return (member toErrorMessage *))" and t = "san" and result = 0.2048192771084337 or
repr = "(return (member createInstance (member instantiationService *)))" and t = "san" and result = 0.11088154269972447 or
repr = "(member stack (parameter err *))" and t = "san" and result = 0.75 or
repr = "(return (member shift *))" and t = "san" and result = 0.19751906887044063 or
repr = "(return (member dirname (root https://www.npmjs.com/package/vs/base/common/resources)))" and t = "san" and result = 0.5 or
repr = "(return (member getCellIndex (member viewModel *)))" and t = "san" and result = 0.375 or
repr = "(return (member setTimeout (global)))" and t = "san" and result = 0.3080694399100616 or
repr = "(member callstack *)" and t = "san" and result = 1.0 or
repr = "(member clientToken *)" and t = "san" and result = 0.7100000000000002 or
repr = "(member visibility *)" and t = "san" and result = 0.25 or
repr = "(return (member trim (member constructor (member fn *))))" and t = "san" and result = 1.0 or
repr = "(return (member test *))" and t = "san" and result = 0.12544305555555557 or
repr = "(return (member index *))" and t = "san" and result = 0.75 or
repr = "(member requestAnimationFrame *)" and t = "san" and result = 0.7575757575757576 or
repr = "(parameter 1 (return (member apply *)))" and t = "san" and result = 0.6600000000000001 or
repr = "(return (member trim (return (member noConflict (member $ *)))))" and t = "san" and result = 1.0 or
repr = "(return (member max (member Math (global))))" and t = "san" and result = 0.75 or
repr = "(return (member trim (return (member noConflict (member jQuery *)))))" and t = "san" and result = 1.0 or
repr = "(member cancelAnimationFrame *)" and t = "san" and result = 0.7575757575757576 or
repr = "(return (member Event (member jQuery (global))))" and t = "san" and result = 0.7575757575757576 or
repr = "(return (member getElementsByTagName *))" and t = "san" and result = 0.25 or
repr = "(return (member trim (return (member noConflict (member constructor *)))))" and t = "san" and result = 0.08895833333333024 or
repr = "(return (member call (member slice *)))" and t = "san" and result = 0.6520454545454538 or
repr = "(return (member trim (member constructor (member prototype (member $ *)))))" and t = "san" and result = 1.0 or
repr = "(return (member sortTree *))" and t = "san" and result = 0.25 or
repr = "(return (member findSkillByName (global)))" and t = "san" and result = 0.5 or
repr = "(return (member find *))" and t = "san" and result = 0.6538683602771362 or
repr = "(return (member findSkillByName *))" and t = "san" and result = 0.375 or
repr = "(return (return (parameter _dereq_ *)))" and t = "san" and result = 0.5050505050505051 or
repr = "(member reference *)" and t = "san" and result = 0.5 or
repr = "(member to *)" and t = "san" and result = 0.2783359058020567 or
repr = "(return (member trim (return (member noConflict *))))" and t = "san" and result = 1.0 or
repr = "(return (member trim (member constructor (member prototype (member constructor *)))))" and t = "san" and result = 1.0 or
repr = "(return (member trim (member constructor (member prototype (member jQuery *)))))" and t = "san" and result = 1.0 or
repr = "(return (member trim (member constructor *)))" and t = "san" and result = 0.8055555555555524 or
repr = "(return (member find (member element *)))" and t = "san" and result = 0.6026694045174539 or
repr = "(return (member slice (member prototype (member Array (global)))))" and t = "san" and result = 0.38257575757575757 or
repr = "(return (member camelCase (member constructor (member prototype (member $ *)))))" and t = "san" and result = 1.0 or
repr = "(return (member trim (member $ (parameter window *))))" and t = "san" and result = 0.9127819548872136 or
repr = "(return (member attr *))" and t = "san" and result = 0.12185706200986292 or
repr = "(return (member fix *))" and t = "san" and result = 0.5825 or
repr = "(return (member then (instance (member Promise (global)))))" and t = "san" and result = 0.556772544724352 or
repr = "(return (member output (return (member addTemplate *))))" and t = "san" and result = 0.2766666666666665 or
repr = "(return (parameter f *))" and t = "san" and result = 0.19775312120059113 or
repr = "(member $trigger (instance (member Constructor *)))" and t = "san" and result = 0.01643449532923189 or
repr = "(return (member drawCircle *))" and t = "san" and result = 0.39999999999999997 or
repr = "(return (member camelCase (member constructor (member prototype (member constructor *)))))" and t = "san" and result = 1.0 or
repr = "(return (member camelCase (member constructor (member prototype (member exports *)))))" and t = "san" and result = 1.0 or
repr = "(return (member toLowerCase (parameter name *)))" and t = "san" and result = 0.8659572317891503 or
repr = "(return (member c2p (parameter axis *)))" and t = "san" and result = 0.8333333333333333 or
repr = "(return (member render (member prototype *)))" and t = "san" and result = 0.1883333333333334 or
repr = "(member height (return (member extend *)))" and t = "san" and result = 1.0 or
repr = "(return (member camelCase (member constructor (member fn *))))" and t = "san" and result = 0.24999999999999467 or
repr = "(return (member append *))" and t = "san" and result = 0.5 or
repr = "(return (member extend (member $ *)))" and t = "san" and result = 1.0 or
repr = "(return (member camelCase (member $ *)))" and t = "san" and result = 1.0 or
repr = "(return (member extend (member $ (global))))" and t = "san" and result = 0.7546987951807229 or
repr = "(member $trigger (instance (member Constructor (member collapse (member fn *)))))" and t = "san" and result = 1.0 or
repr = "(return (member trim (member jQuery (global))))" and t = "san" and result = 1.0 or
repr = "(return (member camelCase (member constructor (member prototype (member jQuery *)))))" and t = "san" and result = 1.0 or
repr = "(return (member call (member slice (member prototype *))))" and t = "san" and result = 0.33406875484063114 or
repr = "(return (member moment *))" and t = "san" and result = 0.10109947473975134 or
repr = "(return (parameter g *))" and t = "san" and result = 0.3616666666666667 or
repr = "(return (member renderFgSegEls *))" and t = "san" and result = 0.4166666666666667 or
repr = "(return (member Zepto (global)))" and t = "san" and result = 0.035714285714285546 or
repr = "(return (member extend (return (member noConflict *))))" and t = "san" and result = 1.0 or
repr = "(return (member camelCase (member constructor (member fn (member jQuery *)))))" and t = "san" and result = 1.0 or
repr = "(return (member extend (member $ (member window (global)))))" and t = "san" and result = 0.578634538152608 or
repr = "(return (member extend (member jQuery *)))" and t = "san" and result = 1.0 or
repr = "(return (member Zepto *))" and t = "san" and result = 0.6876584472134715 or
repr = "(member target (member cache (instance (member qtip (root https://www.npmjs.com/package/jquery.qtip)))))" and t = "san" and result = 0.5227272727272728 or
repr = "(return (member exec (return (member RegExp (global)))))" and t = "san" and result = 0.5537100326574012 or
repr = "(return (member extend (member jQuery (member window (global)))))" and t = "san" and result = 0.9309054399415845 or
repr = "(return (member drawLine (member target *)))" and t = "san" and result = 0.39999999999999997 or
repr = "(member vpn_addr *)" and t = "san" and result = 0.5000000000000016 or
repr = "(member account_addr *)" and t = "san" and result = 1.0 or
repr = "(member client_addr (parameter connection *))" and t = "san" and result = 1.0 or
repr = "(member ip *)" and t = "san" and result = 0.25 or
repr = "(return (member getToken *))" and t = "san" and result = 0.5 or
repr = "(member account_addr (parameter 0 (return (member findOne *))))" and t = "san" and result = 0.7500000000000001 or
repr = "(member client_addr *)" and t = "san" and result = 0.26515151515151414 or
repr = "(member vpn_addr (parameter connection *))" and t = "san" and result = 1.0 or
repr = "(member vpn_addr (parameter connection (parameter 1 (return (member each *)))))" and t = "san" and result = 1.0 or
repr = "(member price_per_GB *)" and t = "san" and result = 0.7575757575757576 or
repr = "(member vpn_addr (parameter 0 (parameter 1 (return (member each *)))))" and t = "san" and result = 1.0 or
repr = "(return (member getToken (member tokens *)))" and t = "san" and result = 1.0 or
repr = "(member account_addr (parameter 0 (return (member findOne (member Node *)))))" and t = "san" and result = 1.0 or
repr = "(return (member match *))" and t = "san" and result = 0.3965086589698046 or
repr = "(member email (member user (member session (parameter req *))))" and t = "san" and result = 1.0 or
repr = "(member text (parameter 0 (instance (member model *))))" and t = "san" and result = 0.25 or
repr = "(member email (parameter 0 (return (member find (member model *)))))" and t = "san" and result = 1.0 or
repr = "(member email (member user (member session *)))" and t = "san" and result = 1.0 or
repr = "(member email *)" and t = "san" and result = 0.6287878787878788 or
repr = "(member email (parameter 0 (return (member find *))))" and t = "san" and result = 1.0 or
repr = "(member email (member user *))" and t = "san" and result = 1.0 or
repr = "(return (member clone (instance (member range *))))" and t = "san" and result = 0.28 or
repr = "(return (member map (root https://www.npmjs.com/package/jquery)))" and t = "san" and result = 1.0 or
repr = "(return (member inArray *))" and t = "san" and result = 0.5151515151515149 or
repr = "(member href (member attributes (parameter a *)))" and t = "san" and result = 0.5606060606060606 or
repr = "(member frontier *)" and t = "san" and result = 1.0 or
repr = "(return (parameter a *))" and t = "san" and result = 0.25 or
repr = "(member dataValue *)" and t = "san" and result = 0.9457861847050937 or
repr = "(return (member getDialog *))" and t = "san" and result = 0.4756959579890221 or
repr = "(instance (member element (member htmlParser (member CKEDITOR (global)))))" and t = "san" and result = 1.0 or
repr = "(member attributes *)" and t = "san" and result = 1.0 or
repr = "(return (member clone (member range *)))" and t = "san" and result = 0.920888880144737 or
repr = "(member style *)" and t = "san" and result = 0.2015197686880506 or
repr = "(member gutters (parameter a *))" and t = "san" and result = 0.2524019333395159 or
repr = "(return (member abs *))" and t = "san" and result = 0.14445421786878138 or
repr = "(member toolbarGroups *)" and t = "san" and result = 0.5 or
repr = "(member distance *)" and t = "san" and result = 0.75 or
repr = "(parameter 0 (return (member extend *)))" and t = "san" and result = 0.5 or
repr = "(return (member Event (root https://www.npmjs.com/package/jquery)))" and t = "san" and result = 1.0 or
repr = "(return (member getFirst *))" and t = "san" and result = 0.37297402309058614 or
repr = "(return (member Event (parameter $ *)))" and t = "san" and result = 0.5151515151515149 or
repr = "(member title *)" and t = "san" and result = 0.3495360280073186 or
repr = "(return (member data *))" and t = "san" and result = 0.39097744360902253 or
repr = "(return (member getComputedStyle *))" and t = "san" and result = 0.4529307282415631 or
repr = "(instance (member element (member htmlParser *)))" and t = "san" and result = 0.47058823529411736 or
repr = "(return (member replace (member style *)))" and t = "san" and result = 0.3181818181818181 or
repr = "(member style (member attributes (parameter a *)))" and t = "san" and result = 0.556055988887707 or
repr = "(return (member match (parameter a *)))" and t = "san" and result = 0.125 or
repr = "(member state *)" and t = "san" and result = 0.21374486575526108 or
repr = "(parameter 0 (return (root https://www.npmjs.com/package/jquery)))" and t = "san" and result = 0.7277069435469059 or
repr = "(return (member getNext *))" and t = "san" and result = 0.23655276239460798 or
repr = "(return (member getAttribute (parameter a *)))" and t = "san" and result = 0.256056610302921 or
repr = "(member frontier (member doc (parameter a *)))" and t = "san" and result = 0.8712121212121211 or
repr = "(return (member getDocumentElement *))" and t = "san" and result = 0.25 or
repr = "(return (member override (member tools *)))" and t = "san" and result = 0.1582278481012658 or
repr = "(return (member removeCustomData *))" and t = "san" and result = 0.125 or
repr = "(parameter 1 (return (member extend (parameter $ *))))" and t = "san" and result = 0.5 or
repr = "(return (root https://www.npmjs.com/package/jquery))" and t = "san" and result = 0.540086506078731 or
repr = "(return (member createBookmark *))" and t = "san" and result = 0.25 or
repr = "(return (member contains (return (member elementPath (member dom *)))))" and t = "san" and result = 0.2500000000000002 or
repr = "(return (member map (parameter $ *)))" and t = "san" and result = 0.3901515151515149 or
repr = "(member href *)" and t = "san" and result = 1.0 or
repr = "(member selectees *)" and t = "san" and result = 0.3424892514970265 or
repr = "(return (member createDocumentFragment *))" and t = "san" and result = 0.5 or
repr = "(parameter 1 (return (member extend (root https://www.npmjs.com/package/jquery))))" and t = "san" and result = 1.0 or
repr = "(return (member getBogus *))" and t = "san" and result = 0.5 or
repr = "(return (member split (parameter a *)))" and t = "san" and result = 0.21139581980127203 or
repr = "(member collapsed *)" and t = "san" and result = 1.0 or
repr = "(return (member match (member value *)))" and t = "san" and result = 0.08198268206039078 or
repr = "(return (member editable (member editor *)))" and t = "san" and result = 0.25 or
repr = "(return (member getValue *))" and t = "san" and result = 0.5 or
repr = "(return (member getCustomData *))" and t = "san" and result = 0.5 or
repr = "(return (member extend (member tools *)))" and t = "san" and result = 0.7499999999999999 or
repr = "(member active *)" and t = "san" and result = 0.08084419695962747 or
repr = "(return (member equals (member startContainer *)))" and t = "san" and result = 0.4006439573047788 or
repr = "(return (member getNextRange (return (member createIterator *))))" and t = "san" and result = 0.5374097200361843 or
repr = "(return (member getParent (return (member getParent *))))" and t = "san" and result = 0.7575757575757576 or
repr = "(return (member getAttribute *))" and t = "san" and result = 0.3731060606060606 or
repr = "(return (member extend (member tools (member CKEDITOR (global)))))" and t = "san" and result = 1.0 or
repr = "(return (member refresh *))" and t = "san" and result = 0.23675244931576367 or
repr = "(return (member getRanges *))" and t = "san" and result = 0.5 or
repr = "(parameter 0 (return (parameter $ *)))" and t = "san" and result = 0.6791637168761524 or
repr = "(return (member getChild *))" and t = "san" and result = 0.526894475210784 or
repr = "(return (member toLowerCase (member nodeName *)))" and t = "san" and result = 0.9244807192727463 or
repr = "(return (member inArray (root https://www.npmjs.com/package/jquery)))" and t = "san" and result = 1.0 or
repr = "(return (member showBlock *))" and t = "san" and result = 0.75 or
repr = "(member currentItem *)" and t = "san" and result = 0.2212771302849053 or
repr = "(member label *)" and t = "san" and result = 0.5669131377408813 or
repr = "(member pos (instance (member StringStream *)))" and t = "san" and result = 0.2500000000000002 or
repr = "(return (member contains (instance (member elementPath (member dom *)))))" and t = "san" and result = 1.0 or
repr = "(return (member replace (member className *)))" and t = "san" and result = 0.5571849425432935 or
repr = "(return (member replace (parameter a *)))" and t = "san" and result = 0.9241572560660906 or
repr = "(return (member next *))" and t = "san" and result = 0.25 or
repr = "(return (member getKey *))" and t = "san" and result = 0.25 or
repr = "(member pos *)" and t = "san" and result = 0.8715599109940222 or
repr = "(return (member toLowerCase (member recipient *)))" and t = "san" and result = 0.5 or
repr = "(return (member toJSON *))" and t = "san" and result = 0.13499999999999995 or
repr = "(member user (parameter req (parameter 2 (return (member post *)))))" and t = "san" and result = 0.5882352941176477 or
repr = "(parameter 0 (return (member expect *)))" and t = "san" and result = 0.08000000000000052 or
repr = "(member user (parameter 0 (parameter 2 (return (member post *)))))" and t = "san" and result = 1.0 or
repr = "(return (member signup *))" and t = "san" and result = 0.27000000000000013 or
repr = "(return (member createIfNotExistsWithLeadId *))" and t = "san" and result = 0.25 or
repr = "(return (member closeRequestByRequestId *))" and t = "san" and result = 0.625 or
repr = "(return (member sign *))" and t = "san" and result = 0.7575757575757576 or
repr = "(return (member createWithIdAndRequester *))" and t = "san" and result = 0.48000000000000004 or
repr = "(member id *)" and t = "san" and result = 0.25 or
repr = "(return (member removeParticipantByRequestId *))" and t = "san" and result = 0.5 or
repr = "(return (member json (parameter res *)))" and t = "san" and result = 0.5711757575757573 or
repr = "(member tasks *)" and t = "san" and result = 0.5661700879765394 or
repr = "(return (member displayLastYearKPI (parameter myLibrary *)))" and t = "san" and result = 0.3099706744868038 or
repr = "(return (member filter (member _ (global))))" and t = "san" and result = 0.11363636363636331 or
repr = "(parameter 0 (return (member parse *)))" and t = "san" and result = 0.7575757575757576 or
repr = "(return (member findOneAndUpdate *))" and t = "san" and result = 0.75 or
repr = "(return (member getKeystroke (member data *)))" and t = "san" and result = 0.21108860457278056 or
repr = "(member type *)" and t = "san" and result = 0.39140203305751997 or
repr = "(return (member contains (return (member elementPath *))))" and t = "san" and result = 1.0 or
repr = "(return (member getSetting *))" and t = "san" and result = 1.0 or
repr = "(return (member load *))" and t = "san" and result = 0.38661202185792354 or
repr = "(member dataLabel *)" and t = "san" and result = 0.5882850854917895 or
repr = "(member pos (instance (member StringStream (member constructor *))))" and t = "san" and result = 0.25688017801195534 or
repr = "(member hints *)" and t = "san" and result = 0.5959595959595959 or
repr = "(member next *)" and t = "san" and result = 0.744563358562999 or
repr = "(member resolve *)" and t = "san" and result = 0.21719593388496006 or
repr = "(return (member getSetting (member data (member _z *))))" and t = "san" and result = 1.0 or
repr = "(return (member indexOf (parameter a *)))" and t = "san" and result = 0.25 or
repr = "(return (member attachListener *))" and t = "san" and result = 0.09107468123861565 or
repr = "(return (member concat (return (member concat *))))" and t = "san" and result = 0.1790585358979131 or
repr = "(parameter 1 (parameter 0 (return (member push *))))" and t = "san" and result = 0.5667975688291198 or
repr = "(member address *)" and t = "san" and result = 1.0 or
repr = "(return (member getComputedStyle (member window (global))))" and t = "san" and result = 0.023229939440059487 or
repr = "(return (member fromCharCode *))" and t = "san" and result = 1.0 or
repr = "(member gutters *)" and t = "san" and result = 0.2557671542789319 or
repr = "(member address (member email *))" and t = "san" and result = 0.9299605674941063 or
repr = "(member next (member previous (member next (member previous *))))" and t = "san" and result = 0.7260248767311185 or
repr = "(return (member getComputedStyle (global)))" and t = "san" and result = 1.0 or
repr = "(member power *)" and t = "san" and result = 1.0 or
repr = "(member linkedObject *)" and t = "san" and result = 0.5362819162352115 or
repr = "(return (member translate *))" and t = "san" and result = 0.25 or
repr = "(return (member fire (member CKEDITOR (global))))" and t = "san" and result = 0.41966360457278085 or
repr = "(return (member getUrl (member CKEDITOR (global))))" and t = "san" and result = 0.5 or
repr = "(return (member normalize *))" and t = "san" and result = 0.75 or
repr = "(return (member getPosition *))" and t = "san" and result = 0.03371466077948767 or
repr = "(return (member elementFromPoint *))" and t = "san" and result = 0.4918199456289942 or
repr = "(member classes *)" and t = "san" and result = 0.25 or
repr = "(return (member val (return (member jQuery (global)))))" and t = "san" and result = 1.0 or
repr = "(member d *)" and t = "san" and result = 0.5236508860244217 or
repr = "(return (member createText *))" and t = "san" and result = 0.1338262754817625 or
repr = "(return (member transformToArrayFormat (member data (member _z *))))" and t = "san" and result = 0.7567609354236619 or
repr = "(return (member getParentNode *))" and t = "san" and result = 1.0 or
repr = "(return (member next (parameter 0 (member tokenize *))))" and t = "san" and result = 0.518928863909967 or
repr = "(return (member e *))" and t = "san" and result = 0.18686868686868685 or
repr = "(return (member getNodeCache (member data *)))" and t = "san" and result = 1.0 or
repr = "(return (member applyOptions *))" and t = "san" and result = 0.19711560238912545 or
repr = "(return (member jQuery (global)))" and t = "san" and result = 0.739126717125998 or
repr = "(return (member applyOptions (member prototype *)))" and t = "san" and result = 0.3175902799638158 or
repr = "(return (return (member Function (global))))" and t = "san" and result = 1.0 or
repr = "(return (member getCursor (parameter cm *)))" and t = "san" and result = 0.8626373626373627 or
repr = "(return (member split (member className *)))" and t = "san" and result = 0.349621836031663 or
repr = "(return (member copy (member tools *)))" and t = "san" and result = 0.7575757575757576 or
repr = "(member image *)" and t = "san" and result = 0.34061074210594516 or
repr = "(return (member fontMetrics (member renderer *)))" and t = "san" and result = 0.3787878787878788 or
repr = "(return (member angleTo *))" and t = "san" and result = 0.25 or
repr = "(return (member split (member value *)))" and t = "san" and result = 1.0 or
repr = "(return (member $process *))" and t = "san" and result = 0.3961934407711843 or
repr = "(return (member pick (parameter g *)))" and t = "san" and result = 0.3787878787878788 or
repr = "(return (member getDocumentElement (member document *)))" and t = "san" and result = 0.25 or
repr = "(return (return (parameter $interpolate *)))" and t = "san" and result = 0.75 or
repr = "(return (member fix (member event (member jQuery (global)))))" and t = "san" and result = 0.34257575757575753 or
repr = "(return (member n *))" and t = "san" and result = 0.06313131313131312 or
repr = "(return (member w *))" and t = "san" and result = 0.1868686868686868 or
repr = "(member a *)" and t = "san" and result = 0.1868686868686868 or
repr = "(return (member translatePath *))" and t = "san" and result = 0.0824097200361843 or
repr = "(parameter 0 (return (member camelCase (member $ (parameter window *)))))" and t = "san" and result = 1.0 or
repr = "(member createDocumentFragment *)" and t = "san" and result = 0.23705408515535067 or
repr = "(return (member getPlotLinePath *))" and t = "san" and result = 0.16283900441538424 or
repr = "(return (member equals *))" and t = "san" and result = 1.0 or
repr = "(return (member shadow *))" and t = "san" and result = 0.1882512273573722 or
repr = "(return (member override *))" and t = "san" and result = 0.07606094842934508 or
repr = "(return (member slice (member prototype *)))" and t = "san" and result = 0.007575757575757498 or
repr = "(return (member getParentNode (parameter a *)))" and t = "san" and result = 1.0 or
repr = "(member frontier (member doc *))" and t = "san" and result = 0.9999999999999998
    }    
}