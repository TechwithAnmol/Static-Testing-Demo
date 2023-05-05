/**
 * This query finds potential cross-site scripting (XSS) vulnerabilities
 * in PHP code by looking for echo statements that include unescaped
 * user input.
 */

import php

from Expr e
where e instanceof Echo &&
      e.getParameters().getType().toString() = "string" &&
      exists(Expr arg | arg = e.getParameters().get(0) |
             arg instanceof FunctionCall &&
             arg.getCallee().toString() = "htmlspecialchars" &&
             arg.getArgument(1).toString() = "ENT_QUOTES" &&
             arg.getArgument(2) instanceof VariableAccess &&
             arg.getArgument(2).getType().toString() = "string" &&
             arg.getArgument(2).getType().toString() != "string[]")
select e, "Potential XSS found: " + e.toString()
