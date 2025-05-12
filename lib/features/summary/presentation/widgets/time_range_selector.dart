import 'package:flutter/material.dart';
import '../../domain/entities/time_range.dart';

class TimeRangeSelector extends StatelessWidget {
  final TimeRange selectedTimeRange;
  final Function(TimeRange) onTimeRangeSelected;

  const TimeRangeSelector({
    Key? key,
    required this.selectedTimeRange,
    required this.onTimeRangeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTimeRangeButton(context, TimeRange.day),
          _buildTimeRangeButton(context, TimeRange.week),
          _buildTimeRangeButton(context, TimeRange.month),
          _buildTimeRangeButton(context, TimeRange.year),
        ],
      ),
    );
  }

  Widget _buildTimeRangeButton(BuildContext context, TimeRange timeRange) {
    final isSelected = selectedTimeRange == timeRange;

    return InkWell(
      onTap: () => onTimeRangeSelected(timeRange),
      borderRadius: BorderRadius.circular(4.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color:
              isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Text(
          timeRange.displayName,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? Colors.white
                : Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }
}
