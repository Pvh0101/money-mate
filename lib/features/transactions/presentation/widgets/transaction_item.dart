import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/core/enums/transaction_type.dart';
import 'package:money_mate/features/transactions/domain/entities/transaction.dart'
    as entity;

class TransactionItem extends StatelessWidget {
  final entity.Transaction transaction;
  final VoidCallback? onTap;

  const TransactionItem({
    Key? key,
    required this.transaction,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon category
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getCategoryColor(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // Transaction details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.note.isEmpty
                          ? (transaction.type == TransactionType.income
                              ? 'Tiền vào'
                              : 'Chi tiêu')
                          : transaction.note,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat.Hm().format(transaction.date),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    if (transaction.includeVat)
                      Text(
                        'VAT: ${((transaction.vatRate ?? 0) * 100).toInt()}%',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              // Amount
              Text(
                currencyFormat.format(transaction.amount),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: transaction.type == TransactionType.income
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor() {
    // Màu sắc mặc định dựa trên loại giao dịch
    if (transaction.type == TransactionType.income) {
      return Colors.green.shade400;
    } else {
      return Colors.red.shade400;
    }

    // TODO: Thay thế bằng màu sắc từ danh mục khi có thông tin danh mục
  }

  IconData _getCategoryIcon() {
    // Icon mặc định dựa trên loại giao dịch
    if (transaction.type == TransactionType.income) {
      return Icons.arrow_downward;
    } else {
      return Icons.arrow_upward;
    }

    // TODO: Thay thế bằng icon từ danh mục khi có thông tin danh mục
  }
}
