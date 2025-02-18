import 'package:flutter/material.dart';
// import 'package:tictactoe_tutorial/ui/theme/color.dart';
import 'package:tictactoe_tutorial/utils/game_logic.dart';
// import 'dart:ui';

// import 'package:tictactoe_tutorial/utils/game_logic.dart';
// import 'dart:ui';
// import 'ui/theme/color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  //adding the necessary variables
  String lastValue = "X";
  bool gameOver = false;
  int turn = 0; // to check the draw
  String result = "";
  List<int> scoreboard = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ]; //the score are for the different combination of the game [Row1,2,3, Col1,2,3, Diagonal1,2];
  //let's declare a new Game components

  Game game = Game();

  //let's initi the GameBoard
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    game.board = Game.initGameBoard();
    print(game.board);
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      // MainColor.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(
            flex: 2,
          ),
          Text(
            " $lastValue   turn".toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 58,
            ),
          ),
          const Spacer(),
          //now we will make the game board
          //but first we will create a Game class that will contains all the data and method that we will need
          SizedBox(
            width: boardWidth,
            height: boardWidth,
            child: GridView.count(
              crossAxisCount: Game.boardlenth ~/ 3, // the ~/ operator allows you to evide to integer and return an Int as a result
              padding: const EdgeInsets.all(16.0),
              mainAxisSpacing:  6.0,
              crossAxisSpacing: 6.0,
              children: List.generate(
                Game.boardlenth,
                (index) {
                  return GestureDetector(
                    onTap: gameOver
                        ? null
                        : () {
                            //when we click we need to add the new value to the board and refrech the screen
                            //we need also to toggle the player
                            //now we need to apply the click only if the field is empty
                            //now let's create a button to repeat the game

                            if (game.board![index] == "") {
                              setState(() {
                                game.board![index] = lastValue;
                                turn++;
                                gameOver = game.winnerCheck(
                                    lastValue, index, scoreboard, 3);

                                if (gameOver) {
                                  result = "$lastValue Winner";
                                } else if (!gameOver && turn == 9) {
                                  result = "It's a Draw!";
                                  gameOver = true;
                                }
                                if (lastValue == "X") {
                                  lastValue = "O";
                                } else {
                                  lastValue = "X";
                                }
                              });
                            }
                          },
                    child: Container(
                      width: Game.blocSize,
                      height: Game.blocSize,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        //  MainColor.secondaryColor,
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: Center(
                        child: Text(
                          game.board![index],
                          style: TextStyle(
                            color: game.board![index] == "X"
                                ? Colors.blue
                                : Colors.red,
                            fontSize: 85.0,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Spacer(),
          Text(
          result,
          style: const TextStyle(color: Colors.white, fontSize: 50.0),
          ),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                //erase the board
                game.board = Game.initGameBoard();
                lastValue = "X";
                gameOver = false;
                turn = 0;
                result = "";
                scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
              });
            },
            icon: const Icon(Icons.replay),
            label: const Text("Repeat the Game"),
          ),
          const Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }
}
