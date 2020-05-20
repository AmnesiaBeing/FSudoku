import 'dart:isolate';
import 'dart:math';

import 'package:flutter/foundation.dart';

// 这俩是用于防止愚蠢的错误
const Index_Invalid = -1;
const Number_Invalid = 0;

// 难度级别，这里只是代表题目出来后，有多少个数字
const Difficult_Easy = 32;
const Difficult_Hard = 25;
const Difficult_VeryHard = 19;
const Difficult_VeryVeryHard = 16;
const Difficult_Default = Difficult_VeryVeryHard;

// 一个单元格，内部可以有9个候选数字
class SudokuCellViewModel extends ChangeNotifier {
  // 不会起名
  SudokuCellViewModel.fromWhat(SudokuBoardViewModel parent,
      {bool isFixed = false}) {
    this.isFixed = isFixed;
    this.board = parent;
  }

  SudokuCellViewModel.fromNumber(SudokuBoardViewModel parent, int number,
      {bool isFixed = true}) {
    this.isFixed = isFixed;
    this.board = parent;
  }

  // 候选数据
  List<bool> candidateNumbers =
      List.generate(9, (index) => false, growable: false);
  // 0,1-9
  int _number;
  dynamic get number {
    if (isFixed)
      return _number;
    else {
      List<int> ret = _countCandidateNumbers();
      // TODO:追加设置，候选数字不自动成为填写的数字
      if (ret.length == 1) return _number;
      return ret;
    }
  }

  List<int> _countCandidateNumbers() {
    List<int> ret = List();
    for (int i = 0; i < 9; i++) {
      if (candidateNumbers[i]) {
        ret.add(i + 1);
      }
    }
    return ret;
  }

  // 增加一个候选数字，n的范围0-8
  void addCandidateNumber(int n) {
    if (isFixed)
      return;
    else {
      candidateNumbers[n - 1] = true;
      List<int> tmp = _countCandidateNumbers();
      if (tmp.length == 1) {
        // TODO:追加设置，候选数字不自动成为填写的数字
        _number = n;
      }
      // TODO:记录操作
    }
  }

  // 减少一个候选数字，n的范围0-8
  void removeCandidateNumber(int n) {
    if (isFixed)
      return;
    else {
      candidateNumbers[n - 1] = false;
      List<int> tmp = _countCandidateNumbers();
      if (tmp.length == 1) {
        // TODO:追加设置，候选数字不自动成为填写的数字
        _number = tmp[0];
      }
      // TODO:记录操作
    }
  }

  // 单元格是否是已知数
  bool isFixed;
  // 在数独中的坐标 0-8
  int rowInBoard = Index_Invalid;
  int colInBoard = Index_Invalid;
  // 所处九宫格的序号
  int blockInBoard = Index_Invalid;

  SudokuBoardViewModel board;

  void handleOnTap() {}

  void handleOnHover() {}
}

// 所有数据都在这里啦
class SudokuBoardViewModel extends ChangeNotifier {
  // 据了解，dart里一切皆对象，（可以理解为指针？）
  // 所有格子
  List<SudokuCellViewModel> cells;
  // 原始数据
  List<int> raw;
  List<int> rawWithAnswer;
  // 用于存档功能
  List<int> cellsBakup;
  // 所有行、列、九宫格，便于引用与检查
  List<List<SudokuCellViewModel>> rows;
  List<List<SudokuCellViewModel>> cols;
  List<List<SudokuCellViewModel>> boxes;

