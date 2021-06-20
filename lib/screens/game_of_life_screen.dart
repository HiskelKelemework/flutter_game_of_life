import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_of_life/cubits/board_cubit.dart';
import 'package:game_of_life/widgets/tile.dart';

class GameOfLifeScreen extends StatefulWidget {
  const GameOfLifeScreen({Key? key}) : super(key: key);

  @override
  _GameOfLifeScreenState createState() => _GameOfLifeScreenState();
}

class _GameOfLifeScreenState extends State<GameOfLifeScreen> {
  final dimension = 20.0;
  late int rowCount, columnCount;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    rowCount = screenHeight ~/ dimension;
    columnCount = screenWidth ~/ dimension;

    final boardCubit = BlocProvider.of<BoardCubit>(context);
    boardCubit.initBoard(rows: rowCount, columns: columnCount);
    boardCubit.forward();

    return Scaffold(
      body: Column(
        children: [
          for (final i in List.generate(rowCount, (i) => i))
            Row(
              children: [
                for (final j in List.generate(columnCount, (i) => i))
                  Tile(
                    dimension: dimension,
                    tileCubit: boardCubit.tileCubits[i][j],
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
