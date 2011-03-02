package org.tinytlf.layout.constraints.horizontal
{
import flash.text.engine.ContentElement;
import flash.text.engine.TextLine;

import org.tinytlf.layout.constraints.*;

public class HConstraintFactory implements IConstraintFactory
	{
		public function getConstraint(element:ContentElement, line:TextLine, atomIndex:int):ITextConstraint
		{
			return new HConstraint(element, line);
		}
	}
}