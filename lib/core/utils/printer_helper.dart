// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:thermal_printer/esc_pos_utils_platform/src/capability_profile.dart';
// import 'package:thermal_printer/esc_pos_utils_platform/src/enums.dart';
// import 'package:thermal_printer/esc_pos_utils_platform/src/generator.dart';
// import 'package:thermal_printer/esc_pos_utils_platform/src/pos_styles.dart';
// import 'package:thermal_printer/thermal_printer.dart';

// /// Simple singleton helper to manage printer discovery, permissions and connection.
// class PrinterHelper {
//   PrinterHelper._internal();
//   static final PrinterHelper instance = PrinterHelper._internal();

//   StreamSubscription? _discoverySub;
//   final List<dynamic> _devices = [];

//   /// Exposes a read-only list of discovered devices.
//   List<dynamic> get devices => List.unmodifiable(_devices);

//   /// Stream controller to emit device list updates.
//   final StreamController<List<dynamic>> _devicesController =
//       StreamController.broadcast();

//   Stream<List<dynamic>> get devicesStream => _devicesController.stream;

//   bool _isConnected = false;
//   String? _connectedName;

//   bool get isConnected => _isConnected;

//   /// Name/address of the currently connected printer, if any.
//   String? get connectedName => _connectedName;

//   /// Start discovery. If [clearPrevious] is true, clears previous devices list.
//   /// Set [isBle] to false to use classic Bluetooth discovery (non-BLE).
//   Future<void> startDiscovery({
//     bool clearPrevious = true,
//     bool isBle = false,
//   }) async {
//     if (_discoverySub != null) return;

//     if (clearPrevious) {
//       _devices.clear();
//       _devicesController.add(devices);
//     }

//     debugPrint('PrinterHelper: starting discovery (isBle=$isBle)');
//     _discoverySub = PrinterManager.instance
//         .discovery(type: PrinterType.bluetooth, isBle: isBle)
//         .listen(
//           (device) {
//             try {
//               debugPrint(
//                 'PrinterHelper: discovered device name=${device.name} address=${device.address}',
//               );
//               if (device.address == null) return;
//               final exists = _devices.any((d) => d.address == device.address);
//               if (!exists) {
//                 _devices.add(device);
//                 _devicesController.add(devices);
//               }
//             } catch (e) {
//               debugPrint('PrinterHelper: discovery item handling error: $e');
//             }
//           },
//           onError: (e) {
//             debugPrint('PrinterHelper: discovery error: $e');
//           },
//         );
//   }

//   Future<bool> sendBytesToPrint(List<int> bytes, PrinterType type) async {
//     debugPrint('PrinterHelper: sendBytesToPrint called, bytes=${bytes.length}');
//     if (!_isConnected) {
//       debugPrint(
//         'PrinterHelper: sendBytesToPrint called but no printer connected',
//       );
//       // Try to send anyway and catch errors from platform.
//       try {
//         await PrinterManager.instance.send(type: type, bytes: bytes);
//         debugPrint(
//           'PrinterHelper: sendBytesToPrint succeeded (no _isConnected)',
//         );
//         return true;
//       } catch (e) {
//         debugPrint('PrinterHelper: error sending bytes (no _isConnected): $e');
//         return false;
//       }
//     }

//     try {
//       await PrinterManager.instance.send(type: type, bytes: bytes);
//       debugPrint('PrinterHelper: sendBytesToPrint succeeded');
//       return true;
//     } catch (e) {
//       debugPrint('PrinterHelper: error sending bytes: $e');
//       return false;
//     }
//   }

//   /// Convenience: generate a test ticket and send it to the connected printer.
//   Future<bool> printTestTicket({
//     PrinterType type = PrinterType.bluetooth,
//   }) async {
//     return await printTestTicketWithPaper(
//       type: type,
//       paperSize: PaperSize.mm80,
//     );
//   }

