import 'package:GyroLocationApp/data/sharedpref/shared_preference_helper.dart';
import 'package:GyroLocationApp/models/app/vendor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class VendorFireStoreRepository {

  final CollectionReference collection = FirebaseFirestore.instance.collection('vendors');

  // shared pref object
  final SharedPreferenceHelper _sharedPrefsHelper;
  // constructor
  VendorFireStoreRepository(this._sharedPrefsHelper);

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }


  Future<DocumentReference> addVendor(Vendor vendor) {
    print("vendro-firebase");
    _sharedPrefsHelper.saveUserType("vendor");
    return collection.add(vendor.toJson());

  }

  void deleteVendor(String mobile) async{
    print("driverstatus-store");
    print(mobile);
    //await collection.doc(id).update({"is_available":i});
    var data= await collection.where("number",isEqualTo: mobile).snapshots();
    data.first.then((value) =>{
      collection.doc(value.docs.first.id).delete()
    });
  }

  Future<Map<String, dynamic>> getVendorInfo(String mobile) async {
    var map;
    var data= await collection.where("number",isEqualTo: mobile).snapshots();
    var value =await data.first;
    print("vendro-info::${mobile}");
    print("vendro-info::${value.toString()}");
    map = {'name':value.docs.first.get("name"),'vendor_code':value.docs.first.get("businessCode"),"number":value.docs.first.get("number")};
    return map;
  }

  vendorLogout(String mobile) async{
    await FirebaseAuth.instance.signOut();
    deleteVendor(mobile);
  }

}
