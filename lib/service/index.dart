import 'dart:async';

import 'package:web3wallet_sdk/api/api.dart';
import 'package:web3wallet_sdk/service/account.dart';
import 'package:web3wallet_sdk/service/assets.dart';
import 'package:web3wallet_sdk/service/gov.dart';
import 'package:web3wallet_sdk/service/keyring.dart';
import 'package:web3wallet_sdk/service/parachain.dart';
import 'package:web3wallet_sdk/service/recovery.dart';
import 'package:web3wallet_sdk/service/setting.dart';
import 'package:web3wallet_sdk/service/staking.dart';
import 'package:web3wallet_sdk/service/tx.dart';
import 'package:web3wallet_sdk/service/uos.dart';
import 'package:web3wallet_sdk/service/walletConnect.dart';
import 'package:web3wallet_sdk/service/webViewRunner.dart';
import 'package:web3wallet_sdk/storage/keyring.dart';

/// The service calling JavaScript API of `polkadot-js/api` directly
/// through [WebViewRunner], providing APIs for [Web3WalletApi].
class SubstrateService {
  late ServiceKeyring keyring;
  late ServiceSetting setting;
  late ServiceAccount account;
  late ServiceTx tx;

  late ServiceStaking staking;
  late ServiceGov gov;
  late ServiceParachain parachain;
  late ServiceAssets assets;
  late ServiceUOS uos;
  late ServiceRecovery recovery;

  late ServiceWalletConnect walletConnect;

  WebViewRunner? _web;

  WebViewRunner? get webView => _web;

  Future<void> init(
    Keyring keyringStorage, {
    WebViewRunner? webViewParam,
    Function? onInitiated,
    String? jsCode,
  }) async {
    keyring = ServiceKeyring(this);
    setting = ServiceSetting(this);
    account = ServiceAccount(this);
    tx = ServiceTx(this);
    staking = ServiceStaking(this);
    gov = ServiceGov(this);
    parachain = ServiceParachain(this);
    assets = ServiceAssets(this);
    uos = ServiceUOS(this);
    recovery = ServiceRecovery(this);

    walletConnect = ServiceWalletConnect(this);

    _web = webViewParam ?? WebViewRunner();
    await _web!.launch(keyring, keyringStorage, onInitiated, jsCode: jsCode);
  }
}
