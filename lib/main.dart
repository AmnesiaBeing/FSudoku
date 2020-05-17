import 'package:flutter/material.dart';

import 'sudokuBoardWidget.dart';
import 'sudokuKeyPadWidget.dart';
import 'sudokuModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sudoku',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SudokuPage(),
    );
  }
}

class SudokuPage extends StatefulWidget {
  SudokuPage({Key key}) : super(key: key);

  @override
  _SudokuPageState createState() => _SudokuPageState();
}

class _SudokuPageState extends State<SudokuPage> {
  String _title = 'Sudoku';

  double _cellWidth = 32;
  double _textScaleFactor = 1;

  Board _sudokuBoardData;

  Cell _focusedCell;

  @override
  Widget build(BuildContext context) {
    // 首先获取窗口大小，决定按照什么模式来绘制UI
    Size size = MediaQuery.of(context).size;
    double shortestSide = size.shortestSide;
    _cellWidth = shortestSide / 9 - 6;
    // 简单起见，认为这个应用只有竖屏的用法，横屏以后再说

    return Scaffold(
        // 标题栏，俩按钮
        appBar: AppBar(
          title: Text(_title),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  _share();
                }),
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  _share();
                }),
          ],
        ),
        // 竖屏的时候，最上面是新数独什么的，各种难度的选项，然后是撤销，模式，提示，草稿（读写）
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlineButton(
                  onPressed: () {},
                  child: Text('Easy'),
                ),
                OutlineButton(
                  onPressed: () {},
                  child: Text('Normal'),
                ),
                OutlineButton(
                  onPressed: () {},
                  child: Text('Hard'),
                ),
                OutlineButton(
                  onPressed: () {},
                  child: Text('???'),
                ),
              ],
            ),
            Divider(),
            Text('Click cell first, then (un)select candidate numbers.'),
            Divider(),
            SudokuBoard(
              board: _sudokuBoardData,
              onFocusedCellChanged: _handleFocusedCellChanged,
              cellWidth: _cellWidth,
              textScaleFactor: _textScaleFactor,
            ),
            Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              IconButton(icon: Icon(Icons.redo), onPressed: () {}),
              IconButton(icon: Icon(Icons.lightbulb_outline), onPressed: () {}),
              SudokuKeyPad(
                focusedCell: _focusedCell,
                onFocusedCellChanged: _handleFocusedCellChanged,
                cellWidth: _cellWidth,
                textScaleFactor: _textScaleFactor,
              ),
              IconButton(icon: Icon(Icons.redo), onPressed: () {}),
              IconButton(icon: Icon(Icons.lightbulb_outline), onPressed: () {}),
            ]),
          ],
        ));
  }

  @override
  void initState() {
    _sudokuBoardData = Board();
    _sudokuBoardData.random();
    super.initState();
  }

  void _handleFocusedCellChanged(Cell cell) {
    setState(() {
      _focusedCell = cell;
    });
  }

  void _share() {}
}
