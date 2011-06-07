unit ZTO.Crypt.Types;

interface

type
	THashAlgorithm = (haIgnore, haSha512, haSha384, haSha256, haSha1, haRipemd160, haRipemd128, haMd5, haMd4, haHaval, haTiger);
  THashAlgorithms = set of THashAlgorithm;

implementation

end.
