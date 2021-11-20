import 'package:flutter/widgets.dart';

/// An enum used to determine the type of the device used by the user.
enum DeviceType {
  phone,
  tablet
}

/// This class is used to determine the type of the device used by the user.
class IsPhoneOrTabletService {
  /// This method is used to determine the type of the device used by the user.
  static DeviceType getDeviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
    return data.size.shortestSide < 550 ? DeviceType.phone : DeviceType.tablet;
  }
}