/// Country model for developer examples.
class Country {
  final String code;
  final String name;
  final String flag;
  final String region;

  const Country({
    required this.code,
    required this.name,
    required this.flag,
    required this.region,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => '$flag $name';
}

const sampleCountries = [
  Country(code: 'US', name: 'United States', flag: '🇺🇸', region: 'Americas'),
  Country(code: 'CA', name: 'Canada', flag: '🇨🇦', region: 'Americas'),
  Country(code: 'GB', name: 'United Kingdom', flag: '🇬🇧', region: 'Europe'),
  Country(code: 'DE', name: 'Germany', flag: '🇩🇪', region: 'Europe'),
  Country(code: 'FR', name: 'France', flag: '🇫🇷', region: 'Europe'),
  Country(code: 'IN', name: 'India', flag: '🇮🇳', region: 'Asia'),
  Country(code: 'JP', name: 'Japan', flag: '🇯🇵', region: 'Asia'),
  Country(code: 'AU', name: 'Australia', flag: '🇦🇺', region: 'Oceania'),
  Country(code: 'BR', name: 'Brazil', flag: '🇧🇷', region: 'Americas'),
  Country(code: 'ZA', name: 'South Africa', flag: '🇿🇦', region: 'Africa'),
];
