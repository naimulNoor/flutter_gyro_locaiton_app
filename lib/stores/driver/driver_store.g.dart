// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DriverStore on _DriverStore, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: '_DriverStore.loading'))
      .value;
  Computed<bool>? _$isListLoadingComputed;

  @override
  bool get isListLoading =>
      (_$isListLoadingComputed ??= Computed<bool>(() => super.isListLoading,
              name: '_DriverStore.isListLoading'))
          .value;
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading => (_$isLoadingComputed ??=
          Computed<bool>(() => super.isLoading, name: '_DriverStore.isLoading'))
      .value;

  final _$isDriverCreatedAtom = Atom(name: '_DriverStore.isDriverCreated');

  @override
  bool get isDriverCreated {
    _$isDriverCreatedAtom.reportRead();
    return super.isDriverCreated;
  }

  @override
  set isDriverCreated(bool value) {
    _$isDriverCreatedAtom.reportWrite(value, super.isDriverCreated, () {
      super.isDriverCreated = value;
    });
  }

  final _$successAtom = Atom(name: '_DriverStore.success');

  @override
  bool get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(bool value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  final _$addDriverTaskAtom = Atom(name: '_DriverStore.addDriverTask');

  @override
  ObservableFuture<DocumentReference<Object?>?> get addDriverTask {
    _$addDriverTaskAtom.reportRead();
    return super.addDriverTask;
  }

  @override
  set addDriverTask(ObservableFuture<DocumentReference<Object?>?> value) {
    _$addDriverTaskAtom.reportWrite(value, super.addDriverTask, () {
      super.addDriverTask = value;
    });
  }

  final _$loaderAtom = Atom(name: '_DriverStore.loader');

  @override
  bool get loader {
    _$loaderAtom.reportRead();
    return super.loader;
  }

  @override
  set loader(bool value) {
    _$loaderAtom.reportWrite(value, super.loader, () {
      super.loader = value;
    });
  }

  final _$addDriverAsyncAction = AsyncAction('_DriverStore.addDriver');

  @override
  Future<dynamic> addDriver(String name, dynamic number, String vendor_code,
      Position _driverposition) {
    return _$addDriverAsyncAction
        .run(() => super.addDriver(name, number, vendor_code, _driverposition));
  }

  final _$showDriverAsyncAction = AsyncAction('_DriverStore.showDriver');

  @override
  Future<dynamic> showDriver(String name, dynamic number, String businessCode) {
    return _$showDriverAsyncAction
        .run(() => super.showDriver(name, number, businessCode));
  }

  final _$driverLogoutAsyncAction = AsyncAction('_DriverStore.driverLogout');

  @override
  Future<dynamic> driverLogout(String mobile) {
    return _$driverLogoutAsyncAction.run(() => super.driverLogout(mobile));
  }

  final _$_DriverStoreActionController = ActionController(name: '_DriverStore');

  @override
  Stream<QuerySnapshot<Object?>> getDriverList(String vendorCOde) {
    final _$actionInfo = _$_DriverStoreActionController.startAction(
        name: '_DriverStore.getDriverList');
    try {
      return super.getDriverList(vendorCOde);
    } finally {
      _$_DriverStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic driverStatus(String? id, bool status) {
    final _$actionInfo = _$_DriverStoreActionController.startAction(
        name: '_DriverStore.driverStatus');
    try {
      return super.driverStatus(id, status);
    } finally {
      _$_DriverStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic deleteDriver(String? id) {
    final _$actionInfo = _$_DriverStoreActionController.startAction(
        name: '_DriverStore.deleteDriver');
    try {
      return super.deleteDriver(id);
    } finally {
      _$_DriverStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isDriverCreated: ${isDriverCreated},
success: ${success},
addDriverTask: ${addDriverTask},
loader: ${loader},
loading: ${loading},
isListLoading: ${isListLoading},
isLoading: ${isLoading}
    ''';
  }
}
