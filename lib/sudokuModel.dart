import 'dart:math';

const Index_Invalid = -1;

const Number_Invalid = 0;

// Cell cell_1 = Cell(1);
// Cell cell_2 = Cell(2);
// Cell cell_3 = Cell(3);
// Cell cell_4 = Cell(4);
// Cell cell_5 = Cell(5);
// Cell cell_6 = Cell(6);
// Cell cell_7 = Cell(7);
// Cell cell_8 = Cell(8);
// Cell cell_9 = Cell(9);

// 一个单元格，内部可以有9个候选数字
class Cell {
  Cell();

  Cell.fromNumber({int number, bool isFixed = false}) {
    this.addCandidateNumber(number);
    this.isFixed = isFixed;
  }

  // 候选数据
  List<bool> candidateNumber = List.generate(9, (index) => false);
  // 候选数据有几个
  int candidateNumberCount = 0;
  // 候选数量为1时，有个唯一值
  int number = Number_Invalid;
  // 单元格状态，
  bool isFixed = false;
  // 在数独中的坐标 0-8
  int rowInBoard = Index_Invalid;
  int colInBoard = Index_Invalid;
  // 所处九宫格的序号
  int nineBoxInBoard = Index_Invalid;

  int _countCandidateNumber() {
    int ret = 0;
    candidateNumber.forEach((element) {
      if (element) ret++;
    });
    return candidateNumberCount = ret;
  }

  void addCandidateNumber(int candidate) {
    candidateNumber[candidate - 1] = true;
    _countCandidateNumber();
    if (_countCandidateNumber() == 1)
      number = candidate;
    else
      number = Number_Invalid;
  }

  void removeCandidateNumber(int candidate) {
    candidateNumber[candidate - 1] = false;
    _countCandidateNumber();
    if (_countCandidateNumber() == 1)
      number = candidateNumber.indexOf(true) + 1;
    else
      number = Number_Invalid;
  }

  void toggleCandidateNumber(int candidate) {
    if (candidateNumber[candidate - 1]) {
      removeCandidateNumber(candidate);
    } else {
      addCandidateNumber(candidate);
    }
  }
}

// 所有数据都在这里啦
class Board {
  // 据了解，dart里一切皆对象，（可以理解为指针？）
  // 所有格子
  List<Cell> cells;
  // 所有行、列、九宫格
  List<List<Cell>> rows;
  List<List<Cell>> cols;
  List<List<Cell>> boxes;

  @override
  String toString() {
    return '';
  }

  void fromString(String str) {}

  // 初始化数据结构
  void initState() {
    rows = List(9);
    cols = List(9);
    boxes = List(9);
    for (int i = 0; i < 9; i++) {
      rows[i] = List(9);
      cols[i] = List(9);
      boxes[i] = List(9);
      for (int j = 0; j < 9; j++) {
        rows[i][j] = cells[i * 9 + j];
        rows[i][j].rowInBoard = i;
        cols[i][j] = cells[j * 9 + i];
        cols[i][j].colInBoard = i;
        boxes[i][j] = cells[(i ~/ 3) * 27 + (j ~/ 3) * 9 + (i % 3) * 3 + j % 3];
        boxes[i][j].nineBoxInBoard = i;
      }
    }
  }

  void random() {
    cells = List(9 * 9);
    for (int i = 0; i < 81; i++) {
      int rnd = Random().nextInt(10);
      cells[i] = rnd == 0
          ? Cell()
          : Cell.fromNumber(
              number: rnd, isFixed: [true, false, true][Random().nextInt(3)]);
    }
    initState();
  }
}
