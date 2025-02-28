// import 'package:equatable/equatable.dart';
//
// import '../../data/models/categories.dart';
//
// class CategoriesState extends Equatable {
//   final List<Categories> categories;
//   final Categories? selectedCategories;
//   final String? error;
//   final bool isLoading;
//
//   const CategoriesState({
//     this.selectedCategories,
//     this.error,
//     this.isLoading = false,
//     this.categories = const [],
//   });
//
//   CategoriesState copyWith({
//     List<Categories>? categories,
//     Categories? selectedCategories,
//     String? error,
//     bool? isLoading,
//   }) {
//     return CategoriesState(
//       categories: categories ?? this.categories,
//       selectedCategories: selectedCategories ?? this.selectedCategories,
//       error: error ?? this.error,
//       isLoading: isLoading ?? this.isLoading,
//     );
//   }
//
//   @override
//   List<Object?> get props => [categories, selectedCategories, error, isLoading];
// }
