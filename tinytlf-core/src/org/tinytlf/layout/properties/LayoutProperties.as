package org.tinytlf.layout.properties {
import org.tinytlf.layout.constraints.ITextConstraint;

public class LayoutProperties implements ILayoutProperties {
  private static const defaultPadding:EmptyInsets = new EmptyInsets();

  private var _padding:Insets = defaultPadding;
  public function get padding():Insets {
    return _padding;
  }

  public function get textIndent():Number {
    return 0;
  }

  public function get textAlign():String {
    return TextAlign.LEFT;
  }

  private var _height:Number;
  public function get height():Number {
    return _height;
  }
  public function set height(value:Number):void {
    _height = value;
  }

  public function get leading():Number {
    return 0;
  }

  private var _constraint:ITextConstraint;
  public function get constraint():ITextConstraint {
    return _constraint;
  }

  public function set constraint(value:ITextConstraint):void {
    _constraint = value;
  }
}
}
