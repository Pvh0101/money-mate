import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../widgets/time_range_selector.dart';
import '../bloc/summary_bloc.dart';
import '../bloc/summary_event.dart';
import '../bloc/summary_state.dart';
import '../../domain/entities/time_range.dart';
import '../../../../core/enums/transaction_type.dart';
import '../../../../core/di/service_locator.dart';
import '../../../transactions/presentation/bloc/transaction_bloc.dart';
import '../../../transactions/presentation/bloc/transaction_state.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // Sử dụng tháng hiện tại
        final now = DateTime.now();
        final firstDay = DateTime(now.year, now.month, 1);
        final lastDay = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

        final bloc = sl<SummaryBloc>();
        bloc.add(GetSummaryByDateRangeEvent(
          startDate: firstDay,
          endDate: lastDay,
        ));
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Financial Summary'),
          elevation: 0,
        ),
        body: const SummaryContent(),
      ),
    );
  }
}

class SummaryContent extends StatefulWidget {
  const SummaryContent({Key? key}) : super(key: key);

  @override
  State<SummaryContent> createState() => _SummaryContentState();
}

class _SummaryContentState extends State<SummaryContent> {
  @override
  void initState() {
    super.initState();

    // Tự động làm mới dữ liệu sau khi widget được xây dựng
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Đảm bảo dữ liệu được làm mới khi widget vừa hiển thị
      context.read<SummaryBloc>().add(const RefreshSummaryEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sử dụng BlocConsumer cho TransactionBloc
    return BlocConsumer<TransactionBloc, TransactionState>(
      // listener phản hồi các sự kiện nhưng không rebuild UI
      listener: (context, transactionState) {
        // Khi có thao tác thành công trên giao dịch, làm mới dữ liệu summary
        if (transactionState is TransactionOperationSuccess) {
          debugPrint(
              'SummaryPage: Transaction state changed, refreshing summary data');
          context.read<SummaryBloc>().add(const RefreshSummaryEvent());

          // Hiển thị thông báo (tùy chọn)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đang cập nhật thống kê...'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      },
      // builder xây dựng UI dựa trên trạng thái transaction hiện tại
      builder: (context, transactionState) {
        // Render UI dựa vào SummaryBloc, không phụ thuộc vào transactionState
        return BlocBuilder<SummaryBloc, SummaryState>(
          builder: (context, state) {
            // Sử dụng logic xây dựng UI trực tiếp ở đây thay vì gọi SummaryPageContent
            if (state is SummaryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SummaryError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}',
                        style: const TextStyle(color: Colors.red)),
                    ElevatedButton(
                      onPressed: () {
                        final now = DateTime.now();
                        context
                            .read<SummaryBloc>()
                            .add(GetSummaryByDateRangeEvent(
                              startDate: DateTime(now.year, now.month, 1),
                              endDate: DateTime(now.year, now.month + 1, 0),
                            ));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is SummaryLoaded) {
              final summaryData = state.summaryData;
              final currencyFormatter = NumberFormat.currency(
                locale: 'en_US',
                symbol: '\$',
                decimalDigits: 2,
              );

              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Thanh lựa chọn khoảng thời gian
                  TimeRangeSelector(
                    selectedTimeRange: state.currentTimeRange,
                    onTimeRangeSelected: (timeRange) {
                      context
                          .read<SummaryBloc>()
                          .add(ChangeTimeRangeEvent(timeRange: timeRange));
                    },
                  ),

                  // Thông tin khoảng thời gian
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            '${DateFormat('MM/dd/yyyy').format(summaryData.startDate)} - ${DateFormat('MM/dd/yyyy').format(summaryData.endDate)}',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // Nút làm mới dữ liệu với menu dropdown
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.refresh),
                          tooltip: 'Làm mới và tùy chọn khác',
                          itemBuilder: (context) => [
                            const PopupMenuItem<String>(
                              value: 'refresh',
                              child: Text('Làm mới dữ liệu'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'clear_cache',
                              child: Text('Xóa cache & làm mới'),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'refresh') {
                              // Gửi sự kiện làm mới dữ liệu
                              context
                                  .read<SummaryBloc>()
                                  .add(const RefreshSummaryEvent());

                              // Hiển thị thông báo
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Đang làm mới dữ liệu...'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            } else if (value == 'clear_cache') {
                              // Gửi sự kiện xóa cache và làm mới
                              context
                                  .read<SummaryBloc>()
                                  .add(const ClearSummaryCacheEvent());

                              // Hiển thị thông báo
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Đang xóa cache và tính toán lại...'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  // Thẻ tổng quan
                  Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(top: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text('Overview',
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 16),

                          // Thu nhập
                          _buildStatRow(
                              context,
                              'Income',
                              currencyFormatter.format(summaryData.totalIncome),
                              Colors.green,
                              Icons.arrow_upward),
                          const Divider(height: 24),

                          // Chi tiêu
                          _buildStatRow(
                              context,
                              'Expenses',
                              currencyFormatter
                                  .format(summaryData.totalExpense),
                              Colors.red,
                              Icons.arrow_downward),
                          const Divider(height: 24),

                          // Số dư
                          _buildStatRow(
                              context,
                              'Balance',
                              currencyFormatter.format(summaryData.balance),
                              summaryData.balance >= 0
                                  ? Colors.blue
                                  : Colors.orange,
                              summaryData.balance >= 0
                                  ? Icons.savings
                                  : Icons.money_off),
                        ],
                      ),
                    ),
                  ),

                  // Phân phối chi tiêu theo danh mục
                  if (summaryData.expenseByCategory.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildCategoryDistribution(
                        context,
                        'Expense Distribution',
                        summaryData.expenseByCategory,
                        currencyFormatter,
                        Colors.red.shade100),
                  ],

                  // Phân phối thu nhập theo danh mục
                  if (summaryData.incomeByCategory.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildCategoryDistribution(
                        context,
                        'Income Distribution',
                        summaryData.incomeByCategory,
                        currencyFormatter,
                        Colors.green.shade100),
                  ],
                ],
              );
            }

            return const Center(
                child: Text('Select a time range to view summary'));
          },
        );
      },
    );
  }

  Widget _buildStatRow(BuildContext context, String title, String value,
      Color color, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 16),
        Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDistribution(BuildContext context, String title,
      Map<String, double> data, NumberFormat formatter, Color backgroundColor) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...data.entries
                .map((entry) => _buildCategoryItem(
                    context,
                    entry.key,
                    entry.value,
                    formatter,
                    backgroundColor,
                    data.values.reduce((a, b) => a + b)))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(
      BuildContext context,
      String categoryId,
      double amount,
      NumberFormat formatter,
      Color backgroundColor,
      double total) {
    final percentage =
        total > 0 ? (amount / total * 100).toStringAsFixed(1) : '0.0';

    // Format categoryId để có tên hiển thị đẹp hơn
    String displayName = categoryId.replaceAll('_', ' ');
    if (displayName.startsWith('expense ')) {
      displayName = displayName.replaceFirst('expense ', '');
    } else if (displayName.startsWith('income ')) {
      displayName = displayName.replaceFirst('income ', '');
    }
    // Viết hoa chữ cái đầu tiên
    displayName = displayName
        .split(' ')
        .map((word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  displayName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8), // Đảm bảo khoảng cách tối thiểu
              Text('${formatter.format(amount)} ($percentage%)'),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: total > 0 ? amount / total : 0,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(backgroundColor),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}
