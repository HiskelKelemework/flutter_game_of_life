import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_of_life/cubits/tile_cubit.dart';
import 'package:game_of_life/cubits/tile_state.dart';

class Tile extends StatelessWidget {
  final double dimension;
  final TileCubit tileCubit;

  const Tile({Key? key, required this.dimension, required this.tileCubit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TileCubit, TileState>(
      bloc: tileCubit,
      builder: (context, tileState) {
        final tileColor = tileState is DeadTile ? Colors.grey : Colors.black;

        return InkWell(
          onTap: tileCubit.toggle,
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(
              height: dimension - 2,
              width: dimension - 2,
              color: tileColor,
            ),
          ),
        );
      },
    );
  }
}
