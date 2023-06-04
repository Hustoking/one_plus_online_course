import 'package:flutter/material.dart';

class AlwaysBouncingScrollPhysics extends AlwaysScrollableScrollPhysics {
  const AlwaysBouncingScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  AlwaysBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return AlwaysBouncingScrollPhysics(parent: BouncingScrollPhysics(parent: ancestor));
  }
}
