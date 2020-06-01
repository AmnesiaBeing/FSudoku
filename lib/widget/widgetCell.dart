import 'package:flutter/material.dart';
import 'package:fsudoku/model/modelSudokuBoard.dart';
import 'package:fsudoku/model/modelSudokuCell.dart';
import 'package:fsudoku/ui/colors.dart';

class SudokuCell extends StatefulWidget {
  SudokuCell(
    this.key, {
    @required this.cell,
    this.cellWidth = 33,
    this.textScaleFactor = 1,
    @required this.board,
  }) {
    cell.registerWidgetKey(this.key);
  }

  final Key key;
  final SudokuBoardViewModel board;
  final SudokuCellViewModel cell;
  final int cellWidth;
  final double textScaleFactor;

  @override
  State<StatefulWidget> createState() => SudokuCellState();
}

class SudokuCellState extends State<SudokuCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.cellWidth * 1.0,
      height: widget.cellWidth * 1.0,
      decoration: BoxDecoration(
          border: Border.all(width: 1),
          color: _getCellBackgroundColor(context)),
      child: InkWell(
        child: Center(
            // 三种情况的没有确定数字和有确定数字的也不一样
            child: (widget.cell.isFixed ||
                    widget.cell.filledNumber != Number_Invalid)
                ? Text(
                    widget.cell.filledNumber.toString(),
                    textScaleFactor: widget.textScaleFactor,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  )
                : _buildSudokuCellCandidate(
                    context, widget.cell.listCandidateNumbers())),
        onTap: _handleTap,
        onHover: _handleHover,
      ),
    );
  }

  // 单元格内的候选数字
  Widget _buildSudokuCellCandidate(
      BuildContext context, List<int> candidateNumber) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: List<Widget>.generate(
            3,
            (i) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: List<Widget>.generate(3, (j) {
                  int c = i * 3 + j + 1;
                  return Container(
                      width: (widget.cellWidth - 2) / 3,
                      height: (widget.cellWidth - 2) / 3,
                      color: (widget.board.curNumber != Number_Invalid &&
                              widget.board.curNumber == c &&
                              widget.cell
                                  .candidateNumbers[widget.board.curNumber - 1])
                          ? CellBgSameNumber
                          : Colors.transparent,
                      child: Offstage(
                          offstage: !candidateNumber.contains(c),
                          child: Center(
                              child: Text(
                            c.toString(),
                            style: TextStyle(color: Colors.black, fontSize: 10),
                          ))));
                }, growable: false)),
            growable: false));
  }

  Color _getCellBackgroundColor(BuildContext context) {
    // 根据不同的类型有不同的颜色
    Color ret =
        widget.cell.isFixed ? CellBgWithFixedNumber : CellBgWithoutFixedNumber;

    if (_isInWarningRange()) ret = Color.alphaBlend(CellBgWarning, ret);

    if (widget.board.focusedCell == widget.cell)
      ret = Color.alphaBlend(CellBgFocused.withAlpha(255), ret);
    if (_isInFocusedRange()) ret = Color.alphaBlend(CellBgFocused, ret);

    if (widget.board.sameNumberCells.contains(widget.cell) &&
        widget.cell.filledNumber != Number_Invalid)
      ret = Color.alphaBlend(CellBgSameNumber, ret);

    if (_isInHoveredRange()) ret = Color.alphaBlend(CellBgHovered, ret);

    return ret;
  }

  void _handleTap() {
    widget.cell.handleOnTap();
  }

  // TODO：对鼠标移出事件做处理
  void _handleHover(bool isHover) {
    if (isHover) widget.cell.handleOnHover();
  }

  bool _isInFocusedRange() {
    return widget.board.focusedCells.contains(widget.cell);
  }

  bool _isInHoveredRange() {
    return widget.board.hoveredCells.contains(widget.cell);
  }

  bool _isInWarningRange() {
    return widget.cell.isWrong;
  }

  void refresh() {
    setState(() {});
  }
}
