{ mkDerivation, attoparsec, base, simple, stdenv, text }:
mkDerivation {
  pname = "kafka-scripts";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ attoparsec base simple text ];
  homepage = "https://github.com/2chilled/kafka-scripts#readme";
  description = "Any scripts which make an addition to kafka scripts";
  license = stdenv.lib.licenses.bsd3;
}
