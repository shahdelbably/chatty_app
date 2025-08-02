part of 'search_cubit.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<UserModel> users;

  SearchSuccess({required this.users});
}

class SearchFailure extends SearchState {
  final String error;

  SearchFailure({required this.error});
}
