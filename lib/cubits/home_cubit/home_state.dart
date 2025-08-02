part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<UserModel> users; // قائمة المستخدمين اللي هنعرضهم كـ "محادثات"

  HomeSuccess({required this.users});
}

class HomeFailure extends HomeState {
  final String error;
  HomeFailure({required this.error});
}
