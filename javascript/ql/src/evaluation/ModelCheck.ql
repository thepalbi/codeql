external predicate adaptiveThreatModelingModels(
  string modelChecksum, string modelLanguage, string modelName, string modelType
);

select any(string checksum | adaptiveThreatModelingModels(checksum, "javascript",_ ,_))
