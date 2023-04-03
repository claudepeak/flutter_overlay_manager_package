import 'package:flutter/material.dart';

class OverlayManager {
  OverlayEntry? _overlay;
  late Offset _offset;
  late Size _size;
  late GlobalKey _dimensionKey;
  late LayerLink _layerLink;

  OverlayManager._();

  static OverlayManager create() => OverlayManager._();

  void setRequirements(GlobalKey key, [LayerLink? link]) {
    _dimensionKey = key;
    _layerLink = link ?? LayerLink();
    _initRenderBox();
  }

  void _initRenderBox() {
    if (_dimensionKey.currentContext != null) {
      final renderBox = _dimensionKey.currentContext!.findRenderObject() as RenderBox;
      _offset = renderBox.localToGlobal(Offset.zero);
      _size = renderBox.size;
    } else {
      _offset = Offset.zero;
      _size = Size.zero;
    }
  }

  LayerLink get layerLink => _layerLink;
  Size get size => _size;
  Offset get offset => _offset;

  void show(BuildContext context, Widget child) {
    if (Overlay.of(context) != null) {
      _overlay = OverlayEntry(builder: (context) => child);
      Overlay.of(context)!.insert(_overlay!);
    }
  }

  bool mounted() {
    return _overlay != null;
  }

  void close({bool rootNavigator = true}) {
    if (_overlay != null) {
      _overlay!.remove();
      _overlay = null;
    }
  }

  void dispose() {
    if (_overlay != null) close();
  }
}
