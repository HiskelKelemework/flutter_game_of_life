import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_of_life/cubits/tile_state.dart';

class TileCubit extends Cubit<TileState> {
  TileCubit({bool alive = false}) : super(alive ? AliveTile() : DeadTile());

  void toggle() {
    emit(state is DeadTile ? AliveTile() : DeadTile());
  }

  void kill() {
    emit(DeadTile());
  }

  void reserect() {
    emit(AliveTile());
  }
}
