module TsmRepr {
    float getReprScore(string repr, string t){
        none() or
    //    repr = "(member path (parameter 0 (member getDirectoryList (member exports *))))::(member path (parameter 0 (member getDirectoryList *)))::(member path (parameter options (member getDirectoryList (member exports *))))::(member path (parameter options (member getDirectoryList *)))::(member path (parameter options *))::(member path *)" and t = "src" and result = 1.0 
    //    or
    //   repr = "(member body (parameter 0 (parameter 1 (return (member post *)))))::(member body (parameter req (parameter 1 (return (member post *)))))::(member body (parameter req *))::(member body *)::(parameter 2 (return (member moveTorrents *)))" and t = "src" and result = 1.0 or
        
         repr = "(parameter 0 (return (root https://www.npmjs.com/package/mv)))" and t = "snk" and result = 1.0 
        //or
        // repr = "(parameter 1 (return (root https://www.npmjs.com/package/mv)))" and t = "snk" and result = 1.0 
    }
}


// float getReprScore(string repr, string t){
//     repr = "(member path (parameter 0 (member getDirectoryList (member exports *))))::(member path (parameter 0 (member getDirectoryList *)))::(member path (parameter options (member getDirectoryList (member exports *))))::(member path (parameter options (member getDirectoryList *)))::(member path (parameter options *))::(member path *)" and t = "src" and result = 1.0 
//     or
// //   repr = "(member body (parameter 0 (parameter 1 (return (member post *)))))::(member body (parameter req (parameter 1 (return (member post *)))))::(member body (parameter req *))::(member body *)::(parameter 2 (return (member moveTorrents *)))" and t = "src" and result = 1.0 or
    
//     repr = "(parameter 0 (return (root https://www.npmjs.com/package/mv)))" and t = "snk" and result = 1.0 
//     //or
// //    repr = "(parameter 1 (return (root https://www.npmjs.com/package/mv)))" and t = "snk" and result = 1.0 
// }
