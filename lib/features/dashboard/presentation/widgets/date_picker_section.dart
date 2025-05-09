import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart'; // For date formatting

enum CalendarViewMode { week, month }

class DatePickerSection extends StatefulWidget {
  const DatePickerSection({super.key});

  @override
  State<DatePickerSection> createState() => _DatePickerSectionState();
}

class _CalendarDay {
  final DateTime date;
  final bool
      isDisplayedMonth; // Is this day part of the primary month of the displayed week?
  bool isSelected;
  final bool isToday;

  _CalendarDay({
    required this.date,
    required this.isDisplayedMonth,
    this.isSelected = false,
    this.isToday = false,
  });
}

class _DatePickerSectionState extends State<DatePickerSection> {
  late DateTime _selectedDate;
  late DateTime _focusedDate; // Represents the month or the week in focus
  CalendarViewMode _currentViewMode = CalendarViewMode.week;

  final List<String> _weekDaysHeader = [
    'Mo',
    'Tu',
    'We',
    'Th',
    'Fr',
    'Sa',
    'Su'
  ];
  List<_CalendarDay> _displayedDaysList = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = now;
    _focusedDate =
        DateTime(now.year, now.month, now.day); // Start with today in focus
    _generateDisplayedDays();
  }

  void _generateDisplayedDays() {
    _displayedDaysList.clear();
    final DateTime today = DateTime.now();

    if (_currentViewMode == CalendarViewMode.week) {
      DateTime mondayOfFocusedWeek =
          _focusedDate.subtract(Duration(days: _focusedDate.weekday - 1));
      final DateTime referenceDayForMonthStyle =
          mondayOfFocusedWeek.add(const Duration(days: 3));

      for (int i = 0; i < 7; i++) {
        final dayInWeek = mondayOfFocusedWeek.add(Duration(days: i));
        _displayedDaysList.add(_CalendarDay(
          date: dayInWeek,
          isDisplayedMonth: dayInWeek.month == referenceDayForMonthStyle.month,
          isSelected: _isSameDay(dayInWeek, _selectedDate),
          isToday: _isSameDay(dayInWeek, today),
        ));
      }
    } else {
      // CalendarViewMode.month
      final DateTime firstDayOfMonth =
          DateTime(_focusedDate.year, _focusedDate.month, 1);
      final int daysInMonth =
          DateTime(_focusedDate.year, _focusedDate.month + 1, 0).day;
      int weekdayOfFirstDay = firstDayOfMonth.weekday;

      for (int i = 0; i < weekdayOfFirstDay - 1; i++) {
        final prevMonthDay =
            firstDayOfMonth.subtract(Duration(days: weekdayOfFirstDay - 1 - i));
        _displayedDaysList.add(_CalendarDay(
            date: prevMonthDay,
            isDisplayedMonth: false,
            isToday: _isSameDay(prevMonthDay, today)));
      }

      for (int i = 0; i < daysInMonth; i++) {
        final currentMonthDay = firstDayOfMonth.add(Duration(days: i));
        _displayedDaysList.add(_CalendarDay(
            date: currentMonthDay,
            isDisplayedMonth: true,
            isSelected: _isSameDay(currentMonthDay, _selectedDate),
            isToday: _isSameDay(currentMonthDay, today)));
      }

      int daysSoFar = _displayedDaysList.length;
      int nextMonthDayCounter = 1;
      while (daysSoFar < 42) {
        // Always display 6 weeks for month view
        final nextMonthDayDateTime = DateTime(
            _focusedDate.year, _focusedDate.month + 1, nextMonthDayCounter++);
        _displayedDaysList.add(_CalendarDay(
            date: nextMonthDayDateTime,
            isDisplayedMonth: false,
            isToday: _isSameDay(nextMonthDayDateTime, today)));
        daysSoFar++;
      }
    }
    // Ensure _selectedDate is correctly marked if it's in the list
    // This might be redundant if selection logic is robust
    for (var day in _displayedDaysList) {
      day.isSelected = _isSameDay(day.date, _selectedDate);
    }
  }

  bool _isSameDay(DateTime dateA, DateTime dateB) {
    return dateA.year == dateB.year &&
        dateA.month == dateB.month &&
        dateA.day == dateB.day;
  }

  void _onDateTapped(_CalendarDay day) {
    setState(() {
      _selectedDate = day.date;
      // If the tapped day's month is different from the focused month (in month view)
      // or if the week of the tapped day is different (in week view), update _focusedDate.
      if (_currentViewMode == CalendarViewMode.month) {
        if (day.date.month != _focusedDate.month ||
            day.date.year != _focusedDate.year) {
          _focusedDate = DateTime(day.date.year, day.date.month, 1);
        }
      } else {
        // CalendarViewMode.week
        DateTime mondayOfTappedDayWeek =
            day.date.subtract(Duration(days: day.date.weekday - 1));
        DateTime mondayOfFocusedWeek =
            _focusedDate.subtract(Duration(days: _focusedDate.weekday - 1));
        if (!_isSameDay(mondayOfTappedDayWeek, mondayOfFocusedWeek)) {
          _focusedDate =
              mondayOfTappedDayWeek; // Focus on the week of the tapped day
        }
      }
      _generateDisplayedDays();
    });
  }

  void _changeFocusedPeriod(int amount) {
    setState(() {
      if (_currentViewMode == CalendarViewMode.week) {
        _focusedDate = _focusedDate.add(Duration(days: 7 * amount));
        // Optionally, update _selectedDate to be in the new focused week
        // _selectedDate = _focusedDate.add(Duration(days: _selectedDate.weekday - 1));
      } else {
        _focusedDate =
            DateTime(_focusedDate.year, _focusedDate.month + amount, 1);
        // Optionally, update _selectedDate to be in the new focused month
        // _selectedDate = DateTime(_focusedDate.year, _focusedDate.month, _selectedDate.day);
      }
      _generateDisplayedDays();
    });
  }

  void _toggleViewMode() {
    setState(() {
      _currentViewMode = _currentViewMode == CalendarViewMode.week
          ? CalendarViewMode.month
          : CalendarViewMode.week;
      // When switching view, ensure _focusedDate is sensible for the new view relative to _selectedDate
      if (_currentViewMode == CalendarViewMode.week) {
        _focusedDate =
            _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
      } else {
        _focusedDate = DateTime(_selectedDate.year, _selectedDate.month, 1);
      }
      _generateDisplayedDays();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    // Figma: Inter SemiBold 14px, color onSurface
    final monthYearStyle = textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
    );

    // Figma: Inter SemiBold 12px, color onSurface. titleSmall trong theme đã có màu này.
    final weekDayStyle = textTheme.titleSmall;

    // Figma: Inter Regular 14px, color onSurface. bodyMedium trong theme có màu onSurfaceVariant.
    final dateStyle = textTheme.bodyMedium?.copyWith(
      color: colorScheme.onSurface,
    );
    // Style for today, not selected
    final todayDateStyle = dateStyle?.copyWith(color: colorScheme.primary);

    // Style for dates not in the displayed month
    final nonDisplayedMonthDateStyle =
        dateStyle?.copyWith(color: colorScheme.outline);

    // Figma: Inter SemiBold 14px, color onPrimary. bodyMedium là 14px Regular.
    final selectedDateStyle = textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );

    final String headerMonthYear =
        DateFormat('MMMM - yyyy').format(_focusedDate);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: colorScheme.brightness == Brightness.light
                ? const Color(0xFF1D3A58)
                    .withOpacity(0.08) // Shadow nhẹ hơn cho card này
                : const Color(0xFF1B2025)
                    .withOpacity(0.8), // Shadow nhẹ hơn cho card này
            blurRadius: 32,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildNavigationHeader(context, monthYearStyle, headerMonthYear),
          const SizedBox(height: 16.0),
          _buildWeekDayHeader(context, weekDayStyle),
          const SizedBox(height: 8.0),
          _buildCalendarView(context, dateStyle, nonDisplayedMonthDateStyle,
              selectedDateStyle, todayDateStyle),
        ],
      ),
    );
  }

  Widget _buildNavigationHeader(
      BuildContext context, TextStyle? monthYearStyle, String headerMonthYear) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _CalendarNavButton(
            iconPath: 'assets/icons/chevron_left.svg',
            onTap: () => _changeFocusedPeriod(-1)),
        Text(headerMonthYear, style: monthYearStyle),
        Row(
          children: [
            _CalendarNavButton(
                iconPath: 'assets/icons/chevron_right.svg',
                onTap: () => _changeFocusedPeriod(1)),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(_currentViewMode == CalendarViewMode.week
                  ? Icons.calendar_view_month
                  : Icons.calendar_view_week),
              onPressed: _toggleViewMode,
              tooltip: _currentViewMode == CalendarViewMode.week
                  ? 'View by Month'
                  : 'View by Week',
              color: theme.colorScheme.onSurface,
              splashRadius: 20,
            )
          ],
        )
      ],
    );
  }

  Widget _buildWeekDayHeader(BuildContext context, TextStyle? weekDayStyle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:
          _weekDaysHeader.map((day) => Text(day, style: weekDayStyle)).toList(),
    );
  }

  Widget _buildCalendarView(
      BuildContext context,
      TextStyle? dateStyle,
      TextStyle? nonDisplayedMonthDateStyle,
      TextStyle? selectedDateStyle,
      TextStyle? todayStyle) {
    if (_displayedDaysList.isEmpty) return const SizedBox.shrink();

    if (_currentViewMode == CalendarViewMode.week) {
      return Row(
        children: _displayedDaysList.map((calendarDay) {
          return _buildDayCell(calendarDay, dateStyle,
              nonDisplayedMonthDateStyle, selectedDateStyle, todayStyle);
        }).toList(),
      );
    } else {
      // CalendarViewMode.month
      return Column(
        children:
            List.generate((_displayedDaysList.length / 7).ceil(), (rowIndex) {
          final rowChildren =
              _displayedDaysList.skip(rowIndex * 7).take(7).map((calendarDay) {
            return _buildDayCell(calendarDay, dateStyle,
                nonDisplayedMonthDateStyle, selectedDateStyle, todayStyle);
          }).toList();

          while (rowChildren.length < 7) {
            rowChildren.add(Expanded(child: Container()));
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Row(children: rowChildren),
          );
        }),
      );
    }
  }

  Widget _buildDayCell(
      _CalendarDay calendarDay,
      TextStyle? dateStyle,
      TextStyle? nonDisplayedMonthDateStyle,
      TextStyle? selectedDateStyle,
      TextStyle? todayStyle) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isTodayNotSelected =
        calendarDay.isToday && !calendarDay.isSelected;
    TextStyle? currentStyle;
    Color? backgroundColor = Colors.transparent;
    BoxBorder? border;

    if (calendarDay.isSelected) {
      currentStyle = selectedDateStyle;
      backgroundColor = colorScheme.primary;
    } else if (isTodayNotSelected) {
      currentStyle = todayStyle;
      // Optionally add a border for today if not selected
      border =
          Border.all(color: colorScheme.primary.withOpacity(0.5), width: 1);
    } else if (calendarDay.isDisplayedMonth) {
      currentStyle = dateStyle;
    } else {
      currentStyle = nonDisplayedMonthDateStyle;
    }

    return Expanded(
      child: GestureDetector(
        onTap: () => _onDateTapped(calendarDay),
        child: Container(
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12.0),
            border: border,
          ),
          child: Center(
            child: Text(
              calendarDay.date.day.toString(),
              style: currentStyle,
            ),
          ),
        ),
      ),
    );
  }
}

class _CalendarNavButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onTap;

  const _CalendarNavButton({required this.iconPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: theme.colorScheme.outline,
            width: 0.5,
          ),
        ),
        child: SvgPicture.asset(
          iconPath,
          colorFilter:
              ColorFilter.mode(theme.colorScheme.onSurface, BlendMode.srcIn),
          width: 20,
          height: 20,
        ),
      ),
    );
  }
}
