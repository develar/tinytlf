package org.tinytlf.layout.constraints.horizontal
{
import flash.text.engine.ContentElement;
import flash.text.engine.TextLine;

import org.tinytlf.layout.constraints.TextConstraintBase;
import org.tinytlf.layout.properties.TextFloat;

/**
	 * The base class for a constraint that exists within a horizontal ltr or
	 * rtl text field.
	 */
	public class HConstraint extends TextConstraintBase
	{
		public function HConstraint(element:ContentElement, line:TextLine)
		{
			doInitialize(element, line);
		}
		
		override public function get majorValue():Number
		{
			return x;
		}
		
		override public function set majorValue(value:Number):void
		{
			x = value;
		}
		
		override public function get majorSize():Number
		{
			return totalWidth;
		}
		
		override public function set majorSize(value:Number):void
		{
			width = value;
		}
		
		override public function getMajorValue(atMinor:Number, fromMajor:Number):Number
		{
			if(atMinor < y)
				return -1;
			
			if(atMinor >= (y + totalHeight))
				return -1;
			
			if(float == TextFloat.LEFT)
			{
				return fromLeft(atMinor, fromMajor);
			}
			else if(float == TextFloat.RIGHT)
			{
				return fromRight(atMinor, fromMajor);
			}
			
			return fromLeft(atMinor, fromMajor);
		}
		
		private function fromLeft(atMinor:Number, fromMajor:Number):Number
		{
			if(fromMajor < x)
				return fromMajor;
			
			if(fromMajor >= x && fromMajor < (x + totalWidth))
				return (x + totalWidth);
			
			return fromMajor;
		}
		
		private function fromRight(atMinor:Number, fromMajor:Number):Number
		{
			if(fromMajor < x)
				return x;
			
			if(fromMajor >= x && fromMajor < (x + totalWidth))
				return (x - totalWidth);
			
			return fromMajor;
		}
	}
}