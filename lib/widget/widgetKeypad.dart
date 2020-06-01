import 'package:flutter/material.dart';
import 'package:fsudoku/model/modelSudokuBoard.dart';
import 'package:fsudoku/model/modelSudokuCell.dart';

// 形态：竖向，横向，九宫格
enum SudokuKeypadStyle { Vertical, Horizontal, Block }

class SudokuKeypad extends StatefulWidget {
  final SudokuBoardViewModel board;

  final int cellWidth;
  final double textScaleFactor;

  final Key key;

  SudokuKeypad(
      {this.key,
      this.cellWidth = 33,
      this.textScaleFactor = 1,
      @required this.board}) {
    board.keypadKey = this.key;
  }

  @override
  SudokuKeypadState createState() => SudokuKeypadState();
}

class SudokuKeypadState extends State<SudokuKeypad> {
  SudokuCellViewModel _focusedCell;

  @override
  Widget build(BuildContext context) {
    List<Widget> lc = List<Widget>();

    for (int i = 0; i < 3; i++) {
      List<Widget> lr = List<Widget>();
      for (int j = 0; j < 3; j++) {
        int cur = i * 3 + j + 1;
        bool v = _isCellContainsNumber(cur);
        lr.add(Container(
          margin: EdgeInsets.all(1),
          width: widget.cellWidth * 1.0,
          height: widget.cellWidth * 1.0,
          color: v ? Colors.black : Colors.white,
          child: InkWell(
              child: Center(
                  child: Text(
                cur.toString(),
                textScaleFactor: widget.textScaleFactor,
                style: TextStyle(
                    color: v ? Colors.white : Colors.black, fontSize: 20),
              )),
              onTap: () {
                if (_focusedCell != null)
                  widget.board.handleKeypadTap(_focusedCell, cur);
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

  bool _isCellContainsNumber(int number) {
    return (_focusedCell != null) &&
        (_focusedCell.candidateNumbers[number - 1] ||
            _focusedCell.filledNumber == number);
  }

  void setFocusedCell(SudokuCellViewModel cell) {
    setState(() {
      _focusedCell = cell;
    });
  }

  void refresh() {
    setState(() {});
  }
}
