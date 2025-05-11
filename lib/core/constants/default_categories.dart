import '../../features/categories/data/models/category_model.dart';
import '../enums/category_type.dart';

final List<CategoryModel> defaultIncomeCategories = [
  const CategoryModel(
    id: 'income_salary',
    name: 'Salary',
    iconName: 'salary',
    type: CategoryType.income,
    isDefault: true,
  ),
  CategoryModel(
    id: 'income_bonus',
    name: 'Bonus',
    iconName: 'bonus',
    type: CategoryType.income,
    isDefault: true,
  ),
  CategoryModel(
    id: 'income_business',
    name: 'Business',
    iconName: 'business',
    type: CategoryType.income,
    isDefault: true,
  ),
];

final List<CategoryModel> defaultExpenseCategories = [
  CategoryModel(
    id: 'expense_food',
    name: 'Food & Drink',
    iconName: 'food',
    type: CategoryType.expense,
    isDefault: true,
  ),
  CategoryModel(
    id: 'expense_transport',
    name: 'Transportation',
    iconName: 'transport',
    type: CategoryType.expense,
    isDefault: true,
  ),
  CategoryModel(
    id: 'expense_shopping',
    name: 'Shopping',
    iconName: 'shopping',
    type: CategoryType.expense,
    isDefault: true,
  ),
  CategoryModel(
    id: 'expense_bills',
    name: 'Bills',
    iconName: 'bills',
    type: CategoryType.expense,
    isDefault: true,
  ),
  CategoryModel(
    id: 'expense_health',
    name: 'Healthcare',
    iconName: 'health',
    type: CategoryType.expense,
    isDefault: true,
  ),
];

List<CategoryModel> getAllDefaultCategories() {
  return [...defaultIncomeCategories, ...defaultExpenseCategories];
}
