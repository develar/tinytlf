package org.tinytlf.layout.constraints
{
import flash.display.DisplayObject;
import flash.geom.Rectangle;
import flash.text.engine.*;

import org.tinytlf.ITextEngine;
import org.tinytlf.layout.properties.StyleAwareLayoutProperties;

/**
	 * The base text constraint.
	 */
	public class TextConstraintBase implements ITextConstraint
	{
    private static var emptyLayoutProperties:StyleAwareLayoutProperties = new StyleAwareLayoutProperties();
    
    protected var x:Number;
    protected var y:Number;
    protected var width:Number;
    protected var height:Number;
    
    protected var elementLayoutProperties:StyleAwareLayoutProperties;
    
		public function TextConstraintBase(constraintElement:* = null)
		{
			if(constraintElement)
				initialize(constraintElement);
		}
		
		protected var engine:ITextEngine;

    public function initialize(e:*):void {
      element = e;
    }
    
    protected function doInitialize(element:ContentElement, line:TextLine):void {
      initialize(element);
      
      marker = element.userData == null ? line.textBlock.userData : element.userData;
      engine = ITextEngine(line.userData);
      elementLayoutProperties = marker is StyleAwareLayoutProperties ? StyleAwareLayoutProperties(marker) : emptyLayoutProperties;
        
      x = line.x;
      y = line.y;
        
      if (element is GraphicElement) {
        var g:GraphicElement = GraphicElement(element);
        var dObj:DisplayObject = g.graphic;
        if (elementLayoutProperties.float) {
          dObj.x = elementLayoutProperties.padding.left;
          dObj.y = elementLayoutProperties.padding.top;
        }
        else {
          var bounds:Rectangle = dObj.getBounds(line);
          x = bounds.x;
          y = line.y;
          width = bounds.width || g.elementWidth;
          height = bounds.height || g.elementHeight;
        }
      }
    }
		
		private var marker:Object;
		public function get constraintMarker():Object
		{
			return marker;
		}
		
		public function get float():String
		{
			return elementLayoutProperties.float;
		}
		
		private var element:*;
		public function get content():*
		{
			return element;
		}
		
		public function get majorValue():Number
		{
			return 0;
		}
		
		public function set majorValue(value:Number):void
		{
		}
		
		public function get majorSize():Number
		{
			return 0;
		}
		
		public function set majorSize(value:Number):void
		{
		}

		public function getMajorValue(atMinor:Number, fromMajor:Number):Number
		{
			return -1;
		}
		
		protected function get totalWidth():Number
		{
			return elementLayoutProperties.width + elementLayoutProperties.paddingLeft + elementLayoutProperties.paddingRight;
		}
		
		protected function get totalHeight():Number
		{
			return height + elementLayoutProperties.padding.height;
		}
	}
}