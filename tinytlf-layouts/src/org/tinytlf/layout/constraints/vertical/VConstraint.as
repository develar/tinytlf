package org.tinytlf.layout.constraints.vertical
{
	import flash.text.engine.ContentElement;
	
	import org.tinytlf.layout.constraints.TextConstraintBase;
	
	/**
	 * The base class for a constraint that exists within a vertical ttb or btt
	 * text field.
	 */
	public class VConstraint extends TextConstraintBase
	{
		public function VConstraint(constraintElement:ContentElement = null)
		{
			super(constraintElement);
		}
		
		override public function get majorValue():Number
		{
			return y;
		}
		
		override public function set majorValue(value:Number):void
		{
			y = value;
		}
		
		override public function get majorSize():Number
		{
			return totalHeight;
		}
		
		override public function set majorSize(value:Number):void
		{
			height = value;
		}
		
		override public function getMajorValue(atMinor:Number, fromMajor:Number):Number
		{
			if(atMinor < x)
				return -1;
			
			if(atMinor > (x + totalWidth))
				return -1;
			
			if(fromMajor < y)
				return fromMajor;
			
			if(fromMajor >= y && fromMajor < (y + totalHeight))
				return (y + totalHeight);
			
			return fromMajor;
		}
	}
}