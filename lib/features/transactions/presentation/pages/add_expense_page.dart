import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/core/constants/route_constants.dart';
import 'package:money_mate/core/enums/category_type.dart';
import 'package:money_mate/core/enums/transaction_type.dart';
import 'package:money_mate/core/widgets/custom_app_bar.dart';
import 'package:money_mate/core/widgets/buttons/app_fill_button.dart';
import 'package:money_mate/features/categories/domain/entities/category.dart';
import 'package:money_mate/features/transactions/domain/entities/transaction.dart';
import 'package:money_mate/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:money_mate/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:money_mate/features/transactions/presentation/bloc/transaction_state.dart';
import '../widgets/category_list.dart';
import '../widgets/transaction_form_core.dart';
import 'package:money_mate/features/summary/presentation/bloc/summary_bloc.dart';
import 'package:money_mate/features/summary/presentation/bloc/summary_event.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});
  static const String routeName = RouteConstants.addExpense;

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _actualSelectedDate = DateTime.now();
  String? _selectedCategoryId;
  Category? _selectedCategory;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _handleCategorySelected(Category category) {
    setState(() {
      _selectedCategoryId = category.id;
      _selectedCategory = category;
    });
  }

  void _handleDateSelected(DateTime? date) {
    setState(() {
      _actualSelectedDate = date;
    });
  }

  void _submitExpense() {
    if (_formKey.currentState!.validate() &&
        _selectedCategory != null &&
        _actualSelectedDate != null) {
      final amount = double.parse(_amountController.text);
      final note = _titleController.text;
      final now = DateTime.now();

      final transaction = Transaction(
        id: '', // ID sẽ được tạo trong bloc
        amount: amount,
        date: _actualSelectedDate!,
        categoryId: _selectedCategory!.id,
        note: note,
        type: TransactionType.expense,
        userId: '', // Người dùng hiện tại sẽ được xử lý trong repository
        createdAt: now,
        updatedAt: now,
        includeVat: false,
        paymentMethod:
            PaymentMethod.cash, // TODO: Truyền giá trị thực tế khi có UI
      );

      context
          .read<TransactionBloc>()
          .add(AddTransactionEvent(transaction: transaction));
    } else if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn một danh mục'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (_actualSelectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn ngày'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        titleText: 'Add Expense',
        showBackButton: true,
      ),
      body: BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionOperationSuccess) {
            // Khi thêm giao dịch thành công, làm mới dữ liệu trước khi quay lại
            // Sử dụng khoảng thời gian gần đây (ví dụ: 30 ngày)
            final now = DateTime.now();
            final startDate = now.subtract(const Duration(days: 30));

            context.read<TransactionBloc>().add(
                  GetTransactionsByDateRangeEvent(
                    start: startDate,
                    end: now,
                  ),
                );

            // Làm mới dữ liệu Summary bằng cách gửi sự kiện RefreshSummaryEvent
            context.read<SummaryBloc>().add(const RefreshSummaryEvent());

            // Đợi một chút để đảm bảo sự kiện được xử lý
            Future.delayed(const Duration(milliseconds: 300), () {
              Navigator.pop(context, true);
            });
          } else if (state is TransactionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TransactionFormCore(
                isIncome: false,
                formKey: _formKey,
                initialDate: _actualSelectedDate,
                onDateSelected: _handleDateSelected,
                titleController: _titleController,
                amountController: _amountController,
                categorySection: CategoryList(
                  type: CategoryType.expense,
                  selectedCategoryId: _selectedCategoryId,
                  onCategorySelected: _handleCategorySelected,
                ),
              ),
              const SizedBox(height: 48),
              BlocBuilder<TransactionBloc, TransactionState>(
                builder: (context, state) {
                  final isLoading = state is TransactionLoading;
                  return AppFillButton(
                    text: 'Add Expense',
                    onPressed: isLoading ? () {} : _submitExpense,
                    isExpanded: true,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