  // 构造函数
  SudokuBoardViewModel() {
    cells = List.generate(9 * 9, (_) => SudokuCellViewModel.fromWhat(this),
        growable: false);

    // 方便UI处理
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
        boxes[i][j].blockInBoard = i;
      }
    }
    // 生成数独的线程
    // TODO:后台生成一定数量的数独题目，比如最多10个，下一个题目可以随时读取

    // FOR TEST ONLY
    cells.forEach((element) {
      // element.isFixed = false;
      element.addCandidateNumber(Random().nextInt(9) + 1);
      // element.addCandidateNumber(Random().nextInt(9) + 1);
      element.isFixed = Random().nextBool();
    });
  }

  // 依次生成数独题目的字符串，0表示
  @override
  String toString() {
    StringBuffer sb = StringBuffer();
    for (int i = 0; i < 81; i++) {
      sb.write(raw[i]);
    }
    return sb.toString();
  }

  // 生成比较好看的形式，includeAnswer:是否包含答案？
  String toStringEx(bool includeAnswer) {
    StringBuffer sb = StringBuffer();
    sb.writeln('-------------------');
    for (int i = 0; i < 9; i++) {
      sb.write('|');
      for (int j = 0; j < 9; j++) {
        // 当格子上的数字是固定的，输出
        // 如果需要输出自己填写的数字，得判断一下是否唯一，然后输出
        // 否则输出0
        if (includeAnswer) {
          sb.write(rawWithAnswer[i * 9 + j]);
        } else {
          sb.write(raw[i * 9 + j]);
        }
        sb.write('|');
      }
      sb.writeln();
    }
    sb.writeln('-------------------');
    return sb.toString();
  }

  // 深拷贝列表内容，因为如果改变了cells的指向的话，rows、cols、blocks这仨会出问题的
  void copyCells(List<SudokuCellViewModel> src, List<SudokuCellViewModel> dst) {
    for (int i = 0; i < 81; i++) {
      dst[i].isFixed = src[i].isFixed;
      dst[i].rowInBoard = src[i].rowInBoard;
      dst[i].colInBoard = src[i].colInBoard;
      dst[i].blockInBoard = src[i].blockInBoard;
      // ?
      dst[i].candidateNumbers = src[i].candidateNumbers;
    }
  }

  // 假定是标准形式，一溜的字符串，长度为81
  // true转换成功，false转换失败
  bool fromString(String str) {
    if (str.length != 81) return false;

    List<SudokuCellViewModel> newCells = List(81);
    for (int i = 0; i < 81; i++) {
      try {
        newCells[i] =
            SudokuCellViewModel.fromNumber(this, int.tryParse(str[i]));
      } catch (e) {
        return false;
      }
    }
    return true;
  }

  // 生成一个新题的接口，level代表有多少个已知数
  Future<dynamic> newModel(int level) {
// return compute((){},);

    // List<List<int>> field = List.filled(
    //     9, List.filled(9, Number_Invalid, growable: false),
    //     growable: false);
    // List<List<bool>> rows =
    //     List.filled(9, List.filled(9, false, growable: false), growable: false);
    // List<List<bool>> cols =
    //     List.filled(9, List.filled(9, false, growable: false), growable: false);
    // List<List<bool>> blocks =
    //     List.filled(9, List.filled(9, false, growable: false), growable: false);

    // bool ret = false;

    // while (!ret) {
    //   clearFRCB(field, rows, cols, blocks);
    //   ret = lasVegas(field, rows, cols, blocks, 11);
    // }

    // digSudoku(field, rows, cols, blocks, level);

    // for (int i = 0; i < 9; i++) {
    //   for (int j = 0; j < 9; j++) {
    //     int v = field[i][j];
    //     cells[i * 9 + j] =
    //         v == 0 ? Cell() : Cell.fromNumber(number: v, isFixed: true);
    //   }
    // }

    // initState();
  }

  // void computeCandidateNumber() {}
}

class SudokuModel {
// 网上抄的生成/解数独的代码

// 这个函数用剪枝法解一个数独矩阵field，（0为空，1-9表示所填数字），
// rows、cols、blocks表示第i行、列、宫已经有数字j填入了（用于判断是否重复）
  bool dfs(List<List<int>> field, List<List<bool>> rows, List<List<bool>> cols,
      List<List<bool>> blocks) {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (field[i][j] == 0) {
          int k = i ~/ 3 * 3 + j ~/ 3;
          for (int n = 0; n < 9; n++) {
            if (!rows[i][n] && !cols[j][n] && !blocks[k][n]) {
              rows[i][n] = true;
              cols[j][n] = true;
              blocks[k][n] = true;
              field[i][j] = n + 1;
              if (dfs(field, rows, cols, blocks)) return true;
              rows[i][n] = false;
              cols[j][n] = false;
              blocks[k][n] = false;
              field[i][j] = 0;
            }
          }
          return false;
        }
      }
    }
    return true;
  }

