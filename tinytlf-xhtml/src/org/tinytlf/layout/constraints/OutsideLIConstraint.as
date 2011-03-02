package org.tinytlf.layout.constraints
{
import flash.text.engine.ContentElement;
import flash.text.engine.TextLine;

import org.tinytlf.layout.constraints.horizontal.HConstraint;
import org.tinytlf.layout.properties.TextFloat;

public class OutsideLIConstraint extends HConstraint
	{
		public function OutsideLIConstraint(element:ContentElement, line:TextLine)
		{
			super(element, line);
		}
		
		override public function get float():String
		{
			return TextFloat.LEFT;
		}
		
		override public function getMajorValue(atMinor:Number, fromMajor:Number):Number
		{
			return x + totalWidth;
		}
	}
}