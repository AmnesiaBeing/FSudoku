import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fsudoku/model/modelSudokuCell.dart';
import 'package:fsudoku/widget/widgetKeypad.dart';

// 所有数据都在这里啦
class SudokuBoardViewModel {
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
  List<List<SudokuCellViewModel>> blocks;

  // 当前处于激活状态的cell
  // SudokuCellViewModel focusedCell;
  // SudokuCellViewModel hoveredCell;
  // 当前需要显示激活状态的cell们
  Set<SudokuCellViewModel> focusedCells = Set();
  // 当前需要显示为鼠标移过状态的cell们
  Set<SudokuCellViewModel> hoveredCells = Set();

  // 键盘的把柄，让你重画就重画
  GlobalKey<SudokuKeypadState> keypadKey;

  // 构造函数
  SudokuBoardViewModel() {
    cells =
        List.generate(9 * 9, (_) => SudokuCellViewModel(this), growable: false);

    // 方便UI处理
    rows = List(9);
    cols = List(9);
    blocks = List(9);
    for (int i = 0; i < 9; i++) {
      rows[i] = List(9);
      cols[i] = List(9);
      blocks[i] = List(9);
      for (int j = 0; j < 9; j++) {
        rows[i][j] = cells[i * 9 + j];
        rows[i][j].rowInBoard = i;
        cols[i][j] = cells[j * 9 + i];
        cols[i][j].colInBoard = i;
        blocks[i][j] =
            cells[(i ~/ 3) * 27 + (j ~/ 3) * 9 + (i % 3) * 3 + j % 3];
        blocks[i][j].blockInBoard = i;
      }
    }
    // 生成数独的线程
    // TODO:后台生成一定数量的数独题目，比如最多10个，下一个题目可以随时读取

    // FOR TEST ONLY
    // cells.forEach((element) {
    //   element.addCandidateNumber(Random().nextInt(9) + 1);
    // element.addCandidateNumber(Random().nextInt(9) + 1);
    // element.isFixed = Random().nextBool();
    //   element.isFixed = false;
    // });
    // FOR TEST ONLY
    // 随机生成10个数字，测试自动填充的功能
    int n = 10;
    raw = List.generate(81, (index) => Number_Invalid, growable: false);
    while (n > 0) {
      int x = Random().nextInt(81);
      int v = Random().nextInt(9) + 1;
      raw[x] = v;
      cells[x].setNumber(v, true);
      n--;
    }
    calAllCandidateNumber();
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

    List<int> newCells = List(81);
    for (int i = 0; i < 81; i++) {
      try {
        newCells[i] = int.tryParse(str[i]);
      } catch (e) {
        return false;
      }
    }
    clearCells();
    for (int i = 0; i < 81; i++) {
      cells[i].setNumber(newCells[i], newCells[i] != 0);
    }
    raw = newCells;
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

  // 求同一行、一列、一九宫格的单元格的集合
  Set<SudokuCellViewModel> _calSameRowColBlockCell(SudokuCellViewModel cell) {
    Set<SudokuCellViewModel> ret = Set();
    ret.addAll(rows[cell.rowInBoard]);
    ret.addAll(cols[cell.colInBoard]);
    ret.addAll(blocks[cell.blockInBoard]);
    return ret;
  }

  // 求含有同一数字的集合
  Set<SudokuCellViewModel> _calSameNumberCells(SudokuCellViewModel cell) {
    Set<SudokuCellViewModel> ret = Set();
    if (cell.number is int)
      cells.forEach((element) {
        if (element.number is int) {
          if (element.number == cell.number) {
            ret.add(element);
          }
        } else {
          if ((element.number as List<int>).contains(cell.number)) {
            ret.add(element);
          }
        }
      });
    return ret;
  }

  // 处理单元格按下事件
  // 已知原来有的，求出和新的有关的，求交集，交集不用变，原有的-交集=需要告诉它们恢复原样
  // 新来的-交集=需要通知它们作出改变
  // 画个伟恩图就好，感觉是不是想多了我
  void handleTap(SudokuCellViewModel cell) {
    Set<SudokuCellViewModel> oldCells = focusedCells;
    Set<SudokuCellViewModel> newCells = _calSameRowColBlockCell(cell);
    newCells.addAll(_calSameNumberCells(cell));
    focusedCells = newCells;

    Set<SudokuCellViewModel> tmp1 = newCells.union(oldCells);
    Set<SudokuCellViewModel> tmp2 = newCells.intersection(oldCells);
    Set<SudokuCellViewModel> tmp3 = tmp1.difference(tmp2);
    tmp3.forEach((element) {
      element.notifyRefresh();
    });

    keypadKey.currentState.setFocusedCell(cell);
  }

  // 同上，对鼠标移过的也算一算
  void handleHover(SudokuCellViewModel cell) {
    Set<SudokuCellViewModel> oldCells = hoveredCells;
    Set<SudokuCellViewModel> newCells = _calSameRowColBlockCell(cell);

    newCells.difference(oldCells).forEach((element) {
      element.notifyRefresh();
    });

    hoveredCells = newCells;
  }

  // 清空内容
  void clearCells() {
    cells.forEach((element) {
      element.setNumber(Number_Invalid, false);
    });
  }

  // 计算候选数字，有且仅有在数独开始时使用
  // 直接操作内部数组
  // 这个时候number肯定只有固定的数字
  void calAllCandidateNumber() {
    List<List<bool>> r = List.generate(
        9,
        (i) => List.generate(
            9,
            (j) => rows[i].any((element) =>
                (element.number is int && element.number == j + 1))));
    List<List<bool>> c = List.generate(
        9,
        (i) => List.generate(
            9,
            (j) => cols[i].any((element) =>
                (element.number is int && element.number == j + 1))));
    List<List<bool>> b = List.generate(
        9,
        (i) => List.generate(
            9,
            (j) => blocks[i].any((element) =>
                (element.number is int && element.number == j + 1))));
    cells.forEach((element) {
      if (!element.isFixed) {
        // 依次判断这个格子是否能填1-9
        for (int i = 0; i < 9; i++)
          if (!r[element.rowInBoard][i] &&
              !c[element.colInBoard][i] &&
              !b[element.blockInBoard][i]) {
            element.candidateNumbers[i] = true;
          }
      }
    });
  }
}
