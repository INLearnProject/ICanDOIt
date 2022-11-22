import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../models/challenge_model.dart';
import '../../controllers/challenges_controller.dart';

class ChallengesListBuilder extends StatelessWidget {
  final String unityPattern = "UnityChallenge.";

  const ChallengesListBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    List<ChallengeModel> challengesList =
        Provider.of<ChallengesController>(context).getChallenges();
    final ChallengesController provider =
        Provider.of<ChallengesController>(context);

    if (challengesList.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          "Aucun challenge en cours pourtant tu peux le faire !",
          style: TextStyle(
            color: Colors.orange[600],
            fontSize: 18.0,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      itemCount: challengesList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 3.0, left: 8.0, right: 8.0),
          child: Dismissible(
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                ScaffoldMessenger.of(context).showSnackBar(_buildSnackBar(
                    content:
                        "Le challenge ${challengesList[index].name} a bien été validé"));
                provider.remove(index: index);
              }
              if (direction == DismissDirection.startToEnd) {
                ScaffoldMessenger.of(context).showSnackBar(
                  _buildSnackBar(
                    content:
                        "Le challenge ${challengesList[index].name} a bien été supprimé",
                  ),
                );
                provider.remove(index: index);
              }
            },
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                final bool? resultat = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          "Confirmation",
                          style: TextStyle(color: Colors.blue),
                        ),
                        content: const Text(
                            "Êtes-vous sûr de vouloir supprimer le challenge ?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text("Oui"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: const Text("Non"),
                          )
                        ],
                      );
                    });
                return resultat;
              }
              return true;
            },
            background: Container(
              color: Colors.red,
              padding: const EdgeInsets.only(right: 10.0),
              alignment: Alignment.centerLeft,
              child: const Icon(
                Icons.delete,
                size: 50.0,
                color: Colors.white,
              ),
            ),
            secondaryBackground: Container(
              padding: const EdgeInsets.only(right: 10.0),
              alignment: Alignment.centerRight,
              color: Colors.green,
              child: const Icon(
                Icons.check,
                size: 50.0,
                color: Colors.white,
              ),
            ),
            key: Key(UniqueKey().toString()),
            child: Container(
              color: Colors.white,
              child: ListTile(
                title: Text(challengesList[index].name),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      const Text(
                        "Objectif :",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(width: 5.0),
                      Text(challengesList[index].target.toString()),
                      const SizedBox(width: 5.0),
                      Text(challengesList[index]
                          .unity
                          .toString()
                          .replaceAll(unityPattern, "")
                          .toUpperCase()),
                    ],
                  ),
                ),
                isThreeLine: true,
              ),
            ),
          ),
        );
      },
    );
  }

  SnackBar _buildSnackBar({required String content}) {
    return SnackBar(
      content: Text(
        content,
        textAlign: TextAlign.center,
      ),
    );
  }
}
