// ignore_for_file: lines_longer_than_80_chars

class UserLocation {
  const UserLocation({
    required this.name,
    required this.symbol,
    this.isServiceAvailable = false,
  });

  UserLocation.fromMap(Map<String, dynamic> map)
      : this(
          name: map['name'] as String,
          isServiceAvailable: map['isServiceAvailable'] as bool,
          symbol: map['symbol'] as String,
        );

  factory UserLocation.fromLocationName(String locName) {
    return LocationList.list.firstWhere((loc) => loc.name == locName, orElse: UserLocation.dafault);
  }
  
  UserLocation.dafault(): this(
    name: 'THIRUVANANTHAPURAM',
    symbol: 'TVM',
    isServiceAvailable: true,
  );

  final String name;
  final bool isServiceAvailable;
  final String symbol;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isServiceAvailable': isServiceAvailable,
      'symbol': symbol,
    };
  }


}

class LocationList {
  const LocationList._();
  static List<UserLocation> list = [
    const UserLocation(
      name: 'THIRUVANANTHAPURAM',
      isServiceAvailable: true,
      symbol: 'TVM',
    ),
    const UserLocation(
      name: 'KOLLAM',
      isServiceAvailable: true,
      symbol: 'KLM',
    ),
  ];
}
