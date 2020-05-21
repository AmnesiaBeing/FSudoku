import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fsudoku/model/modelSudokuBoard.dart';
import 'package:fsudoku/widget/widgetCell.dart';

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
class SudokuCellViewModel {
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

  // Widget State
  GlobalKey<SudokuCellState> key;

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

  void handleOnTap() {
    board.handleTap(this);
  }

  void handleOnHover() {
    board.handleHover(this);
  }

  void notifyRefresh() {
    key.currentState.refresh();
  }

  void registerWidgetKey(GlobalKey<SudokuCellState> key) {
    this.key = key;
  }
}
