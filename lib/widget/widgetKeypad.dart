import 'package:flutter/material.dart';
import 'package:fsudoku/model/modelSudoku.dart';

// 形态：竖向，横向，九宫格
enum SudokuKeypadStyle { Vertical, Horizontal, Block }

class SudokuKeypad extends StatefulWidget {
  final SudokuBoardViewModel board;

  final double cellWidth;
  final double textScaleFactor;

  SudokuKeypad(
      {Key key,
      this.cellWidth = 32,
      this.textScaleFactor = 1,
      @required this.board})
      : super(key: key);

  @override
  _SudokuKeypadState createState() => _SudokuKeypadState();
}

class _SudokuKeypadState extends State<SudokuKeypad> {
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
          // color: _isCellContainsNumber(widget.focusedCell, cur)
          //     ? Theme.of(context).accentColor
          //     : Theme.of(context).disabledColor,
          child: InkWell(
              child: Center(
                  child: Text(
                cur.toString(),
                textScaleFactor: widget.textScaleFactor,
                style: TextStyle(
                    // color: _isCellContainsNumber(widget.focusedCell, cur)
                    //     ? Theme.of(context).textSelectionColor
                    //     : Theme.of(context).textSelectionColor,
                    fontSize: 20),
              )),
              onTap: () {
                // if (widget.focusedCell != null && !widget.focusedCell.isFixed) {
                  // widget.focusedCell.toggleCandidateNumber(cur);
                // }
                // widget.onFocusedCellChanged(widget.focusedCell);
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

  // bool _isCellContainsNumber(Cell cell, int number) {
  //   return (cell != null) &&
  // (cell.numbers[number - 1] || cell.number == number);
  // }
}
