import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:campus_times/components/choice_selector.dart';
import 'package:campus_times/components/material_textformfield.dart';
import 'package:campus_times/components/text_divider.dart';
import 'package:campus_times/constants/constants.dart';

import '../../provider/student_provider.dart';
import '../../provider/auth_provider.dart';

class AddStudents extends ConsumerWidget {
  AddStudents({super.key});

  final _formKey = GlobalKey<FormState>();

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
          backgroundColor: Color(0xFF001219),
          title: const Text(
            "Add Students",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 30),
                  child: const Text(
                    "Spreadsheet Entry",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontFamily: "RobotoFlex"),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: ElevatedButton(
                    onPressed: () =>
                        ref.read(studentProvider.notifier).pickSpreadsheet(),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.teal.shade600),
                        minimumSize:
                            MaterialStateProperty.all(const Size(200, 60))),
                    child: Text(
                      "Upload Spreadsheet",
                      style: TextStyle(color: Colors.white.withOpacity(0.9)),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const TextDivider(text: "OR"),
                const SizedBox(height: 30),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 30),
                  child: const Text(
                    "Single Entry",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontFamily: "RobotoFlex"),
                  ),
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        MaterialTextFormField(
                          controller: ref
                              .watch(studentProvider.notifier)
                              .studentNameController,
                          validator: (value) => Validators.nameValidator(value),
                          hintText: "Enter Student Name",
                          hintColor: Colors.white.withOpacity(0.5),
                        ),
                        const SizedBox(height: 30),
                        MaterialTextFormField(
                          controller: ref
                              .read(studentProvider.notifier)
                              .studentRollNoController,
                          validator: (value) =>
                              Validators.rollNumberValidator(value),
                          hintText: "Enter Roll Number",
                          hintColor: Colors.white.withOpacity(0.5),
                        ),
                        const SizedBox(height: 30),
                        MaterialTextFormField(
                          controller: ref
                              .read(studentProvider.notifier)
                              .studentEmailController,
                          validator: (value) =>
                              Validators.emailValidator(value),
                          hintText: "Enter Student Mail",
                          hintColor: Colors.white.withOpacity(0.5),
                        ),
                        const SizedBox(height: 30),
                        ChoiceSelector(
                          onChanged: (value) => ref
                              .read(studentProvider.notifier)
                              .updateBranch(value!),
                          value: ref.watch(studentProvider).branch,
                          items: Branches.branchList,
                          hint: "Select Branch",
                        ),
                        const SizedBox(height: 30),
                        ChoiceSelector(
                          onChanged: (value) => ref
                              .read(studentProvider.notifier)
                              .updateRole(value!),
                          value: ref.watch(studentProvider).role,
                          items: StudentRoles.studentRoleList,
                          hint: "Select student role",
                        ),
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ref.read(studentProvider.notifier).addStudent();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Added Student')),
                                );
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.green.shade600),
                                minimumSize: MaterialStateProperty.all(
                                    const Size(140, 60))),
                            child: Text(
                              "Add Student",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.9)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
