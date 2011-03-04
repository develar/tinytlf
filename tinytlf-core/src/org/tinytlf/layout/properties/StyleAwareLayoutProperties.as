/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf.layout.properties
{
    import flash.text.engine.*;

import org.tinytlf.layout.constraints.ITextConstraint;

import org.tinytlf.styles.StyleAwareActor;
    
	/**
	 * This class is essentially a struct which stores values that describe the
	 * layout values that should be applied to lines rendered from a TextBlock.
	 * 
	 * This is associated via the TextBlock's <code>userData</code> value, and 
	 * is the only valid value for the <code>userData</code> of a TextBlock in
	 * tinytlf.
	 * 
	 * LayoutProperties is dynamic and extends from the tinytlf styling 
	 * framework, so he's not without extension points. Most of the inline and 
	 * block level layout values are defined as public members, but feel free to
	 * tack on properties as you need.
	 */
    public dynamic class StyleAwareLayoutProperties extends StyleAwareActor implements ILayoutProperties
    {
        public function StyleAwareLayoutProperties(props:Object = null)
        {
			super(props);
        }

    public var x:Number = 0;
    public var y:Number = 0;

    public var width:Number = 0;
    public var _height:Number = 0;
    public var _leading:Number = 0;
    public var _textIndent:Number = 0;

    public var _textAlign:String = TextAlign.LEFT;
    public var textDirection:String = TextDirection.LTR;
    public var textTransform:String = TextTransform.NONE;
    public var float:String;
    
    public var display:String = TextDisplay.INLINE;
    public var letterSpacing:Boolean = false;
    public var locale:String = 'en';
    
    public function get textIndent():Number {
      return _textIndent;
    }
    public function set textIndent(value:Number):void {
      _textIndent = value;
    }
    
    public function get textAlign():String {
      return _textAlign;
    }
		
		override protected function applyProperty(property:String, destination:Object):void
		{
			if(property === "textAlign" && destination is TextBlock)
			{
				setupBlockJustifier(TextBlock(destination));
				return;
			}
			
			super.applyProperty(property, destination);
		}
		
		/**
		 * Utility method which applies justification properties to the 
		 * TextBlock before it's rendered.
		 */
		protected function setupBlockJustifier(block:TextBlock):void
		{
			var justification:String = LineJustification.UNJUSTIFIED;
			var justifier:TextJustifier = TextJustifier.getJustifierForLocale(locale);
			
			if(textAlign == TextAlign.JUSTIFY)
				justification = LineJustification.ALL_BUT_LAST;
			
			justifier.lineJustification = justification;
			
			if(	!block.textJustifier || 
				block.textJustifier.lineJustification != justification || 
				block.textJustifier.locale != locale)
			{
				applyTo(justifier);
				block.textJustifier = justifier;
			}
		}

    private var _padding:Insets = new Insets();
    public function get padding():Insets {
      return null;
    }

    public function set height(value:Number):void {
      _height = value;
    }

    public function get leading():Number {
      return _leading;
    }

    public function get height():Number {
      return _height;
    }

    public function get constraint():ITextConstraint {
      return null;
    }

    public function set constraint(value:ITextConstraint):void {
    }
  }
}

