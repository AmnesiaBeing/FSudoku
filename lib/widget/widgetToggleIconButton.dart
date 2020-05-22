import 'package:flutter/material.dart';

// 一个按一下切换图标的按钮
class ToggleIconButton extends StatefulWidget {
  // onPressed 的时候，返回T或者F的图标
  final Icon iconT;
  final Icon iconF;
  final bool value;
  final void Function(bool) onPressed;

  ToggleIconButton(
      {Key key,
      this.iconT,
      this.iconF,
      this.value = true,
      @required this.onPressed})
      : super(key: key);

  @override
  _ToggleIconButtonState createState() => _ToggleIconButtonState();
}

class _ToggleIconButtonState extends State<ToggleIconButton> {
  bool _value;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _value ? widget.iconT : widget.iconF,
      onPressed: _handleOnPressed,
    );
  }

  void _handleOnPressed() {
    widget.onPressed(_value);
    setState(() {
      _value = !_value;
    });
  }
}
