module TsmRepr {
  float getReprScore(string repr, string t) {
    repr = "(parameter 0 (return (parameter a *)))" and t = "snk" and result = 1.0
    or
    repr = "(parameter d *)" and t = "src" and result = 0.125
    or
    repr = "(parameter 0 (return (parameter b *)))" and t = "snk" and result = 1.0
    or
    repr = "(member menu *)" and t = "snk" and result = 1.0
    or
    repr = "(member node *)" and t = "snk" and result = 1.0
    or
    repr = "(parameter 0 (return (member css *)))" and t = "src" and result = 0.5
    or
    repr = "(parameter 0 (return (member write *)))" and t = "snk" and result = 1.0
    or
    repr = "(parameter 0 (return (member append *)))" and t = "snk" and result = 1.0
    or
    repr = "(member $node *)" and t = "snk" and result = 1.0
    or
    repr = "(member el *)" and t = "snk" and result = 1.0
    or
    repr = "(parameter c *)" and t = "src" and result = 0.5
    or
    repr = "(return (member first *))" and t = "san" and result = 0.25
    or
    repr = "(member css *)" and t = "src" and result = 0.25
    or
    repr = "(parameter 0 (return (member $ (global))))" and t = "snk" and result = 1.0
    or
    repr = "(member input *)" and t = "snk" and result = 1.0
    or
    repr = "(return (parameter b *))" and t = "san" and result = 0.375
    or
    repr = "(member hint *)" and t = "snk" and result = 1.0
    or
    repr = "(return (parameter a *))" and t = "san" and result = 0.5
    or
    repr = "(parameter 1 (return (member attr *)))" and t = "src" and result = 0.125
    or
    repr = "(parameter 0 (return (member append (return (parameter b *)))))" and
    t = "snk" and
    result = 1.0
    or
    repr = "(parameter 0 (return (member write (member document (global)))))" and
    t = "snk" and
    result = 1.0
    or
    repr = "(return (member css *))" and t = "san" and result = 0.5
    or
    repr = "(member datasets *)" and t = "san" and result = 0.5
  }
}
