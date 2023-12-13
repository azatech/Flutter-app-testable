// part of 'filter_kind_cubit.dart';
//
// enum FilterKind {
//   all,
//   completed,
//   incomplete,
// }
//
// sealed class FilterKindState {
//   final FilterKind filter;
//
//   const FilterKindState({
//     required this.filter,
//   });
//
//   bool get isFilteredByAll => filter == FilterKind.all;
//
//   bool get isFilteredByCompleted => filter == FilterKind.completed;
//
//   bool get isFilteredByIncomplete => filter == FilterKind.incomplete;
// }
//
// class FilterKindInitial extends FilterKindState {
//   FilterKindInitial({
//     super.filter = FilterKind.all,
//   });
// }
//
// class FilterKindUpdatedState extends FilterKindState {
//   FilterKindUpdatedState({
//     required super.filter,
//   });
// }
