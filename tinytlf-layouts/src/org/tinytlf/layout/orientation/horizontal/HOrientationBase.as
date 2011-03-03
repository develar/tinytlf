package org.tinytlf.layout.orientation.horizontal
{
import flash.text.engine.TextBlock;
import flash.text.engine.TextLine;
import flash.text.engine.TextLineValidity;
import flash.utils.Dictionary;

import org.tinytlf.layout.IConstraintTextContainer;
import org.tinytlf.layout.constraints.FloatConstraint;
import org.tinytlf.layout.orientation.TextFlowOrientationBase;
import org.tinytlf.layout.properties.*;
import org.tinytlf.util.TinytlfUtil;
import org.tinytlf.util.fte.TextBlockUtil;

/**
	 * The base class for the IMajorOrientation and IMinorOrientation classes
	 * for horizontal-based languages. Languages which are left-to-right
	 * (typically the Romance languages) or right-to-left (Hebrew, Arabic, etc.)
	 * use either the LTR or RTL major orientations for their horizontal
	 * alignment and spacing, but rely on the same (vertical) minor orientation.
	 */
	public class HOrientationBase extends TextFlowOrientationBase
	{
		public function HOrientationBase(target:IConstraintTextContainer)
		{
			super(target);
		}
		
		override public function getLineSize(block:TextBlock, previousLine:TextLine):Number
		{
			var lp:ILayoutProperties = TinytlfUtil.getLP(block);
			var totalWidth:Number = getTotalSize(block);
			
			if(previousLine == null)
				totalWidth -= lp.textIndent;
			
			return totalWidth - lp.padding.width;
		}
		
		override public function position(line:TextLine):void
		{
			var props:ILayoutProperties = TinytlfUtil.getLP(line);
			var totalWidth:Number = getTotalSize(line);
			
			var lineWidth:Number = line.width;
			var x:Number = 0;
			
			if(!line.previousLine)
				x += props.textIndent;
			
			switch(props.textAlign)
			{
				case TextAlign.LEFT:
				case TextAlign.JUSTIFY:
					x += props.padding.left;
					break;
				case TextAlign.CENTER:
					x = (totalWidth - lineWidth) * 0.5;
					break;
				case TextAlign.RIGHT:
					x = totalWidth - lineWidth + props.padding.right;
					break;
			}
			
			line.x = x;
		}
		
		override protected function getTotalSize(from:Object = null):Number
		{
      if (from != null) {
        var lp:ILayoutProperties = TinytlfUtil.getLP(from);
        if (lp is StyleAwareLayoutProperties) {
          return StyleAwareLayoutProperties(lp).width;
        }
      }

      if (target.explicitWidth != target.explicitWidth) {
        return TextLine.MAX_LINE_WIDTH;
      }

      return target.explicitWidth;
		}
		
		private const importantLines:Vector.<TextLine> = new <TextLine>[];
		
		override public function checkTargetBounds(latestLine:TextLine):Boolean
		{
			if(super.checkTargetBounds(latestLine))
				return true;

      if (!(ILayoutProperties(latestLine.textBlock.userData).constraint is FloatConstraint)) {
        importantLines.push(latestLine);
      }
			
			return false;
		}
		
		override public function postTextBlock(block:TextBlock):void
		{
			super.postTextBlock(block);
			
			var layoutProperties:ILayoutProperties = block.userData;
      var h:Number = 0;
      var line:TextLine = block.firstLine;
      do {
        h += line.height + layoutProperties.leading;
      }
      while ((line = line.nextLine) != null);
      
      layoutProperties.height = h;
		}
    
    override public function preLayout():void
		{
			super.preLayout();
			
			target.totalHeight = 0;
		}
		
		override public function postLayout():void
		{
			super.postLayout();
			
			//Attempt to calculate the measured height of the target container.
			
			var measuredHeight:Number = 0;
			
			// A dictionary of blocks, but also stores the number of lines
			// from each block that exist in this container.
			var blocks:Dictionary = new Dictionary(true);
			var block:TextBlock;
			var props:ILayoutProperties;
			for(var i:int = 0, n:int = importantLines.length; i < n; i += 1)
			{
				if(importantLines[i].validity != TextLineValidity.VALID)
					continue;
				
				block = importantLines[i].textBlock;
				
				if(block in blocks)
					continue;
				
				blocks[block] = true;
				props = block.userData;

        if (target.hasLine(block.firstLine)) {
          measuredHeight += props.padding.top;
        }

        if (!TextBlockUtil.isInvalid(block) && target.hasLine(block.lastLine)) {
          measuredHeight += props.padding.bottom;
        }
				
				measuredHeight += props.height;
			}
			
			target.measuredHeight = measuredHeight;
      if (target.totalHeight == 0) {
        target.totalHeight = measuredHeight;
      }
			
			//Don't hold onto these lines, they will be reused later.
			importantLines.length = 0;
		}
	}
}