module TsmRepr {float getReprScore(string repr, string t){
repr = "(member userid *)" and t = "src" and result = 1.0  or 
repr = "(member userid (member query (parameter req *)))" and t = "src" and result = 1.0  or 
repr = "(parameter 1 (return (member log *)))" and t = "src" and result = 1.0  or 
repr = "(member userid (member query *))" and t = "src" and result = 1.0  or 
repr = "(member body *)" and t = "src" and result = 1.0  or 
repr = "(member body (parameter req *))" and t = "src" and result = 1.0  or 
repr = "(member desc *)" and t = "src" and result = 1.0  or 
repr = "(parameter 1 (return (member log (member console (global)))))" and t = "src" and result = 1.0
}}