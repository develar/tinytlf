/*
* Copyright (c) 2010 the original author or authors
*
* Permission is hereby granted to use, modify, and distribute this file
* in accordance with the terms of the license agreement accompanying it.
*/
package org.tinytlf.layout
{
	import flash.display.*;
import flash.errors.IllegalOperationError;
import flash.text.engine.*;
	import flash.utils.Dictionary;
	
	import org.tinytlf.ITextEngine;
	
	public class TextContainerBase implements ITextContainer
	{
		public function TextContainerBase(container:Sprite, 
										  explicitWidth:Number = NaN, 
										  explicitHeight:Number = NaN)
		{
			this.target = container;
			
			_explicitWidth = explicitWidth;
			_explicitHeight = explicitHeight;
		}
		
		public function layout(block:TextBlock, line:TextLine):TextLine
		{
			return null;
		}

    private var c:Dictionary = new Dictionary();
    
    protected function doCreateTextLine(block:TextBlock, previousLine:TextLine, width:Number):TextLine {
      var line:TextLine;
      var isYoungOrphan:Boolean;
      if (youngOrphanCount != 0) {
        line = visibleLines[youngOrphanLinesIndices[--youngOrphanCount]];
        isYoungOrphan = true;
      }
      else if (orphanCount != 0) {
        line = orphanLines[--orphanCount];
      }

			if (line != null) {
				line = block.recreateTextLine(line, previousLine, width, 0.0, true);
        if (line == null) {
          c[isYoungOrphan ? visibleLines[youngOrphanLinesIndices[youngOrphanCount]] : orphanLines[orphanCount]] = true;
          isYoungOrphan ? youngOrphanCount++ : orphanCount++;
          return null;
        }
        else if (line != null && isYoungOrphan) {
          return line; // young orphan, already added to target and to visibleLines
        }
      }
      else {
        line = block.createTextLine(previousLine, width, 0.0, true);
      }

      if (line != null) {
        visibleLines.push(line);
        lines.addChild(line);
      }
      
      return line;
		}
		
		protected var _target:Sprite;
		
		public function get target():Sprite
		{
			return _target;
		}
		
		public function set target(doc:Sprite):void
		{
			if(doc == _target)
				return;
			
			_target = doc;
			
			foreground = Sprite(target.addChild(fgShapes || new Sprite()));
			lines = Sprite(target.addChild(lines || new Sprite()));
			background = Sprite(target.addChildAt(bgShapes || new Sprite(), 0));
		}
		
		protected var _engine:ITextEngine;
		
		public function get engine():ITextEngine
		{
			return _engine;
		}
		
		public function set engine(textEngine:ITextEngine):void
		{
			if(textEngine == _engine)
				return;
			
			_engine = textEngine;
		}
		
		private var bgShapes:Sprite;
		
		public function get background():Sprite
		{
			return bgShapes;
		}
		
		public function set background(shapesContainer:Sprite):void
		{
			if(shapesContainer === bgShapes)
				return;
			
			bgShapes = shapesContainer;
		}
		
		private var fgShapes:Sprite;
		
		public function get foreground():Sprite
		{
			return fgShapes;
		}
		
		public function set foreground(shapesContainer:Sprite):void
		{
			if(shapesContainer === fgShapes)
				return;
			
			fgShapes = shapesContainer;
			
			if(fgShapes)
			{
				// Don't let foreground shapes get in the way of interacting
				// with the TextLines.
				fgShapes.mouseEnabled = false;
				//But maybe we do want children to receive mouse events?
				//fgShapes.mouseChildren = false;
			}
		}
		
		private var lineContainer:Sprite;
		
		protected function get lines():Sprite
		{
			return lineContainer;
		}
		
		protected function set lines(container:Sprite):void
		{
			if(container === lineContainer)
				return;
			
			lineContainer = container;
			
			if(lineContainer)
			{
				lineContainer.mouseEnabled = true;
				lineContainer.mouseChildren = false;
			}
		}
		
		protected var _explicitHeight:Number = NaN;
		
		public function get explicitHeight():Number
		{
			return _explicitHeight;
		}
		
		public function set explicitHeight(value:Number):void
		{
			if(value === _explicitHeight)
				return;
			
			_explicitHeight = value;
			invalidateVisibleLines();
			engine.invalidate();
		}
		
		protected var _explicitWidth:Number = NaN;
		
		public function get explicitWidth():Number
		{
			return _explicitWidth;
		}
		
		public function set explicitWidth(value:Number):void
		{
			if(value === _explicitWidth)
				return;
			
			_explicitWidth = value;
			invalidateVisibleLines();
			engine.invalidate();
		}
		
		protected var height:Number = 0;
		
		public function get measuredHeight():Number
		{
			return height;
		}
		
		public function set measuredHeight(value:Number):void
		{
			if(value === height)
				return;
			
			height = value;
		}
		
		protected var width:Number = 0;
		
		public function get measuredWidth():Number
		{
			return width;
		}
		
		public function set measuredWidth(value:Number):void
		{
			if(value === width)
				return;
			
			width = value;
		}
		
		protected var tHeight:Number = 0;
		
		public function get totalHeight():Number
		{
			return tHeight;
		}
		
		public function set totalHeight(value:Number):void
		{
			if(value === tHeight)
				return;
			
			tHeight = value;
		}
		
		protected var tWidth:Number = 0;
		
		public function get totalWidth():Number
		{
			return tWidth;
		}
		
		public function set totalWidth(value:Number):void
		{
			if(value === tWidth)
				return;
			
			tWidth = value;
		}
		
		private var _scrollable:Boolean = true;
		public function get scrollable():Boolean
		{
			return _scrollable;
		}
		
		public function set scrollable(value:Boolean):void
		{
			if(value == _scrollable)
				return;
			
			_scrollable = value;
			if(engine)
				engine.invalidate();
		}
		
		private var orphanLines:Vector.<TextLine> = new <TextLine>[];
		private var orphanCount:int;
		private var youngOrphanCount:int;
		private const youngOrphanLinesIndices:Vector.<int> = new Vector.<int>();
		private var visibleLines:Vector.<TextLine> = new <TextLine>[];
		
		public function hasLine(line:TextLine):Boolean
		{
			return visibleLines.indexOf(line) != -1;
		}
		
		public function preLayout():void
		{	
      var n:int = visibleLines.length;
      youngOrphanLinesIndices.length = n;
			// Parse through and look for invalid lines.
			for(var i:int = 0; i < n; i += 1)
			{
				var line:TextLine = visibleLines[i];
				if (line.validity != TextLineValidity.VALID) {
				  youngOrphanLinesIndices[youngOrphanCount++] = i;
        }
			}
		}

    public function postLayout():void {
      if (youngOrphanCount == 0) {
        orphanLines.length = orphanCount;
        youngOrphanLinesIndices.length = 0;
        return;
      }
      
      orphanLines.length = orphanCount + youngOrphanCount;
      var visibleBlocks:Dictionary = engine.analytics.cachedBlocks;
      while (youngOrphanCount > 0) {
        var visibleLineIndex:int = youngOrphanLinesIndices[--youngOrphanCount];
        var line:TextLine = visibleLines[visibleLineIndex];
        assert(!(line.textBlock in visibleBlocks) || line in c);
        assert(orphanLines.indexOf(line) == -1);
        
        lines.removeChild(line);
        line.userData = null;
        orphanLines[orphanCount++] = line;
				visibleLines.splice(visibleLineIndex, 1);
      }
      
      assert(visibleLines.length == lines.numChildren);

      var invalidCount:int = 0;
      for each (var textLine:TextLine in visibleLines) {
        if (!(textLine.textBlock in visibleBlocks)) {
          invalidCount++;
        }
      }
      
      assert(invalidCount == 0);
      
      for (var i:int = 0, n:int = lines.numChildren; i < n; i++) {
        assert(TextLine(lines.getChildAt(i)).textBlock in visibleBlocks);
      }
      
      youngOrphanLinesIndices.length = 0;
      c = new Dictionary();
		}
    
    private function assert(value:Boolean):void {
      if (!value) {
        throw new IllegalOperationError("assert failed");
      }
    }
		
		public function resetShapes():void
		{
			clearShapeContainer(foreground);
			clearShapeContainer(background);
		}
		
		private function clearShapeContainer(container:Sprite):void
		{
			if(!container)
				return;
			
			container.graphics.clear();
			var n:int = container.numChildren;
			var child:DisplayObject;
			
			for(var i:int = 0; i < n; ++i)
			{
				child = container.getChildAt(i);
				if(child is Shape)
				{
					Shape(child).graphics.clear();
				}
				else if(child is Sprite)
				{
					Sprite(child).graphics.clear();
					while(Sprite(child).numChildren)
						Sprite(child).removeChildAt(0);
				}
				
			}
		}
		
		protected function registerLine(line:TextLine):void
		{
      line.userData = engine;
      engine.interactor.getMirror(line);

      var i:int = orphanLines.indexOf(line);
      assert(i == -1 || i >= orphanCount);
		}
		
		protected function getLineIndexFromTarget(line:TextLine):int
		{
			if(!target.contains(line))
				return -1;
			
			return target.getChildIndex(line);
		}
		
		protected function invalidateVisibleLines():void
		{
			var n:int = visibleLines.length;
			for(var i:int = 0; i < n; ++i)
			{
				visibleLines[i].validity = TextLineValidity.INVALID;
			}
			
			totalHeight = 0;
			totalWidth = 0;
		}
}
}
