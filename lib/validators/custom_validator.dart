/// This class is used for custom validator.
class CustomValidator {
  /// This method is used to determine if a filled form field has an error.
  /// An error occurred if the [value] is empty or null.
  /// In the case of an error, the [message] is returned and displayed to the screen.
  static emptyValidator(String? value, String message) {
    if (value == null || value.isEmpty) {
      return message;
    }
    return null;
  }
}