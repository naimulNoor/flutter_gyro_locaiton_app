import 'package:cloud_firestore/cloud_firestore.dart';

class Driver {
  final String driver_name;
  final String driver_number;
  final String vendor_code;
  final String driver_lat;
  final String driver_lon;
   final String ref_id;
   final bool is_available;

  Driver(this.driver_name, this.ref_id, this.driver_lat, this.driver_lon,{required this.driver_number, required this.vendor_code,required this.is_available});

  factory Driver.fromJson(Map<String, dynamic> json) => _driverFromJson(json);

  Map<String, dynamic> toJson() => _driverToJson(this);

  @override
  String toString() => 'Vaccination<>';


}

Driver _driverFromJson(Map<String, dynamic> json) {
  return Driver(
    json['ref_id'] as String,
    json['driver_name'] as String,
    json['driver_lat'] as String,
    json['driver_lon'] as String,
    driver_number: json['driver_number'] as String,
    vendor_code: json['vendor_code'] as String,
    is_available: json['is_available'] as bool
  );
}

Map<String, dynamic> _driverToJson(Driver instance) =>
    <String, dynamic>{
      'ref_id':instance.ref_id,
      'driver_name': instance.driver_name,
      'driver_number': instance.driver_number,
      'driver_lon': instance.driver_lon,
      'driver_lat': instance.driver_lat,
      'vendor_code': instance.vendor_code,
      'is_available': instance.is_available,
    };
