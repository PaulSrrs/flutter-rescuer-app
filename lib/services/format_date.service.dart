/// This class is used to deal with date format and display.
class FormatDateService {
  /// Transform a numbered date to a sentence.
  /// It receives [data] as numbered date.
  /// For example, 2012-10-09 becomes 09th October 2012.
  static formatDate(String date) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    final separated = date.split("-");
    final int dayAsNb = int.parse(separated[2]);
    late String dayAsString;
    final String month = months[(int.parse(separated[1]) - 1).toInt()];
    final String year = separated[0];

    if (dayAsNb == 1) {
      dayAsString = "$dayAsNb" "st";
    } else if (dayAsNb == 2) {
      dayAsString = "$dayAsNb" "nd";
    } else if (dayAsNb == 3) {
      dayAsString = "$dayAsNb" "rd";
    } else {
      dayAsString = "$dayAsNb" "th";
    }
    return "$dayAsString $month $year";
  }
}
