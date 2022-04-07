// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$VendorStore on _vendroStore, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: '_vendroStore.loading'))
      .value;
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading => (_$isLoadingComputed ??=
          Computed<bool>(() => super.isLoading, name: '_vendroStore.isLoading'))
      .value;

  final _$isVendorCreatedAtom = Atom(name: '_vendroStore.isVendorCreated');

  @override
  bool get isVendorCreated {
    _$isVendorCreatedAtom.reportRead();
    return super.isVendorCreated;
  }

  @override
  set isVendorCreated(bool value) {
    _$isVendorCreatedAtom.reportWrite(value, super.isVendorCreated, () {
      super.isVendorCreated = value;
    });
  }

  final _$successAtom = Atom(name: '_vendroStore.success');

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

  final _$addVendorTaskAtom = Atom(name: '_vendroStore.addVendorTask');

  @override
  ObservableFuture<DocumentReference<Object?>?> get addVendorTask {
    _$addVendorTaskAtom.reportRead();
    return super.addVendorTask;
  }

  @override
  set addVendorTask(ObservableFuture<DocumentReference<Object?>?> value) {
    _$addVendorTaskAtom.reportWrite(value, super.addVendorTask, () {
      super.addVendorTask = value;
    });
  }

  final _$addVendorAsyncAction = AsyncAction('_vendroStore.addVendor');

  @override
  Future<dynamic> addVendor(String name, dynamic number, String businessCode) {
    return _$addVendorAsyncAction
        .run(() => super.addVendor(name, number, businessCode));
  }

  final _$vendorLogoutAsyncAction = AsyncAction('_vendroStore.vendorLogout');

  @override
  Future<dynamic> vendorLogout(String mobile) {
    return _$vendorLogoutAsyncAction.run(() => super.vendorLogout(mobile));
  }

  final _$_vendroStoreActionController = ActionController(name: '_vendroStore');

  @override
  Future<Map<String, dynamic>> getVendorInfo(String mobile) {
    final _$actionInfo = _$_vendroStoreActionController.startAction(
        name: '_vendroStore.getVendorInfo');
    try {
      return super.getVendorInfo(mobile);
    } finally {
      _$_vendroStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isVendorCreated: ${isVendorCreated},
success: ${success},
addVendorTask: ${addVendorTask},
loading: ${loading},
isLoading: ${isLoading}
    ''';
  }
}