// 用拉斯维加斯算法生成数独，向空矩阵中随机填写n个数字（一般是11）
// 然后用剪枝法解这个数独（据说有99%的概率可以解出来）
// TODO：用剪枝法解数独时，左上角第一个数字可能每次都是1？
  bool lasVegas(List<List<int>> field, List<List<bool>> rows,
      List<List<bool>> cols, List<List<bool>> blocks, int n) {
    Random rnd = Random();
    while (n > 0) {
      int i = rnd.nextInt(9);
      int j = rnd.nextInt(9);
      if (field[i][j] == 0) {
        int k = i ~/ 3 * 3 + j ~/ 3;
        int v = rnd.nextInt(9);
        if (!rows[i][v] && !cols[j][v] && !blocks[k][v]) {
          field[i][j] = v + 1;
          rows[i][v] = true;
          cols[j][v] = true;
          blocks[k][v] = true;
          n--;
        }
      }
    }

    return dfs(field, rows, cols, blocks);
  }

// 挖洞生成数独，level表示挖洞的数目
// TODO：这个地方需要改进，应该使用随机保留方法
  void digSudoku(List<List<int>> field, List<List<bool>> rows,
      List<List<bool>> cols, List<List<bool>> blocks, int level) {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (checkUnique(field, rows, cols, blocks, i, j)) {
          int k = i ~/ 3 * 3 + j ~/ 3;
          rows[i][field[i][j] - 1] = false;
          cols[j][field[i][j] - 1] = false;
          blocks[k][field[i][j] - 1] = false;
          field[i][j] = 0;
          level++;
          if (level >= 81) break;
        }
      }
    }
  }

// [i,j]这个位置已经有一个数字了
// 将[i,j]这个位置依次填写1-9除原数字,然后解数独，判断是否有两个以上的解
// 如果无解，即只有唯一解，返回true
// 如果有解，即至少有两个解，返回false
  bool checkUnique(List<List<int>> field, List<List<bool>> rows,
      List<List<bool>> cols, List<List<bool>> blocks, int i, int j) {
    int k = i ~/ 3 * 3 + j ~/ 3;
    List<List<int>> tmpField = List.generate(
        9, (i) => List.generate(9, (index) => field[i][j], growable: false),
        growable: false);
    List<List<bool>> tmpRows = List.generate(
        9, (i) => List.generate(9, (index) => rows[i][j], growable: false),
        growable: false);
    List<List<bool>> tmpCols = List.generate(
        9, (i) => List.generate(9, (index) => cols[i][j], growable: false),
        growable: false);
    List<List<bool>> tmpBlocks = List.generate(
        9, (i) => List.generate(9, (index) => blocks[i][j], growable: false),
        growable: false);

    tmpRows[i][field[i][j] - 1] = false;
    tmpCols[j][field[i][j] - 1] = false;
    tmpBlocks[k][field[i][j] - 1] = false;

    for (int n = 0; n < 9; n++) {
      if ((n + 1) != field[i][j]) {
        tmpField[i][j] = (n + 1);
        if (!tmpRows[i][n] && !tmpCols[j][n] && tmpBlocks[k][n]) {
          tmpRows[i][n] = true;
          tmpCols[j][n] = true;
          tmpBlocks[k][n] = true;
          if (dfs(tmpField, tmpRows, tmpCols, tmpBlocks)) return false;
          tmpRows[i][n] = false;
          tmpCols[j][n] = false;
          tmpBlocks[k][n] = false;
        }
      }
    }
    return true;
  }

  void clearFRCB(List<List<int>> field, List<List<bool>> rows,
      List<List<bool>> cols, List<List<bool>> blocks) {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        field[i][j] = 0;
        rows[i][j] = false;
        cols[i][j] = false;
        blocks[i][j] = false;
      }
    }
  }
}
