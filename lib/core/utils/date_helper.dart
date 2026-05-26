import 'package:intl/intl.dart';

class DateHelper {
  DateHelper._();

  static const _locale = 'id';

  static final DateFormat _monthYear = DateFormat('MMMM yyyy', _locale);
  static final DateFormat _dayMonth = DateFormat('d MMM yyyy', _locale);
  static final DateFormat _fullDate = DateFormat('EEEE, d MMM yyyy', _locale);
  static final DateFormat _dayLabel = DateFormat('EEE, d MMM', _locale);

  static String formatMonthYear(DateTime date) => _monthYear.format(date);
  static String formatDayMonth(DateTime date) => _dayMonth.format(date);
  static String formatFullDate(DateTime date) => _fullDate.format(date);
  static String formatDayLabel(DateTime date) => _dayLabel.format(date);

  /// Returns first day of the given month at 00:00.
  static DateTime startOfMonth(int year, int month) =>
      DateTime(year, month, 1);

  /// Returns the last moment of the given month.
  static DateTime endOfMonth(int year, int month) {
    final firstNext = (month == 12)
        ? DateTime(year + 1, 1, 1)
        : DateTime(year, month + 1, 1);
    return firstNext.subtract(const Duration(milliseconds: 1));
  }

  /// Strips time-of-day, returning a date at 00:00.
  static DateTime dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static int daysInMonth(int year, int month) {
    final firstNext = (month == 12)
        ? DateTime(year + 1, 1, 1)
        : DateTime(year, month + 1, 1);
    return firstNext.subtract(const Duration(days: 1)).day;
  }
}
