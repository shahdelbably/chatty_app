import 'dart:developer';

import 'package:chatty/models/user_model.dart';
import 'package:chatty/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._firestoreService) : super(SearchInitial());
  final FirestoreService _firestoreService;
  List<UserModel> _allUsers = [];
  Future<void> _loadAllUsersForSearch() async {
    try {
      final String? currentUid = FirebaseAuth.instance.currentUser?.uid;
      if (currentUid == null) {
        emit(SearchFailure(error: "User not logged in."));
        return;
      }
      final List<Map<String, dynamic>>? usersData = await _firestoreService
          .fetchUsers(currentUid);
      if (usersData != null) {
        _allUsers = usersData.map((e) => UserModel.fromMap(e)).toList();
        log("All users loaded for search: ${_allUsers.length} users");
        // هنا مش هنعمل emit(SearchSuccess) عشان مش عايزين نعرضهم كلهم في البداية
      } else {
        _allUsers = [];
        log("No users found for search.");
      }
    } catch (e) {
      log("Error loading all users for search: $e");
      emit(SearchFailure(error: e.toString())); // ممكن نرجع حالة فشل عامة هنا
    }
  }

  void searchUsers(String query) async {
    // لو لسه مش حملنا كل المستخدمين، نحملهم الأول
    if (_allUsers.isEmpty) {
      // لازم ننتظر تحميلهم قبل ما نبحث
      await _loadAllUsersForSearch();
      // لو فيه ايرور حصل اثناء التحميل، ممكن نطلع منه
      if (state is SearchFailure) return;
    }

    if (query.isEmpty) {
      emit(SearchSuccess(users: [])); // لو مفيش بحث، اعرض قائمة فاضية
      return;
    }

    emit(SearchLoading()); // ممكن تعرض Loading state أثناء البحث

    final String lowerCaseQuery = query.toLowerCase();
    final List<UserModel> filteredUsers =
        _allUsers.where((user) {
          return user.name?.toLowerCase().contains(lowerCaseQuery) == true ||
              user.email?.toLowerCase().contains(lowerCaseQuery) == true;
        }).toList();
    emit(SearchSuccess(users: filteredUsers));
  }
}
