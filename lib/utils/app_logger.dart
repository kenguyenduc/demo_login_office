import 'package:logger/logger.dart';

/// Use logger to debug, it will not show in release mode
final Logger logger = Logger(printer: PrettyPrinter());

final Logger loggerNoStack = Logger(printer: PrettyPrinter(methodCount: 0));

final Logger loggerSimple = Logger(printer: SimplePrinter());
