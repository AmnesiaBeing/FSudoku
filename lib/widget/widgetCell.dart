import 'package:flutter/material.dart';
import 'package:fsudoku/model/modelSudokuBoard.dart';
import 'package:fsudoku/model/modelSudokuCell.dart';

class SudokuCell extends StatefulWidget {
  SudokuCell(
    this.key, {
    @required this.cell,
    this.cellWidth = 32,
    this.textScaleFactor = 1,
    @required this.board,
  }) {
    cell.registerWidgetKey(this.key);
  }

  final Key key;
  final SudokuBoardViewModel board;
  final SudokuCellViewModel cell;
  final double cellWidth;
  final double textScaleFactor;

  @override
  State<StatefulWidget> createState() => SudokuCellState();
}

class SudokuCellState extends State<SudokuCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.cellWidth,
      height: widget.cellWidth,
      decoration: BoxDecoration(
          border: Border.all(width: 1),
          color: _getCellBackgroundColor(context)),
      child: InkWell(
        child: Center(
            // 三种情况的没有确定数字和有确定数字的也不一样
            child: (widget.cell.isFixed || widget.cell.number is int)
                ? Text(
                    widget.cell.number.toString(),
                    textScaleFactor: widget.textScaleFactor,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  )
                : _buildSudokuCellCandidate(context, widget.cell.number)),
        onTap: _handleTap,
        onHover: _handleHover,
      ),
    );
  }

  // 单元格内的候选数字
  Widget _buildSudokuCellCandidate(BuildContext context, List candidateNumber) {
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
                  return Center(
                      child: Text(
                    candidateNumber.contains(c) ? c.toString() : ' ',
                    style: TextStyle(color: Colors.black, fontSize: 10),
                  ));
                }, growable: false)),
            growable: false));
  }

  Color _getCellBackgroundColor(BuildContext context) {
    // 根据不同的类型有不同的颜色
    Color ret = widget.cell.isFixed
        ? Theme.of(context).disabledColor
        // : (widget.cell.numbers.length == 1)
        //     ? Theme.of(context).toggleableActiveColor
        : Colors.white;

    if (_isInFocusedRange()) return Theme.of(context).disabledColor;
    // ret = Color.alphaBlend(Colors.blue, ret);

    if (_isInHoverRange())
      ret = Color.alphaBlend(Theme.of(context).hoverColor, ret);

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

  bool _isInHoverRange() {
    return widget.board.hoveredCells.contains(widget.cell);
  }

  void refresh() {
    setState(() {});
  }
}
