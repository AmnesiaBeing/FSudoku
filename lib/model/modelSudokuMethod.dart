import 'dart:math';

// 网上抄的生成/解数独的代码

// 这个函数用剪枝法解一个数独矩阵field，（0为空，1-9表示所填数字），
// rows、cols、blocks表示第i行、列、宫已经有数字j填入了（用于判断是否重复）
bool dfs(List<List<int>> field, List<List<bool>> rows, List<List<bool>> cols,
    List<List<bool>> blocks) {
  for (int i = 0; i < 9; i++) {
    for (int j = 0; j < 9; j++) {
      if (field[i][j] == 0) {
        int k = i ~/ 3 * 3 + j ~/ 3;
        for (int n = 0; n < 9; n++) {
          if (!rows[i][n] && !cols[j][n] && !blocks[k][n]) {
            rows[i][n] = true;
            cols[j][n] = true;
            blocks[k][n] = true;
            field[i][j] = n + 1;
            if (dfs(field, rows, cols, blocks)) return true;
            rows[i][n] = false;
            cols[j][n] = false;
            blocks[k][n] = false;
            field[i][j] = 0;
          }
        }
        return false;
      }
    }
  }
  return true;
}

// 用拉斯维加斯算法生成数独，向空矩阵中随机填写n个数字（一般是11）
// 然后用剪枝法解这个数独（据说有99%的概率可以解出来）
// TODO：用剪枝法解数独时，左上角第一个数字可能每次都是1？
bool lasVegas(List<List<int>> field, List<List<bool>> rows,
    List<List<bool>> cols, List<List<bool>> blocks, int n) {
  Random rnd = Random();
  while (n > 0) {
    int i = rnd.nextInt(9);
    int j = rnd.nextInt(9);
    if (field[i][j] == 0) {
      int k = i ~/ 3 * 3 + j ~/ 3;
      int v = rnd.nextInt(9);
      if (!rows[i][v] && !cols[j][v] && !blocks[k][v]) {
        field[i][j] = v + 1;
        rows[i][v] = true;
        cols[j][v] = true;
        blocks[k][v] = true;
        n--;
      }
    }
  }

  return dfs(field, rows, cols, blocks);
}

// 挖洞生成数独，level表示挖洞的数目
// field是一个完整的数独，现在要对其进行随机挖洞
void digSudoku(List<List<int>> field, List<List<bool>> rows,
    List<List<bool>> cols, List<List<bool>> blocks, int level) {
  while (level < 81) {
    int x = Random().nextInt(9);
    int y = Random().nextInt(9);
    if (field[x][y] == 0) continue;
    if (checkUnique(field, rows, cols, blocks, x, y)) {
      int k = x ~/ 3 * 3 + y ~/ 3;
      rows[x][field[x][y] - 1] = false;
      cols[y][field[x][y] - 1] = false;
      blocks[k][field[x][y] - 1] = false;
      field[x][y] = 0;
    }
    level++;
  }
}

// [i,j]这个位置已经有一个数字了
// 将[i,j]这个位置依次填写1-9除原数字,然后解数独，判断是否有两个以上的解
// 如果无解，即只有唯一解，返回true
// 如果有解，即至少有两个解，返回false
bool checkUnique(List<List<int>> field, List<List<bool>> rows,
    List<List<bool>> cols, List<List<bool>> blocks, int x, int y) {
  int k = x ~/ 3 * 3 + y ~/ 3;
  List<List<int>> tmpField = List.generate(
      9, (i) => List.generate(9, (index) => field[i][y], growable: false),
      growable: false);
  List<List<bool>> tmpRows = List.generate(
      9, (i) => List.generate(9, (index) => rows[i][y], growable: false),
      growable: false);
  List<List<bool>> tmpCols = List.generate(
      9, (i) => List.generate(9, (index) => cols[i][y], growable: false),
      growable: false);
  List<List<bool>> tmpBlocks = List.generate(
      9, (i) => List.generate(9, (index) => blocks[i][y], growable: false),
      growable: false);

  tmpRows[x][field[x][y] - 1] = false;
  tmpCols[y][field[x][y] - 1] = false;
  tmpBlocks[k][field[x][y] - 1] = false;

  for (int n = 0; n < 9; n++) {
    if ((n + 1) != field[x][y]) {
      tmpField[x][y] = (n + 1);
      if (!tmpRows[x][n] && !tmpCols[y][n] && tmpBlocks[k][n]) {
        tmpRows[x][n] = true;
        tmpCols[y][n] = true;
        tmpBlocks[k][n] = true;
        if (dfs(tmpField, tmpRows, tmpCols, tmpBlocks)) return false;
        tmpRows[x][n] = false;
        tmpCols[y][n] = false;
        tmpBlocks[k][n] = false;
      }
    }
  }
  return true;
}

void clearFRCB(List<List<int>> field, List<List<bool>> rows,
    List<List<bool>> cols, List<List<bool>> blocks) {
  for (int i = 0; i < 9; i++) {
    for (int j = 0; j < 9; j++) {
      field[i][j] = 0;
      rows[i][j] = false;
      cols[i][j] = false;
      blocks[i][j] = false;
    }
  }
}
