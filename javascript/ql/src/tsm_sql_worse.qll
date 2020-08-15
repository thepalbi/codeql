
import javascript

import NodeRepresentation

module TSMSqlWorse{
    string rep(DataFlow::Node node){
        result = candidateRep(node, _)
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

    float getReprScore(string repr, string t){
        repr = "(member file *)" and t = "src" and result = 1.0 or
        repr = "(member url (parameter 0 (parameter 0 (return (member use *)))))" and t = "src" and result = 1.0 or
        repr = "(member id (member where *))" and t = "src" and result = 1.0 or
        repr = "(parameter data (parameter 1 (return (member on *))))" and t = "src" and result = 1.0 or
        repr = "(member x-user-email *)" and t = "src" and result = 1.0 or
        repr = "(member url (parameter req *))" and t = "src" and result = 1.0 or
        repr = "(member cookies *)" and t = "src" and result = 1.0 or
        repr = "(return (member search *))" and t = "src" and result = 1.0 or
        repr = "(member product (parameter 0 (return (member insert (member reviews *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter data (parameter 1 (return (member on (parameter socket *)))))" and t = "src" and result = 1.0 or
        repr = "(member new *)" and t = "src" and result = 1.0 or
        repr = "(member q *)" and t = "src" and result = 0.6900000000000001 or
        repr = "(parameter 0 (return (member decodeURIComponent (global))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (member coupon *))" and t = "src" and result = 1.0 or
        repr = "(member authorization (member headers *))" and t = "src" and result = 1.0 or
        repr = "(member cookies (parameter req *))" and t = "src" and result = 1.0 or
        repr = "(member product (parameter 0 (return (member insert *))))" and t = "src" and result = 1.0 or
        repr = "(member x-user-email (member headers (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (parameter 1 (return (member on *))))" and t = "src" and result = 1.0 or
        repr = "(member email (member where *))" and t = "src" and result = 1.0 or
        repr = "(member current (member query *))" and t = "src" and result = 1.0 or
        repr = "(member md_debug *)" and t = "src" and result = 1.0 or
        repr = "(parameter data *)" and t = "src" and result = 0.8333333333333334 or
        repr = "(member coupon (member params *))" and t = "src" and result = 1.0 or
        repr = "(member email (member query *))" and t = "src" and result = 1.0 or
        repr = "(member body *)" and t = "src" and result = 1.0 or
        repr = "(member id *)" and t = "src" and result = 1.0 or
        repr = "(member to (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member repeat (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member challenge (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (parameter 1 (return (member on (parameter socket *)))))" and t = "src" and result = 1.0 or
        repr = "(member file (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member BasketId *)" and t = "src" and result = 1.0 or
        repr = "(member md_debug (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member startsWith *)))" and t = "src" and result = 1.0 or
        repr = "(member url *)" and t = "src" and result = 1.0 or
        repr = "(member continueCode *)" and t = "src" and result = 1.0 or
        repr = "(member email (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member new (member query *))" and t = "src" and result = 1.0 or
        repr = "(member to *)" and t = "src" and result = 1.0 or
        repr = "(member continueCode (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member email *)" and t = "src" and result = 1.0 or
        repr = "(member file (member params *))" and t = "src" and result = 1.0 or
        repr = "(member password (parameter 0 (return (member updateAttributes *))))" and t = "src" and result = 1.0 or
        repr = "(member authorization *)" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (member coupon (parameter 0 (return (member updateAttributes *)))))" and t = "src" and result = 1.0 or
        repr = "(member authorization (member headers (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member coupon *)" and t = "src" and result = 1.0 or
        repr = "(return (member search (parameter $location *)))" and t = "src" and result = 1.0 or
        repr = "(member repeat *)" and t = "src" and result = 1.0 or
        repr = "(member current (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member continueCode (member params *))" and t = "src" and result = 1.0 or
        repr = "(member repeat (member query *))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter req *))" and t = "src" and result = 1.0 or
        repr = "(member q (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member challenge *)" and t = "src" and result = 1.0 or
        repr = "(member to (member query *))" and t = "src" and result = 1.0 or
        repr = "(member q (member query *))" and t = "src" and result = 1.0 or
        repr = "(member password *)" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member endsWith *)))" and t = "src" and result = 1.0 or
        repr = "(member id (member where (parameter 0 (return (member find *)))))" and t = "src" and result = 1.0 or
        repr = "(member md_debug (member query *))" and t = "src" and result = 1.0 or
        repr = "(member id (member params *))" and t = "src" and result = 1.0 or
        repr = "(member challenge (member query *))" and t = "src" and result = 1.0 or
        repr = "(member url (parameter req (parameter 0 (return (member use *)))))" and t = "src" and result = 1.0 or
        repr = "(member BasketId (member where (parameter 0 (return (member destroy *)))))" and t = "src" and result = 1.0 or
        repr = "(member id (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member product *)" and t = "src" and result = 1.0 or
        repr = "(member x-user-email (member headers *))" and t = "src" and result = 1.0 or
        repr = "(member BasketId (member where *))" and t = "src" and result = 1.0 or
        repr = "(member current *)" and t = "src" and result = 1.0 or
        repr = "(member new (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member password (parameter 0 (return (member updateAttributes (parameter user *)))))" and t = "src" and result = 1.0 or
        repr = "(member coupon (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter req (parameter 1 (return (member post *)))))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter 0 (parameter 1 (return (member put *)))))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter req (parameter 1 (return (member put *)))))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter 0 (parameter 1 (return (member post *)))))" and t = "src" and result = 1.0 or
        repr = "(member x-forwarded-for (member headers (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member collectionLabel *)" and t = "src" and result = 1.0 or
        repr = "(member cookies (parameter 0 (parameter 1 (return (member post *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member overwrite (member $layer *))))" and t = "src" and result = 1.0 or
        repr = "(parameter roleId (parameter 1 (return (member param *))))" and t = "src" and result = 1.0 or
        repr = "(member last_login_ip (member $set (parameter 1 (return (member updateOne *)))))" and t = "src" and result = 1.0 or
        repr = "(member reportID *)" and t = "src" and result = 1.0 or
        repr = "(member cookies (parameter req (parameter 1 (return (member post *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 3 (parameter 1 (return (member param *))))" and t = "src" and result = 1.0 or
        repr = "(member roleId (member params *))" and t = "src" and result = 1.0 or
        repr = "(parameter datasourceId (parameter 1 (return (member param *))))" and t = "src" and result = 1.0 or
        repr = "(member last_login_ip *)" and t = "src" and result = 1.0 or
        repr = "(parameter datasourceId *)" and t = "src" and result = 1.0 or
        repr = "(member reportID (parameter 4 (parameter 1 (return (member controller *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member set (member $user (parameter req *)))))" and t = "src" and result = 1.0 or
        repr = "(member x-forwarded-for (member headers *))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member fromDatasource *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member getLayer *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member set (member $role (parameter req *)))))" and t = "src" and result = 1.0 or
        repr = "(member x-forwarded-for *)" and t = "src" and result = 1.0 or
        repr = "(parameter roleId *)" and t = "src" and result = 1.0 or
        repr = "(member name (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter userId (parameter 1 (return (member param *))))" and t = "src" and result = 1.0 or
        repr = "(member sqlQuery (member query *))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (return (member model (root https://www.npmjs.com/package/mongoose)))))" and t = "src" and result = 1.0 or
        repr = "(member last_login_ip (member $set *))" and t = "src" and result = 1.0 or
        repr = "(member sqlQuery *)" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member set (member $datasource *))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member set (member $layer (parameter req *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member set (member $role *))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member set *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (return (member model *))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member getReportDefinition (parameter reportModel *))))" and t = "src" and result = 1.0 or
        repr = "(member contextHelp *)" and t = "src" and result = 1.0 or
        repr = "(parameter layerId (parameter 1 (return (member param *))))" and t = "src" and result = 1.0 or
        repr = "(member layerID *)" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (instance (return (member model (root https://www.npmjs.com/package/mongoose)))))" and t = "src" and result = 1.0 or
        repr = "(member layerID (parameter 3 (parameter 1 (return (member controller *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member getSqlQuerySchema (return (member fromDatasource *)))))" and t = "src" and result = 1.0 or
        repr = "(member roleId (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member cookies (parameter 1 (return (member toPNG *))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member getCollectionSchema *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member set (member $user *))))" and t = "src" and result = 1.0 or
        repr = "(member contextHelp (member $addToSet *))" and t = "src" and result = 1.0 or
        repr = "(member name *)" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member overwrite *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member getReportDefinition *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member overwrite (member $layer (parameter req *)))))" and t = "src" and result = 1.0 or
        repr = "(member reportID (parameter $routeParams (parameter 1 (return (member controller *)))))" and t = "src" and result = 1.0 or
        repr = "(member layerID (parameter $routeParams (parameter 1 (return (member controller *)))))" and t = "src" and result = 1.0 or
        repr = "(member sharedSpace (member $set *))" and t = "src" and result = 1.0 or
        repr = "(member sqlQuery (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (instance (return (member model *))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member set (member $datasource (parameter req *)))))" and t = "src" and result = 1.0 or
        repr = "(member layerID (parameter $routeParams *))" and t = "src" and result = 1.0 or
        repr = "(member collectionName (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member set (member $layer *))))" and t = "src" and result = 1.0 or
        repr = "(parameter layerId *)" and t = "src" and result = 1.0 or
        repr = "(member collectionName (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member reportID (parameter $routeParams *))" and t = "src" and result = 1.0 or
        repr = "(parameter userId *)" and t = "src" and result = 1.0 or
        repr = "(member collectionName *)" and t = "src" and result = 1.0 or
        repr = "(member collectionName (member query *))" and t = "src" and result = 1.0 or
        repr = "(member name (member params *))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member getLayer (parameter api *))))" and t = "src" and result = 1.0 or
        repr = "(member roleId *)" and t = "src" and result = 1.0 or
        repr = "(member collectionName (member params *))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member getSqlQuerySchema *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member getCollectionSchema (return (member fromDatasource *)))))" and t = "src" and result = 1.0 or
        repr = "(member sharedSpace *)" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member stringify (member JSON (global)))))" and t = "src" and result = 1.0 or
        repr = "(member index (member params *))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member stringify *)))" and t = "src" and result = 1.0 or
        repr = "(member index (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member index *)" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (parameter 0 (return (member log *))))" and t = "src" and result = 1.0 or
        repr = "(member lang (member params *))" and t = "src" and result = 1.0 or
        repr = "(member name (member query *))" and t = "src" and result = 1.0 or
        repr = "(member lang (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(return (member split *))" and t = "src" and result = 0.03120000000000034 or
        repr = "(parameter t (parameter 1 (return (member addEventListener (global)))))" and t = "src" and result = 1.0 or
        repr = "(member title *)" and t = "src" and result = 1.0 or
        repr = "(member received *)" and t = "src" and result = 1.0 or
        repr = "(parameter e *)" and t = "src" and result = 1.0 or
        repr = "(member title (member query *))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (parameter 1 (return (member addEventListener (parameter t *)))))" and t = "src" and result = 1.0 or
        repr = "(member received (parameter 0 (return (member send *))))" and t = "src" and result = 1.0 or
        repr = "(parameter o *)" and t = "src" and result = 0.05984848484848487 or
        repr = "(return (member parseInt (global)))" and t = "src" and result = 0.23325750000000012 or
        repr = "(return (member concat *))" and t = "src" and result = 0.1118012422360248 or
        repr = "(member title (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member name (global))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member match *)))" and t = "src" and result = 0.2716573333333332 or
        repr = "(member name (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(return (member val (member iframeURLInput *)))" and t = "src" and result = 0.6754666666666668 or
        repr = "(parameter t (parameter 1 (return (member addEventListener (parameter t *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter e (parameter 1 (return (member addEventListener (global)))))" and t = "src" and result = 1.0 or
        repr = "(member received (parameter 0 (return (member send (parameter res *)))))" and t = "src" and result = 1.0 or
        repr = "(member input (member query *))" and t = "src" and result = 1.0 or
        repr = "(parameter e (parameter 1 (return (member addEventListener *))))" and t = "src" and result = 1.0 or
        repr = "(parameter a *)" and t = "src" and result = 0.3043999999999999 or
        repr = "(parameter 0 (return (member log *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member log (member console (global)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (parameter 1 (return (member addEventListener (global)))))" and t = "src" and result = 1.0 or
        repr = "(member input (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (parameter 1 (return (member addEventListener *))))" and t = "src" and result = 1.0 or
        repr = "(parameter t (parameter 1 (return (member addEventListener *))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member parseInt (global))))" and t = "src" and result = 1.0 or
        repr = "(member input *)" and t = "src" and result = 1.0 or
        repr = "(return (member htmlEncode (member tools *)))" and t = "src" and result = 3.303433641966753 or
        repr = "(return (member replace *))" and t = "src" and result = 0.038671875000000036 or
        repr = "(parameter t *)" and t = "src" and result = 1.0 or
        repr = "(member name (member window (global)))" and t = "src" and result = 1.0 or
        repr = "(member lang *)" and t = "src" and result = 1.0 or
        repr = "(member address (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member address (member query *))" and t = "src" and result = 1.0 or
        repr = "(member signature (member query *))" and t = "src" and result = 1.0 or
        repr = "(member username (member query *))" and t = "src" and result = 1.0 or
        repr = "(member coin *)" and t = "src" and result = 1.0 or
        repr = "(member signature *)" and t = "src" and result = 1.0 or
        repr = "(member password (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member signature (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member username *)" and t = "src" and result = 1.0 or
        repr = "(member coin (member query *))" and t = "src" and result = 1.0 or
        repr = "(member username (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member password (member query *))" and t = "src" and result = 1.0 or
        repr = "(member amount (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member amount *)" and t = "src" and result = 1.0 or
        repr = "(member amount (member query *))" and t = "src" and result = 1.0 or
        repr = "(member coin (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member address *)" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member safeLoad (root https://www.npmjs.com/package/js-yaml))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (member onMessage_ (member prototype *)))" and t = "src" and result = 1.0 or
        repr = "(parameter e (member onMessage_ (member prototype *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member isValidUserId (global))))" and t = "src" and result = 1.0 or
        repr = "(member to (parameter 0 (return (member sendMail *))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member has *)))" and t = "src" and result = 1.0 or
        repr = "(member payload *)" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member parse (root https://www.npmjs.com/package/url))))" and t = "src" and result = 1.0 or
        repr = "(member category *)" and t = "src" and result = 1.0 or
        repr = "(parameter e (member onMessage_ (instance (member SlideController (parameter window *)))))" and t = "src" and result = 1.0 or
        repr = "(member category (member params *))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (parameter 0 (return (member end *))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member parse *)))" and t = "src" and result = 1.0 or
        repr = "(member userControlled *)" and t = "src" and result = 1.0 or
        repr = "(member userName (member variables *))" and t = "src" and result = 1.0 or
        repr = "(parameter ev (parameter 1 (return (member addEventListener (global)))))" and t = "src" and result = 1.0 or
        repr = "(member data (member params *))" and t = "src" and result = 1.0 or
        repr = "(member cookies (parameter 0 (parameter 1 (return (member get *)))))" and t = "src" and result = 1.0 or
        repr = "(member host (parameter 0 (parameter 1 (return (member post *)))))" and t = "src" and result = 1.0 or
        repr = "(member data *)" and t = "src" and result = 1.0 or
        repr = "(member user (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member userControlled (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter e (member onMessage_ (member prototype (member SlideController *))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (member onMessage_ (instance (member SlideController (global)))))" and t = "src" and result = 1.0 or
        repr = "(member path (member params *))" and t = "src" and result = 1.0 or
        repr = "(member action (member params *))" and t = "src" and result = 1.0 or
        repr = "(member cookies (parameter req (parameter 1 (return (member get *)))))" and t = "src" and result = 1.0 or
        repr = "(member userName *)" and t = "src" and result = 1.0 or
        repr = "(return (member param (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (member onMessage_ (member prototype (member SlideController *))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (member onMessage_ (member prototype (member SlideController (parameter window *)))))" and t = "src" and result = 1.0 or
        repr = "(member payload (member params *))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (member onMessage_ *))" and t = "src" and result = 1.0 or
        repr = "(member host (parameter req *))" and t = "src" and result = 1.0 or
        repr = "(parameter ev (parameter 1 (return (member addEventListener *))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member load *)))" and t = "src" and result = 1.0 or
        repr = "(member data (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (member onMessage_ (member prototype (member SlideController (global)))))" and t = "src" and result = 1.0 or
        repr = "(parameter e (member onMessage_ *))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member load (root https://www.npmjs.com/package/js-yaml))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (root https://www.npmjs.com/package/escape-html)))" and t = "src" and result = 1.0 or
        repr = "(member user (member query *))" and t = "src" and result = 1.0 or
        repr = "(member action *)" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member safeLoad *)))" and t = "src" and result = 1.0 or
        repr = "(parameter e (member onMessage_ (member prototype (member SlideController (global)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (parameter 0 (return (member end (parameter res *)))))" and t = "src" and result = 1.0 or
        repr = "(member url (parameter 0 (parameter 1 (return (member on *)))))" and t = "src" and result = 1.0 or
        repr = "(member path *)" and t = "src" and result = 1.0 or
        repr = "(member userName (member variables (parameter 0 (return (member select *)))))" and t = "src" and result = 1.0 or
        repr = "(return (member param *))" and t = "src" and result = 1.0 or
        repr = "(member category (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (member onMessage_ (instance (member SlideController *))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member parse (member default (root https://www.npmjs.com/package/url)))))" and t = "src" and result = 1.0 or
        repr = "(member payload (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member url (parameter req (parameter 1 (return (member on *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member get *)))" and t = "src" and result = 1.0 or
        repr = "(member url (parameter 0 (parameter 0 (return (member createServer *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter e (member onMessage_ (member prototype (member SlideController (parameter window *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member parse (member default *))))" and t = "src" and result = 1.0 or
        repr = "(return (member param (parameter request *)))" and t = "src" and result = 1.0 or
        repr = "(member host (parameter req (parameter 1 (return (member post *)))))" and t = "src" and result = 1.0 or
        repr = "(member userControlled (member query *))" and t = "src" and result = 1.0 or
        repr = "(member user *)" and t = "src" and result = 1.0 or
        repr = "(member url (parameter req (parameter 0 (return (member createServer *)))))" and t = "src" and result = 1.0 or
        repr = "(member action (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (member onMessage_ (instance (member SlideController (parameter window *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member hasOwnProperty *)))" and t = "src" and result = 1.0 or
        repr = "(parameter e (member onMessage_ (instance (member SlideController *))))" and t = "src" and result = 1.0 or
        repr = "(parameter ev *)" and t = "src" and result = 1.0 or
        repr = "(parameter e (member onMessage_ (instance (member SlideController (global)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (return (member get *))))" and t = "src" and result = 1.0 or
        repr = "(member path (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member host *)" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member String (global))))" and t = "src" and result = 1.0 or
        repr = "(member query_for (member params *))" and t = "src" and result = 1.0 or
        repr = "(member query_for (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member query_string *)" and t = "src" and result = 1.0 or
        repr = "(member query_string (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member query_string (member params *))" and t = "src" and result = 1.0 or
        repr = "(member query_for *)" and t = "src" and result = 1.0 or
        repr = "(member number *)" and t = "src" and result = 1.0 or
        repr = "(member number (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member fileName (member query *))" and t = "src" and result = 1.0 or
        repr = "(member fileName *)" and t = "src" and result = 1.0 or
        repr = "(member time (member query *))" and t = "src" and result = 1.0 or
        repr = "(member id (member query *))" and t = "src" and result = 1.0 or
        repr = "(member time *)" and t = "src" and result = 1.0 or
        repr = "(member time (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member id (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member fileName (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member number (member query *))" and t = "src" and result = 1.0 or
        repr = "(parameter err (parameter 1 (return (member on *))))" and t = "src" and result = 1.0 or
        repr = "(parameter message (parameter 1 (return (member on (parameter ws *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter message (parameter 1 (return (member on *))))" and t = "src" and result = 1.0 or
        repr = "(parameter err *)" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (parameter 1 (return (member on (parameter ws *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter message *)" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member subscribers *)))" and t = "src" and result = 1.0 or
        repr = "(member ucid (parameter subscription *))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter req (parameter 2 (return (member post *)))))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter 0 (parameter 4 (return (member post *)))))" and t = "src" and result = 1.0 or
        repr = "(member template *)" and t = "src" and result = 1.0 or
        repr = "(parameter 2 (return (member verbose *)))" and t = "src" and result = 1.0 or
        repr = "(parameter campaignId (member getMail *))" and t = "src" and result = 0.1893939393939394 or
        repr = "(parameter updates *)" and t = "src" and result = 0.005038726077763708 or
        repr = "(member group (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member countClick *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member getRule *)))" and t = "src" and result = 1.0 or
        repr = "(member type (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter req (parameter 3 (return (member post *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 2 (return (member insert *)))" and t = "src" and result = 1.0 or
        repr = "(member subscription (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member link (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 2 (member insert *))" and t = "src" and result = 0.005038726077763708 or
        repr = "(member lcid (parameter subscription *))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member takeConfirmation *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member getByCid *)))" and t = "src" and result = 1.0 or
        repr = "(member url (parameter 0 (parameter 1 (return (member get *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 2 (return (member update *)))" and t = "src" and result = 1.0 or
        repr = "(member user-agent (member headers *))" and t = "src" and result = 1.0 or
        repr = "(parameter listId (member update *))" and t = "src" and result = 0.12689393939393936 or
        repr = "(member body (parameter req (parameter 2 (return (member get *)))))" and t = "src" and result = 1.0 or
        repr = "(member token (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member subscription (member params *))" and t = "src" and result = 1.0 or
        repr = "(parameter 4 (return (member verbose (root https://www.npmjs.com/package/npmlog))))" and t = "src" and result = 1.0 or
        repr = "(member next (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member join *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member getResource *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member keys (member Object (global)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 2 (return (member filterClickedSubscribers *)))" and t = "src" and result = 1.0 or
        repr = "(member lcid (member params *))" and t = "src" and result = 1.0 or
        repr = "(return (member names *))" and t = "src" and result = 0.020154904311054832 or
        repr = "(member next *)" and t = "src" and result = 1.0 or
        repr = "(member status *)" and t = "src" and result = 1.0 or
        repr = "(member lcid (parameter 1 (parameter 2 (return (member get *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member includes (return (member map *)))))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter req (member login *)))" and t = "src" and result = 1.0 or
        repr = "(member group *)" and t = "src" and result = 1.0 or
        repr = "(parameter 2 (return (member countClick *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member countOpen *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (member create *))" and t = "src" and result = 0.12689393939393936 or
        repr = "(parameter 0 (return (member resetPassword *)))" and t = "src" and result = 1.0 or
        repr = "(member group (member query *))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member filter *)))" and t = "src" and result = 1.0 or
        repr = "(member start *)" and t = "src" and result = 1.0 or
        repr = "(member access_token *)" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member filter *)))" and t = "src" and result = 1.0 or
        repr = "(member campaign (member params *))" and t = "src" and result = 1.0 or
        repr = "(member username (parameter 1 (return (member render *))))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member getWithMergeTags *)))" and t = "src" and result = 1.0 or
        repr = "(member type (member query *))" and t = "src" and result = 1.0 or
        repr = "(member fid (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter 0 (parameter 2 (return (member get *)))))" and t = "src" and result = 1.0 or
        repr = "(member search (member query *))" and t = "src" and result = 1.0 or
        repr = "(member importId *)" and t = "src" and result = 1.0 or
        repr = "(member segment (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member importId (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member resetToken *)" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member getImport *)))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter 0 (parameter 3 (return (member post *)))))" and t = "src" and result = 1.0 or
        repr = "(return (member determineDeltas *))" and t = "src" and result = 0.05332555921132409 or
        repr = "(member campaign (parameter subscription *))" and t = "src" and result = 1.0 or
        repr = "(member segment (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member search (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 3 (return (member join (root https://www.npmjs.com/package/path))))" and t = "src" and result = 1.0 or
        repr = "(parameter listId *)" and t = "src" and result = 0.0625 or
        repr = "(parameter 0 (return (member getImport *)))" and t = "src" and result = 1.0 or
        repr = "(member start (member query *))" and t = "src" and result = 1.0 or
        repr = "(member email (member params *))" and t = "src" and result = 1.0 or
        repr = "(member lcid *)" and t = "src" and result = 1.0 or
        repr = "(return (member convertKeys *))" and t = "src" and result = 0.17913945723963415 or
        repr = "(parameter 1 (return (member createOrUpdate *)))" and t = "src" and result = 1.0 or
        repr = "(return (member trim *))" and t = "src" and result = 0.1153296052578397 or
        repr = "(member status (member params *))" and t = "src" and result = 1.0 or
        repr = "(member campaign *)" and t = "src" and result = 1.0 or
        repr = "(member formTest (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member linkId *)" and t = "src" and result = 1.0 or
        repr = "(member link *)" and t = "src" and result = 1.0 or
        repr = "(parameter evt (parameter 1 (return (member addEventListener *))))" and t = "src" and result = 1.0 or
        repr = "(parameter rows *)" and t = "src" and result = 1.0 or
        repr = "(parameter searchFields (member filter *))" and t = "src" and result = 0.7575757575757576 or
        repr = "(member segmentId (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter sql *)" and t = "src" and result = 0.5 or
        repr = "(member parent (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 3 (return (member verbose *)))" and t = "src" and result = 1.0 or
        repr = "(member reportTemplate (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (parameter 2 (return (member update *)))))" and t = "src" and result = 1.0 or
        repr = "(member fid *)" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (parameter 2 (return (member query *))))" and t = "src" and result = 1.0000000000000002 or
        repr = "(member segmentId *)" and t = "src" and result = 1.0 or
        repr = "(member listId (member params *))" and t = "src" and result = 1.0 or
        repr = "(parameter 2 (return (member statsClickedSubscribersByColumn *)))" and t = "src" and result = 1.0 or
        repr = "(member formTest *)" and t = "src" and result = 1.0 or
        repr = "(parameter 3 (return (member countOpen *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member checkResetToken *)))" and t = "src" and result = 1.0 or
        repr = "(member status (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member list (member params *))" and t = "src" and result = 1.0 or
        repr = "(parameter 3 (return (member join *)))" and t = "src" and result = 1.0 or
        repr = "(member type (parameter 1 (return (member render *))))" and t = "src" and result = 1.0 or
        repr = "(member type (parameter 1 (return (member render (parameter res *)))))" and t = "src" and result = 1.0 or
        repr = "(member user-agent (member headers (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member importId (member params *))" and t = "src" and result = 1.0 or
        repr = "(member originalUrl (parameter 0 (parameter 1 (return (member all *)))))" and t = "src" and result = 1.0 or
        repr = "(member form (member params *))" and t = "src" and result = 1.0 or
        repr = "(member start (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 3 (return (member filter *)))" and t = "src" and result = 1.0 or
        repr = "(member c (member query *))" and t = "src" and result = 1.0 or
        repr = "(member template (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member segmentId (member params *))" and t = "src" and result = 1.0 or
        repr = "(member subscription *)" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member updateRule *)))" and t = "src" and result = 1.0 or
        repr = "(member listId *)" and t = "src" and result = 1.0 or
        repr = "(member resetToken (parameter 1 (return (member render (parameter res *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member getFailedImports *)))" and t = "src" and result = 1.0 or
        repr = "(member originalUrl (parameter req (parameter 1 (return (member all *)))))" and t = "src" and result = 1.0 or
        repr = "(member cid (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (parameter 0 (return (member forEach *))))" and t = "src" and result = 0.7374208532647027 or
        repr = "(member body (parameter 0 (parameter 2 (return (member post *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member resolve *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 2 (return (member verbose (root https://www.npmjs.com/package/npmlog))))" and t = "src" and result = 1.0 or
        repr = "(member url (parameter req (parameter 1 (return (member get *)))))" and t = "src" and result = 1.0 or
        repr = "(member linkId (member params *))" and t = "src" and result = 1.0 or
        repr = "(member lcid (parameter subscription (parameter 2 (return (member get *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter values *)" and t = "src" and result = 0.0946969696969697 or
        repr = "(member formTest (member query *))" and t = "src" and result = 1.0 or
        repr = "(member segment *)" and t = "src" and result = 1.0 or
        repr = "(parameter 3 (return (member countClick *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member getLinks *)))" and t = "src" and result = 1.0 or
        repr = "(member rule (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter 0 (member login *)))" and t = "src" and result = 1.0 or
        repr = "(member campaign (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member ucid *)" and t = "src" and result = 1.0 or
        repr = "(member lcid (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member originalUrl (parameter req *))" and t = "src" and result = 1.0 or
        repr = "(parameter 2 (return (member error (root https://www.npmjs.com/package/npmlog))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member getListsWithEmail *)))" and t = "src" and result = 1.0 or
        repr = "(member limit (member query *))" and t = "src" and result = 1.0 or
        repr = "(member template (member query *))" and t = "src" and result = 1.0 or
        repr = "(member user-agent *)" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member filterSubscribers *)))" and t = "src" and result = 1.0 or
        repr = "(member next (parameter 1 (return (member render *))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member includes *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member Number (global))))" and t = "src" and result = 1.0 or
        repr = "(member username (parameter 1 (return (member render (parameter res *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member get *)))" and t = "src" and result = 1.0 or
        repr = "(return (member Number (global)))" and t = "src" and result = 0.06249999999999997 or
        repr = "(member type *)" and t = "src" and result = 1.0 or
        repr = "(member cid (member query *))" and t = "src" and result = 1.0 or
        repr = "(member next (member query *))" and t = "src" and result = 1.0 or
        repr = "(member useSegment (parameter list (parameter 1 (return (member get *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (member applyDelta (parameter t *)))" and t = "src" and result = 0.23500000000000007 or
        repr = "(parameter 0 (return (member createRule *)))" and t = "src" and result = 1.0 or
        repr = "(member linkId (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (parameter 0 (return (member map *))))" and t = "src" and result = 1.0 or
        repr = "(member cid (member params *))" and t = "src" and result = 1.0 or
        repr = "(member resetToken (parameter 1 (return (member render *))))" and t = "src" and result = 1.0 or
        repr = "(return (member makePredByNodeName *))" and t = "src" and result = 0.028193407894843207 or
        repr = "(parameter 0 (return (member parse (member JSON (global)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 2 (return (member countOpen *)))" and t = "src" and result = 1.0 or
        repr = "(member form *)" and t = "src" and result = 1.0 or
        repr = "(parameter field *)" and t = "src" and result = 0.2500000000000003 or
        repr = "(parameter 3 (return (member verbose (root https://www.npmjs.com/package/npmlog))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member redirect *)))" and t = "src" and result = 1.0 or
        repr = "(member limit *)" and t = "src" and result = 1.0 or
        repr = "(member template (member editorData *))" and t = "src" and result = 1.0 or
        repr = "(parameter 2 (return (member filterStatusSubscribers *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (member delete *))" and t = "src" and result = 0.12689393939393936 or
        repr = "(parameter 0 (return (member getResource *)))" and t = "src" and result = 1.0 or
        repr = "(member ucid (parameter subscription (parameter 2 (return (member get *)))))" and t = "src" and result = 1.0 or
        repr = "(member field (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member ucid (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member filterQuicklist *)))" and t = "src" and result = 1.0 or
        repr = "(member useSegment (parameter list *))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member checkResetToken *)))" and t = "src" and result = 1.0 or
        repr = "(parameter evt *)" and t = "src" and result = 1.0 or
        repr = "(member c *)" and t = "src" and result = 1.0 or
        repr = "(member reportTemplate *)" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member convertKeys *)))" and t = "src" and result = 1.0 or
        repr = "(member field (member params *))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member update *)))" and t = "src" and result = 1.0 or
        repr = "(member search *)" and t = "src" and result = 1.0 or
        repr = "(member next (parameter 1 (return (member render (parameter res *)))))" and t = "src" and result = 1.0 or
        repr = "(member keys *)" and t = "src" and result = 0.49667444078867595 or
        repr = "(parameter 3 (member uploadDir *))" and t = "src" and result = 1.0 or
        repr = "(parameter evt (parameter 1 (return (member addEventListener (global)))))" and t = "src" and result = 1.0 or
        repr = "(member segment (member query *))" and t = "src" and result = 1.0 or
        repr = "(parameter 4 (return (member countOpen *)))" and t = "src" and result = 1.0 or
        repr = "(member token *)" and t = "src" and result = 1.0 or
        repr = "(member access_token (member query *))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (member body (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member token (member query *))" and t = "src" and result = 1.0 or
        repr = "(return (member getAllResponseHeaders (parameter xhr *)))" and t = "src" and result = 0.031030684877244016 or
        repr = "(member campaign (parameter 1 (parameter 2 (return (member get *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member encodeURIComponent (global))))" and t = "src" and result = 1.0 or
        repr = "(member ucid (member params *))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member create *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member create *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member queryParams *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 2 (return (member error *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member findByAccessToken *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 4 (return (member verbose *)))" and t = "src" and result = 1.0 or
        repr = "(member listId (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member createRule *)))" and t = "src" and result = 1.0 or
        repr = "(member rule (member params *))" and t = "src" and result = 1.0 or
        repr = "(member template (member editorData (parameter resource *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member stop *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 4 (return (member countClick *)))" and t = "src" and result = 1.0 or
        repr = "(member campaign (parameter subscription (parameter 2 (return (member get *)))))" and t = "src" and result = 1.0 or
        repr = "(member template (member editorData (member resource *)))" and t = "src" and result = 1.0 or
        repr = "(member limit (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member useSegment *)" and t = "src" and result = 1.0 or
        repr = "(member field *)" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member reduce (parameter fieldList *))))" and t = "src" and result = 1.0 or
        repr = "(member fid (member query *))" and t = "src" and result = 1.0 or
        repr = "(member editor *)" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (member body *))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member redirect (parameter res *))))" and t = "src" and result = 1.0 or
        repr = "(parameter id *)" and t = "src" and result = 0.53125 or
        repr = "(member originalUrl *)" and t = "src" and result = 1.0 or
        repr = "(member reportTemplate (member query *))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member concat *)))" and t = "src" and result = 0.20000000000000018 or
        repr = "(member list (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member parent (member query *))" and t = "src" and result = 1.0 or
        repr = "(member cid *)" and t = "src" and result = 1.0 or
        repr = "(member parent *)" and t = "src" and result = 1.0 or
        repr = "(member ucid (parameter 1 (parameter 2 (return (member get *)))))" and t = "src" and result = 1.0 or
        repr = "(member c (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member join (root https://www.npmjs.com/package/path))))" and t = "src" and result = 1.0 or
        repr = "(member email (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member useSegment (parameter 1 (parameter 1 (return (member get *)))))" and t = "src" and result = 1.0 or
        repr = "(member editor (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member link (member params *))" and t = "src" and result = 1.0 or
        repr = "(member form (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member cid (parameter 1 (return (member formatMessage *))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member start *)))" and t = "src" and result = 1.0 or
        repr = "(member list *)" and t = "src" and result = 1.0 or
        repr = "(member editor (member query *))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter req (parameter 4 (return (member post *)))))" and t = "src" and result = 1.0 or
        repr = "(member access_token (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (member listTestUsers *))" and t = "src" and result = 0.12689393939393936 or
        repr = "(return (root https://www.npmjs.com/package/slugify))" and t = "src" and result = 0.5 or
        repr = "(member cid (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member segment (member params *))" and t = "src" and result = 1.0 or
        repr = "(member rule *)" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member keys *)))" and t = "src" and result = 1.0 or
        repr = "(member name (parameter 0 (return (member extend *))))" and t = "src" and result = 1.0 or
        repr = "(member name (parameter 0 (return (member listowner (parameter Database *)))))" and t = "src" and result = 1.0 or
        repr = "(member name (parameter 0 (return (member get_apikey (parameter User *)))))" and t = "src" and result = 1.0 or
        repr = "(member new (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member owner (member params *))" and t = "src" and result = 1.0 or
        repr = "(member regkey (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member regkey (parameter 0 (return (member extend *))))" and t = "src" and result = 1.0 or
        repr = "(member name (parameter 0 (return (member get_apikey *))))" and t = "src" and result = 1.0 or
        repr = "(member regkey (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member ip *)" and t = "src" and result = 1.0 or
        repr = "(member regkey (parameter $routeParams *))" and t = "src" and result = 1.0 or
        repr = "(member owner (parameter 0 (return (member insertOne *))))" and t = "src" and result = 1.0 or
        repr = "(member regkey (member params *))" and t = "src" and result = 1.0 or
        repr = "(member project *)" and t = "src" and result = 1.0 or
        repr = "(member owner (member $set *))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member error *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member createFromHexString *)))" and t = "src" and result = 1.0 or
        repr = "(member uid (parameter 0 (return (member updateOne *))))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member replace (member link *))))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (member onRequestUpdate_ (member prototype *)))" and t = "src" and result = 1.0 or
        repr = "(member apikey (parameter 0 (return (member findOne *))))" and t = "src" and result = 1.0 or
        repr = "(member name (parameter 0 (return (member update_password *))))" and t = "src" and result = 1.0 or
        repr = "(member x-api-key *)" and t = "src" and result = 1.0 or
        repr = "(member id (parameter $routeParams (parameter 1 (return (member controller *)))))" and t = "src" and result = 1.0 or
        repr = "(member old (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member info (return (member get *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter message (member onRequestUpdate_ (member prototype *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member set_data *)))" and t = "src" and result = 1.0 or
        repr = "(member user (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (member status (member $set *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (member link *))" and t = "src" and result = 1.0 or
        repr = "(member regkey (parameter 0 (return (member extend (parameter User *)))))" and t = "src" and result = 1.0 or
        repr = "(member group (member params *))" and t = "src" and result = 1.0 or
        repr = "(member name (parameter 0 (return (member get *))))" and t = "src" and result = 1.0 or
        repr = "(member secondarygroups *)" and t = "src" and result = 1.0 or
        repr = "(member project (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member id (parameter 0 (return (member findOne *))))" and t = "src" and result = 1.0 or
        repr = "(member new (member params *))" and t = "src" and result = 1.0 or
        repr = "(member regkey *)" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member createFromHexString (member ObjectID (root https://www.npmjs.com/package/mongodb)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member error (return (member get *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member info *)))" and t = "src" and result = 1.0 or
        repr = "(member ip (parameter 0 (return (member json (parameter res *)))))" and t = "src" and result = 1.0 or
        repr = "(member projects (parameter 0 (return (member find *))))" and t = "src" and result = 1.0 or
        repr = "(member projects *)" and t = "src" and result = 1.0 or
        repr = "(member owner (parameter 0 (return (member find *))))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member replace *)))" and t = "src" and result = 1.0 or
        repr = "(member id (parameter 0 (return (member updateOne *))))" and t = "src" and result = 1.0 or
        repr = "(parameter message (member onRequestUpdate_ (member prototype (member WrappedAuthenticatorPort_ *))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member get_data *)))" and t = "src" and result = 1.0 or
        repr = "(member owner (member $set (parameter 1 (return (member updateOne *)))))" and t = "src" and result = 1.0 or
        repr = "(member name (parameter 0 (return (member extend (parameter User *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (member onRequestUpdate_ *))" and t = "src" and result = 1.0 or
        repr = "(member name (member web *))" and t = "src" and result = 1.0 or
        repr = "(member id (parameter 0 (return (member user_list *))))" and t = "src" and result = 1.0 or
        repr = "(member id (parameter 0 (return (member project_delete_project *))))" and t = "src" and result = 1.0 or
        repr = "(member id (parameter $routeParams *))" and t = "src" and result = 1.0 or
        repr = "(member group (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member old *)" and t = "src" and result = 1.0 or
        repr = "(member name (parameter 0 (return (member update_password (parameter User *)))))" and t = "src" and result = 1.0 or
        repr = "(member uid (parameter 0 (return (member findOne *))))" and t = "src" and result = 1.0 or
        repr = "(member x-api-key (member headers (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member id (parameter 2 (parameter 1 (return (member controller *)))))" and t = "src" and result = 1.0 or
        repr = "(member regkey (parameter 2 (parameter 1 (return (member controller *)))))" and t = "src" and result = 1.0 or
        repr = "(member name (parameter 0 (return (member listowner (parameter Web *)))))" and t = "src" and result = 1.0 or
        repr = "(member name (parameter 0 (return (member findOne *))))" and t = "src" and result = 1.0 or
        repr = "(member name (parameter 0 (return (member send *))))" and t = "src" and result = 1.0 or
        repr = "(member apikey *)" and t = "src" and result = 1.0 or
        repr = "(member logs (parameter 0 (return (member updateOne *))))" and t = "src" and result = 1.0 or
        repr = "(member id (parameter 0 (return (member project_add_user_to_project *))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (member _id (parameter 0 (return (member updateOne *)))))" and t = "src" and result = 1.0 or
        repr = "(member regkey (parameter $routeParams (parameter 1 (return (member controller *)))))" and t = "src" and result = 1.0 or
        repr = "(member ip (parameter 0 (return (member json *))))" and t = "src" and result = 1.0 or
        repr = "(member owner (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (member onRequestUpdate_ (member prototype (member WrappedAuthenticatorPort_ *))))" and t = "src" and result = 1.0 or
        repr = "(member #DBUSER# *)" and t = "src" and result = 1.0 or
        repr = "(member regkey (member query *))" and t = "src" and result = 1.0 or
        repr = "(member name (parameter 0 (return (member listowner *))))" and t = "src" and result = 1.0 or
        repr = "(member #DBNAME# (parameter 1 (return (member send_notif_mail *))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (member status *))" and t = "src" and result = 1.0 or
        repr = "(member x-api-key (member headers *))" and t = "src" and result = 1.0 or
        repr = "(member old (member params *))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter 0 (parameter 1 (return (member delete *)))))" and t = "src" and result = 1.0 or
        repr = "(member name (parameter 0 (return (member send (parameter res *)))))" and t = "src" and result = 1.0 or
        repr = "(member id (parameter 0 (return (member deleteOne *))))" and t = "src" and result = 1.0 or
        repr = "(member user (member params *))" and t = "src" and result = 1.0 or
        repr = "(member name (member web (parameter 0 (return (member send *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member set_data *)))" and t = "src" and result = 1.0 or
        repr = "(member #DBNAME# *)" and t = "src" and result = 1.0 or
        repr = "(member #DBUSER# (parameter 1 (return (member send_notif_mail *))))" and t = "src" and result = 1.0 or
        repr = "(member owner *)" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member createFromHexString (member ObjectID *))))" and t = "src" and result = 1.0 or
        repr = "(member group (parameter 0 (return (member find *))))" and t = "src" and result = 1.0 or
        repr = "(member x-my-apikey (member headers *))" and t = "src" and result = 1.0 or
        repr = "(member name (parameter 0 (return (member updateOne *))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (member _id *))" and t = "src" and result = 1.0 or
        repr = "(member name (parameter 0 (return (member get (parameter User *)))))" and t = "src" and result = 1.0 or
        repr = "(member x-my-apikey *)" and t = "src" and result = 1.0 or
        repr = "(member project (member params *))" and t = "src" and result = 1.0 or
        repr = "(parameter message (member onRequestUpdate_ *))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member replace (member series *))))" and t = "src" and result = 1.0 or
        repr = "(member logs *)" and t = "src" and result = 1.0 or
        repr = "(member body (parameter req (parameter 1 (return (member delete *)))))" and t = "src" and result = 1.0 or
        repr = "(member x-my-apikey (member headers (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member id (parameter 0 (return (member user_list (parameter GOActionLog *)))))" and t = "src" and result = 1.0 or
        repr = "(member uid *)" and t = "src" and result = 1.0 or
        repr = "(parameter 3 (member instanceByUrl *))" and t = "src" and result = 1.0 or
        repr = "(member id (parameter 1 (return (member find *))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member json *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member remove *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member put (member storage *))))" and t = "src" and result = 1.0 or
        repr = "(member id (parameter req (member instanceByUrl *)))" and t = "src" and result = 1.0 or
        repr = "(member id (parameter 1 (return (member remove (root https://www.npmjs.com/package/lodash)))))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter req (parameter 2 (return (member put *)))))" and t = "src" and result = 1.0 or
        repr = "(member id (parameter req *))" and t = "src" and result = 1.0 or
        repr = "(member id (parameter 1 (return (member findIndex (root https://www.npmjs.com/package/lodash)))))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter req (member create *)))" and t = "src" and result = 1.0 or
        repr = "(member id (parameter 1 (return (member find (root https://www.npmjs.com/package/lodash)))))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter 0 (member create *)))" and t = "src" and result = 1.0 or
        repr = "(member id (parameter 0 (member instanceByUrl *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member put *)))" and t = "src" and result = 1.0 or
        repr = "(parameter id (member instance *))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member remove (member storage *))))" and t = "src" and result = 1.0 or
        repr = "(member url (parameter 0 (member show *)))" and t = "src" and result = 1.0 or
        repr = "(member url (parameter req (member show *)))" and t = "src" and result = 1.0 or
        repr = "(member id (parameter 1 (return (member remove *))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member put (member storage (root https://www.npmjs.com/package/node-shopping-list)))))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter 0 (parameter 2 (return (member put *)))))" and t = "src" and result = 1.0 or
        repr = "(member url (parameter req (member jump *)))" and t = "src" and result = 1.0 or
        repr = "(member id (parameter req (member instance *)))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter req (member update *)))" and t = "src" and result = 1.0 or
        repr = "(member q (parameter $routeParams *))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter 0 (member update *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member json (parameter res (member show *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member json (parameter 1 (member show *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member remove (member storage (root https://www.npmjs.com/package/node-shopping-list)))))" and t = "src" and result = 1.0 or
        repr = "(parameter id (member instanceByUrl *))" and t = "src" and result = 1.0 or
        repr = "(parameter 3 (member instance *))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member json (parameter res *))))" and t = "src" and result = 1.0 or
        repr = "(member url (parameter 0 (member jump *)))" and t = "src" and result = 1.0 or
        repr = "(member id (parameter 1 (return (member findIndex *))))" and t = "src" and result = 1.0 or
        repr = "(member id (parameter 0 (member instance *)))" and t = "src" and result = 1.0 or
        repr = "(parameter msg *)" and t = "src" and result = 1.0 or
        repr = "(return (member stringify *))" and t = "src" and result = 0.4800000000000002 or
        repr = "(parameter msg (parameter 1 (return (member on *))))" and t = "src" and result = 1.0 or
        repr = "(parameter stats *)" and t = "src" and result = 0.4800000000000001 or
        repr = "(parameter msg (parameter 1 (return (member on (parameter websocket *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (parameter 1 (return (member on (parameter websocket *)))))" and t = "src" and result = 1.0 or
        repr = "(member desc (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member userid (member query *))" and t = "src" and result = 1.0 or
        repr = "(member desc (member query *))" and t = "src" and result = 1.0 or
        repr = "(member desc *)" and t = "src" and result = 1.0 or
        repr = "(member userid *)" and t = "src" and result = 1.0 or
        repr = "(member userid (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member log (member console (global)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member log *)))" and t = "src" and result = 1.0 or
        repr = "(member postId (member params *))" and t = "src" and result = 1.0 or
        repr = "(member categoryId *)" and t = "src" and result = 1.0 or
        repr = "(member cookies (parameter req (parameter 0 (return (member use *)))))" and t = "src" and result = 1.0 or
        repr = "(member cookies (parameter 0 (parameter 0 (return (member use *)))))" and t = "src" and result = 1.0 or
        repr = "(member categoryId (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member postId *)" and t = "src" and result = 1.0 or
        repr = "(member postId (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member categoryId (member params *))" and t = "src" and result = 1.0 or
        repr = "(member ID (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter 0 (member createStudentenhuis *)))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter req (member updateMaaltijdById *))))" and t = "src" and result = 1.0 or
        repr = "(member studentenhuisID (member params (parameter 0 (member updateMaaltijdById *))))" and t = "src" and result = 1.0 or
        repr = "(member studentenhuisID (member params (parameter req (member getAllMaaltijden *))))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter 0 (member createMaaltijdById *))))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter 0 (member deleteMaaltijdById *))))" and t = "src" and result = 1.0 or
        repr = "(member maaltijdID (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter 0 (member getAllDeelnemersOfMaaltijd *))))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter req (member createMaaltijdById *))))" and t = "src" and result = 1.0 or
        repr = "(member maaltijdID (member params (parameter 0 (member updateMaaltijdById *))))" and t = "src" and result = 1.0 or
        repr = "(member maaltijdID (member params (parameter req (member getAllDeelnemersOfMaaltijd *))))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter 0 (member createStudentenhuis *))))" and t = "src" and result = 1.0 or
        repr = "(member maaltijdID *)" and t = "src" and result = 1.0 or
        repr = "(member maaltijdID (member params (parameter 0 (member createDeelnemer *))))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter req (member getStudentenhuisById *))))" and t = "src" and result = 1.0 or
        repr = "(member maaltijdID (member params (parameter 0 (member getMaaltijdById *))))" and t = "src" and result = 1.0 or
        repr = "(member ID (member params (parameter req (member updateStudentenhuisById *))))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter req (member updateMaaltijdById *)))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter req (member getAllStudentenhuizen *))))" and t = "src" and result = 1.0 or
        repr = "(member ID (member params (parameter 0 (member updateStudentenhuisById *))))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter 0 (member validateToken *))))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter 0 (member createDeelnemer *))))" and t = "src" and result = 1.0 or
        repr = "(member maaltijdID (member params (parameter req (member deleteDeelnemerFromMaaltijd *))))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter req (member createDeelnemer *))))" and t = "src" and result = 1.0 or
        repr = "(member studentenhuisID (member params (parameter req (member deleteDeelnemerFromMaaltijd *))))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter req (member updateStudentenhuisById *)))" and t = "src" and result = 1.0 or
        repr = "(member maaltijdID (member params (parameter req (member getMaaltijdById *))))" and t = "src" and result = 1.0 or
        repr = "(member maaltijdID (member params (parameter req (member updateMaaltijdById *))))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter 0 (member deleteDeelnemerFromMaaltijd *))))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter 0 (member createMaaltijdById *)))" and t = "src" and result = 1.0 or
        repr = "(member studentenhuisID *)" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter 0 (member updateMaaltijdById *))))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter req (member updateStudentenhuisById *))))" and t = "src" and result = 1.0 or
        repr = "(member studentenhuisID (member params (parameter 0 (member getAllMaaltijden *))))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter req (member createMaaltijdById *)))" and t = "src" and result = 1.0 or
        repr = "(member ID (member params *))" and t = "src" and result = 1.0 or
        repr = "(member maaltijdID (member params *))" and t = "src" and result = 1.0 or
        repr = "(member studentenhuisID (member params (parameter req (member createDeelnemer *))))" and t = "src" and result = 1.0 or
        repr = "(member studentenhuisID (member params *))" and t = "src" and result = 1.0 or
        repr = "(member studentenhuisID (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member ID (member params (parameter 0 (member deleteStudentenhuisById *))))" and t = "src" and result = 1.0 or
        repr = "(member maaltijdID (member params (parameter 0 (member getAllDeelnemersOfMaaltijd *))))" and t = "src" and result = 1.0 or
        repr = "(member studentenhuisID (member params (parameter 0 (member getAllDeelnemersOfMaaltijd *))))" and t = "src" and result = 1.0 or
        repr = "(return (member header *))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter 0 (member updateMaaltijdById *)))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter 0 (member updateStudentenhuisById *))))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter req (member getMaaltijdById *))))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter 0 (member updateStudentenhuisById *)))" and t = "src" and result = 1.0 or
        repr = "(member studentenhuisID (member params (parameter req (member getAllDeelnemersOfMaaltijd *))))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter 0 (member getAllStudentenhuizen *))))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter 0 (member getMaaltijdById *))))" and t = "src" and result = 1.0 or
        repr = "(member studentenhuisID (member params (parameter req (member updateMaaltijdById *))))" and t = "src" and result = 1.0 or
        repr = "(member ID (member params (parameter req (member deleteStudentenhuisById *))))" and t = "src" and result = 1.0 or
        repr = "(member studentenhuisID (member params (parameter 0 (member getMaaltijdById *))))" and t = "src" and result = 1.0 or
        repr = "(member studentenhuisID (member params (parameter 0 (member createMaaltijdById *))))" and t = "src" and result = 1.0 or
        repr = "(member studentenhuisID (member params (parameter req (member createMaaltijdById *))))" and t = "src" and result = 1.0 or
        repr = "(member maaltijdID (member params (parameter 0 (member deleteDeelnemerFromMaaltijd *))))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter 0 (member deleteStudentenhuisById *))))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter req (member getAllMaaltijden *))))" and t = "src" and result = 1.0 or
        repr = "(member maaltijdID (member params (parameter req (member deleteMaaltijdById *))))" and t = "src" and result = 1.0 or
        repr = "(member studentenhuisID (member params (parameter req (member deleteMaaltijdById *))))" and t = "src" and result = 1.0 or
        repr = "(member ID (member params (parameter 0 (member getStudentenhuisById *))))" and t = "src" and result = 1.0 or
        repr = "(member studentenhuisID (member params (parameter 0 (member deleteMaaltijdById *))))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter req (member validateToken *))))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter req (member createStudentenhuis *))))" and t = "src" and result = 1.0 or
        repr = "(member ID (member params (parameter req (member getStudentenhuisById *))))" and t = "src" and result = 1.0 or
        repr = "(member studentenhuisID (member params (parameter 0 (member deleteDeelnemerFromMaaltijd *))))" and t = "src" and result = 1.0 or
        repr = "(member studentenhuisID (member params (parameter req (member getMaaltijdById *))))" and t = "src" and result = 1.0 or
        repr = "(member maaltijdID (member params (parameter req (member createDeelnemer *))))" and t = "src" and result = 1.0 or
        repr = "(member ID *)" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter req (member deleteStudentenhuisById *))))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter 0 (member getAllMaaltijden *))))" and t = "src" and result = 1.0 or
        repr = "(member body (parameter req (member createStudentenhuis *)))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter req (member deleteMaaltijdById *))))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter 0 (member getStudentenhuisById *))))" and t = "src" and result = 1.0 or
        repr = "(member studentenhuisID (member params (parameter 0 (member createDeelnemer *))))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter req (member getAllDeelnemersOfMaaltijd *))))" and t = "src" and result = 1.0 or
        repr = "(member maaltijdID (member params (parameter 0 (member deleteMaaltijdById *))))" and t = "src" and result = 1.0 or
        repr = "(return (member header (parameter req (member deleteDeelnemerFromMaaltijd *))))" and t = "src" and result = 1.0 or
        repr = "(member firstName (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member firstName *)" and t = "src" and result = 1.0 or
        repr = "(member firstName (member query *))" and t = "src" and result = 1.0 or
        repr = "(member chatRoom (parameter 0 (return (member find *))))" and t = "src" and result = 1.0 or
        repr = "(parameter proxy_response (parameter 1 (return (member addListener *))))" and t = "src" and result = 1.0 or
        repr = "(member todo_id (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member todo_id (member params *))" and t = "src" and result = 1.0 or
        repr = "(member _id *)" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (parameter 1 (return (member addListener *))))" and t = "src" and result = 1.0 or
        repr = "(member url (parameter request *))" and t = "src" and result = 1.0 or
        repr = "(member chatRoom *)" and t = "src" and result = 1.0 or
        repr = "(member todo_id *)" and t = "src" and result = 1.0 or
        repr = "(parameter proxy_response *)" and t = "src" and result = 1.0 or
        repr = "(member _id (parameter 0 (return (member remove *))))" and t = "src" and result = 1.0 or
        repr = "(parameter chunk (parameter 1 (return (member addListener *))))" and t = "src" and result = 1.0 or
        repr = "(parameter chunk *)" and t = "src" and result = 1.0 or
        repr = "(parameter chunk (parameter 1 (return (member addListener (parameter proxy_response *)))))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (parameter 1 (return (member addListener (parameter proxy_response *)))))" and t = "src" and result = 1.0 or
        repr = "(member year (member params *))" and t = "src" and result = 1.0 or
        repr = "(member projectname (member query *))" and t = "src" and result = 1.0 or
        repr = "(member id (member params (parameter 0 (member ensureUserCanEdit *))))" and t = "src" and result = 1.0 or
        repr = "(member page (member query *))" and t = "src" and result = 1.0 or
        repr = "(member minbounty (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member page (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member status (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member page *)" and t = "src" and result = 1.0 or
        repr = "(member minbounty (member query *))" and t = "src" and result = 1.0 or
        repr = "(member projectname *)" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member delClaim *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member escapeHtml (global))))" and t = "src" and result = 1.0 or
        repr = "(member size (member query *))" and t = "src" and result = 1.0 or
        repr = "(member size *)" and t = "src" and result = 1.0 or
        repr = "(member minbounty *)" and t = "src" and result = 1.0 or
        repr = "(member status (member query *))" and t = "src" and result = 1.0 or
        repr = "(member maxbounty (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member size (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member maxbounty (member query *))" and t = "src" and result = 1.0 or
        repr = "(member id (member params (parameter req (member ensureUserCanEdit *))))" and t = "src" and result = 1.0 or
        repr = "(parameter 1 (return (member updateClaim *)))" and t = "src" and result = 1.0 or
        repr = "(member year (member params (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member maxbounty *)" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member updateClaim *)))" and t = "src" and result = 1.0 or
        repr = "(parameter 0 (return (member getClaimById *)))" and t = "src" and result = 1.0 or
        repr = "(member projectname (member query (parameter req *)))" and t = "src" and result = 1.0 or
        repr = "(member year *)" and t = "src" and result = 1.0
        or
        repr = "(parameter 0 (return (member updateAttributes (parameter basket *))))" and t = "snk" and result = 0.5400000000000003 or
        repr = "(member description *)" and t = "snk" and result = 0.7516778523489933 or
        repr = "(parameter 0 (return (member json *)))" and t = "snk" and result = 0.7933333333333336 or
        repr = "(parameter 0 (return (member sendNotification *)))" and t = "snk" and result = 0.5 or
        repr = "(return (member updateAttributes *))" and t = "snk" and result = 0.40800000000000014 or
        repr = "(parameter 0 (return (member contains *)))" and t = "snk" and result = 0.2846439393939394 or
        repr = "(parameter 0 (return (member text (return (root https://www.npmjs.com/package/pdfkit)))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member findById (member SecurityQuestion *))))" and t = "snk" and result = 0.3529411764705872 or
        repr = "(parameter 0 (return (member findById *)))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member discountFromCoupon *)))" and t = "snk" and result = 0.20000000000000018 or
        repr = "(parameter 0 (return (member queryResultToJson *)))" and t = "snk" and result = 0.30000000000000004 or
        repr = "(return (member search (parameter productService *)))" and t = "snk" and result = 0.3322147651006711 or
        repr = "(parameter 0 (return (member findById (member User *))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member containsOrEscaped *)))" and t = "snk" and result = 0.19050000000000003 or
        repr = "(parameter 0 (return (member text (instance (root https://www.npmjs.com/package/pdfkit)))))" and t = "snk" and result = 0.2727272727272726 or
        repr = "(member UserId (parameter data (parameter 0 (return (member then *)))))" and t = "snk" and result = 0.9411764705882347 or
        repr = "(member id (member data *))" and t = "snk" and result = 0.9411764705882347 or
        repr = "(return (member findById *))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member findChallenge *)))" and t = "snk" and result = 0.25 or
        repr = "(parameter 0 (return (member json (return (member status *)))))" and t = "snk" and result = 0.15999999999999936 or
        repr = "(member items (parameter 0 (return (member json *))))" and t = "snk" and result = 1.0 or
        repr = "(return (member toString *))" and t = "snk" and result = 0.4734848484848485 or
        repr = "(parameter 0 (return (member push (parameter 0 (member onDropField *)))))" and t = "snk" and result = 0.9675000000000005 or
        repr = "(member columns (parameter schema *))" and t = "snk" and result = 0.4705882352941174 or
        repr = "(member items *)" and t = "snk" and result = 0.686668610197169 or
        repr = "(parameter 0 (instance (parameter Noty *)))" and t = "snk" and result = 0.2250000000000001 or
        repr = "(parameter 0 (return (member get *)))" and t = "snk" and result = 0.6125 or
        repr = "(member items (parameter 0 (return (member json (parameter res *)))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member push *)))" and t = "snk" and result = 0.39527518640377474 or
        repr = "(member columns *)" and t = "snk" and result = 0.5294117647058826 or
        repr = "(return (member map (member columns *)))" and t = "snk" and result = 0.31999999999999873 or
        repr = "(return (member generatorCode *))" and t = "snk" and result = 0.25 or
        repr = "(member results (parameter data (parameter 0 (return (member then *)))))" and t = "snk" and result = 1.0 or
        repr = "(return (member stringify *))" and t = "snk" and result = 1.0 or
        repr = "(member results (parameter 0 (parameter 0 (return (member then *)))))" and t = "snk" and result = 1.0 or
        repr = "(member insertId *)" and t = "snk" and result = 1.0 or
        repr = "(member results (parameter data *))" and t = "snk" and result = 0.8235294117647053 or
        repr = "(parameter 0 (return (member load (member scriptLoader *))))" and t = "snk" and result = 0.5132 or
        repr = "(member elem (return (member createTween *)))" and t = "snk" and result = 0.4854522454142947 or
        repr = "(member class (member attributes *))" and t = "snk" and result = 0.6111962352941176 or
        repr = "(return (member call (parameter t *)))" and t = "snk" and result = 1.0 or
        repr = "(member classList (parameter e *))" and t = "snk" and result = 0.17213608237716974 or
        repr = "(return (member join (return (member sort *))))" and t = "snk" and result = 0.30164007766990286 or
        repr = "(parameter 0 (return (member charAt (member referrer *))))" and t = "snk" and result = 0.5 or
        repr = "(member element (parameter a *))" and t = "snk" and result = 0.7031162687378641 or
        repr = "(member 0 (parameter t *))" and t = "snk" and result = 0.25 or
        repr = "(parameter 0 (return (member unfold *)))" and t = "snk" and result = 1.0 or
        repr = "(return (member call (member map *)))" and t = "snk" and result = 0.6196447230929988 or
        repr = "(parameter 0 (return (member push (return (member $assembleMultilineRegExp *)))))" and t = "snk" and result = 0.30227207766990294 or
        repr = "(parameter 0 (return (member insert *)))" and t = "snk" and result = 0.2990063961413445 or
        repr = "(parameter 0 (return (member is *)))" and t = "snk" and result = 0.0755555555555556 or
        repr = "(parameter 2 (return (member style (member constructor (member prototype *)))))" and t = "snk" and result = 0.272727272727273 or
        repr = "(parameter 0 (return (member push (member modifiers *))))" and t = "snk" and result = 0.42999999999999994 or
        repr = "(parameter 3 (return (member Range (return (parameter e *)))))" and t = "snk" and result = 1.0 or
        repr = "(member overflowX (member style (parameter t *)))" and t = "snk" and result = 0.03763440860215107 or
        repr = "(parameter 0 (return (return (parameter e *))))" and t = "snk" and result = 0.16999999999999998 or
        repr = "(member start *)" and t = "snk" and result = 0.39 or
        repr = "(parameter 0 (return (member appendChild *)))" and t = "snk" and result = 0.25757575757575757 or
        repr = "(parameter 2 (return (return (return (parameter e *)))))" and t = "snk" and result = 0.364 or
        repr = "(parameter 4 (return (return (member compile *))))" and t = "snk" and result = 0.7857142857142856 or
        repr = "(parameter 0 (return (member insertBefore *)))" and t = "snk" and result = 0.3122243354784872 or
        repr = "(parameter 0 (return (member bind (return (parameter t *)))))" and t = "snk" and result = 1.0 or
        repr = "(return (member substr *))" and t = "snk" and result = 0.40849599999999997 or
        repr = "(return (member call (member slice *)))" and t = "snk" and result = 0.64 or
        repr = "(parameter 2 (return (member style (member jQuery (parameter t *)))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member after (return (parameter t *)))))" and t = "snk" and result = 0.25 or
        repr = "(parameter 4 (return (parameter 0 (member select *))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 1 (return (member makeSpan *)))" and t = "snk" and result = 0.20202020202020204 or
        repr = "(parameter 0 (return (member query *)))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member moveText (member editor *))))" and t = "snk" and result = 0.30303030303030304 or
        repr = "(member 0 (return (member split (member hostname *))))" and t = "snk" and result = 0.5775757575757576 or
        repr = "(member s *)" and t = "snk" and result = 0.6748828282828284 or
        repr = "(member data *)" and t = "snk" and result = 0.2567341121443756 or
        repr = "(parameter 0 (return (member render *)))" and t = "snk" and result = 0.33999999999999997 or
        repr = "(parameter 0 (return (member add *)))" and t = "snk" and result = 0.5 or
        repr = "(parameter 0 (return (member render (member prototype *))))" and t = "snk" and result = 0.6860606060606063 or
        repr = "(member old (return (member extend (member $ *))))" and t = "snk" and result = 1.0 or
        repr = "(return (member replace (member 3 (return (member match *)))))" and t = "snk" and result = 0.5250390572390573 or
        repr = "(member className *)" and t = "snk" and result = 0.04630415533980589 or
        repr = "(member firstChild (return (member getElementById (member document (global)))))" and t = "snk" and result = 0.06313131313131308 or
        repr = "(parameter 0 (return (member clearTimeout (global))))" and t = "snk" and result = 0.25 or
        repr = "(member 1 (return (member match *)))" and t = "snk" and result = 0.1412 or
        repr = "(parameter 0 (return (member comparePoint (member $clickSelection *))))" and t = "snk" and result = 0.32412509691122393 or
        repr = "(member old (return (member speed (member constructor *))))" and t = "snk" and result = 0.0833333333333334 or
        repr = "(parameter 0 (return (member parse *)))" and t = "snk" and result = 0.24614141414141497 or
        repr = "(member 0 (return (member split (member backgroundSize *))))" and t = "snk" and result = 0.5 or
        repr = "(parameter 0 (return (member insertBefore (member parentNode (parameter t *)))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member removeChild (member parentNode *))))" and t = "snk" and result = 0.5151515151515149 or
        repr = "(member type *)" and t = "snk" and result = 0.025749967812540242 or
        repr = "(parameter 0 (return (member clearInterval (global))))" and t = "snk" and result = 0.25 or
        repr = "(return (member Number (global)))" and t = "snk" and result = 0.272 or
        repr = "(parameter 2 (return (member _data (member jQuery (parameter t *)))))" and t = "snk" and result = 0.7500000000000004 or
        repr = "(parameter 0 (return (member indexOf *)))" and t = "snk" and result = 0.3125 or
        repr = "(return (member substr (member autoInsertedLineEnd *)))" and t = "snk" and result = 0.30332775757575753 or
        repr = "(parameter 1 (return (parameter i *)))" and t = "snk" and result = 0.75 or
        repr = "(return (member eval *))" and t = "snk" and result = 0.5077777777777778 or
        repr = "(member end *)" and t = "snk" and result = 0.39 or
        repr = "(parameter 1 (return (member attr *)))" and t = "snk" and result = 0.31310291262135914 or
        repr = "(member 3 (return (member match (parameter e *))))" and t = "snk" and result = 0.5250390572390573 or
        repr = "(parameter 0 (return (member isNumeric (member $ *))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member isNaN (global))))" and t = "snk" and result = 0.017799999999999983 or
        repr = "(member Parser (member less *))" and t = "snk" and result = 0.7867647058823528 or
        repr = "(return (member createTextNode (member document (global))))" and t = "snk" and result = 0.5 or
        repr = "(parameter 0 (return (member push (return (member $getFoldLineTokens *)))))" and t = "snk" and result = 0.20172614293375304 or
        repr = "(parameter 0 (return (parameter n *)))" and t = "snk" and result = 0.7575757575757576 or
        repr = "(parameter 0 (return (member rgba (member functions (parameter e *)))))" and t = "snk" and result = 0.7857142857142856 or
        repr = "(parameter 0 (member data *))" and t = "snk" and result = 0.2738750722961252 or
        repr = "(return (member duration *))" and t = "snk" and result = 1.0 or
        repr = "(member parentNode (parameter e *))" and t = "snk" and result = 0.7424242424242425 or
        repr = "(parameter 2 (return (member style *)))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member addRange (member multiSelect *))))" and t = "snk" and result = 0.6507499999999999 or
        repr = "(member 1 (return (member exec *)))" and t = "snk" and result = 0.08453333333333346 or
        repr = "(parameter 0 (return (member get (member tabIndex *))))" and t = "snk" and result = 0.17280000000000006 or
        repr = "(parameter 0 (return (member hasOwnProperty *)))" and t = "snk" and result = 0.546922993751061 or
        repr = "(return (member replace (return (member replace *))))" and t = "snk" and result = 0.9668970873786409 or
        repr = "(parameter 0 (return (member replaceChild *)))" and t = "snk" and result = 0.5151515151515151 or
        repr = "(parameter 0 (return (member isNumeric (member constructor *))))" and t = "snk" and result = 1.0 or
        repr = "(member r *)" and t = "snk" and result = 0.2249609427609427 or
        repr = "(return (member match *))" and t = "snk" and result = 0.0445333333333332 or
        repr = "(parameter 1 (return (parameter t *)))" and t = "snk" and result = 0.25592396116504856 or
        repr = "(parameter 1 (return (member max *)))" and t = "snk" and result = 0.5671198058252426 or
        repr = "(member sheets (member exports (global)))" and t = "snk" and result = 0.7867647058823528 or
        repr = "(member g *)" and t = "snk" and result = 0.2249609427609427 or
        repr = "(member maybeInsertedBrackets *)" and t = "snk" and result = 0.7575757575757576 or
        repr = "(parameter 1 (parameter 0 (return (member setTimeout (global)))))" and t = "snk" and result = 0.7968498316498319 or
        repr = "(parameter 0 (return (member isNumeric (member jQuery (parameter t *)))))" and t = "snk" and result = 0.272727272727273 or
        repr = "(parameter 0 (return (member setHtml *)))" and t = "snk" and result = 0.17500582524271857 or
        repr = "(parameter 0 (parameter 0 (return (member max *))))" and t = "snk" and result = 0.625 or
        repr = "(parameter 2 (return (member _data (member jQuery *))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member appendChild (return (member getElementById *)))))" and t = "snk" and result = 0.5 or
        repr = "(parameter 0 (return (member push (member items (member toolbar *)))))" and t = "snk" and result = 0.6186613743031687 or
        repr = "(parameter 0 (return (member addCommandKeyListener (return (parameter e *)))))" and t = "snk" and result = 0.03388385104518635 or
        repr = "(member 0 (return (member rectangularRangeBlock (member selection (member editor *)))))" and t = "snk" and result = 0.38599999999999995 or
        repr = "(member 3 (return (member exec *)))" and t = "snk" and result = 0.47773333333333345 or
        repr = "(parameter 0 (return (member push (parameter b *))))" and t = "snk" and result = 0.515151515151515 or
        repr = "(parameter 0 (return (member onCompositionUpdate (parameter t *))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member query (return (member createConnection *)))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member moveToElementEditStart *)))" and t = "snk" and result = 0.125 or
        repr = "(parameter 1 (return (member call *)))" and t = "snk" and result = 0.3750000000000001 or
        repr = "(parameter 0 (instance (member RegExp (global))))" and t = "snk" and result = 0.542848881577352 or
        repr = "(parameter 0 (return (member parseFloat (global))))" and t = "snk" and result = 0.3932 or
        repr = "(parameter 1 (return (member setAttribute (member meta (global)))))" and t = "snk" and result = 0.033102912621359115 or
        repr = "(member type (parameter e *))" and t = "snk" and result = 0.5297743305638025 or
        repr = "(return (member parseInt (global)))" and t = "snk" and result = 0.5250390572390573 or
        repr = "(member value (return (member highlight *)))" and t = "snk" and result = 0.8746210658145768 or
        repr = "(parameter 0 (return (member push (member requireFail *))))" and t = "snk" and result = 0.42999999999999994 or
        repr = "(parameter 0 (return (member checkBoundaryOfElement *)))" and t = "snk" and result = 0.125 or
        repr = "(parameter 0 (return (member insertBefore (member parentNode *))))" and t = "snk" and result = 0.4696969696969697 or
        repr = "(parameter 0 (return (member exec *)))" and t = "snk" and result = 0.3999999999999998 or
        repr = "(parameter 0 (return (parameter i *)))" and t = "snk" and result = 0.25 or
        repr = "(member hostPart *)" and t = "snk" and result = 0.5784377920620345 or
        repr = "(parameter 2 (return (member _data (member $ *))))" and t = "snk" and result = 1.0 or
        repr = "(member 1 (return (member split (member backgroundSize *))))" and t = "snk" and result = 0.32000000000000006 or
        repr = "(parameter 0 (return (member val (return (parameter t *)))))" and t = "snk" and result = 0.5 or
        repr = "(member parentNode *)" and t = "snk" and result = 0.25757575757575746 or
        repr = "(parameter 0 (return (member rgba (member functions *))))" and t = "snk" and result = 1.0 or
        repr = "(member P *)" and t = "snk" and result = 0.125 or
        repr = "(parameter 0 (return (member postformat (return (member lang *)))))" and t = "snk" and result = 0.5454545454545452 or
        repr = "(parameter 0 (return (member max (member Math (global)))))" and t = "snk" and result = 0.05939519417475769 or
        repr = "(parameter 1 (return (member setAttribute (parameter a *))))" and t = "snk" and result = 0.26226700000000025 or
        repr = "(member load *)" and t = "snk" and result = 0.14 or
        repr = "(parameter 0 (return (member $ (global))))" and t = "snk" and result = 0.31547444492167154 or
        repr = "(parameter 0 (return (member push (parameter b (member render *)))))" and t = "snk" and result = 0.7149999999999999 or
        repr = "(parameter 0 (return (member html *)))" and t = "snk" and result = 0.9652000000000003 or
        repr = "(return (member $ (global)))" and t = "snk" and result = 0.32693798058252427 or
        repr = "(parameter 3 (instance (member Range (return (parameter e *)))))" and t = "snk" and result = 0.908496 or
        repr = "(parameter 0 (return (member call (member hasOwnProperty *))))" and t = "snk" and result = 0.8344 or
        repr = "(parameter 0 (return (member trim (return (member noConflict *)))))" and t = "snk" and result = 0.5163357858009707 or
        repr = "(parameter 0 (return (member trim (member jQuery (parameter t *)))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 1 (return (member setTimeout (global))))" and t = "snk" and result = 0.23325750000000012 or
        repr = "(parameter 0 (return (parameter t *)))" and t = "snk" and result = 0.25 or
        repr = "(parameter 0 (return (member trim *)))" and t = "snk" and result = 0.8576036081384228 or
        repr = "(parameter 0 (return (member Error (global))))" and t = "snk" and result = 0.5443285436893204 or
        repr = "(member autoInsertedLineEnd *)" and t = "snk" and result = 0.25 or
        repr = "(member load (member WebFont *))" and t = "snk" and result = 1.0 or
        repr = "(member fileName *)" and t = "snk" and result = 0.75 or
        repr = "(return (member sanitizeValue *))" and t = "snk" and result = 0.59882875 or
        repr = "(parameter 0 (parameter 0 (return (member backfill *))))" and t = "snk" and result = 0.07550384466019422 or
        repr = "(member overflowY *)" and t = "snk" and result = 0.03763440860215107 or
        repr = "(parameter 0 (return (member insertBefore (member parentNode (member nextSibling *)))))" and t = "snk" and result = 1.0 or
        repr = "(member 2 (return (member exec *)))" and t = "snk" and result = 0.2611333333333333 or
        repr = "(parameter 1 (return (member set (member data (parameter a *)))))" and t = "snk" and result = 0.08532767990585453 or
        repr = "(parameter 0 (return (member push (member items *))))" and t = "snk" and result = 0.1875757575757575 or
        repr = "(return (member join *))" and t = "snk" and result = 0.4014743368181682 or
        repr = "(parameter 0 (return (member unbind (return (parameter t *)))))" and t = "snk" and result = 1.0 or
        repr = "(return (member replace (return (member join *))))" and t = "snk" and result = 0.7031162687378641 or
        repr = "(return (member e *))" and t = "snk" and result = 0.29753216823506806 or
        repr = "(parameter 2 (return (member render (member katex (global)))))" and t = "snk" and result = 0.33999999999999997 or
        repr = "(return (member call (parameter 0 (member wrapInner *))))" and t = "snk" and result = 0.272727272727273 or
        repr = "(parameter 0 (return (member createTextNode (member document (global)))))" and t = "snk" and result = 0.24424242424242426 or
        repr = "(parameter 0 (return (member removeMarker (member session (member editor *)))))" and t = "snk" and result = 0.7575757575757576 or
        repr = "(parameter 0 (return (member TypeError (global))))" and t = "snk" and result = 0.65 or
        repr = "(parameter 0 (return (member push (parameter i *))))" and t = "snk" and result = 0.46310291262135905 or
        repr = "(parameter 1 (return (member bind *)))" and t = "snk" and result = 0.16835016835016833 or
        repr = "(parameter 0 (return (member test *)))" and t = "snk" and result = 0.36386666666666667 or
        repr = "(member overflow (member style (parameter t *)))" and t = "snk" and result = 0.03763440860215107 or
        repr = "(parameter 1 (return (member set (member data *))))" and t = "snk" and result = 1.0 or
        repr = "(member 0 (return (member split *)))" and t = "snk" and result = 0.5 or
        repr = "(parameter 0 (return (member compareDocumentPosition (parameter t *))))" and t = "snk" and result = 0.31060606060606066 or
        repr = "(parameter 1 (return (member pastFuture *)))" and t = "snk" and result = 0.3599999999999998 or
        repr = "(parameter 0 (parameter 0 (return (member push *))))" and t = "snk" and result = 0.31417931569108587 or
        repr = "(parameter 0 (return (member tinycolor (global))))" and t = "snk" and result = 0.12540961553398045 or
        repr = "(parameter 0 (return (parameter e (member forEach *))))" and t = "snk" and result = 0.7575757575757576 or
        repr = "(parameter 0 (return (member getTextRange (member doc *))))" and t = "snk" and result = 0.7575757575757576 or
        repr = "(member watchTimer *)" and t = "snk" and result = 0.7053571428571427 or
        repr = "(parameter 0 (return (member Function (global))))" and t = "snk" and result = 0.08382424242424238 or
        repr = "(parameter 2 (return (member callback *)))" and t = "snk" and result = 0.030000000000000027 or
        repr = "(member addExternalUserId *)" and t = "snk" and result = 0.5 or
        repr = "(return (member makeSpan (return (parameter e *))))" and t = "snk" and result = 0.5990000000000001 or
        repr = "(parameter 0 (return (member call (member hasOwnProperty (member prototype *)))))" and t = "snk" and result = 0.041173921028466356 or
        repr = "(return (member toLowerCase *))" and t = "snk" and result = 0.503325559211324 or
        repr = "(parameter 2 (return (member open *)))" and t = "snk" and result = 0.13374999999999998 or
        repr = "(member group *)" and t = "snk" and result = 0.25 or
        repr = "(member b *)" and t = "snk" and result = 0.22496094276094275 or
        repr = "(parameter 0 (return (member setAttributeNode (parameter t *))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member indexOf (parameter t *))))" and t = "snk" and result = 0.625 or
        repr = "(member classList *)" and t = "snk" and result = 0.17213608237716974 or
        repr = "(return (member after (return (member jQuery (global)))))" and t = "snk" and result = 0.3787878787878788 or
        repr = "(parameter 1 (return (member Range (return (parameter e *)))))" and t = "snk" and result = 1.0 or
        repr = "(member mobile *)" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member push (parameter i (member find *)))))" and t = "snk" and result = 0.21689708737864083 or
        repr = "(parameter 1 (return (member setStyle (return (member getFirst *)))))" and t = "snk" and result = 0.36651500000000015 or
        repr = "(member row *)" and t = "snk" and result = 0.20390171421177217 or
        repr = "(member old (return (member speed (member constructor (member prototype *)))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member hasOwnProperty (member k (parameter e *)))))" and t = "snk" and result = 0.5151515151515149 or
        repr = "(return (member concat (return (member concat *))))" and t = "snk" and result = 0.24389323977653812 or
        repr = "(parameter 0 (return (member addRange *)))" and t = "snk" and result = 0.34925 or
        repr = "(parameter 0 (return (return (member bind (member call *)))))" and t = "snk" and result = 0.5 or
        repr = "(member value *)" and t = "snk" and result = 0.1890113475426337 or
        repr = "(parameter 0 (return (member onCompositionUpdate (parameter 1 (member TextInput *)))))" and t = "snk" and result = 0.5289474759012164 or
        repr = "(return (member call *))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (parameter 1 (member parse *))))" and t = "snk" and result = 0.13494949494949454 or
        repr = "(parameter 0 (return (member removeChild (member parentNode (parameter e *)))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member replaceChild (return (member createElement *)))))" and t = "snk" and result = 0.2424242424242423 or
        repr = "(parameter 0 (return (member getUserName (global))))" and t = "snk" and result = 0.24000000000000005 or
        repr = "(member payload (return (member parse (member JSON (global)))))" and t = "snk" and result = 0.5151515151515149 or
        repr = "(parameter 0 (return (member send *)))" and t = "snk" and result = 0.7300000000000002 or
        repr = "(parameter 0 (return (member log (member console (global)))))" and t = "snk" and result = 0.75 or
        repr = "(parameter 0 (return (member sendFile (parameter res *))))" and t = "snk" and result = 1.0 or
        repr = "(return (member pop (return (member split (member url *)))))" and t = "snk" and result = 0.7575757575757576 or
        repr = "(parameter 0 (return (member query (instance (member Pool *)))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 1 (return (member setHeader *)))" and t = "snk" and result = 0.2999999999999996 or
        repr = "(parameter 0 (return (member readFileSync (root https://www.npmjs.com/package/fs))))" and t = "snk" and result = 0.5999999999999992 or
        repr = "(parameter 0 (return (member send (parameter response *))))" and t = "snk" and result = 0.0399999999999997 or
        repr = "(return (member split (return (member pop *))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member includes *)))" and t = "snk" and result = 0.16999999999999993 or
        repr = "(parameter 1 (return (member log (member console (global)))))" and t = "snk" and result = 1.0 or
        repr = "(member name *)" and t = "snk" and result = 0.7326648026289196 or
        repr = "(parameter 0 (return (member query (return (member Pool *)))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member run (instance (member Database *)))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member run (return (member Database *)))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member run *)))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member concat (member Buffer (global)))))" and t = "snk" and result = 0.5 or
        repr = "(parameter 0 (return (member stringify *)))" and t = "snk" and result = 0.5 or
        repr = "(return (member shift (return (member concat *))))" and t = "snk" and result = 0.3844414292175486 or
        repr = "(member column (member start *))" and t = "snk" and result = 0.3211459267195822 or
        repr = "(parameter 0 (return (parameter errorHandler *)))" and t = "snk" and result = 0.32999999999999996 or
        repr = "(member 0 (return (member select *)))" and t = "snk" and result = 0.7575757575757576 or
        repr = "(parameter 0 (return (member unfold (member session *))))" and t = "snk" and result = 0.9999999999999998 or
        repr = "(return (member toString (parameter key *)))" and t = "snk" and result = 0.30060606060606043 or
        repr = "(parameter 0 (return (parameter successHandler *)))" and t = "snk" and result = 0.14000000000000012 or
        repr = "(parameter 0 (return (parameter 1 (return (member get *)))))" and t = "snk" and result = 0.38131313131313127 or
        repr = "(return (member trim (return (member toLowerCase *))))" and t = "snk" and result = 0.508500396728867 or
        repr = "(parameter 1 (return (parameter callback *)))" and t = "snk" and result = 0.42999999999999994 or
        repr = "(member length *)" and t = "snk" and result = 0.5656757770771567 or
        repr = "(parameter 0 (return (member onCompositionUpdate *)))" and t = "snk" and result = 0.7500000000000001 or
        repr = "(parameter 0 (return (parameter 4 (return (member addConfirmation *)))))" and t = "snk" and result = 0.5050505050505051 or
        repr = "(parameter 1 (return (member query *)))" and t = "snk" and result = 0.4375 or
        repr = "(parameter 0 (return (member json (parameter res *))))" and t = "snk" and result = 0.6599999999999999 or
        repr = "(parameter 1 (return (member render (parameter res *))))" and t = "snk" and result = 0.6083333333333336 or
        repr = "(parameter 0 (return (member redirect (parameter res (member login *)))))" and t = "snk" and result = 0.8333333333333334 or
        repr = "(member column *)" and t = "snk" and result = 0.3455207399470843 or
        repr = "(member params (member component (parameter c (member Pb (member g *)))))" and t = "snk" and result = 0.5714285714285687 or
        repr = "(parameter 0 (return (member Ca *)))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member findMailByCampaign *)))" and t = "snk" and result = 0.3731343283582089 or
        repr = "(parameter 0 (return (root https://www.npmjs.com/package/request)))" and t = "snk" and result = 0.27520000000000033 or
        repr = "(member customFields *)" and t = "snk" and result = 1.0 or
        repr = "(parameter 1 (return (member apply (member splice *))))" and t = "snk" and result = 1.0 or
        repr = "(return (member map *))" and t = "snk" and result = 0.33333333333333326 or
        repr = "(parameter 3 (return (member sendConfirmSubscription *)))" and t = "snk" and result = 0.08499999999999996 or
        repr = "(parameter 4 (return (member formatMessage *)))" and t = "snk" and result = 0.25 or
        repr = "(parameter 0 (return (member consumeEntity (member EntityParser (parameter n *)))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 2 (return (member list *)))" and t = "snk" and result = 0.32249999999999984 or
        repr = "(parameter 0 (return (member fromOrientedRange *)))" and t = "snk" and result = 0.23405948492866016 or
        repr = "(parameter 1 (return (parameter n *)))" and t = "snk" and result = 0.25 or
        repr = "(parameter 2 (return (member injectCustomFormData *)))" and t = "snk" and result = 0.27000000000000013 or
        repr = "(member messageId *)" and t = "snk" and result = 0.40470588235294164 or
        repr = "(parameter 0 (return (parameter 1 (return (member resetPassword *)))))" and t = "snk" and result = 0.5050505050505051 or
        repr = "(member smtpPort *)" and t = "snk" and result = 0.375 or
        repr = "(return (member trim *))" and t = "snk" and result = 0.5 or
        repr = "(member first (parameter t *))" and t = "snk" and result = 0.45535714285714285 or
        repr = "(parameter 0 (return (member min (member Math (global)))))" and t = "snk" and result = 0.5 or
        repr = "(parameter 0 (return (parameter 1 (member getMail *))))" and t = "snk" and result = 0.9581818181818186 or
        repr = "(parameter 0 (return (member push (return (member getRow *)))))" and t = "snk" and result = 0.059174440788675925 or
        repr = "(member (tokens) *)" and t = "snk" and result = 0.26550751879699247 or
        repr = "(parameter 0 (return (member stylize (parameter e *))))" and t = "snk" and result = 0.07500000000000048 or
        repr = "(parameter 0 (instance (member Error (global))))" and t = "snk" and result = 0.8200000000000003 or
        repr = "(return (member parse *))" and t = "snk" and result = 0.3776788553259131 or
        repr = "(parameter 1 (return (member filterClickedSubscribers *)))" and t = "snk" and result = 0.0625 or
        repr = "(member target *)" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (parameter 2 (return (member validateEmail *)))))" and t = "snk" and result = 0.5050505050505051 or
        repr = "(parameter 3 (return (member addConfirmation *)))" and t = "snk" and result = 0.41500000000000004 or
        repr = "(parameter 0 (return (member consumeEntity (member EntityParser *))))" and t = "snk" and result = 0.5000000000000004 or
        repr = "(return (member readFileSync *))" and t = "snk" and result = 1.0 or
        repr = "(member row (member start *))" and t = "snk" and result = 0.32114592671958236 or
        repr = "(member tagName (member target (return (member Event (parameter $ *)))))" and t = "snk" and result = 0.22058823529411734 or
        repr = "(member id (member body (parameter req *)))" and t = "snk" and result = 0.3440000000000004 or
        repr = "(parameter 0 (return (member setEndCell (return (parameter TableGrid *)))))" and t = "snk" and result = 0.326592922792463 or
        repr = "(parameter 0 (return (member stylize *)))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member trigger *)))" and t = "snk" and result = 0.25 or
        repr = "(return (member trim (return (member toString (member NAME *)))))" and t = "snk" and result = 0.8846703947421604 or
        repr = "(parameter 0 (return (return (member withConverter *))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member push (return (member getUnuseds *)))))" and t = "snk" and result = 0.014326125350643922 or
        repr = "(member target (return (member Event *)))" and t = "snk" and result = 0.08333333333333248 or
        repr = "(member target (return (member Event (parameter $ *))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member max *)))" and t = "snk" and result = 0.5 or
        repr = "(parameter 1 (return (member apply *)))" and t = "snk" and result = 0.5 or
        repr = "(parameter 1 (return (member removeInLine (member doc (parameter t *)))))" and t = "snk" and result = 0.22153954566191658 or
        repr = "(parameter 0 (return (parameter 1 (return (member pause *)))))" and t = "snk" and result = 0.5050505050505051 or
        repr = "(parameter 5 (return (member verbose (root https://www.npmjs.com/package/npmlog))))" and t = "snk" and result = 0.5 or
        repr = "(return (member split (return (member toLowerCase *))))" and t = "snk" and result = 0.4055351662595226 or
        repr = "(parameter 2 (return (member removeInLine (member doc (parameter t *)))))" and t = "snk" and result = 0.22153954566191664 or
        repr = "(parameter 0 (return (member consumeEntity *)))" and t = "snk" and result = 1.0 or
        repr = "(return (member trim (return (member toString (parameter key *)))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (parameter 4 (return (member update *)))))" and t = "snk" and result = 0.5050505050505051 or
        repr = "(parameter 1 (return (member select (member dom (parameter editor *)))))" and t = "snk" and result = 0.7575757575757576 or
        repr = "(parameter 0 (return (member splice (return (member split *)))))" and t = "snk" and result = 0.5 or
        repr = "(member tagName *)" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member getParent (member dom (parameter editor *)))))" and t = "snk" and result = 0.326592922792463 or
        repr = "(parameter 0 (return (parameter 1 (return (member deleteRule *)))))" and t = "snk" and result = 0.5050505050505051 or
        repr = "(parameter 0 (return (parameter 2 (return (member updateRule *)))))" and t = "snk" and result = 0.5050505050505051 or
        repr = "(member 0 (return (member rectangularRangeBlock *)))" and t = "snk" and result = 0.31249999999999994 or
        repr = "(parameter 0 (return (parameter 3 (return (member post *)))))" and t = "snk" and result = 0.5050505050505049 or
        repr = "(member params (member component (parameter c *)))" and t = "snk" and result = 1.0 or
        repr = "(return (member getRow *))" and t = "snk" and result = 0.3500000000000006 or
        repr = "(parameter 0 (return (member unget *)))" and t = "snk" and result = 0.5 or
        repr = "(return (member slice *))" and t = "snk" and result = 0.5245028940752299 or
        repr = "(parameter 1 (return (member sendMail *)))" and t = "snk" and result = 0.3266666666666667 or
        repr = "(return (member slice (parameter e *)))" and t = "snk" and result = 0.7843275451828736 or
        repr = "(parameter 1 (return (parameter callback (member takeConfirmation *))))" and t = "snk" and result = 0.33480000000000043 or
        repr = "(parameter 1 (return (member statsClickedSubscribersByColumn *)))" and t = "snk" and result = 0.0625 or
        repr = "(parameter 1 (parameter 0 (return (member each *))))" and t = "snk" and result = 0.2424242424242422 or
        repr = "(parameter 0 (return (member createTransport *)))" and t = "snk" and result = 0.8125 or
        repr = "(member first *)" and t = "snk" and result = 0.5446428571428572 or
        repr = "(parameter 0 (return (member set (member set (member set *)))))" and t = "snk" and result = 0.06585745062691606 or
        repr = "(member params (member component (parameter 0 (member Pb *))))" and t = "snk" and result = 1.0 or
        repr = "(return (member concat (member first *)))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (parameter 2 (return (member get *)))))" and t = "snk" and result = 0.5050505050505051 or
        repr = "(return (member slice (parameter e (member exec *))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member trim (member tinymce (global)))))" and t = "snk" and result = 0.5 or
        repr = "(member column (member end *))" and t = "snk" and result = 0.3211459267195822 or
        repr = "(parameter 1 (return (member filterStatusSubscribers *)))" and t = "snk" and result = 0.0625 or
        repr = "(member host *)" and t = "snk" and result = 0.7575757575757576 or
        repr = "(member params *)" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (parameter 2 (return (member createRule *)))))" and t = "snk" and result = 0.5050505050505051 or
        repr = "(parameter 1 (member customFields *))" and t = "snk" and result = 0.8181818181818187 or
        repr = "(return (member readFileSync (root https://www.npmjs.com/package/fs)))" and t = "snk" and result = 0.9384269662921358 or
        repr = "(parameter 0 (return (parameter 2 (return (member createOrUpdate *)))))" and t = "snk" and result = 0.5050505050505051 or
        repr = "(parameter 0 (return (parameter 1 (return (member all *)))))" and t = "snk" and result = 0.5050505050505051 or
        repr = "(member range *)" and t = "snk" and result = 0.7500000000000001 or
        repr = "(parameter 0 (return (parameter callback *)))" and t = "snk" and result = 0.681818181818182 or
        repr = "(return (member concat *))" and t = "snk" and result = 0.0625 or
        repr = "(return (member trim (return (member toString (member DESCRIPTION *)))))" and t = "snk" and result = 0.5 or
        repr = "(member row (member end *))" and t = "snk" and result = 0.3211459267195822 or
        repr = "(parameter 0 (return (member importScripts (global))))" and t = "snk" and result = 0.25 or
        repr = "(parameter 0 (return (member concat *)))" and t = "snk" and result = 0.03125 or
        repr = "(parameter 0 (return (member substring (return (member replace *)))))" and t = "snk" and result = 0.5 or
        repr = "(parameter 0 (return (member getParent *)))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (member query (parameter connection *))))" and t = "snk" and result = 1.0 or
        repr = "(return (parameter t *))" and t = "snk" and result = 0.21716211146142167 or
        repr = "(parameter 0 (return (member insertBefore (return (member getParent *)))))" and t = "snk" and result = 0.37555132904302563 or
        repr = "(parameter 0 (return (member setEndCell *)))" and t = "snk" and result = 1.0 or
        repr = "(parameter 1 (return (member list *)))" and t = "snk" and result = 0.32249999999999984 or
        repr = "(parameter 0 (return (member hasOwnProperty (member voidElements *))))" and t = "snk" and result = 0.598294697708395 or
        repr = "(parameter 0 (return (member set *)))" and t = "snk" and result = 0.17999999999999994 or
        repr = "(member _id (member session_user (member logInfo *)))" and t = "snk" and result = 1.0 or
        repr = "(member email (return (member findOne (return (member mongo_users *)))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 1 (return (member sendList *)))" and t = "snk" and result = 0.5 or
        repr = "(return (member find *))" and t = "snk" and result = 0.16000000000000014 or
        repr = "(member msg *)" and t = "snk" and result = 0.769230769230769 or
        repr = "(parameter 0 (return (member project_remove_user_from_project *)))" and t = "snk" and result = 0.4800000000000001 or
        repr = "(member uid (return (member findOne (return (member mongo_users *)))))" and t = "snk" and result = 1.0 or
        repr = "(member name (return (member findOne *)))" and t = "snk" and result = 1.0 or
        repr = "(parameter 1 (return (member updateOne (return (member mongo_users *)))))" and t = "snk" and result = 0.5 or
        repr = "(member name (return (member findOne (return (member mongo_groups *)))))" and t = "snk" and result = 0.8 or
        repr = "(parameter 0 (return (member send_notif_mail *)))" and t = "snk" and result = 0.5700000000000001 or
        repr = "(member _id (member session_user (member logInfo (member locals (parameter req *)))))" and t = "snk" and result = 0.5547368421052649 or
        repr = "(member _id (member session_user *))" and t = "snk" and result = 1.0 or
        repr = "(member my *)" and t = "snk" and result = 0.6400000000000001 or
        repr = "(parameter 0 (return (parameter 1 (return (member post *)))))" and t = "snk" and result = 0.2575757575757575 or
        repr = "(parameter 0 (return (parameter 0 (member onRequestUpdate_ *))))" and t = "snk" and result = 1.0 or
        repr = "(member _id (return (member findOne (return (member mongo_users *)))))" and t = "snk" and result = 0.33999999999999997 or
        repr = "(member publicKey (return (member checkRegistration (root https://www.npmjs.com/package/u2f))))" and t = "snk" and result = 0.6756756756756757 or
        repr = "(parameter 1 (return (member ldap_add_user *)))" and t = "snk" and result = 0.2400000000000002 or
        repr = "(member projects (return (member findOne (return (member mongo_users *)))))" and t = "snk" and result = 0.7575757575757576 or
        repr = "(parameter 0 (return (return (parameter $compile *))))" and t = "snk" and result = 0.13076923076923078 or
        repr = "(parameter 0 (return (member insertOne (return (member mongo_events *)))))" and t = "snk" and result = 0.9600000000000002 or
        repr = "(parameter 0 (return (parameter $http *)))" and t = "snk" and result = 0.13076923076923078 or
        repr = "(return (parameter 3 (parameter 1 (return (member controller *)))))" and t = "snk" and result = 0.3962703962703963 or
        repr = "(parameter 1 (return (member debug *)))" and t = "snk" and result = 0.5 or
        repr = "(member _id (member session_user (member logInfo (member locals *))))" and t = "snk" and result = 1.0 or
        repr = "(member data (return (member parse *)))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (return (parameter 0 (member onRequestUpdate_ (member prototype *)))))" and t = "snk" and result = 0.9320000000000009 or
        repr = "(parameter 1 (return (member send_notif_mail *)))" and t = "snk" and result = 0.24000000000000005 or
        repr = "(parameter 0 (return (member fromString (root https://www.npmjs.com/package/html-to-text))))" and t = "snk" and result = 0.7575757575757576 or
        repr = "(return (member slice (member pathname (return (member parse *)))))" and t = "snk" and result = 0.41000000000000036 or
        repr = "(parameter 0 (return (member parseInt (global))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (parameter 0 (return (member isNaN (global)))))" and t = "snk" and result = 0.5400000000000001 or
        repr = "(parameter 1 (return (member cookie (return (member status *)))))" and t = "snk" and result = 1.0 or
        repr = "(return (member cookie (return (member status (parameter res *)))))" and t = "snk" and result = 1.0 or
        repr = "(return (member cookie *))" and t = "snk" and result = 0.515151515151515 or
        repr = "(parameter 0 (return (member query (return (member createPool *)))))" and t = "snk" and result = 1.0 or
        repr = "(member port (return (member parse (root https://www.npmjs.com/package/url))))" and t = "snk" and result = 0.7575757575757576 or
        repr = "(parameter 0 (return (member request (root https://www.npmjs.com/package/http))))" and t = "snk" and result = 0.5 or
        repr = "(member path *)" and t = "snk" and result = 0.7575757575757576 or
        repr = "(parameter 1 (return (member emit *)))" and t = "snk" and result = 0.75 or
        repr = "(parameter 2 (return (member show *)))" and t = "snk" and result = 0.7575757575757576 or
        repr = "(parameter 0 (return (member push (parameter 1 (member render *)))))" and t = "snk" and result = 1.0 or
        repr = "(parameter 0 (instance (member text *)))" and t = "snk" and result = 0.6666666666666666 or
        repr = "(member pathname (return (member parse (root https://www.npmjs.com/package/url))))" and t = "snk" and result = 0.7575757575757576 or
        repr = "(parameter 1 (return (member emit (parameter socket *))))" and t = "snk" and result = 0.25 or
        repr = "(parameter 0 (return (member readFile *)))" and t = "snk" and result = 0.5 or
        repr = "(parameter 0 (return (member setHtml (member selectedElement *))))" and t = "snk" and result = 0.5050505050505051 or
        repr = "(parameter 1 (return (member emit (instance (root https://www.npmjs.com/package/rabbitmq-node)))))" and t = "snk" and result = 0.25 or
        repr = "(parameter 0 (instance (member style (member CKEDITOR (global)))))" and t = "snk" and result = 0.6666666666666667 or
        repr = "(parameter 0 (return (member create *)))" and t = "snk" and result = 0.5 or
        repr = "(parameter 0 (return (member setAttributes (member selectedElement *))))" and t = "snk" and result = 0.5050505050505051 or
        repr = "(parameter 0 (return (member output *)))" and t = "snk" and result = 0.75 or
        repr = "(parameter 0 (return (member push (member filter *))))" and t = "snk" and result = 0.4800000000000001
        or
        repr = "(return (member find *))" and t = "san" and result = 0.4126424242424241 or
        repr = "(return (member replace (member url (parameter req *))))" and t = "san" and result = 1.0 or
        repr = "(return (member get *))" and t = "san" and result = 0.5753012048192772 or
        repr = "(member continueCode (parameter 0 (return (member json *))))" and t = "san" and result = 0.11764705882353016 or
        repr = "(return (member replace *))" and t = "san" and result = 0.5082757281553398 or
        repr = "(member coupon (parameter 0 (return (member updateAttributes *))))" and t = "san" and result = 1.0 or
        repr = "(return (member findChallenge *))" and t = "san" and result = 0.25 or
        repr = "(return (member search (parameter productService *)))" and t = "san" and result = 0.4161073825503355 or
        repr = "(return (member query *))" and t = "san" and result = 0.38100000000000006 or
        repr = "(return (member replace (member url *)))" and t = "san" and result = 0.035714285714285546 or
        repr = "(return (member find (member SecurityAnswer *)))" and t = "san" and result = 1.0 or
        repr = "(return (member substring (member q (member query *))))" and t = "san" and result = 0.9600000000000002 or
        repr = "(return (member decodeURIComponent (global)))" and t = "san" and result = 0.5 or
        repr = "(return (member hash *))" and t = "san" and result = 0.4800000000000001 or
        repr = "(return (member updateAttributes (parameter user *)))" and t = "san" and result = 0.04000000000000026 or
        repr = "(member searchQuery (parameter $scope *))" and t = "san" and result = 0.832214765100671 or
        repr = "(return (member get (member authenticatedUsers *)))" and t = "san" and result = 0.5 or
        repr = "(member coupon (parameter 0 (return (member updateAttributes (parameter basket *)))))" and t = "san" and result = 0.6600000000000013 or
        repr = "(return (member getReportDefinition *))" and t = "san" and result = 0.5400000000000003 or
        repr = "(return (member toPDF *))" and t = "san" and result = 0.5 or
        repr = "(return (member findByIdAndUpdate *))" and t = "san" and result = 1.0 or
        repr = "(member elements *)" and t = "san" and result = 0.6800000000000013 or
        repr = "(return (member findOneAndUpdate *))" and t = "san" and result = 0.030303030303030328 or
        repr = "(return (member findByIdAndUpdate (return (member model (root https://www.npmjs.com/package/mongoose)))))" and t = "san" and result = 1.0 or
        repr = "(return (member getCollectionSchema *))" and t = "san" and result = 1.0 or
        repr = "(member data *)" and t = "san" and result = 0.7575757575757577 or
        repr = "(return (member findOneAndUpdate (return (member model *))))" and t = "san" and result = 1.0 or
        repr = "(return (member execute *))" and t = "san" and result = 0.25000000000000006 or
        repr = "(return (member getLayer (parameter api *)))" and t = "san" and result = 0.7650000000000003 or
        repr = "(return (member findByIdAndUpdate (return (member model *))))" and t = "san" and result = 0.030303030303030328 or
        repr = "(return (member getSqlQuerySchema *))" and t = "san" and result = 1.0 or
        repr = "(return (member findOneAndUpdate (return (member model (root https://www.npmjs.com/package/mongoose)))))" and t = "san" and result = 1.0 or
        repr = "(return (member getReportData (parameter api *)))" and t = "san" and result = 0.5400000000000003 or
        repr = "(return (member toPNG *))" and t = "san" and result = 0.5 or
        repr = "(return (member updateNum *))" and t = "san" and result = 0.73 or
        repr = "(return (member checkUser *))" and t = "san" and result = 0.25 or
        repr = "(return (member registered *))" and t = "san" and result = 0.5 or
        repr = "(return (member startLive *))" and t = "san" and result = 0.25 or
        repr = "(return (member getHotLive *))" and t = "san" and result = 0.74 or
        repr = "(return (member find (return (member Search *))))" and t = "san" and result = 1.0 or
        repr = "(return (member toUpperCase *))" and t = "san" and result = 0.8919046778464254 or
        repr = "(return (member runInContext (parameter t (member runInContext (parameter t *)))))" and t = "san" and result = 1.0 or
        repr = "(parameter 0 (return (member push *)))" and t = "san" and result = 0.020000000000000018 or
        repr = "(return (member runInContext (return (member Object (parameter i *)))))" and t = "san" and result = 1.0 or
        repr = "(return (member exec (member lR (return (member create *)))))" and t = "san" and result = 1.0 or
        repr = "(return (member camelCase (member constructor (member fn (member jQuery *)))))" and t = "san" and result = 0.16666666666666313 or
        repr = "(return (member split (member bK (parameter o *))))" and t = "san" and result = 0.28757575757575743 or
        repr = "(return (member fromCharCode (member String (global))))" and t = "san" and result = 0.4554666666666668 or
        repr = "(member display *)" and t = "san" and result = 1.0 or
        repr = "(member watchTimer (member less (member window (global))))" and t = "san" and result = 1.0 or
        repr = "(return (member parse *))" and t = "san" and result = 0.6972000000000002 or
        repr = "(return (member match (parameter e *)))" and t = "san" and result = 0.6240794668185046 or
        repr = "(return (member map (member prototype *)))" and t = "san" and result = 0.8620689655172413 or
        repr = "(return (member querySelectorAll *))" and t = "san" and result = 0.5 or
        repr = "(return (member sort (return (member getAnnotations (parameter e *)))))" and t = "san" and result = 1.0 or
        repr = "(return (member create (member Object (global))))" and t = "san" and result = 0.393513058993632 or
        repr = "(return (member eval (member prototype *)))" and t = "san" and result = 0.7111111111111112 or
        repr = "(return (member substr *))" and t = "san" and result = 0.3668114973262032 or
        repr = "(return (member extend (parameter t *)))" and t = "san" and result = 0.270909090909091 or
        repr = "(member matchesSelector (member support (member find (member constructor (member fn *)))))" and t = "san" and result = 1.0 or
        repr = "(return (member toString (parameter t *)))" and t = "san" and result = 0.040000000000000036 or
        repr = "(instance (member exports (member module (global))))" and t = "san" and result = 0.176042036117671 or
        repr = "(return (member slice (return (member replace (parameter i *)))))" and t = "san" and result = 0.46505050505050494 or
        repr = "(return (member split (member value *)))" and t = "san" and result = 0.4765908603220306 or
        repr = "(return (member screenToTextCoordinates *))" and t = "san" and result = 0.5694117647058821 or
        repr = "(return (member removeChild (member parentNode *)))" and t = "san" and result = 1.0 or
        repr = "(return (member call (member slice (member prototype *))))" and t = "san" and result = 0.047111111111111194 or
        repr = "(return (member camelCase (member constructor (member prototype *))))" and t = "san" and result = 1.0 or
        repr = "(return (member cloneNode (parameter t (member clone *))))" and t = "san" and result = 0.21117647058823513 or
        repr = "(return (member runInContext *))" and t = "san" and result = 0.5000000000000004 or
        repr = "(return (member resolve *))" and t = "san" and result = 0.75 or
        repr = "(return (member render *))" and t = "san" and result = 0.8550843906339234 or
        repr = "(return (member split (parameter t *)))" and t = "san" and result = 0.16815207766990276 or
        repr = "(return (member split (member stack (parameter e *))))" and t = "san" and result = 0.43757575757575745 or
        repr = "(return (member split *))" and t = "san" and result = 0.4602485529623851 or
        repr = "(return (member getSelectionRange *))" and t = "san" and result = 0.5 or
        repr = "(return (member Number (global)))" and t = "san" and result = 0.22887000000000002 or
        repr = "(return (member slice (parameter 0 (member $computeWrapSplits *))))" and t = "san" and result = 0.7800000000000002 or
        repr = "(return (member toString (parameter e *)))" and t = "san" and result = 0.5886570873786408 or
        repr = "(return (parameter e *))" and t = "san" and result = 0.060606060606060656 or
        repr = "(return (member css (return (member noConflict (member jQuery *)))))" and t = "san" and result = 0.15053763440859985 or
        repr = "(member watchTimer (member less (parameter e *)))" and t = "san" and result = 0.7410714285714283 or
        repr = "(member matchesSelector (member support *))" and t = "san" and result = 1.0 or
        repr = "(return (member substr (member autoInsertedLineEnd *)))" and t = "san" and result = 0.6407642602495542 or
        repr = "(return (member eval *))" and t = "san" and result = 0.2577777777777778 or
        repr = "(member end *)" and t = "san" and result = 0.3730990750661447 or
        repr = "(return (member makeSpan (member exports (parameter t *))))" and t = "san" and result = 0.059396772815533835 or
        repr = "(return (member toJSON *))" and t = "san" and result = 0.07787878787878787 or
        repr = "(return (member getCurrentToken (return (member TokenIterator *))))" and t = "san" and result = 0.33398181818181805 or
        repr = "(member _a *)" and t = "san" and result = 0.89 or
        repr = "(return (member createTextNode (member document (global))))" and t = "san" and result = 1.0 or
        repr = "(return (member match (parameter t *)))" and t = "san" and result = 0.36396266666666677 or
        repr = "(return (member screenToDocumentPosition (member session (member editor *))))" and t = "san" and result = 0.30793415605014074 or
        repr = "(return (member makeSpan *))" and t = "san" and result = 0.30000000000000016 or
        repr = "(return (member split (parameter e *)))" and t = "san" and result = 0.17999999999999994 or
        repr = "(return (member removeChild (member parentNode (parameter e *))))" and t = "san" and result = 0.27272727272727226 or
        repr = "(return (member camelCase (member jQuery (parameter t *))))" and t = "san" and result = 1.0 or
        repr = "(return (member stringify *))" and t = "san" and result = 0.22799999999999998 or
        repr = "(return (member replace (parameter e *)))" and t = "san" and result = 0.42752458252427195 or
        repr = "(member a *)" and t = "san" and result = 0.16099999999999998 or
        repr = "(return (member slice (parameter e (member $computeWrapSplits *))))" and t = "san" and result = 1.0 or
        repr = "(return (member removeChild *))" and t = "san" and result = 1.0 or
        repr = "(return (member replace (return (member replace *))))" and t = "san" and result = 0.17431691674021801 or
        repr = "(return (member getLine *))" and t = "san" and result = 0.42 or
        repr = "(return (member match *))" and t = "san" and result = 0.5445333333333332 or
        repr = "(return (member get (member manager (parameter e *))))" and t = "san" and result = 1.0 or
        repr = "(return (return (parameter e *)))" and t = "san" and result = 0.42 or
        repr = "(return (member exec (member lR (return (member getLanguage *)))))" and t = "san" and result = 0.6539904761904707 or
        repr = "(return (member parseFunction (instance (member exports *))))" and t = "san" and result = 0.02941176470588238 or
        repr = "(return (member createWidget *))" and t = "san" and result = 0.5578947368421053 or
        repr = "(return (member rectangularRangeBlock (member selection (member editor (parameter e *)))))" and t = "san" and result = 0.23520000000000008 or
        repr = "(return (member css (member constructor (member prototype (member constructor *)))))" and t = "san" and result = 1.0 or
        repr = "(return (member tinycolor (global)))" and t = "san" and result = 0.6954096155339805 or
        repr = "(return (member join (return (member split *))))" and t = "san" and result = 0.33224807766990294 or
        repr = "(member matchesSelector (member support (member find (return (member noConflict *)))))" and t = "san" and result = 0.7500000000000007 or
        repr = "(return (member getAttribute (parameter t *)))" and t = "san" and result = 0.5 or
        repr = "(return (parameter i *))" and t = "san" and result = 0.13712121212121214 or
        repr = "(member display (member style *))" and t = "san" and result = 1.0 or
        repr = "(return (member withStyle *))" and t = "san" and result = 0.2 or
        repr = "(return (member get (member manager (instance (member Recognizer *)))))" and t = "san" and result = 0.8493975903614457 or
        repr = "(return (member map (parameter t *)))" and t = "san" and result = 0.16542540747278633 or
        repr = "(member disconnectedMatch (member support (member find (return (member noConflict *)))))" and t = "san" and result = 1.0 or
        repr = "(return (member cloneNode *))" and t = "san" and result = 1.0 or
        repr = "(return (member camelCase (member constructor (member fn (member constructor *)))))" and t = "san" and result = 1.0 or
        repr = "(return (member screenToTextCoordinates (member renderer *)))" and t = "san" and result = 1.0 or
        repr = "(return (member clone *))" and t = "san" and result = 0.42 or
        repr = "(return (member find (instance (member Search *))))" and t = "san" and result = 0.9037636363636361 or
        repr = "(return (member exec (instance (member RegExp (global)))))" and t = "san" and result = 0.04876774193548373 or
        repr = "(return (member get (member manager *)))" and t = "san" and result = 1.0 or
        repr = "(return (member parseInt (global)))" and t = "san" and result = 0.48775250000000003 or
        repr = "(return (member attr (member anchor *)))" and t = "san" and result = 1.0 or
        repr = "(member disconnectedMatch (member support (member find (member $ *))))" and t = "san" and result = 1.0 or
        repr = "(return (member substr (parameter e *)))" and t = "san" and result = 1.0 or
        repr = "(return (member slice *))" and t = "san" and result = 0.3033372203943379 or
        repr = "(return (member replace (return (member replace (member result *)))))" and t = "san" and result = 0.40386584289496885 or
        repr = "(return (member concat *))" and t = "san" and result = 0.32500000000000007 or
        repr = "(return (member extend (member jQuery (global))))" and t = "san" and result = 0.8654545454545453 or
        repr = "(return (member getElementById (member document (global))))" and t = "san" and result = 1.0 or
        repr = "(return (member escapeRegExp *))" and t = "san" and result = 1.0 or
        repr = "(return (member attr (return (member $ (global)))))" and t = "san" and result = 1.0 or
        repr = "(return (member stepBackward *))" and t = "san" and result = 0.6127689518454392 or
        repr = "(return (member replace (return (member toLowerCase (parameter t *)))))" and t = "san" and result = 0.22447284495439843 or
        repr = "(member disconnectedMatch *)" and t = "san" and result = 1.0 or
        repr = "(return (member getCurrentToken *))" and t = "san" and result = 0.44577804275453015 or
        repr = "(return (member resolve (parameter t *)))" and t = "san" and result = 0.5 or
        repr = "(return (member pastFuture *))" and t = "san" and result = 0.2199999999999997 or
        repr = "(return (member getCursor (member selection (member editor *))))" and t = "san" and result = 0.32853076714377605 or
        repr = "(return (member data (return (member $ (global)))))" and t = "san" and result = 0.040000000000000036 or
        repr = "(return (member $ (global)))" and t = "san" and result = 0.3055555555555556 or
        repr = "(member disconnectedMatch (member support (member find (member jQuery *))))" and t = "san" and result = 1.0 or
        repr = "(return (member apply *))" and t = "san" and result = 0.32000000000000006 or
        repr = "(return (member documentToScreenPosition (member session (member editor *))))" and t = "san" and result = 0.26081430966230723 or
        repr = "(member autoInsertedLineEnd *)" and t = "san" and result = 0.5075757575757575 or
        repr = "(member load (member WebFont *))" and t = "san" and result = 0.3599999999999999 or
        repr = "(member frame *)" and t = "san" and result = 0.8996476704913209 or
        repr = "(return (member middle *))" and t = "san" and result = 0.15000000000000008 or
        repr = "(member fileName *)" and t = "san" and result = 0.5 or
        repr = "(return (member exec (member lR *)))" and t = "san" and result = 1.0 or
        repr = "(return (member replace (member textContent *)))" and t = "san" and result = 0.1913699323330392 or
        repr = "(return (member attr *))" and t = "san" and result = 0.21999999999999997 or
        repr = "(return (member join *))" and t = "san" and result = 0.4005504019537245 or
        repr = "(return (member max (member Math (global))))" and t = "san" and result = 0.5 or
        repr = "(member watchTimer (member exports (global)))" and t = "san" and result = 1.0 or
        repr = "(return (member replace (parameter t *)))" and t = "san" and result = 1.0 or
        repr = "(return (member pop (member $redoStack (instance (member UndoManager *)))))" and t = "san" and result = 0.7049336063584895 or
        repr = "(member display (member style (parameter t *)))" and t = "san" and result = 1.0 or
        repr = "(parameter 0 (return (member RegExp (global))))" and t = "san" and result = 0.09900000000000009 or
        repr = "(return (member exec (member lR (member parent (parameter r *)))))" and t = "san" and result = 1.0 or
        repr = "(return (member e *))" and t = "san" and result = 0.4276694833877472 or
        repr = "(return (member exec (member lR (parameter 3 (member highlight *)))))" and t = "san" and result = 1.0 or
        repr = "(return (member createElement (member document (global))))" and t = "san" and result = 0.9848484848484849 or
        repr = "(return (member splice *))" and t = "san" and result = 1.0 or
        repr = "(return (member exec *))" and t = "san" and result = 0.4888666666666667 or
        repr = "(member disconnectedMatch (member support (member find (member $ (parameter t *)))))" and t = "san" and result = 0.2159999999999961 or
        repr = "(return (member GetVariable *))" and t = "san" and result = 0.03711538687849374 or
        repr = "(return (member pop (member $redoStack *)))" and t = "san" and result = 0.8106060606060606 or
        repr = "(return (member getTokens (member session (instance (member Text *)))))" and t = "san" and result = 0.638791273545171 or
        repr = "(return (member replace (member textContent (parameter t *))))" and t = "san" and result = 1.0 or
        repr = "(return (member splice (parameter n *)))" and t = "san" and result = 0.5151515151515149 or
        repr = "(return (member pixelToScreenCoordinates (member renderer (member editor (parameter e *)))))" and t = "san" and result = 0.32853076714377605 or
        repr = "(return (member toLowerCase *))" and t = "san" and result = 0.5 or
        repr = "(return (member css (member jQuery *)))" and t = "san" and result = 1.0 or
        repr = "(return (member call (member map (member prototype *))))" and t = "san" and result = 0.22206896551724134 or
        repr = "(return (member map (member c (parameter o *))))" and t = "san" and result = 0.03757575757575726 or
        repr = "(return (member output (return (member addTemplate *))))" and t = "san" and result = 0.8077519223300971 or
        repr = "(return (member join (parameter e *)))" and t = "san" and result = 0.9579972627243303 or
        repr = "(return (member exec (member lR (parameter r (member highlight *)))))" and t = "san" and result = 1.0 or
        repr = "(return (member slice (parameter t *)))" and t = "san" and result = 0.22614165057293698 or
        repr = "(return (member exec (member lR (member top *))))" and t = "san" and result = 1.0 or
        repr = "(return (member filter (member prevObject *)))" and t = "san" and result = 0.3889149279199766 or
        repr = "(member elem *)" and t = "san" and result = 0.18257575757575747 or
        repr = "(return (member sort (return (member getAnnotations *))))" and t = "san" and result = 0.5151515151515149 or
        repr = "(return (member createTween *))" and t = "san" and result = 0.1075268817204301 or
        repr = "(member selected (parameter 0 (return (member push *))))" and t = "san" and result = 0.2500000000000002 or
        repr = "(member value *)" and t = "san" and result = 0.37841296803492647 or
        repr = "(return (member getFirst *))" and t = "san" and result = 0.375 or
        repr = "(member disconnectedMatch (member support (member find (member constructor (member prototype *)))))" and t = "san" and result = 1.0 or
        repr = "(return (parameter 0 (return (member map *))))" and t = "san" and result = 0.4034 or
        repr = "(return (member call *))" and t = "san" and result = 0.64 or
        repr = "(return (member diff *))" and t = "san" and result = 0.5 or
        repr = "(return (member camelCase *))" and t = "san" and result = 1.0 or
        repr = "(return (member join (return (member split (member bK *)))))" and t = "san" and result = 0.08000000000000006 or
        repr = "(return (member getLine (parameter e (member $matchIterator *))))" and t = "san" and result = 0.488496 or
        repr = "(return (member toLowerCase (member name *)))" and t = "san" and result = 0.025454545454545174 or
        repr = "(return (member pop (return (member split *))))" and t = "san" and result = 0.7575757575757576 or
        repr = "(return (member replace (member id *)))" and t = "san" and result = 1.0 or
        repr = "(return (member resolve (root https://www.npmjs.com/package/path)))" and t = "san" and result = 0.5 or
        repr = "(return (member replace (member id (member params *))))" and t = "san" and result = 0.9200000000000006 or
        repr = "(return (return (member compile *)))" and t = "san" and result = 0.5 or
        repr = "(return (root https://www.npmjs.com/package/escape-html))" and t = "san" and result = 0.23000000000000015 or
        repr = "(return (member getUserName (global)))" and t = "san" and result = 0.2400000000000001 or
        repr = "(return (return (member compile (root https://www.npmjs.com/package/pug))))" and t = "san" and result = 1.0 or
        repr = "(return (member split (member url *)))" and t = "san" and result = 1.0 or
        repr = "(member payload_hash (parameter message *))" and t = "san" and result = 0.7575757575757576 or
        repr = "(return (member parse (member JSON (global))))" and t = "san" and result = 0.9733333333333335 or
        repr = "(return (member parseBindingsString (instance (member R *))))" and t = "san" and result = 1.0 or
        repr = "(return (member slice (return (member slice (parameter e *)))))" and t = "san" and result = 0.5 or
        repr = "(return (member formatMessage *))" and t = "san" and result = 0.5 or
        repr = "(member start (member data (parameter 0 (return (member json *)))))" and t = "san" and result = 1.0 or
        repr = "(return (member trim (return (member toString (member email *)))))" and t = "san" and result = 0.33999999999999997 or
        repr = "(return (member escapeRegExp (return (parameter e *))))" and t = "san" and result = 1.0 or
        repr = "(member start (member data *))" and t = "san" and result = 1.0 or
        repr = "(return (member create (member dom *)))" and t = "san" and result = 0.7651515151515151 or
        repr = "(return (member substring (member url *)))" and t = "san" and result = 1.0 or
        repr = "(return (member join (return (member concat *))))" and t = "san" and result = 0.006651118422648095 or
        repr = "(member customFields (parameter subscription *))" and t = "san" and result = 1.0 or
        repr = "(return (member shift (parameter e (member consumeEntity (member EntityParser *)))))" and t = "san" and result = 0.205882352941176 or
        repr = "(member customFields *)" and t = "san" and result = 0.9599999999999997 or
        repr = "(return (member char (parameter e *)))" and t = "san" and result = 1.0 or
        repr = "(return (member map *))" and t = "san" and result = 0.3999999999999998 or
        repr = "(return (member create (member Factory *)))" and t = "san" and result = 0.007575757575757582 or
        repr = "(return (member join (root https://www.npmjs.com/package/path)))" and t = "san" and result = 0.002755987336506164 or
        repr = "(member $raw (return (member Ca (member a (parameter N *)))))" and t = "san" and result = 0.9999999999999999 or
        repr = "(return (member map (parameter searchFields (member filter *))))" and t = "san" and result = 0.6000000000000003 or
        repr = "(return (member keys (member Object (global))))" and t = "san" and result = 0.03000000000000025 or
        repr = "(return (member trim (member tinymce (global))))" and t = "san" and result = 0.75 or
        repr = "(return (member getTokens (member session *)))" and t = "san" and result = 1.0 or
        repr = "(return (member convertKeys *))" and t = "san" and result = 0.5 or
        repr = "(member customFields (parameter 1 (parameter 2 (return (member get *)))))" and t = "san" and result = 0.7400000000000023 or
        repr = "(return (member peek (instance (member Lexer *))))" and t = "san" and result = 0.4291297948510398 or
        repr = "(return (member create *))" and t = "san" and result = 0.75 or
        repr = "(return (member getParent *))" and t = "san" and result = 0.08416868036822041 or
        repr = "(member campaign (parameter 1 (return (member addToCache *))))" and t = "san" and result = 0.4696969696969698 or
        repr = "(return (member parseBindingsString *))" and t = "san" and result = 0.75 or
        repr = "(return (member screenToTextCoordinates (member renderer (member editor (parameter e *)))))" and t = "san" and result = 1.0 or
        repr = "(return (member concat (member first (parameter t *))))" and t = "san" and result = 0.8125 or
        repr = "(return (member char *))" and t = "san" and result = 1.0 or
        repr = "(return (member parseBindingsString (return (member R *))))" and t = "san" and result = 1.0 or
        repr = "(return (member Event *))" and t = "san" and result = 1.0 or
        repr = "(return (member getParent (member dom *)))" and t = "san" and result = 1.0 or
        repr = "(return (member preprocess (return (member getBindingHandler (parameter N *)))))" and t = "san" and result = 1.0 or
        repr = "(member limit (member data (parameter 0 (return (member json *)))))" and t = "san" and result = 1.0 or
        repr = "(return (member Event (parameter $ *)))" and t = "san" and result = 0.5151515151515149 or
        repr = "(return (member format (root https://www.npmjs.com/package/util)))" and t = "san" and result = 0.8400000000000001 or
        repr = "(return (member map (member keys *)))" and t = "san" and result = 0.1000000000000002 or
        repr = "(return (member join (return (member map *))))" and t = "san" and result = 0.2642268759984055 or
        repr = "(return (member substring (member url (parameter req *))))" and t = "san" and result = 1.0 or
        repr = "(return (member keys *))" and t = "san" and result = 1.0 or
        repr = "(return (member toString (member email (member body *))))" and t = "san" and result = 0.16000000000000003 or
        repr = "(return (member trim (member from (member body *))))" and t = "san" and result = 1.0 or
        repr = "(return (member parseBindingsString (return (member R (parameter N *)))))" and t = "san" and result = 0.035714285714285546 or
        repr = "(return (member screenToTextCoordinates (member renderer (member editor *))))" and t = "san" and result = 0.10062755559442883 or
        repr = "(return (member slice (parameter e *)))" and t = "san" and result = 0.25332555921132405 or
        repr = "(return (member pop *))" and t = "san" and result = 0.1103230285122998 or
        repr = "(member first *)" and t = "san" and result = 1.0 or
        repr = "(return (member replace (member content (parameter evt *))))" and t = "san" and result = 0.12878787878787873 or
        repr = "(return (member concat (member first *)))" and t = "san" and result = 1.0 or
        repr = "(return (member split (return (member val *))))" and t = "san" and result = 0.3995028940752299 or
        repr = "(return (member encodeURIComponent (global)))" and t = "san" and result = 0.4166666666666667 or
        repr = "(return (member Array (global)))" and t = "san" and result = 0.07500000000000004 or
        repr = "(return (member getLineRange *))" and t = "san" and result = 0.25332555921132405 or
        repr = "(return (return (member compile (root https://www.npmjs.com/package/handlebars))))" and t = "san" and result = 1.0 or
        repr = "(return (member queryParams *))" and t = "san" and result = 0.4166666666666667 or
        repr = "(return (member toString *))" and t = "san" and result = 0.625 or
        repr = "(return (member replaceEntityNumbers *))" and t = "san" and result = 0.12500000000000022 or
        repr = "(return (member trim (return (member toString (member campaign *)))))" and t = "san" and result = 0.3787878787878788 or
        repr = "(return (member getParent (member dom (parameter editor *))))" and t = "san" and result = 1.0 or
        repr = "(return (member split (member list (member body (parameter req *)))))" and t = "san" and result = 0.3995028940752299 or
        repr = "(return (member filter (return (member concat *))))" and t = "san" and result = 1.0 or
        repr = "(member limit (member data *))" and t = "san" and result = 1.0 or
        repr = "(return (member getWordRange (member session *)))" and t = "san" and result = 0.8333333333333333 or
        repr = "(return (member user_list *))" and t = "san" and result = 0.5400000000000003 or
        repr = "(return (parameter $http *))" and t = "san" and result = 1.0 or
        repr = "(return (member findOne *))" and t = "san" and result = 1.0 or
        repr = "(return (member findOne (return (member mongo_groups *))))" and t = "san" and result = 0.4600000000000002 or
        repr = "(return (member get (parameter User *)))" and t = "san" and result = 0.4600000000000002 or
        repr = "(return (parameter $http (parameter 1 (return (member controller *)))))" and t = "san" and result = 0.15384615384615363 or
        repr = "(return (member checkRegistration (root https://www.npmjs.com/package/u2f)))" and t = "san" and result = 1.0 or
        repr = "(return (member findOne (return (member mongo_projects *))))" and t = "san" and result = 0.4600000000000002 or
        repr = "(member html_message *)" and t = "san" and result = 1.0 or
        repr = "(member _id *)" and t = "san" and result = 0.9200000000000004 or
        repr = "(member home *)" and t = "san" and result = 0.17999999999999994 or
        repr = "(return (member split (member authorization *)))" and t = "san" and result = 0.9600000000000002 or
        repr = "(member message *)" and t = "san" and result = 0.7575757575757576 or
        repr = "(return (member listowner *))" and t = "san" and result = 0.4600000000000002 or
        repr = "(return (member replace (member ssh (member body (parameter req *)))))" and t = "san" and result = 0.7499999999999999 or
        repr = "(return (member get_apikey (parameter User *)))" and t = "san" and result = 0.4600000000000002 or
        repr = "(return (member user_home *))" and t = "san" and result = 0.14000000000000012 or
        repr = "(return (member toHTML (member markdown (root https://www.npmjs.com/package/markdown))))" and t = "san" and result = 1.0 or
        repr = "(return (member bind *))" and t = "san" and result = 0.5 or
        repr = "(return (member project_update_project *))" and t = "san" and result = 0.009999999999999953 or
        repr = "(return (member parse (root https://www.npmjs.com/package/url)))" and t = "san" and result = 1.0 or
        repr = "(return (member stringify (member JSON (global))))" and t = "san" and result = 0.4800000000000001 or
        repr = "(return (member replace (return (member stringify *))))" and t = "san" and result = 0.9600000000000003 or
        repr = "(return (member sign (root https://www.npmjs.com/package/jsonwebtoken)))" and t = "san" and result = 1.0 or
        repr = "(return (member sign *))" and t = "san" and result = 1.0 or
        repr = "(return (member sign (member default *)))" and t = "san" and result = 1.0 or
        repr = "(return (member pop (return (member split (member url *)))))" and t = "san" and result = 0.7575757575757576 or
        repr = "(return (member output *))" and t = "san" and result = 0.515151515151515 or
        repr = "(member data-cke-saved-href *)" and t = "san" and result = 0.976190476190476 or
        repr = "(parameter 0 (member data (parameter 1 (return (member emit *)))))" and t = "san" and result = 1.0 or
        repr = "(member data-cke-saved-href (member attributes (parameter 0 (instance (member style *)))))" and t = "san" and result = 1.0 or
        repr = "(return (member trim *))" and t = "san" and result = 1.0 or
        repr = "(return (member toString (member content *)))" and t = "san" and result = 0.035714285714285546 or
        repr = "(return (member getClaims *))" and t = "san" and result = 0.24000000000000005
    }    
}