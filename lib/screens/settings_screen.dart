// ignore_for_file: use_build_context_synchronously

import 'package:accomplishr_mobile_app/resources/auth_methods.dart';
import 'package:accomplishr_mobile_app/resources/firestore_methods.dart';
import 'package:accomplishr_mobile_app/screens/change_username_screen.dart';
import 'package:accomplishr_mobile_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

import '../utils/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Account",
                          style: GoogleFonts.workSans(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),

                //CHANGE USERNAME
                ListTile(
                  tileColor: Colors.black,
                  leading: const Icon(Icons.person),
                  title: const Text("Change Username"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return const ChangeUsernameScreen();
                      },
                    ));
                  },
                ),

                //SIGN OUT
                ListTile(
                    tileColor: Colors.black,
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text("Sign Out"),
                    onTap: () async {
                      Dialogs.bottomMaterialDialog(
                          msgStyle: GoogleFonts.workSans(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                          titleStyle: GoogleFonts.workSans(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 18),
                          msg: 'Are you sure? You can\'t undo this',
                          title: "Sign Out",
                          color: Colors.white,
                          context: context,
                          actions: [
                            IconsOutlineButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              text: 'Cancel',
                              iconData: Icons.cancel_outlined,
                              color: grayColor,
                              textStyle: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                              iconColor: Colors.black,
                            ),
                            IconsButton(
                              onPressed: () async {
                                String res = await AuthMethods().signOutUser();
                                if (res == 'success') {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                }
                              },
                              text: 'Sign Out',
                              iconData: Icons.exit_to_app,
                              color: Colors.red,
                              textStyle: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                              iconColor: Colors.white,
                            ),
                          ]);
                    }),

                //DELETE ACCOUNT
                ListTile(
                  tileColor: Colors.black,
                  leading: const Icon(Icons.delete_forever),
                  title: const Text("Delete Account"),
                  onTap: () async {
                    Dialogs.bottomMaterialDialog(
                        msgStyle: GoogleFonts.workSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                        titleStyle: GoogleFonts.workSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 18),
                        msg: 'Are you sure? You can\'t undo this',
                        title: "Delete Account",
                        color: Colors.white,
                        context: context,
                        actions: [
                          IconsOutlineButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            text: 'Cancel',
                            iconData: Icons.cancel_outlined,
                            color: grayColor,
                            textStyle: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                            iconColor: Colors.black,
                          ),
                          IconsButton(
                            onPressed: () async {
                              String res =
                                  await AuthMethods().deleteUser(context);

                              if (res == 'success') {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              }
                            },
                            text: 'Delete Account',
                            iconData: Icons.delete_forever,
                            color: Colors.red,
                            textStyle: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                            iconColor: Colors.white,
                          ),
                        ]);
                  },
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Security",
                          style: GoogleFonts.workSans(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),

                //CHANGE PASSWORD
                ListTile(
                  tileColor: Colors.black,
                  leading: const Icon(Icons.password),
                  title: const Text("Change Password"),
                  onTap: () async {
                    String res = await AuthMethods().changePassword(
                        FirebaseAuth.instance.currentUser!.email as String);
                    if (res == 'success') {
                      showSnackBar(
                          'We have sent you an email at ${FirebaseAuth.instance.currentUser?.email}',
                          context);
                    }
                  },
                ),

                //CLEAR HISTORY
                ListTile(
                  tileColor: Colors.black,
                  leading: const Icon(Icons.clear),
                  title: const Text("Clear History"),
                  onTap: () async {
                    Dialogs.bottomMaterialDialog(
                        msgStyle: GoogleFonts.workSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                        titleStyle: GoogleFonts.workSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 18),
                        msg: 'Are you sure? You can\'t undo this',
                        title: "Clear Hisory",
                        color: Colors.white,
                        context: context,
                        actions: [
                          IconsOutlineButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            text: 'Cancel',
                            iconData: Icons.cancel_outlined,
                            color: grayColor,
                            textStyle: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                            iconColor: Colors.black,
                          ),
                          IconsButton(
                            onPressed: () async {
                              await FirestoreMethods().clearHistory(context);
                            },
                            text: 'Clear History',
                            iconData: Icons.delete_forever,
                            color: Colors.red,
                            textStyle: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                            iconColor: Colors.white,
                          ),
                        ]);
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
