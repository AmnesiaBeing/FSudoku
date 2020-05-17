import 'package:flutter/material.dart';

import 'sudokuModel.dart';
import 'theme.dart';

class SudokuCell extends StatefulWidget {
  final Cell cell;
  final double cellWidth;
  final double textScaleFactor;
  final ValueChanged<Cell> onTap;
  final ValueChanged<Cell> onDoubleTap;
  final ValueChanged<Cell> onHover;
  final bool isInActiveRange;
  final bool isInHoverRange;
  final bool isDisabled;
  final bool isWrong;

  SudokuCell(
      {Key key,
      this.cell,
      this.cellWidth = 32,
      this.textScaleFactor = 1,
      this.onTap,
      this.onDoubleTap,
      this.isInActiveRange = false,
      this.isInHoverRange = false,
      this.isDisabled = false,
      this.onHover,
      this.isWrong = false})
      : super(key: key);

  @override
  _SudokuCellState createState() => _SudokuCellState();
}

class _SudokuCellState extends State<SudokuCell> {
  MyTheme theme = Theme0();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(1),
      width: widget.cellWidth,
      height: widget.cellWidth,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: _getCellBorderColor(widget.cell), width: 1),
          color: _getCellBackgroundColor(widget.cell)),
      child: InkWell(
        child: Center(
            // 三种情况的没有确定数字和有确定数字的也不一样
            child: (widget.cell.isFixed ||
                    widget.cell.candidateNumberCount == 1)
                ? Text(
                    widget.cell.number.toString(),
                    textScaleFactor: widget.textScaleFactor,
                    style:
                        TextStyle(color: theme.colorTextNumber, fontSize: 20),
                  )
                : _buildSudokuCellCandidate(widget.cell.candidateNumber)),
        onTap: () {
          widget.onTap(widget.cell);
        },
        onHover: (isHover) {
          widget.onHover(isHover ? widget.cell : null);
        },
      ),
    );
  }

  // 单元格内的候选数字
  Widget _buildSudokuCellCandidate(List candidateNumber) {
    List<Widget> lc = List<Widget>();
    for (int i = 0; i < 3; i++) {
      List<Widget> lr = List<Widget>();
      for (int j = 0; j < 3; j++) {
        int cur = i * 3 + j + 1;

        lr.add(Offstage(
          offstage: !candidateNumber[cur - 1],
          child: Container(
              width: widget.cellWidth / 3 - 1,
              height: widget.cellWidth / 3 - 1,
              // decoration: (_focusedCell == null)
              //     ? null
              //     : (_focusedCell.number == cur)
              //         ? BoxDecoration(color: theme.colorBackgroundCellFocus)
              //         : null,
              child: Center(
                child: Text(
                  cur.toString(),
                  textScaleFactor: widget.textScaleFactor,
                  style: TextStyle(
                      color: theme.colorCandidateTextNumber,
                      fontSize: 8,
                      fontWeight: FontWeight.bold),
                ),
              )),
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

  Color _getCellBackgroundColor(Cell cell) {
    // 根据不同的类型有不同的颜色
    Color ret = widget.cell.isFixed
        ? theme.colorBackgroundCellValueFixed
        : (widget.cell.number == Number_Invalid)
            ? theme.colorBackgroundCellEmpty
            : theme.colorBackgroundCellValue;

    if (widget.isInActiveRange)
      ret = Color.alphaBlend(theme.colorBackgroundCellFocus, ret);

    if (widget.isInHoverRange)
      ret = Color.alphaBlend(theme.colorBackgroundCellHover, ret);

    // // 获得焦点时的颜色
    // if (_focusedCell != null) {
    //   if (_focusedCell.number != Number_Invalid &&
    //       widget.cell.number == _focusedCell.number)
    //     ret = Color.alphaBlend(ret, theme.colorBackgroundCellFocus);
    //   if (_focusedCell.colInBoard != Index_Invalid &&
    //       widget.cell.colInBoard == _focusedCell.colInBoard)
    //     ret = Color.alphaBlend(ret, theme.colorBackgroundCellFocus);
    //   if (_focusedCell.rowInBoard != Index_Invalid &&
    //       widget.cell.rowInBoard == _focusedCell.rowInBoard)
    //     ret = Color.alphaBlend(ret, theme.colorBackgroundCellFocus);
    //   if (_focusedCell.nineBoxInBoard != Index_Invalid &&
    //       widget.cell.nineBoxInBoard == _focusedCell.nineBoxInBoard)
    //     ret = Color.alphaBlend(ret, theme.colorBackgroundCellFocus);
    // }

    // // 鼠标经过时的颜色
    // if (_hoverCell != null) {
    //   if (_hoverCell.colInBoard != Index_Invalid &&
    //       widget.cell.colInBoard == _hoverCell.colInBoard)
    //     ret = Color.alphaBlend(ret, theme.colorBackgroundCellHover);
    //   if (_hoverCell.rowInBoard != Index_Invalid &&
    //       widget.cell.rowInBoard == _hoverCell.rowInBoard)
    //     ret = Color.alphaBlend(ret, theme.colorBackgroundCellHover);
    //   if (_hoverCell.nineBoxInBoard != Index_Invalid &&
    //       widget.cell.nineBoxInBoard == _hoverCell.nineBoxInBoard)
    //     ret = Color.alphaBlend(ret, theme.colorBackgroundCellHover);
    // }

    return ret;
  }

  Color _getCellBorderColor(Cell cell) {
    // 根据不同的类型有不同的颜色
    Color ret = widget.cell.isFixed
        ? theme.colorBackgroundCellValueFixed
        : (widget.cell.number == Number_Invalid)
            ? theme.colorBackgroundCellEmpty
            : theme.colorBackgroundCellValue;

    if (widget.isInActiveRange)
      ret = Color.alphaBlend(theme.colorBackgroundCellFocus, ret);

    if (widget.isInHoverRange)
      ret = Color.alphaBlend(theme.colorBackgroundCellHover, ret);

    // // 获得焦点时的颜色
    // if (_focusedCell != null) {
    //   if (_focusedCell.number != Number_Invalid &&
    //       widget.cell.number == _focusedCell.number)
    //     ret = Color.alphaBlend(ret, theme.colorBackgroundCellFocus);
    //   if (_focusedCell.colInBoard != Index_Invalid &&
    //       widget.cell.colInBoard == _focusedCell.colInBoard)
    //     ret = Color.alphaBlend(ret, theme.colorBackgroundCellFocus);
    //   if (_focusedCell.rowInBoard != Index_Invalid &&
    //       widget.cell.rowInBoard == _focusedCell.rowInBoard)
    //     ret = Color.alphaBlend(ret, theme.colorBackgroundCellFocus);
    //   if (_focusedCell.nineBoxInBoard != Index_Invalid &&
    //       widget.cell.nineBoxInBoard == _focusedCell.nineBoxInBoard)
    //     ret = Color.alphaBlend(ret, theme.colorBackgroundCellFocus);
    // }

    // // 鼠标经过时的颜色
    // if (_hoverCell != null) {
    //   if (_hoverCell.colInBoard != Index_Invalid &&
    //       widget.cell.colInBoard == _hoverCell.colInBoard)
    //     ret = Color.alphaBlend(ret, theme.colorBackgroundCellHover);
    //   if (_hoverCell.rowInBoard != Index_Invalid &&
    //       widget.cell.rowInBoard == _hoverCell.rowInBoard)
    //     ret = Color.alphaBlend(ret, theme.colorBackgroundCellHover);
    //   if (_hoverCell.nineBoxInBoard != Index_Invalid &&
    //       widget.cell.nineBoxInBoard == _hoverCell.nineBoxInBoard)
    //     ret = Color.alphaBlend(ret, theme.colorBackgroundCellHover);
    // }

    return ret;
  }
}
