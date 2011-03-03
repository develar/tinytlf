package org.tinytlf.layout.properties {
public final class EmptyInsets extends Insets {
  override public function get width():Number {
    return 0;
  }

  override public function get height():Number {
    return super.height;
  }
}
}
