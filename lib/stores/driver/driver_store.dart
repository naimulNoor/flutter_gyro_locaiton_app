import 'package:GyroLocationApp/data/driver_firestore_repository.dart';
import 'package:GyroLocationApp/models/app/driver.dart';
import 'package:GyroLocationApp/stores/error/error_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';


part 'driver_store.g.dart';

class DriverStore = _DriverStore with _$DriverStore;
abstract class _DriverStore with Store {
  // repository instance
  final DriverFireStoreRepository _repository;

  // store for handling form errors

  // store for handling error messages
  final ErrorStore errorStore = ErrorStore();

  // bool to check if current user is logged in
  bool isLoggedIn = false;
  @observable
  bool isDriverCreated=false;

  @computed
  bool get loading => isDriverCreated;

  // constructor:---------------------------------------------------------------
  _DriverStore(DriverFireStoreRepository repository) : this._repository = repository {

    // setting up disposers
    _setupDisposers();

    // checking if user is logged in
    // repository.isLoggedIn.then((value) {
    //   this.isLoggedIn = value;
    // });
  }

  // disposers:-----------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _setupDisposers() {
    _disposers = [
      reaction((_) => success, (_) => success = false, delay: 200),
    ];
  }

  // empty responses:-----------------------------------------------------------
  static ObservableFuture<DocumentReference?> emptyLoginResponse =
  ObservableFuture.value(null);

  // store variables:-----------------------------------------------------------
  @observable
  bool success = false;

  @observable
  ObservableFuture<DocumentReference?> addDriverTask = emptyLoginResponse;

  @observable
  bool loader = false;

  @computed
  bool get isListLoading => loader;

  @computed
  bool get isLoading => addDriverTask.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future addDriver(String name, number,String vendor_code,Position _driverposition) async {

    this.isDriverCreated=true;

    Driver driver=new Driver(name,"refid",_driverposition.latitude.toString(),_driverposition.longitude.toString(),driver_number:number, vendor_code: vendor_code,is_available: false);
    final future = _repository.addDriver(driver);
    addDriverTask= ObservableFuture(future);
    await future.then((value) async {

      this.isDriverCreated=false;
      this.success = true;


    }).catchError((e) {
      //print(e);
      this.isDriverCreated=false;
      this.success = false;
      throw e;
    });
  }

  @action
  Stream<QuerySnapshot> getDriverList(String vendorCOde) {
    loader = true;
    final stream = _repository.getDriverList(vendorCOde);
    return stream;
  }

  @action
  Future showDriver(String name, number,String businessCode) async {
  }

  @action
  driverStatus(String? id,bool status){
    print("driverstatus-store");
    print(id);
    loader =true;
    _repository.driverStatus(id!,status);
    loader =false;
  }

  @action
  deleteDriver(String? id,){
    print("driverstatus-store");
    print(id);
    loader =true;
    _repository.deleteDriver(id!);
    loader =false;
  }


  @action
  Future driverLogout(String mobile) async {
    final future = _repository.driverLogout(mobile);
    return future;
  }



  // general methods:-----------------------------------------------------------
  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}