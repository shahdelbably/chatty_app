import 'package:chatty/cubits/search_cubit/search_cubit.dart';
import 'package:chatty/helper/colors.dart';
import 'package:chatty/models/user_model.dart';
import 'package:chatty/widgets/search_result_user_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchViewBody extends StatefulWidget {
  const SearchViewBody({super.key});

  @override
  State<SearchViewBody> createState() => _SearchViewBodyState();
}

class _SearchViewBodyState extends State<SearchViewBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    BlocProvider.of<SearchCubit>(context).searchUsers(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    FontAwesomeIcons.arrowLeft,
                    color: greyColor,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state is SearchLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SearchSuccess) {
                if (state.users.isEmpty && _searchController.text.isEmpty) {
                  return const Center(child: Text('Type to search for users.'));
                } else if (state.users.isEmpty &&
                    _searchController.text.isNotEmpty) {
                  return const Center(
                    child: Text('No users found matching your search.'),
                  );
                }
                return ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    final UserModel user = state.users[index];
                    return SearchResultUserTile(user: user);
                  },
                );
              } else if (state is SearchFailure) {
                return Center(child: Text('Error: ${state.error}'));
              }
              return const Center(child: Text('Start typing to find users.'));
            },
          ),
        ),
      ],
    );
  }
}
