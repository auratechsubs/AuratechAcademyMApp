import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart' as Foundation;

class LogX {


  static final Logger _logger = Logger(
    printer: HybridPrinter(
      PrettyPrinter(
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      error: PrettyPrinter(
        methodCount: 3,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      info: PrettyPrinter(
        methodCount: 0,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
    ),
  );



  static void printLog(String logMsg) {
    if (!Foundation.kReleaseMode) {
      _logger.i('\x1B[32m$logMsg\x1B[0m');
    }
  }

  static void printWarning(String logMsg) {
    if (!Foundation.kReleaseMode) {
      _logger.w(logMsg);
    }
  }

  static void printError(String logMsg) {
    if (!Foundation.kReleaseMode) {
      _logger.e('\x1B[31m$logMsg\x1B[0m');
    }
  }
}
