import 'package:flutter/material.dart';
import 'package:fsudoku/model/modelSudoku.dart';
import 'package:provider/provider.dart';

class SudokuCell extends StatelessWidget {
  final SudokuCellViewModel cell;
  final double cellWidth;
  final double textScaleFactor;

  SudokuCell({
    Key key,
    @required this.cell,
    this.cellWidth = 32,
    this.textScaleFactor = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cellWidth,
      height: cellWidth,
      decoration: BoxDecoration(
          border: Border.all(width: 1),
          color: _getCellBackgroundColor(context)),
      child: InkWell(
        child: Center(
          // 三种情况的没有确定数字和有确定数字的也不一样
          child: ChangeNotifierProvider<SudokuCellViewModel>.value(
              value: cell,
              child: (cell.isFixed || cell.number is int)
                  ? Text(
                      cell.number.toString(),
                      textScaleFactor: textScaleFactor,
                      style: TextStyle(
                          color: Theme.of(context).textSelectionColor,
                          fontSize: 20),
                    )
                  : _buildSudokuCellCandidate(context, cell.number)),
        ),
        onTap: () {},
        onHover: (isHover) {},
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
                    style: TextStyle(
                        color: Theme.of(context).textSelectionColor,
                        fontSize: 10),
                  ));
                }, growable: false)),
            growable: false));
  }

  Color _getCellBackgroundColor(BuildContext context) {
    // 根据不同的类型有不同的颜色
    Color ret = cell.isFixed
        ? Theme.of(context).disabledColor
        // : (cell.numbers.length == 1)
        //     ? Theme.of(context).toggleableActiveColor
        : Theme.of(context).accentColor;

    // if (isInActiveRange)
    //   ret = Color.alphaBlend(Theme.of(context).focusColor, ret);

    // if (isInHoverRange)
    //   ret = Color.alphaBlend(Theme.of(context).hoverColor, ret);

    return ret;
  }
}
