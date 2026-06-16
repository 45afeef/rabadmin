/// Human-friendly date and time formatting.
///
/// Available getters:
/// - [relativeTime] → `5 minutes ago`, `in 2 hours`, `yesterday`, `tomorrow`
/// - [friendlyDate] → `Today`, `Yesterday`, `Tomorrow`, `Jun 16`
/// - [friendlyDateTime] → `Today at 2:30 PM`
extension DateTimeX on DateTime {
  /// Returns a relative time description.
  ///
  /// Examples:
  /// - `just now`
  /// - `5 minutes ago`
  /// - `2 days ago`
  /// - `yesterday`
  /// - `in 3 hours`
  /// - `tomorrow`
  /// - `in 2 weeks`
  String get relativeTime {
    final now = DateTime.now();
    final isFuture = isAfter(now);

    final diff = isFuture ? difference(now) : now.difference(this);

    if (diff.inSeconds < 45) {
      return 'just now';
    }

    if (diff.inMinutes < 60) {
      final value = diff.inMinutes;
      return isFuture
          ? 'in $value minute${value == 1 ? '' : 's'}'
          : '$value minute${value == 1 ? '' : 's'} ago';
    }

    if (diff.inHours < 24) {
      final value = diff.inHours;
      return isFuture
          ? 'in $value hour${value == 1 ? '' : 's'}'
          : '$value hour${value == 1 ? '' : 's'} ago';
    }

    if (diff.inDays == 1) {
      return isFuture ? 'tomorrow' : 'yesterday';
    }

    if (diff.inDays < 7) {
      final value = diff.inDays;
      return isFuture
          ? 'in $value day${value == 1 ? '' : 's'}'
          : '$value day${value == 1 ? '' : 's'} ago';
    }

    if (diff.inDays < 30) {
      final value = (diff.inDays / 7).floor();
      return isFuture
          ? 'in $value week${value == 1 ? '' : 's'}'
          : '$value week${value == 1 ? '' : 's'} ago';
    }

    if (diff.inDays < 365) {
      final value = (diff.inDays / 30).floor();
      return isFuture
          ? 'in $value month${value == 1 ? '' : 's'}'
          : '$value month${value == 1 ? '' : 's'} ago';
    }

    final value = (diff.inDays / 365).floor();
    return isFuture
        ? 'in $value year${value == 1 ? '' : 's'}'
        : '$value year${value == 1 ? '' : 's'} ago';
  }

  /// Returns a friendly date.
  ///
  /// Examples:
  /// - `Today`
  /// - `Yesterday`
  /// - `Tomorrow`
  /// - `Jun 16`
  /// - `Jun 16, 2025`
  String get friendlyDate {
    final now = DateTime.now();

    if (_isSameDay(now)) {
      return 'Today';
    }

    if (_isSameDay(now.subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    }

    if (_isSameDay(now.add(const Duration(days: 1)))) {
      return 'Tomorrow';
    }

    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    if (year == now.year) {
      return '${months[month]} $day';
    }

    return '${months[month]} $day, $year';
  }

  /// Returns a friendly date and time.
  ///
  /// Examples:
  /// - `Today at 2:30 PM`
  /// - `Tomorrow at 9:00 AM`
  /// - `Jun 16 at 4:45 PM`
  String get friendlyDateTime {
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final minuteStr = minute.toString().padLeft(2, '0');
    final amPm = hour >= 12 ? 'PM' : 'AM';

    return '$friendlyDate at $hour12:$minuteStr $amPm';
  }

  bool _isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
