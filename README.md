# web3wallet-sdk

"Web3 Wallet" SDK for integrating substrate-based blockchains as plugins.

## Building a web3plugin dart package

## 1. Create your plugin repo

create a dart package

```shell
flutter create --template=package web3plugin_setheum
cd web3plugin_setheum/
```

add dependencies in pubspec.yaml

```yaml
dependencies:
  web3wallet_sdk: ^0.1.01
```

and install the dependencies.

```shell
flutter pub get
```

## 2. Build your polkadot-js wrapper

The App use a `polkadot-js/api` instance running in a hidden webView
to connect to remote node.

Example:
setheum: [https://github.com/Web3SettersClub/web3plugin-setheum/tree/master/lib/js_service_setheum](https://github.com/Web3SettersClub/web3plugin-setheum/tree/master/lib/js_service_setheum)

## 3. Implement your plugin class

Modify the plugin entry file(eg. web3plugin_setheum.dart),
create a `PluginFoo` class extending `Web3walletPlugin`:

```dart
class PluginSetheum extends Web3walletPlugin {
  /// define your own plugin
}
```

### 3.1. override `Web3walletPlugin.basic`

```dart
  @override
  final basic = PluginBasicData(
    name: 'setheum',
    ss58: 25,
    primaryColor: Colors.deepPurple,
    gradientColor: Colors.blue,
    // The `bg.png` will be displayed as texture on a block with theme color,
    // so it should have a transparent or dark background color.
    backgroundImage: AssetImage('packages/web3plugin_setheum/assets/images/bg.png'),
    icon:
        Image.asset('packages/web3plugin_setheum/assets/images/logo.png'),
    // The `logo_gray.png` should have a gray color `#9e9e9e`.
    iconDisabled: Image.asset(
        'packages/web3plugin_setheum/assets/images/logo_gray.png'),
    isTestNet: false,
  );
```

### 3.2. override `Web3walletPlugin.tokenIcons`

Define the icon widgets so the Web3 Wallet App can display tokens
of your chain with token icons.

```dart
  @override
  final Map<String, Widget> tokenIcons = {
    'SETM': Image.asset(
        'packages/web3plugin_setheum/assets/images/tokens/SETM.png'),
    'SETUSD': Image.asset(
        'packages/web3plugin_setheum/assets/images/tokens/SETUSD.png'),
  };
```

### 3.3. override `Web3walletPlugin.nodeList`

```dart
const node_list = [
  {
    'name': 'Setheum Node 1 (Hosted by Setheum Foundation)',
    'ss58': 25,
    'endpoint': 'wss://rpc-newrome.setheum.xyz',
  },
];
```

```dart
  @override
  List<NetworkParams> get nodeList {
    return node_list.map((e) => NetworkParams.fromJson(e)).toList();
  }
```

### 3.4. override `Web3walletPlugin.getNavItems(BuildContext, Keyring)`

Define your custom navigation-item in `BottomNavigationBar` of Web3 Wallet App.
The `HomeNavItem.content` is the page content widget displayed while your navItem was selected.

```dart
  @override
  List<HomeNavItem> getNavItems(BuildContext context, Keyring keyring) {
    return [
      HomeNavItem(
        text: 'Apps',
        icon: SvgPicture.asset(
          'packages/web3plugin_setheum/assets/images/logo.svg',
          color: Theme.of(context).disabledColor,
        ),
        iconActive: SvgPicture.asset(
            'packages/web3plugin_setheum/assets/images/logo.svg'),
        content: SetheumEntry(this, keyring),
      )
    ];
  }
```

### 3.5. override `Web3walletPlugin.getRoutes(Keyring)`

Define navigation route for your plugin pages.

```dart
  @override
  Map<String, WidgetBuilder> getRoutes(Keyring keyring) {
    return {
      TxConfirmPage.route: (_) =>
          TxConfirmPage(this, keyring, _service.getPassword),
      CurrencySelectPage.route: (_) => CurrencySelectPage(this),
      AccountQrCodePage.route: (_) => AccountQrCodePage(this, keyring),

      TokenDetailPage.route: (_) => TokenDetailPage(this, keyring),
      TransferPage.route: (_) => TransferPage(this, keyring),

      // other pages
      // ...
    };
  }
```

### 3.6. override `Web3walletPlugin.loadJSCode()` method

Load the `polkadot-js/api` wrapper you built in step 2.

```dart
  @override
  Future<String> loadJSCode() => rootBundle.loadString(
      'packages/web3plugin_setheum/lib/js_service_setheum/dist/main.js');
```

### 3.7. override plugin life-circle methods

 - `onWillStart()`, you may want to prepare your plugin state data here.
 - `onStarted()`, remote node connected, you may fetch data from network.
 - `onAccountChanged()`, user just changed account, you may clear
 cache of the prev account and query data for new account.

Example:
[setheum](https://github.com/Web3SettersClub/web3plugin-setheum/blob/master/lib/web3plugin_setheum.dart)

## 4. Fetch data and build pages

We use [https://pub.dev/packages/mobx](https://pub.dev/packages/mobx) as the App state management tool.
 So the directories in a plugin looks like this:

```bash
__ lib
    |__ pages (the UI)
    |__ store (the MobX store)
    |__ service (the Actions fired by UI to mutate the store)
    |__ ...
```

To query data through `Web3walletPlugin.sdk.api`:

(`polkawallet-io/polkawallet_plugin_kusama/lib/service/gov.dart`)

```dart
  Future<List> queryReferendums() async {
    final data = await api.gov.queryReferendums(keyring.current.address);
    store.gov.setReferendums(data);
    return data;
  }
```

To query data by calling JS directly:

(`polkawallet-io/polkawallet_plugin_kusama/lib/service/gov.dart`)

```dart
  Future<void> updateBestNumber() async {
    final int bestNumber = await api.service.webView
        .evalJavascript('api.derive.chain.bestNumber()');
    store.gov.setBestNumber(bestNumber);
  }
```

While we set data to MobX store, the MobX Observer Flutter Widget will rebuild with new data.

## 5. Run your pages in `example/` app

You may want to run an example app in dev while building your plugin pages.

See the `setheum` example:
[setheum](https://github.com/Web3SettersClub/web3plugin-setheum)

### Thanks to the www.polkawallet.io Team for this framework used on the Web3 Wallet
