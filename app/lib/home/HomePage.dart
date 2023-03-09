import 'package:flutter/material.dart';
import '../data/Game.dart';
import '../data/GamesParser.dart';
import 'GameGrid.dart';

import '../GamePage/GamePage.dart';

class HomePage extends StatelessWidget {
  List<Game> games = gamesParser();

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Color(0xFFFEFB255),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        children: [
            GameGrid(
                heading: "Playing",
                games: games,
            ),
            GameGrid(
                heading: "Backlog",
                games: games,
            ),
            GameGrid(
                heading: "Ongoing",
                games: games,
            ),
            ElevatedButton(
                child: Text("Game Page >"),
                onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GamePage()
                    ));
                },
            )
        ]
      )
    );
  }
}