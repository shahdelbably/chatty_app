import 'package:chatty/cubits/home_cubit/home_cubit.dart';
import 'package:chatty/helper/asset_data.dart';
import 'package:chatty/helper/colors.dart';
import 'package:chatty/services/chat_service.dart';
import 'package:chatty/services/firestore_service.dart';
import 'package:chatty/views/search_view.dart';
import 'package:chatty/widgets/home_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();
    final ChatService chatService = ChatService();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leadingWidth: 150,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 8),
            Image.asset(AssetData.whiteLogo, width: 45),
            const SizedBox(width: 8),
            Text(
              'Chatty',
              style: GoogleFonts.pacifico(
                color: whiteColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.magnifyingGlass,
              color: whiteColor,
              size: 20,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SearchView();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => HomeCubit(firestoreService, chatService),
        child: HomeViewBody(),
      ),
    );
  }
}
