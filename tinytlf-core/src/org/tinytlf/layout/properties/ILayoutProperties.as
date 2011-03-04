package org.tinytlf.layout.properties {
import org.tinytlf.layout.constraints.ITextConstraint;

public interface ILayoutProperties {
  function get padding():Insets;

  function get textIndent():Number;
  function set textIndent(value:Number):void;

  function get textAlign():String;

  function get height():Number;
  function set height(height:Number):void;

  function get leading():Number;
  
  function get constraint():ITextConstraint;
  function set constraint(value:ITextConstraint):void;
}
}
