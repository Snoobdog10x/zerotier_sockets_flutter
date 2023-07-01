# zerotier_sockets

Flutter bindings for the [libzt](https://github.com/zerotier/libzt) library. Uses FFI to call into native library. 

Native binaries are distributed in the plugin itself, so this is Flutter plugin, not Dart plugin. Someday plugin may be split into Flutter plugin distributing binaries and separate Dart FFI wrapper for use in commandline Dart apps. 

## Supported platforms

Currently only supports Android. 

To support other platforms platform specific folder must be added with native dependency built from [libzt](https://github.com/zerotier/libzt) and `loader.dart` must be fixed accordingly.

## Usage

For more detailed usage see `example` folder. Also refer to [ZeroTier Sockets tutorial](https://docs.zerotier.com/sockets/tutorial.html).

```dart
import 'package:zerotier_sockets/zerotier_sockets.dart';
import 'package:path_provider/path_provider.dart';

Future<void> startNodeAndConnectToNetwork(String networkId) async {
  // obtain node instance
  var node = ZeroTierNode.instance;

  // set persistent storage path to have identity and network configuration cached
  // you can also use initSetIdentity to set identity from memory but network configs won't be cached
  var appDocPath = (await getApplicationDocumentsDirectory()).path + '/zerotier_node';
  node.initSetPath(appDocPath);
  
  // try to start
  var result = node.start();
  if (!result.success) {
    throw Exception('Failed to start node: $result');
  } 
  
  await node.waitForOnline();

  // parse network id from hex string
  var nwId = BigInt.parse(networkId, radix: 16);
  
  // join network
  result = node.join(nwId);
  if (!result.success) {
    throw Exception('Failed to join network: $result');
  }
  
  await node.waitForNetworkReady(nwId);
  await node.waitForAddressAssignment(nwId);
 
  // get network info
  var networkInfo = node.getNetworkInfo(nwId);
  print(networkInfo.name);
  print(networkInfo.address);
  print(networkInfo.id);

  // connect socket
  ZeroTierSocket socket;
  try {
    socket = await ZeroTierSocket.connect('10.144.242.244', 22);

    // send data
    socket.sink.add([1, 2, 3, 4, 5]);

    // listen for data
    socket.stream.listen((data) => print('received ${data.length} byte(s)'));
  } catch (e) {
    print('Failed to connect socket: $e');
  } finally {
    socket.close();
  }
}
```
