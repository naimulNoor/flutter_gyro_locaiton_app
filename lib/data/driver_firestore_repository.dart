import 'package:GyroLocationApp/data/sharedpref/shared_preference_helper.dart';
import 'package:GyroLocationApp/models/app/driver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class DriverFireStoreRepository {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('drivers');

  // shared pref object
  final SharedPreferenceHelper _sharedPrefsHelper;
  // constructor
  DriverFireStoreRepository(this._sharedPrefsHelper);

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<DocumentReference> addDriver(Driver driver) {
    _sharedPrefsHelper.saveUserType("driver");
    return collection.add(driver.toJson());
  }

  void updateDriver(Driver driver) async {
    await collection.doc(driver.ref_id).update(driver.toJson());
  }



  Stream<QuerySnapshot> getDriverList(String vendorCOde) {
    return collection.where("vendor_code",isEqualTo: vendorCOde).where("is_available",isEqualTo: true).snapshots();
  }

  void driverStatus(String mobile, bool i) async{
    print("driverstatus-store");
    print(mobile);
    //await collection.doc(id).update({"is_available":i});
     var data= await collection.where("driver_number",isEqualTo: mobile).snapshots();
     data.first.then((value) =>{
       collection.doc(value.docs.first.id).update({"is_available":i})

     });
  }
  void deleteDriver(String mobile) async{
    print("driverstatus-store");
    print(mobile);
    //await collection.doc(id).update({"is_available":i});
    var data= await collection.where("driver_number",isEqualTo: mobile).snapshots();
    data.first.then((value) =>{
      collection.doc(value.docs.first.id).delete()
    });
  }

  driverLogout(String mobile) async{
    await FirebaseAuth.instance.signOut();
    deleteDriver(mobile);
  }
}
