import 'package:fsudoku/model/sudokuMethod.dart';

void main() {
  List<List<int>> field = List.generate(
      9, (index) => List.generate(9, (index) => 0, growable: false),
      growable: false);
  List<List<bool>> rows =
      List.generate(9, (index) => List.generate(9, (index) => false));
  List<List<bool>> cols =
      List.generate(9, (index) => List.generate(9, (index) => false));
  List<List<bool>> blocks =
      List.generate(9, (index) => List.generate(9, (index) => false));

  bool ret = false;

  while (!ret) {
    clearFRCB(field, rows, cols, blocks);
    ret = lasVegas(field, rows, cols, blocks, 11);
  }

  digSudoku(field, rows, cols, blocks, 30);

  for (int i = 0; i < 9; i++) {
    print("${field[i]} ");
  }
}
