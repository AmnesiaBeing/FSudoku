import 'package:flutter/material.dart';
import 'package:fsudoku/model/modelSudokuBoard.dart';
import 'package:fsudoku/widget/widgetCell.dart';

// 这俩是用于防止愚蠢的错误
const Index_Invalid = -1;
const Number_Invalid = 0;

class Cell {
  // 单元格是否是已知数
  bool isFixed = false;
  // 在数独中的坐标 0-8
  int rowInBoard = Index_Invalid;
  int colInBoard = Index_Invalid;
  // 所处九宫格的序号
  int blockInBoard = Index_Invalid;
  // 候选数据
  List<bool> candidateNumbers =
      List.generate(9, (index) => false, growable: false);
  // 0,1-9
  int filledNumber = Number_Invalid;

  List<int> listCandidateNumbers() {
    List<int> ret = List();
    for (int i = 0; i < 9; i++) {
      if (this.candidateNumbers[i]) {
        ret.add(i + 1);
      }
    }
    return ret;
  }
}

// 一个单元格，内部可以有9个候选数字
class SudokuCellViewModel extends Cell {
  SudokuBoardViewModel board;
  SudokuCellViewModel(SudokuBoardViewModel parent) {
    this.board = parent;
  }

  // 错误标记，在检查函数中，判断有同一行同一列同一宫存在相同的数字将进行标记
  // 或者已有数字，候选数字与已有数字冲突，也进行标记
  bool isWrong = false;

  // Widget State
  GlobalKey<SudokuCellState> key;

  void handleOnTap() {
    board.handleCellTap(this);
  }

  void handleOnHover() {
    board.handleCellHover(this);
  }

  // 通知对应的widget刷新一哈
  void notifyRefresh() {
    key.currentState.refresh();
  }

  // widget创建时，把globalkey跟model说一下，以后跟你说点啥你要听见。
  void registerWidgetKey(GlobalKey<SudokuCellState> key) {
    this.key = key;
  }
}
