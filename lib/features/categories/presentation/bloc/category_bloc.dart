import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/add_category_usecase.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final AddCategoryUseCase addCategoryUseCase;
  final Uuid uuid;

  CategoryBloc({
    required this.getCategoriesUseCase,
    required this.addCategoryUseCase,
    required this.uuid,
  }) : super(CategoryInitial()) {
    on<GetCategoriesEvent>(_onGetCategories);
    on<AddCategoryEvent>(_onAddCategory);
  }

  Future<void> _onGetCategories(
    GetCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());

    final result = await getCategoriesUseCase(event.type);

    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (categories) => emit(CategoriesLoaded(categories)),
    );
  }

  Future<void> _onAddCategory(
    AddCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());

    final category = Category(
      id: uuid.v4(),
      name: event.name,
      iconName: event.iconName,
      type: event.type,
      isDefault: false,
      userId: event.userId,
    );

    final result = await addCategoryUseCase(category);

    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (addedCategory) {
        emit(CategoryAdded(addedCategory));
        add(GetCategoriesEvent(event.type)); // Tự động load lại danh sách
      },
    );
  }
}
