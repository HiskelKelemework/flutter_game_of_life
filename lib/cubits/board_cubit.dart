import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_of_life/cubits/tile_cubit.dart';
import 'package:game_of_life/cubits/tile_state.dart';

class BoardState {}

class TilePosition {
  int row, col;
  TilePosition(this.row, this.col);
}

class NeighborStat {
  int aliveNeighbours, deadNeighbours;
  List<TilePosition>? neighbours;
  NeighborStat(this.aliveNeighbours, this.deadNeighbours, this.neighbours);
}

class BoardCubit extends Cubit<BoardState> {
  BoardCubit() : super(BoardState());

  late int _width, _height;
  late List<List<TileCubit>> _tileCubits;
  List<List<TileCubit>> get tileCubits => _tileCubits;
  late Timer _timer;
  bool computing = false;

  void initBoard({required int columns, required int rows}) {
    _width = columns;
    _height = rows;

    _tileCubits = [];

    for (final _ in List.generate(_height, (_) => _)) {
      final List<TileCubit> row = [];

      for (final _ in List.generate(_width, (_) => _)) {
        row.add(TileCubit());
      }

      _tileCubits.add(row);
    }
  }

  void forward() {
    _timer = Timer.periodic(new Duration(milliseconds: 100), (_) {
      if (!computing) nextGeneration();
    });
  }

  void pause() {
    _timer.cancel();
  }

  void nextGeneration() {
    computing = true;
    List<TilePosition> changes = [];

    for (final row in List.generate(_height, (i) => i)) {
      for (final col in List.generate(_width, (i) => i)) {
        final tileState = _tileCubits[row][col].state;
        final neighbourStat = getNeighbourStat(TilePosition(row, col));

        if (tileState is AliveTile &&
            (neighbourStat.aliveNeighbours < 2 ||
                neighbourStat.aliveNeighbours > 3)) {
          // dies
          changes.add(TilePosition(row, col));
        } else if (tileState is DeadTile &&
            (neighbourStat.aliveNeighbours == 3)) {
          // becomes a live cell
          changes.add(TilePosition(row, col));
        }
      }
    }

    // apply changes
    for (final change in changes) {
      _tileCubits[change.row][change.col].toggle();
    }
    computing = false;
  }

  NeighborStat getNeighbourStat(TilePosition pos) {
    List<TilePosition> neighbours = [];
    int aliveCount = 0, deadCount = 0;

    if (pos.row > 0) {
      neighbours.add(TilePosition(pos.row - 1, pos.col));

      if (pos.col > 0) {
        neighbours.add(TilePosition(pos.row - 1, pos.col - 1));
      }

      if (pos.col < _width - 1) {
        neighbours.add(TilePosition(pos.row - 1, pos.col + 1));
      }
    }

    if (pos.row < _height - 1) {
      neighbours.add(TilePosition(pos.row + 1, pos.col));

      if (pos.col < _width - 1) {
        neighbours.add(TilePosition(pos.row + 1, pos.col + 1));
      }

      if (pos.col > 0) {
        neighbours.add(TilePosition(pos.row + 1, pos.col - 1));
      }
    }

    if (pos.col > 0) {
      neighbours.add(TilePosition(pos.row, pos.col - 1));
    }

    if (pos.col < _width - 1) {
      neighbours.add(TilePosition(pos.row, pos.col + 1));
    }

    for (final neighbour in neighbours) {
      final tileState = _tileCubits[neighbour.row][neighbour.col].state;
      if (tileState is DeadTile) {
        deadCount++;
      } else {
        aliveCount++;
      }
    }

    return NeighborStat(aliveCount, deadCount, neighbours);
  }
}
