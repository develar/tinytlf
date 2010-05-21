package org.tinytlf.decor.decorations
{
  
  import flash.display.Sprite;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import org.tinytlf.decor.TextDecoration;
  
  public class StrikeThroughDecoration extends TextDecoration
  {
    public function StrikeThroughDecoration(styleName:String="")
    {
      super(styleName);
    }
    
    override public function draw(parent:Sprite, bounds:Vector.<Rectangle>):void
    {
      super.draw(parent, bounds);
      
      var start:Point;
      var end:Point;
      var rect:Rectangle;
      
      while(bounds.length > 0)
      {
        rect = bounds.pop();
        
        start = new Point(rect.x, rect.y + (rect.height * 0.5));
        end = new Point(rect.x + rect.width, rect.y + (rect.height * 0.5));
        
        parent.graphics.lineStyle(
          getStyle("weight") || 2,
          getStyle("color") || getStyle("color") || 0x00,
          getStyle("alpha") || 1,
          getStyle("pixelHinting") || false,
          getStyle("scaleMode") || "normal",
          getStyle("caps") || null,
          getStyle("joints") || null,
          getStyle("miterLimit") || 3);
        
        parent.graphics.moveTo(start.x, start.y);
        parent.graphics.lineTo(end.x, end.y);
      }
    }
  }
}