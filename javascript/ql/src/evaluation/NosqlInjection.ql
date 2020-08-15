/**
 * @name NoSQL injection
 * @description Similar to the out of the box `SqlInjection.ql` query but limited to NoSQL injection
 *              vulnerabilities.
 * @problem.severity error
 */

import semmle.javascript.security.dataflow.NosqlInjection

from
  DataFlow::Configuration cfg, DataFlow::Node source, DataFlow::Node sink, string filePathSink,
  int startLineSink, int endLineSink, int startColumnSink, int endColumnSink, string filePathSource,
  int startLineSource, int endLineSource, int startColumnSource, int endColumnSource
where
  cfg instanceof NosqlInjection::Configuration and
  cfg.hasFlow(source, sink) and
  sink.hasLocationInfo(filePathSink, startLineSink, startColumnSink, endLineSink, endColumnSink) and
  source
      .hasLocationInfo(filePathSource, startLineSource, startColumnSource, endLineSource,
        endColumnSource)
select source, startLineSource, startColumnSource, endLineSource, endColumnSource, filePathSource,
  sink, startLineSink, startColumnSink, endLineSink, endColumnSink, filePathSink
