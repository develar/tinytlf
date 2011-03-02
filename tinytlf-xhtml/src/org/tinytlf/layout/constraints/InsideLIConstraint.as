package org.tinytlf.layout.constraints
{
import flash.text.engine.ContentElement;
import flash.text.engine.TextLine;

import org.tinytlf.layout.constraints.horizontal.HConstraint;
import org.tinytlf.layout.properties.TextFloat;

public class InsideLIConstraint extends HConstraint
	{
		public function InsideLIConstraint(element:ContentElement, line:TextLine)
		{
			super(element, line);
		}
		
		override public function get float():String
		{
			return TextFloat.LEFT;
		}
		
		override public function initialize(e:*):void
		{
			super.initialize(e);
			
			x = majorSize;
		}
		
		override public function getMajorValue(atMinor:Number, fromMajor:Number):Number
		{
			return x;
		}
	}
}