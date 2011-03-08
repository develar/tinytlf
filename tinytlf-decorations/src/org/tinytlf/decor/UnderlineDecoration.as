/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf.decor
{
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.text.engine.ContentElement;
import flash.text.engine.TextLineMirrorRegion;

public class UnderlineDecoration extends ContentElementDecoration
    {
		public function UnderlineDecoration(styleObject:Object = null)
		{
			super(styleObject);
		}
		
		override protected function processContentElement(element:ContentElement):void
		{
			super.processContentElement(element);
			setStyle("underlineThickness", element.elementFormat.getFontMetrics().underlineThickness);
		}
		
		override protected function processTLMR(tlmr:TextLineMirrorRegion):Rectangle
		{
			var rect:Rectangle = tlmr.bounds.clone();
			rect.y = emBox.y;
			rect.height = emBox.height - getStyle('underlineThickness');
			rect.offset(tlmr.textLine.x, tlmr.textLine.y);
			return rect;
		}

      override public function draw(bounds:Vector.<Rectangle>):void {
        super.draw(bounds);

        var rect:Rectangle;
        var g:Graphics;
        var thickness:Number = getStyle("underlineThickness") || 2;
        var layer:Sprite;

        for (var i:int = bounds.length - 1; i > -1; i--) {
          rect = bounds[i];
          layer = rectToLayer(rect);
          if (!layer) {
            continue;
          }

          g = layer.graphics;

          g.lineStyle(
                  thickness,
                  getStyle("underlineColor") || getStyle("color") || 0x00,
                  getStyle("underlineAlpha") || getStyle("alpha") || 1,
                  getStyle("pixelHinting") || false,
                  getStyle("scaleMode") || "normal",
                  getStyle("caps") || null,
                  getStyle("joints") || null,
                  getStyle("miterLimit") || 3);

          g.moveTo(rect.left, rect.bottom - thickness);
          g.lineTo(rect.right, rect.bottom - thickness);
          g.endFill();
          g.lineStyle();
        }
      }
    }
}

