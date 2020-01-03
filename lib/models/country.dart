import 'ambit.dart';

class Country {
  List<Ambit> ambits;
  String name;

  Country({this.ambits, this.name});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      ambits: json['ambits'] != null
          ? (json['ambits'] as List).map((i) => Ambit.fromJson(i)).toList()
          : null,
      name: json['name'],
    );
  }
}
