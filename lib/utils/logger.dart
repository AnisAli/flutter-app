import 'package:logger/logger.dart' as logger;

late logger.Logger _logger, _loggerWithStack;
logger.Logger get log => _logger;
logger.Logger get logStack => _loggerWithStack;

class Logger {
  Logger._();
  static void configure() {
    _logger = logger.Logger(printer: logger.PrettyPrinter(methodCount: 0));
    _loggerWithStack =
        logger.Logger(printer: logger.PrettyPrinter(methodCount: 2));
  }
}
