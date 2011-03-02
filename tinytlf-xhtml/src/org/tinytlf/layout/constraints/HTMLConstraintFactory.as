package org.tinytlf.layout.constraints
{
import flash.text.engine.ContentElement;
import flash.text.engine.TextLine;

import org.tinytlf.layout.constraints.horizontal.HConstraintFactory;

public class HTMLConstraintFactory extends HConstraintFactory
	{
		override public function getConstraint(element:ContentElement, line:TextLine, atomIndex:int):ITextConstraint
		{
			switch(element.userData)
			{
				case null:
				case undefined:
				case 'lineBreak':
					return null;
				case 'listItemOutside':
					return new OutsideLIConstraint(element, line);
				case 'listItemInside':
					return new InsideLIConstraint(element, line);
				default:
					return super.getConstraint(element, line, atomIndex);
			}
		}
	}
}