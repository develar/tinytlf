package org.tinytlf.layout.constraints
{
import flash.text.engine.ContentElement;
import flash.text.engine.TextLine;

public interface IConstraintFactory
	{
		function getConstraint(element:ContentElement, line:TextLine, atomIndex:int):ITextConstraint;
	}
}