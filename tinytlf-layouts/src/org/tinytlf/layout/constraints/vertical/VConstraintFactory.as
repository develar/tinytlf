package org.tinytlf.layout.constraints.vertical
{
import flash.text.engine.ContentElement;
import flash.text.engine.TextLine;

import org.tinytlf.layout.constraints.*;

public class VConstraintFactory implements IConstraintFactory
	{
		public function getConstraint(element:ContentElement, line:TextLine, atomIndex:int):ITextConstraint
		{
			return new VConstraint(element);
		}
	}
}