//   /// Helper to print with a specified [paperSize]. Returns true on success.
//   Future<bool> printTestTicketWithPaper({
//     PrinterType type = PrinterType.bluetooth,
//     required PaperSize paperSize,
//   }) async {
//     try {
//       final bytes = await testTicket(paperSize: paperSize);
//       debugPrint(
//         'PrinterHelper: printTestTicket - sending ${bytes.length} bytes (paperSize=$paperSize)',
//       );
//       final ok = await sendBytesToPrint(bytes, type);
//       debugPrint('PrinterHelper: printTestTicket result: $ok');
//       if (ok) return true;

//       // Fallback: many portable 58mm printers work better with plain text
//       // payloads and extra linefeeds. Try a simple UTF-8 text fallback.
//       debugPrint('PrinterHelper: attempting raw-text fallback print');
//       final fallbackText = 'Test Print\n\n\n\n\n\n';
//       final fallbackBytes = utf8.encode(fallbackText);
//       final fallbackOk = await sendBytesToPrint(fallbackBytes, type);
//       debugPrint('PrinterHelper: fallback result: $fallbackOk');
//       return fallbackOk;
//     } catch (e) {
//       debugPrint('PrinterHelper: printTestTicket error: $e');
//       return false;
//     }
//   }

//   Future<void> stopDiscovery() async {
//     await _discoverySub?.cancel();
//     _discoverySub = null;
//   }

//   Future<List<int>> testTicket({PaperSize paperSize = PaperSize.mm80}) async {
//     // Using default profile
//     final profile = await CapabilityProfile.load();
//     final generator = Generator(paperSize, profile);
//     List<int> bytes = [];

//     bytes += generator.text(
//       'Apna Godam',
//       styles: PosStyles(align: PosAlign.center),
//       linesAfter: 1,
//     );

//     bytes += generator.text(
//       'Broker',
//       styles: PosStyles(bold: true, align: PosAlign.center),
//       linesAfter: 2,
//     );
//     bytes += generator.text('Reverse text', styles: PosStyles(reverse: true));
//     bytes += generator.text(
//       'Underlined text',
//       styles: PosStyles(underline: true),
//       linesAfter: 1,
//     );
//     bytes += generator.text(
//       'Align left',
//       styles: PosStyles(align: PosAlign.left),
//     );
//     bytes += generator.text(
//       'Align center',
//       styles: PosStyles(align: PosAlign.center),
//     );
//     bytes += generator.text(
//       'Align right',
//       styles: PosStyles(align: PosAlign.right),
//       linesAfter: 1,
//     );

//     bytes += generator.text(
//       'Text size 200%',
//       styles: PosStyles(height: PosTextSize.size2, width: PosTextSize.size2),
//     );

//     bytes += generator.feed(2);
//     // Some mobile printers (58mm) may have limited cut support; keep cut but
//     // callers can fallback to raw text if needed.
//     bytes += generator.cut();
//     return bytes;
//   }

//   Future<bool> connect(dynamic device, {bool isBle = true}) async {
//     if (device == null || device.address == null) return false;
//     try {
//       debugPrint(
//         'PrinterHelper: attempting connect to ${device.name ?? device.address} isBle=$isBle',
//       );
//       await PrinterManager.instance.connect(
//         type: PrinterType.bluetooth,
//         model: BluetoothPrinterInput(
//           name: device.name,
//           address: device.address,
//           isBle: isBle,
//           autoConnect: true,
//         ),
//       );
//       debugPrint('PrinterHelper: connect call returned');
//       _isConnected = true;
//       _connectedName = device.name ?? device.address;
//       debugPrint('PrinterHelper: marked connected => $_connectedName');
//       return true;
//     } catch (e) {
//       debugPrint('PrinterHelper: connect error $e');
//       return false;
//     }
//   }

//   Future<void> disconnect() async {
//     try {
//       debugPrint('PrinterHelper: disconnecting');
//       await PrinterManager.instance.disconnect(type: PrinterType.bluetooth);
//     } catch (e) {
//       debugPrint('PrinterHelper: disconnect error $e');
//     }
//     _isConnected = false;
//     _connectedName = null;
//   }

//   void dispose() {
//     _devicesController.close();
//     _discoverySub?.cancel();
//     _discoverySub = null;
//   }
// }
