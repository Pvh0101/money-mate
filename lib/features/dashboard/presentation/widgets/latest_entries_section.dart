import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date and number formatting

class LatestEntriesSection extends StatelessWidget {
  final List<Map<String, dynamic>> entries;

  const LatestEntriesSection({
    super.key,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (entries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Text(
            'No recent transactions.',
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
          child: Text(
            'Latest Entries',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap:
              true, // Important to allow ListView inside SingleChildScrollView
          physics:
              const NeverScrollableScrollPhysics(), // To prevent nested scrolling issues
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            return _LatestEntryItemWidget(entry: entry);
          },
        ),
      ],
    );
  }
}

class _LatestEntryItemWidget extends StatelessWidget {
  final Map<String, dynamic> entry;

  const _LatestEntryItemWidget({required this.entry});

  String _formatDate(String dateString) {
    try {
      final DateTime date = DateFormat("yyyy-MM-dd").parse(dateString);
      return DateFormat("MMM dd, yyyy").format(date);
    } catch (e) {
      return dateString; // Return original if parsing fails
    }
  }

  String _formatAmount(dynamic amount) {
    final num amountValue =
        amount is String ? (double.tryParse(amount) ?? 0.0) : (amount ?? 0.0);
    final format = NumberFormat.currency(
        locale: 'en_US', symbol: '\$'); // Adjust locale and symbol as needed
    return format.format(amountValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isIncome = entry['type'] == 'income';
    final Color amountColor =
        isIncome ? Colors.green.shade600 : Colors.red.shade600;
    final IconData categoryIcon =
        entry['categoryIcon'] ?? Icons.category; // Default icon
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
            width: 0.5,
          )),
      color: isDarkMode ? Colors.grey[850] : theme.cardColor,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: CircleAvatar(
          backgroundColor: amountColor.withOpacity(0.15),
          child: Icon(categoryIcon, color: amountColor, size: 22),
        ),
        title: Text(
          entry['description'] ?? 'N/A',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${entry['category'] ?? 'Uncategorized'} • ${_formatDate(entry['date'] ?? '')}',
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        trailing: Text(
          (isIncome ? '+' : '-') + _formatAmount(entry['amount'] ?? 0),
          style: theme.textTheme.titleMedium?.copyWith(
            color: amountColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          // Handle tap on entry if needed, e.g., navigate to details
        },
      ),
    );
  }
}
