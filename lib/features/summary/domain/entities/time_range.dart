/// Enum đại diện cho các khoảng thời gian thống kê
enum TimeRange {
  day,
  week,
  month,
  year,
}

/// Extension cho TimeRange để có thêm các tiện ích
extension TimeRangeExtension on TimeRange {
  /// Tên hiển thị cho người dùng
  String get displayName {
    switch (this) {
      case TimeRange.day:
        return 'Ngày';
      case TimeRange.week:
        return 'Tuần';
      case TimeRange.month:
        return 'Tháng';
      case TimeRange.year:
        return 'Năm';
    }
  }

  /// Lấy ngày bắt đầu của khoảng thời gian
  DateTime getStartDate([DateTime? reference]) {
    final now = reference ?? DateTime.now();
    final normalizedDate = DateTime(now.year, now.month, now.day);

    switch (this) {
      case TimeRange.day:
        return normalizedDate;
      case TimeRange.week:
        // Lấy ngày đầu tuần (thứ 2)
        final weekDay = normalizedDate.weekday; // 1 = Thứ 2, 7 = Chủ nhật
        return normalizedDate.subtract(Duration(days: weekDay - 1));
      case TimeRange.month:
        // Ngày đầu tháng
        return DateTime(normalizedDate.year, normalizedDate.month, 1);
      case TimeRange.year:
        // Ngày đầu năm
        return DateTime(normalizedDate.year, 1, 1);
    }
  }

  /// Lấy ngày kết thúc của khoảng thời gian
  DateTime getEndDate([DateTime? reference]) {
    final now = reference ?? DateTime.now();
    final normalizedDate =
        DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    switch (this) {
      case TimeRange.day:
        return normalizedDate;
      case TimeRange.week:
        // Lấy ngày cuối tuần (chủ nhật)
        final weekDay = normalizedDate.weekday; // 1 = Thứ 2, 7 = Chủ nhật
        return normalizedDate.add(Duration(days: 7 - weekDay));
      case TimeRange.month:
        // Ngày cuối tháng
        final nextMonth = normalizedDate.month < 12
            ? DateTime(normalizedDate.year, normalizedDate.month + 1, 1)
            : DateTime(normalizedDate.year + 1, 1, 1);
        return nextMonth.subtract(const Duration(milliseconds: 1));
      case TimeRange.year:
        // Ngày cuối năm
        return DateTime(normalizedDate.year, 12, 31, 23, 59, 59, 999);
    }
  }
}
