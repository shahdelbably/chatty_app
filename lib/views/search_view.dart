import 'package:chatty/cubits/search_cubit/search_cubit.dart';
import 'package:chatty/services/firestore_service.dart';
import 'package:chatty/widgets/search_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      body: BlocProvider(
        create: (context) => SearchCubit(firestoreService),
        child: SearchViewBody(),
      ),
    );
  }
}
