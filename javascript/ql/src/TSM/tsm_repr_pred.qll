module TsmRepr {float getReprScore(string repr, string t){
repr = "(member body (parameter 0 (parameter 1 (return (member post *)))))" and t = "src" and result = 1.0000000000  or 
repr = "(member body (parameter req (parameter 1 (return (member post *)))))" and t = "src" and result = 1.0000000000  or 
repr = "(staticMethod sanitizePath)" and t = "san" and result = 0.7500000000  or 
repr = "(parameter 0 (return (member log *)))" and t = "src" and result = 1.0000000000  or 
repr = "(member body *)" and t = "src" and result = 1.0000000000  or 
repr = "(parameter 0 (return (member writeFile *)))" and t = "snk" and result = 1.0000000000  or 
repr = "(parameter 0 (return (member writeFile (root https://www.npmjs.com/package/fs))))" and t = "snk" and result = 1.0000000000  or 
repr = "(return (member join (root https://www.npmjs.com/package/path)))" and t = "san" and result = 1.0000000000  or 
repr = "(parameter 0 (return (member log (member console (global)))))" and t = "src" and result = 1.0000000000  or 
repr = "(member body (parameter req *))" and t = "src" and result = 1.0000000000
}}