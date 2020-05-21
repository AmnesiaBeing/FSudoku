import 'package:flutter/material.dart';
import 'package:fsudoku/model/modelSudokuBoard.dart';

import 'widgetCell.dart';

class SudokuBoard extends StatelessWidget {
  final double cellWidth;
  final double textScaleFactor;
  final SudokuBoardViewModel board;

  SudokuBoard(
      {Key key,
      this.cellWidth = 32,
      this.textScaleFactor = 1,
      @required this.board})
      : super(key: key);

  // 单元格的颜色由基础颜色与动画颜色混合而成
  @override
  Widget build(BuildContext context) {
    return Center(
      child: _buildSudokuBoard(),
    );
  }

  Widget _buildSudokuBoard() {
    // 代码有点复杂，大概意思是，先构建大的九宫格，然后每一个九宫格再画格子
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(
            3,
            (i) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: List<Widget>.generate(
                    3,
                    (j) => Container(
                          decoration:
                              BoxDecoration(border: Border.all(width: 1)),
                          child: Column(
                            children: List<Widget>.generate(
                                3,
                                (k) => Row(
                                      children: List<Widget>.generate(3, (l) {
                                        int index = i * 27 + k * 9 + j * 3 + l;
                                        return SudokuCell(
                                          GlobalKey<SudokuCellState>(),
                                          board: board,
                                          cell: board.cells[index],
                                          cellWidth: cellWidth,
                                        );
                                      }, growable: false),
                                    ),
                                growable: false),
                          ),
                        ),
                    growable: false)),
            growable: false));
  }
}
