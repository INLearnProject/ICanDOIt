import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'components/build_challenges_list.dart';

import '../controllers/challenges_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late PersistentBottomSheetController _bottomSheetController;

  String unityChallenge = "KG";
  late String nameChallenge;
  late String targetChallenge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text("ICanDOIt"),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: const ChallengesListBuilder(),
      backgroundColor: const Color(0xff414a4c),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: buildBottomSheet(),
    );
  }

  updateController(dynamic value) {
    _bottomSheetController.setState!(() {
      unityChallenge = value;
    });
  }

  FloatingActionButton buildBottomSheet() {
    return FloatingActionButton(
      backgroundColor: Colors.orange[700],
      onPressed: () {
        _bottomSheetController =
            scaffoldKey.currentState!.showBottomSheet((context) {
          return Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      onSaved: (value) {
                        nameChallenge = value!;
                      },
                      validator: (value) {
                        final RegExp checkReg = RegExp(r'^\D+$');
                        if (value!.isEmpty) {
                          return "Merci d'entrer un nom pour le challenge";
                        } else if (!checkReg.hasMatch(value)) {
                          return value;
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: "Nom du Challenge",
                      ),
                    ),
                    TextFormField(
                      onSaved: (value) {
                        targetChallenge = value!;
                      },
                      validator: (value) {
                        final isInt = int.tryParse(value!);
                        if (isInt == null) {
                          return "Merci d'entrer uniquement des chiffres pour l'objectif";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Objectif",
                      ),
                    ),
                    DropdownButtonFormField(
                        value: unityChallenge,
                        onChanged: (value) {
                          updateController(value);
                        },
                        onSaved: (value) {
                          updateController(value);
                        },
                        items: const <DropdownMenuItem>[
                          DropdownMenuItem(
                            value: "KG",
                            child: Text("Kg"),
                          ),
                          DropdownMenuItem(
                            value: "KM",
                            child: Text("Km"),
                          )
                        ]),
                    TextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();

                          Provider.of<ChallengesController>(context,
                                  listen: false)
                              .addChallenge(
                                  name: nameChallenge,
                                  target: targetChallenge,
                                  unity: unityChallenge);

                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Ajouter le Challenge"),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
      child: const Icon(Icons.add),
    );
  }
}
