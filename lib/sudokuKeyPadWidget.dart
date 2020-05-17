import 'package:flutter/material.dart';

import 'sudokuModel.dart';
import 'theme.dart';

class SudokuKeyPad extends StatefulWidget {
  final Cell focusedCell;
  final ValueChanged<Cell> onFocusedCellChanged;
  final double cellWidth;
  final double textScaleFactor;

  SudokuKeyPad(
      {Key key,
      this.focusedCell,
      this.onFocusedCellChanged,
      this.cellWidth = 32,
      this.textScaleFactor = 1})
      : super(key: key);

  @override
  _SudokuKeyPadState createState() => _SudokuKeyPadState();
}

class _SudokuKeyPadState extends State<SudokuKeyPad> {
  MyTheme theme = Theme0();
  @override
  Widget build(BuildContext context) {
    List<Widget> lc = List<Widget>();

    for (int i = 0; i < 3; i++) {
      List<Widget> lr = List<Widget>();
      for (int j = 0; j < 3; j++) {
        int cur = i * 3 + j + 1;
        lr.add(Container(
          margin: EdgeInsets.all(1),
          width: widget.cellWidth,
          height: widget.cellWidth,
          color: _isCellContainsNumber(widget.focusedCell, cur)
              ? theme.colorBackgroundCellEmpty
              : theme.colorBackgroundCellDisabled,
          child: InkWell(
              child: Center(
                  child: Text(
                cur.toString(),
                textScaleFactor: widget.textScaleFactor,
                style: TextStyle(
                    color: _isCellContainsNumber(widget.focusedCell, cur)
                        ? theme.colorCandidateTextNumber
                        : theme.colorCandidateTextNumberDisabled,
                    fontSize: 20),
              )),
              onTap: () {
                if (widget.focusedCell != null && !widget.focusedCell.isFixed) {
                  widget.focusedCell.toggleCandidateNumber(cur);
                }
                widget.onFocusedCellChanged(widget.focusedCell);
              }),
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
    return Container(
        child: c,
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: Colors.black38, width: 1),
        ));
  }

  bool _isCellContainsNumber(Cell cell, int number) {
    return (cell != null) &&
        (cell.candidateNumber[number - 1] || cell.number == number);
  }
}
