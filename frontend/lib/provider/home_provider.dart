import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:campus_times/provider/room_provider.dart';
import '../components/menu_tile.dart';
import '../models/student.dart';
import '../models/faculty.dart';

final homeProvider =
    StateNotifierProvider<UserProvider, HomeState>((ref) => UserProvider(ref));

class HomeState {
  final bool toggleSearch;
  final TextEditingController searchController;
  final List<MenuTile> menuTiles;

  HomeState({
    required this.toggleSearch,
    required this.searchController,
    required this.menuTiles,
  });

  HomeState copyWith({
    Student? student,
    Faculty? faculty,
    bool? toggleSearch,
    TextEditingController? searchController,
    List<MenuTile>? menuTiles,
  }) {
    return HomeState(
        toggleSearch: toggleSearch ?? this.toggleSearch,
        searchController: searchController ?? this.searchController,
        menuTiles: menuTiles ?? this.menuTiles);
  }
}

class UserProvider extends StateNotifier<HomeState> {
  UserProvider(Ref ref)
      : super(
          HomeState(
            searchController: TextEditingController(),
            toggleSearch: false,
            menuTiles: [],
          ),
        );

  get searchController => state.searchController;

  get toggleSearch => state.toggleSearch;

  get menuTiles => state.menuTiles;

  final Logger _logger = Logger();

  void buildMenuTiles(BuildContext context) {
    List<MenuTile> menuTiles = [
      MenuTile(
        title: 'Room\nVacancy',
        onTap: () => context.push('/user_home/room_vacancy'),
        body: [
          const SizedBox(height: 5),
          Consumer(
            builder: (_, ref, __) => Text(
              '${ref.watch(roomProvider).roomList.where((element) => element.vacant).length} Vacant',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
        icon: Icons.add,
        primaryColor: Colors.red.shade800,
        secondaryColor: Colors.redAccent.shade200,
      ),
      MenuTile(
        title: "Lost\n&\nFound",
        onTap: () => context.push('/user_home/lost_and_found'),
        primaryColor: Colors.green.shade800,
        secondaryColor: Colors.green.shade400,
        icon: Icons.search,
      ),
      MenuTile(
        title: "Timetables",
        onTap: () => context.push('/user_home/timetables'),
        primaryColor: Colors.blue.shade900,
        secondaryColor: Colors.blue.shade400,
        icon: Icons.edit,
      ),
      MenuTile(
        title: 'Broadcast',
        onTap: () => context.push('/user_home/broadcast'),
        icon: Icons.announcement,
        primaryColor: Colors.yellow.shade800,
        secondaryColor: Colors.yellow.shade400,
      ),
      MenuTile(
        title: "Chat\nRoom",
        onTap: () => context.push('/user_home/chat_room'),
        primaryColor: Colors.orange.shade800,
        secondaryColor: Colors.orange.shade400,
        icon: Icons.search,
      ),
      MenuTile(
        title: "Mess\nMenu",
        onTap: () => context.push('/user_home/mess_menu'),
        primaryColor: Colors.deepPurple.shade800,
        secondaryColor: Colors.deepPurple.shade400,
        icon: Icons.restaurant,
      ),
    ];
    String query = state.searchController.text;
    state = state.copyWith(
        menuTiles: menuTiles
            .where((element) =>
                element.title.toLowerCase().contains(query.toLowerCase()))
            .toList());
  }

  void toggleSearchBar() {
    state = state.copyWith(toggleSearch: !state.toggleSearch);
  }
}
