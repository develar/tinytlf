package org.tinytlf.layout.constraints {
import flash.errors.IllegalOperationError;
import flash.text.engine.TextLine;

public class FloatConstraint implements ITextConstraint {
  private var _float:String;
  private var line:TextLine;
  
  public function FloatConstraint(float:String) {
    _float = float;
  }
  
  public function initialize(untypedLine:*):void {
    line = untypedLine;
  }

  public function get content():* {
    return line;
  }

  public function get constraintMarker():Object {
    return null;
  }

  public function get float():String {
    return _float;
  }

  public function get majorValue():Number {
    return line.x;
  }
  public function set majorValue(value:Number):void {
    line.x = value;
  }

  public function get majorSize():Number {
    return line.width;
  }
  public function set majorSize(value:Number):void {
    throw new IllegalOperationError();
  }

  public function getMajorValue(atMinor:Number, fromMajor:Number):Number {
    // for first line atMinor equals 0, so, overlap occurred (we need more robust float block implementations)
    if (atMinor == 0 && (line.ascent - line.y) < 0.1) {
      return line.x;
    }
    
    if (atMinor < line.y || atMinor >= (line.y + line.descent)) {
      return -1;
    }
    else {
      return line.x;
    }
  }
}
}