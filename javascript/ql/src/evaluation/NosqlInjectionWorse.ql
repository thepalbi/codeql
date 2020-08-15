/**
 * @name NoSQL injection worse
 * @description Same as `NosqlInjection.ql` query but with fewer sinks (reverts 2a87d53 in ql/ repo)
 * @problem.severity error
 */

import NosqlInjectionWorse

from
  DataFlow::Configuration cfg, DataFlow::Node source, DataFlow::Node sink, string filePathSink,
  int startLineSink, int endLineSink, int startColumnSink, int endColumnSink, string filePathSource,
  int startLineSource, int endLineSource, int startColumnSource, int endColumnSource
where
  cfg instanceof NosqlInjectionWorse::Configuration and
  cfg.hasFlow(source, sink) and
  sink.hasLocationInfo(filePathSink, startLineSink, startColumnSink, endLineSink, endColumnSink) and
  source
      .hasLocationInfo(filePathSource, startLineSource, startColumnSource, endLineSource,
        endColumnSource)
select source, startLineSource, startColumnSource, endLineSource, endColumnSource, filePathSource,
  sink, startLineSink, startColumnSink, endLineSink, endColumnSink, filePathSink
