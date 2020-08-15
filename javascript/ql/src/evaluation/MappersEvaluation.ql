/*
 * MappersEvaluation.ql
 *
 * This provides statistics about the performance of the ATM mappers on sources and sinks
 * from the NoSQL injection security query.
 */

private import experimental.adaptivethreatmodeling.AdaptiveThreatModeling
private import semmle.javascript.security.dataflow.NosqlInjectionCustomizations
private import NosqlInjectionEndpointFilters
private import EndpointToEntity
private import EntityToEffectiveEndpoint

private class Sink = NosqlInjection::Sink;

private ATM::Entity getAnEntityMappedToByASink() {
  result = getEntityForEndpoint(any(Sink s))
}

select
  // Sink statistics
  //----------------
  
  // The number of sinks.
  count(Sink s) as numSinks,
  // The number of sinks which map to at least one entity.
  count(Sink s | exists(getEntityForEndpoint(s))) as numSinksWhichMapToAnEntity,
  // The number of sinks for which applying both mappers gives an effective sink.
  count(Sink s | exists(getAnEffectiveSink(getEntityForEndpoint(s)))) as numSinksWhereCompositionOfMappersMapsToAPredictedSink,
  // The number of entities that are mapped to by a sink.
  count(getAnEntityMappedToByASink()) as numEntitiesMappedToByASink,
  // The number of effective sinks given by applying both mappers to a sink.
  count(getAnEffectiveSink(getAnEntityMappedToByASink())) as numPredictedSinksFromApplicationOfCompositionOfMappersToASink
