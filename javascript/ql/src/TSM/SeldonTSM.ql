/**
 * @name Query for testing Seldon's paper example
 * @description Checking unsanitized flows
 * @kind path-problem
 * @problem.severity error
 * @precision high
  */

import javascript
import seldom_tsm
import DataFlow::PathGraph

from DataFlow::Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where
  (
    cfg instanceof SeldonTSM::Configuration
  ) and
  cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This query depends on $@.", source.getNode(),
  "a user-provided value"
