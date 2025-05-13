import '../../../exports/index.dart';
import 'dart:io';

extension WriteLarge on BluetoothCharacteristic {
  Future<void> writeLarge(List<int> value, int mtu, {int timeout = 15}) async {
    int chunkSize = mtu - 3;
    for (int i = 0; i < value.length; i += chunkSize) {
      int end = i + chunkSize;
      if (end > value.length) {
        end = value.length;
      }
      List<int> subValue = value.sublist(i, end);
      write(subValue, withoutResponse: false, timeout: timeout);
    }
  }
}

class BluetoothPrinterSheetCard extends StatefulWidget {
  const BluetoothPrinterSheetCard({Key? key}) : super(key: key);

  @override
  State<BluetoothPrinterSheetCard> createState() =>
      _BluetoothPrinterSheetCardState();
}

class _BluetoothPrinterSheetCardState extends State<BluetoothPrinterSheetCard> {
  InvoiceViewController invoiceViewController =
      Get.find<InvoiceViewController>();

  @override
  void initState() {
    if (invoiceViewController.isBluetoothConnected.value) {
      invoiceViewController.tips.value =
          "Connected Device: ${invoiceViewController.bluetoothDevice?.platformName}";
    }

    // turn on bluetooth ourself if we can
    if (Platform.isAndroid) {
      FlutterBluePlus.turnOn();
    }

    // wait bluetooth to be on
    FlutterBluePlus.adapterState
        .where((s) => s == BluetoothAdapterState.on)
        .first;

    if (FlutterBluePlus.isScanningNow == false) {
      FlutterBluePlus.startScan(
          timeout: const Duration(seconds: 5), androidUsesFineLocation: false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        backgroundColor: context.scaffoldBackgroundColor,
        iconTheme: IconThemeData(
          color: context.iconColor1, //change your color here
        ),
        title: Text(
          'Print Receipt',
          style: context.titleMedium,
        ),
      ),
      body: RefreshIndicator(
          onRefresh: () {
            if (FlutterBluePlus.isScanningNow == false) {
              return FlutterBluePlus.startScan(
                  timeout: const Duration(seconds: 5),
                  androidUsesFineLocation: false);
            }
            return Future.value();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            dragStartBehavior: DragStartBehavior.down,
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Text(
                          invoiceViewController.tips.value,
                          style: context.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  StreamBuilder<List<ScanResult>>(
                    stream: FlutterBluePlus.scanResults,
                    initialData: const [],
                    builder: (c, snapshot) => Column(
                      children: snapshot.data!
                          .where((d) => d.device.localName.isNotEmpty)
                          .map((d) {
                        return ListTile(
                          title: Text(
                            d.device.platformName,
                            style: context.titleMedium,
                          ),
                          subtitle: Text(
                            d.device.remoteId.str,
                            style: context.bodyMedium,
                          ),
                          onTap: () async {
                            invoiceViewController.bluetoothDevice = d.device;
                            invoiceViewController.tips.value =
                                "Selected : ${d.device.platformName}";
                          },
                          trailing:
                              invoiceViewController.bluetoothDevice != null &&
                                      invoiceViewController
                                              .bluetoothDevice?.remoteId.str ==
                                          d.device.remoteId.str
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  : null,
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 400,
                  )
                ],
              ),
            ),
          )),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 30),
        child: Obx(() => Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: invoiceViewController.isBluetoothConnected.value
                        ? null
                        : () async {
                            if (invoiceViewController.bluetoothDevice != null) {
                              invoiceViewController.tips.value =
                                  'Connecting...';

                              await invoiceViewController.bluetoothDevice
                                  ?.connect();

                              invoiceViewController.tips.value =
                                  'Connected Device: ${invoiceViewController.bluetoothDevice?.platformName}';
                              invoiceViewController.isBluetoothConnected.value =
                                  true;
                            } else {
                              invoiceViewController.tips.value =
                                  'Please select a device';
                            }
                          },
                    child: const Text('Connect'),
                  ),
                ),
                const SizedBox(width: 5.0),
                Flexible(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: !invoiceViewController.isBluetoothConnected.value
                        ? null
                        : () async {
                            invoiceViewController.tips.value =
                                'Disconnecting...';
                            await FlutterBluePlus.systemDevices
                                .then((value) => {
                                      for (var value1 in value)
                                        {value1.disconnect()}
                                    });
                            invoiceViewController.tips.value = 'No Connection';
                            invoiceViewController.bluetoothDevice = null;
                            invoiceViewController.isBluetoothConnected.value =
                                false;
                          },
                    child: const Text(
                      'Disconnect',
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
