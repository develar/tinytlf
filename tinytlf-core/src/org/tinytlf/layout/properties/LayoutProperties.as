package org.tinytlf.layout.properties {
import org.tinytlf.layout.constraints.ITextConstraint;

public class LayoutProperties implements ILayoutProperties {
  private static const defaultPadding:EmptyInsets = new EmptyInsets();

  public function LayoutProperties(padding:Insets = null) {
    _padding = padding == null ? defaultPadding : padding;
  }

  private var _padding:Insets;
  public function get padding():Insets {
    return _padding;
  }

  private var _textIndent:Number;
  public function get textIndent():Number {
    return _textIndent;
  }
  public function set textIndent(value:Number):void {
    _textIndent = value;
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
