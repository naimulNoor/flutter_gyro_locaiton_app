
import 'package:cloud_firestore/cloud_firestore.dart';
import 'driver.dart';
class Vendor {
  late String name;
  String? businessCode;
  String? referenceId;
  String? number;
  late dynamic driverLIst;


  Vendor(this.name,this.number, {this.businessCode, required this.driverLIst,});

  factory Vendor.fromSnapshot(DocumentSnapshot snapshot) {
    final newVendor = Vendor.fromJson(snapshot.data() as Map<String, dynamic>);
    newVendor.referenceId = snapshot.reference.id;
    return newVendor;
  }

  factory Vendor.fromJson(Map<String, dynamic> json) => _vendroFromJson(json);

  Map<String, dynamic> toJson() => _VendorToJson(this);

}

Vendor _vendroFromJson(Map<String, dynamic> json) {
  return Vendor(
      json['name'] as String,
      json['number'] as String,
      businessCode: json['businessCode'] as String?,
      driverLIst: _convertDriverList(json['driver_list'] as dynamic));
}

dynamic _convertDriverList(dynamic driverMap) {
  final drivers = <Driver>[];

  for (final driver in driverMap) {

    drivers.add(Driver.fromJson(driver as Map<String, dynamic>));
  }
  return drivers;
}

Map<String, dynamic> _VendorToJson(Vendor instance) => <String, dynamic>{
  'name': instance.name,
  'number': instance.number,
  'businessCode': instance.businessCode,
  'driverlist': _driverList(instance.driverLIst),
};

List<Map<String, dynamic>>? _driverList(dynamic drivers) {
  if (drivers == null) {
    return null;
  }
  final vaccinationMap = <Map<String, dynamic>>[];
  if(drivers is List<Driver>){
    drivers.forEach((driver) {
      vaccinationMap.add(driver.toJson());
    });
  }else{
    Driver driver =new Driver("driver_name", "ref_id","0.0","0.0", driver_number: "driver_number", vendor_code: "vendor_code",is_available: false);
    vaccinationMap.add(driver.toJson());
  }

  return vaccinationMap;
}
