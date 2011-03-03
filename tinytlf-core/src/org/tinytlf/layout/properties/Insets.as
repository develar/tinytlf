package org.tinytlf.layout.properties {
public class Insets {
  public static const EMPTY:Insets = new Insets();
  
  public var left:Number = 0;
  public var top:Number = 0;
  public var right:Number = 0;
  public var bottom:Number = 0;
  
  public function get width():Number {
    return left + right;
  }
  
   public function get height():Number {
    return top + bottom;
  }
}
}