import 'package:flutter/material.dart';

import 'sudokuCellWidget.dart';
import 'sudokuModel.dart';
import 'theme.dart';

class SudokuBoard extends StatefulWidget {
  final Board board;
  final ValueChanged<Cell> onFocusedCellChanged;
  final double cellWidth;
  final double textScaleFactor;

  SudokuBoard(
      {Key key,
      this.board,
      this.onFocusedCellChanged,
      this.cellWidth = 32,
      this.textScaleFactor = 1})
      : super(key: key);

  @override
  _SudokuBoardState createState() => _SudokuBoardState();
}

class _SudokuBoardState extends State<SudokuBoard> {
  MyTheme theme = Theme0();

  Cell _focusedCell;
  Cell _hoverCell;

  // 单元格的颜色由基础颜色与动画颜色混合而成
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: _buildSudokuBoard(widget.board)),
    );
  }

  Widget _buildSudokuBoard(Board sudokuBoardData) {
    List<Widget> lc = List<Widget>();

    for (int i = 0; i < 3; i++) {
      List<Widget> lr = List<Widget>();
      for (int j = 0; j < 3; j++) {
        lr.add(Container(
            padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
            child: _buildSudokuNineBox(sudokuBoardData.boxes[i * 3 + j])));
      }
      Row row = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: lr,
      );
      lc.add(Container(padding: EdgeInsets.all(1), child: row));
    }
    Column col = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: lc,
    );

    return col;
  }

  // 九宫格里有9个单元格
  Widget _buildSudokuNineBox(List<Cell> nineBox) {
    List<Widget> lc = List<Widget>();

    for (int i = 0; i < 3; i++) {
      List<Widget> lr = List<Widget>();
      for (int j = 0; j < 3; j++) {
        lr.add(SudokuCell(
          cell: nineBox[i * 3 + j],
          cellWidth: widget.cellWidth,
          isInActiveRange: _checkIsInFocusRange(nineBox[i * 3 + j]),
          isInHoverRange: _checkIsInHoverRange(nineBox[i * 3 + j]),
          isWrong: _checkIsWrong(nineBox[i * 3 + j]),
          onTap: _handleCellOnTap,
          onHover: _handleCellOnHover,
        ));
      }
      Row r = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: lr,
      );
      lc.add(r);
    }
    Column c = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: lc,
    );

    return c;
  }

  bool _checkIsInFocusRange(Cell cell) {
    if (_focusedCell == null) return false;
    if (_focusedCell.number != Number_Invalid &&
        _focusedCell.number == cell.number) return true;
    if (_focusedCell.nineBoxInBoard == cell.nineBoxInBoard) return true;
    if (_focusedCell.rowInBoard == cell.rowInBoard) return true;
    if (_focusedCell.colInBoard == cell.colInBoard) return true;
    return false;
  }

  bool _checkIsInHoverRange(Cell cell) {
    if (_hoverCell == null) return false;
    if (_hoverCell.nineBoxInBoard == cell.nineBoxInBoard) return true;
    if (_hoverCell.rowInBoard == cell.rowInBoard) return true;
    if (_hoverCell.colInBoard == cell.colInBoard) return true;
    return false;
  }

  bool _checkIsWrong(Cell cell) {
    return false;
  }

  void _handleCellOnTap(Cell cell) {
    _focusedCell = cell;
    widget.onFocusedCellChanged(cell);
  }

  void _handleCellOnHover(Cell cell) {
    setState(() {
      _hoverCell = cell;
    });
  }
}
