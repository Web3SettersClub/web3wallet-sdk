import 'package:web3wallet_sdk/api/api.dart';
import 'package:web3wallet_sdk/api/types/recoveryInfo.dart';
import 'package:web3wallet_sdk/service/recovery.dart';

class ApiRecovery {
  ApiRecovery(this.apiRoot, this.service);

  final Web3WalletApi apiRoot;
  final ServiceRecovery service;

  Future<RecoveryInfo?> queryRecoverable(String address) async {
//    address = "J4sW13h2HNerfxTzPGpLT66B3HVvuU32S6upxwSeFJQnAzg";
    final res = await service.queryRecoverable(address);
    if (res != null) {
      return RecoveryInfo.fromJson(
          Map<String, dynamic>.of(res as Map<String, dynamic>));
    }
    return null;
  }

  Future<List<RecoveryInfo>> queryRecoverableList(
      List<String> addresses) async {
    final List res = await service.queryRecoverableList(addresses);
    return res
        .map((e) => RecoveryInfo.fromJson(Map<String, dynamic>.of(e ?? {})))
        .toList();
  }

  Future<List?> queryActiveRecoveryAttempts(
      String address, List<String> addressNew) async {
    final res = await service.queryActiveRecoveryAttempts(address, addressNew);
    return res;
  }

  Future<List?> queryActiveRecoveries(
      List<String> addresses, String addressNew) async {
    final res = await service.queryActiveRecoveries(addresses, addressNew);
    return res;
  }

  Future<List?> queryRecoveryProxies(List<String> addresses) async {
    final res = await service.queryRecoveryProxies(addresses);
    return res;
  }
}