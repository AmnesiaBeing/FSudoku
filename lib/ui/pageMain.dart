import 'package:flutter/material.dart';
import 'package:fsudoku/model/modelSudokuBoard.dart';
import 'package:fsudoku/widget/widgetBoard.dart';
import 'package:fsudoku/widget/widgetKeypad.dart';

const double AppBarHeight = 48;

class SudokuPage extends StatelessWidget {
  final SudokuBoardViewModel _board = SudokuBoardViewModel();

  // 标题栏，当没有工具栏的时候，标题栏右上角给一个三点按钮，显示下拉菜单
  Widget _buildAppBar(String title) {
    return PreferredSize(
        preferredSize: Size.fromHeight(AppBarHeight),
        child: AppBar(
          title: Text(title),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  _handleShare();
                }),
            IconButton(icon: Icon(Icons.settings), onPressed: () {}),
            // TODO：下拉菜单
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    String _title = 'Sudoku';

    // 获取窗口大小
    Size size = MediaQuery.of(context).size;
    double shortestSide = size.shortestSide;
    // 每个格子的宽度
    double cellWidth = 32;
    // 宽屏时考虑文字缩放
    double textScaleFactor = 1;
    // 是否有标题栏
    bool hasAppbar = true;
    // 中间的内容
    List<Widget> mainWidgets = List();

    Widget main;

    // 判断方向
    if (size.height > size.width) {
      //竖屏
      cellWidth = shortestSide / 9 - 1;

      // 这个啥情况下都得有
      mainWidgets.add(Spacer());
      mainWidgets.add(Center(
          child: SudokuBoard(
        board: _board,
        cellWidth: cellWidth,
        textScaleFactor: textScaleFactor,
      )));
      mainWidgets.add(Spacer());

      mainWidgets.add(Divider());
      if (size.height >= size.width + AppBarHeight + 5 * cellWidth) {
        // 屏幕很长，可以放很多东西，键盘呈九宫格放置
        mainWidgets.add(
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          IconButton(icon: Icon(Icons.redo), onPressed: _handleRedo),
          IconButton(
              icon: Icon(Icons.lightbulb_outline), onPressed: _handleTips),
          SudokuKeypad(
            board: _board,
            cellWidth: cellWidth,
            textScaleFactor: textScaleFactor,
          ),
          IconButton(icon: Icon(Icons.file_upload), onPressed: _handleSave),
          IconButton(icon: Icon(Icons.file_download), onPressed: _handleLoad)
        ]));
      } else if (size.height >= size.width + AppBarHeight + cellWidth) {
        // 屏幕还行，键盘呈一行放置
        mainWidgets.add(SudokuKeypad(
          board: _board,
          cellWidth: cellWidth,
          textScaleFactor: textScaleFactor,
        ));
        mainWidgets.add(
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          IconButton(icon: Icon(Icons.redo), onPressed: _handleRedo),
          IconButton(
              icon: Icon(Icons.lightbulb_outline), onPressed: _handleTips),
          IconButton(icon: Icon(Icons.file_upload), onPressed: _handleSave),
          IconButton(icon: Icon(Icons.file_download), onPressed: _handleLoad)
        ]));
      } else {
        // 屏幕很短，键盘悬浮显示（这个时候还是竖屏么？）

      }

      main = Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: mainWidgets,
      );
    } else {
      // 横屏先不做了
      // // 横屏，要减掉一个标题栏的高度（手机上隐藏标题栏？）
      // cellWidth = (shortestSide - AppBarHeight) / 9 - 2;
      // if (size.width >= size.height + 9 * cellWidth) {
      //   // 超级长，缩略图安排上

      // } else if (size.width >= size.height + 2 * cellWidth) {
      //   // 还能接受，键盘呈一列放置
      // } else {
      //   // 正方形了吧，键盘悬浮显示
      // }
    }

    return Scaffold(
        // 标题栏，俩按钮
        appBar: hasAppbar ? _buildAppBar(_title) : null,
        // 竖屏的时候，最上面是新数独什么的，各种难度的选项，然后是撤销，模式，提示，草稿（读写）
        body: main);
  }

  void _handleShare() {
    // TODO: 将下面的内容复制到剪贴板并显示提示“分享成功”
    // _board.toString();
  }

  void _handleSave() {}

  void _handleLoad() {}

  void _handleTips() {}

  void _handleRedo() {}
}
