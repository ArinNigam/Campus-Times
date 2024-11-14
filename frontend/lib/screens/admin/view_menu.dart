import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:slide_switcher/slide_switcher.dart';
import 'package:campus_times/components/choice_selector.dart';
import 'package:campus_times/components/material_textformfield.dart';
import 'package:campus_times/models/mess_menu.dart';
import 'package:campus_times/provider/menu_provider.dart';
import '../../constants/constants.dart';
import '../../provider/auth_provider.dart';

class ViewMessMenu extends ConsumerWidget {
  const ViewMessMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(authProvider.notifier).tokenCheckProgress !=
          LoadingState.progress) {
        ref.read(authProvider.notifier).verifyAuthTokenExistence(
            context, AuthConstants.adminAuthLabel.toLowerCase());
      }
    });

    return ResponsiveScaledBox(
      width: 411,
      child: Scaffold(
        backgroundColor: Color(0xFF001219),
        appBar: AppBar(
          title: const Text('Mess Menu'),
        ),
        body: SingleChildScrollView(
          child: Consumer(
            builder: (_, ref, __) {
              if (ref.watch(menuProvider).loadingState ==
                  LoadingState.progress) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  children: [
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ChoiceSelector(
                        onChanged: (value) {
                          ref
                              .read(menuProvider.notifier)
                              .setSelectViewMenu(value);
                        },
                        value: ref.read(menuProvider).selectedViewMenu,
                        items: [
                          for (String i
                              in ref.read(menuProvider).messMenus.keys)
                            DropdownMenuItem<String>(
                              value: i,
                              child: Text(i,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: "GoogleSanaFlex")),
                            ),
                        ],
                        hint: 'Select Kitchen',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 30),
                      child: Expanded(
                        child: Row(
                          children: [
                            Expanded(child: Container()),
                            SlideSwitcher(
                              onSelect: (index) => ref
                                  .read(menuProvider.notifier)
                                  .selectMealType(index),
                              containerHeight: 65,
                              containerWight: 300,
                              containerBorderRadius: 20,
                              slidersColors: [
                                Colors.blue.shade700.withOpacity(0.7)
                              ],
                              containerColor: Colors.yellow.shade100,
                              children: MessMenuConstants.mealTypes,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: SlideSwitcher(
                              onSelect: (index) => ref
                                  .read(menuProvider.notifier)
                                  .selectWeekday(index),
                              containerHeight: 550,
                              containerWight: 70,
                              containerBorderRadius: 20,
                              direction: Axis.vertical,
                              slidersColors: [
                                Colors.blue.shade700.withOpacity(0.7)
                              ],
                              containerColor: Colors.yellow.shade100,
                              children: MessMenuConstants.weekdays,
                            ),
                          ),
                          Container(
                            height: 550,
                            width: 285,
                            margin: const EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.transparent, width: 0),
                              color: Color(0xFF04192),
                            ),
                            child: Column(
                              children: [
                                Consumer(
                                  builder: (_, ref, __) {
                                    final menuState = ref.watch(menuProvider);
                                    final weekDay = ref
                                        .watch(menuProvider.notifier)
                                        .getWeekDay(
                                            menuState.selectedWeekdayIndex);
                                    final mealType = ref
                                        .watch(menuProvider.notifier)
                                        .getMealType(
                                            menuState.selectedMealTypeIndex);
                                    return Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 15),
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "$weekDay's $mealType",
                                            style: const TextStyle(
                                                fontSize: 23,
                                                fontFamily: "GoogleSanaFlex"),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                Consumer(
                                  builder: (context, ref, child) {
                                    final menuState = ref.watch(menuProvider);
                                    final weekDay = ref
                                        .watch(menuProvider.notifier)
                                        .getWeekDay(
                                            menuState.selectedWeekdayIndex);
                                    final mealType = ref
                                        .watch(menuProvider.notifier)
                                        .getMealType(
                                            menuState.selectedMealTypeIndex);
                                    if (menuState.selectedViewMenu != null) {
                                      MessMenu? selectedMenu =
                                          menuState.messMenus[
                                              menuState.selectedViewMenu];
                                      int length = selectedMenu
                                              ?.messMenu?[weekDay]?[mealType]
                                              ?.length ??
                                          0;
                                      List controllers = List.generate(length,
                                          (index) => TextEditingController());
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: length,
                                        itemBuilder: (context, index) {
                                          controllers[index].text =
                                              selectedMenu?.messMenu?[weekDay]
                                                      ?[mealType]?[index] ??
                                                  '';
                                          return length != 0
                                              ? Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red.shade600,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    border: Border.all(
                                                        color:
                                                            Colors.transparent,
                                                        width: 0),
                                                  ),
                                                  child: MaterialTextFormField(
                                                    enabled: ref
                                                            .watch(authProvider)
                                                            .currentUserRole ==
                                                        AuthConstants
                                                            .adminAuthLabel
                                                            .toLowerCase(),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 20,
                                                            vertical: 10),
                                                    controller:
                                                        controllers[index],
                                                    hintText:
                                                        'Item ${index + 1}',
                                                    onChanged: (value) =>
                                                        selectedMenu?.messMenu?[
                                                                    weekDay]
                                                                ?[mealType]
                                                            ?[index] = value,
                                                  ),
                                                )
                                              : const Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      'No items today',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                );
                                        },
                                      );
                                    } else {
                                      return const Expanded(
                                        child: Center(
                                          child: Text(
                                            'No menu selected',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          const SizedBox(height: 30),
                          GestureDetector(
                            onTap: () =>
                                ref.read(menuProvider.notifier).deleteMenu(),
                            child: Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.redAccent.withOpacity(0.5),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () =>
                                ref.read(menuProvider.notifier).resetMenu(),
                            child: Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.greenAccent.withOpacity(0.5),
                              ),
                              child: const Icon(
                                Icons.refresh,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () =>
                                ref.read(menuProvider.notifier).updateMenu(),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.green.shade600),
                                minimumSize: MaterialStateProperty.all(
                                    const Size(140, 60))),
                            child: const Text("Update Menu",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "GoogleSanaFlex")),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
