/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf.layout
{
	import flash.text.engine.*;
	
	import org.tinytlf.ITextEngine;
	import org.tinytlf.analytics.ITextEngineAnalytics;
	import org.tinytlf.conversion.ITextBlockFactory;
	import org.tinytlf.layout.properties.*;
	import org.tinytlf.util.TinytlfUtil;
	import org.tinytlf.util.fte.TextBlockUtil;
	
	public class TextLayoutBase implements ITextLayout
	{
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
		
		/**
		 * Clears the shapes out of this Layout's ITextContainers.
		 */
		public function resetShapes():void
		{
			for(var i:int = 0; i < containers.length; i++)
			{
				containers[i].resetShapes();
			}
		}
		
		protected var _containers:Vector.<ITextContainer>;
		
		public function get containers():Vector.<ITextContainer>
		{
			return _containers;
		}
		
		public function addContainer(container:ITextContainer):void
		{
      if (_containers == null) {
        _containers = new Vector.<ITextContainer>(1, true);
        _containers[0] = container;
      }
      else if (_containers.indexOf(container) != -1) {
        return;
      }
      else {
        for (var i:int = 0; i < _containers.length; i++) {
          container[i].scrollable = false;
        }
        
        _containers.fixed = false;
        _containers[_containers.length] = container;
        _containers.fixed = true;
      }
      
			container.engine = engine;
			container.scrollable = true;
			engine.interactor.getMirror(container);
		}
		
		public function removeContainer(container:ITextContainer):void
		{
			var i:int = containers.indexOf(container);
			if(i == -1)
				return;
			
      _containers.fixed = false;
			_containers.splice(i, 1);
      _containers.fixed = true;
			container.engine = null;
		}
		
		public function getContainerForLine(line:TextLine):ITextContainer
		{
			var n:int = containers.length;
			
			for(var i:int = 0; i < n; i++)
			{
				if(containers[i].hasLine(line))
				{
					return containers[i];
				}
			}
			
			return null;
		}
		
		/**
		 * Renders all the TextLines from the list of TextBlocks into this
		 * layout's ITextContainers. Stops when it runs out of TextBlocks or
		 * runs out of space.
		 */
		public function render():void
		{
			if(!containers || !containers.length)
				return;

      var container:ITextContainer;
      for each (container in _containers) {
        container.preLayout();
      }
			
			var factory:ITextBlockFactory = engine.blockFactory;
			var analytics:ITextEngineAnalytics = engine.analytics;
			
			var blockIndex:int = analytics.indexAtPixel(engine.scrollPosition);
			blockIndex = blockIndex <= 0 ? 0 : blockIndex;
			
			var block:TextBlock = factory.getTextBlock(blockIndex);
			container = containers[0];
			
			beginRender(blockIndex);
			
			while(block && container)
			{
				container = renderBlockAcrossContainers(block, container);
				
				cacheBlock(block, blockIndex);
				
				block.releaseLineCreationData();
				
				// Only get the next block if there's a container.
				if(container)
				{
					block = factory.getTextBlock(++blockIndex);
				}
			}
			
			endRender(blockIndex);
			
			for each (container in _containers) {
        container.postLayout();
      }
		}
		
		/**
		 * Renders all the lines from the input TextBlock into the containers,
		 * starting from the container specified by <code>startContainer</code>.
		 *
		 * This method should render every line from the TextBlock into the
		 * ITextContainers.
		 *
		 * @returns The last ITextContainer rendered into, or null if there are
		 * no containers left.
		 */
		protected function renderBlockAcrossContainers(block:TextBlock, 
													   startContainer:ITextContainer):ITextContainer
		{
			// If it's an invalid block that's already been rendered, re-render
			// the damaged lines across multiple containers
			if(TextBlockUtil.isInvalid(block) && block.firstLine)
				return renderInvalidLines(block, startContainer);
			
			// If it's never been rendered, render all the lines across the
			// containers.
			// 
			// Or if the block is 100% valid, still call the ITC's layout 
			// method, but it should be smart enough to skip lines from this
			// textblock.
			
			return renderAllLines(block, startContainer);
		}
		
		protected function renderInvalidLines(block:TextBlock, container:ITextContainer):ITextContainer
		{
			// Check if there's any lines we need to render at the end
			// of the TextBlock.
			// Note: not sure if this case actually happens...
			if(block.firstLine && !block.firstInvalidLine)
			{
				return renderLines(block, block.lastLine, container);
			}
			// Otherwise re-render the invalid lines.
			else if(block.firstInvalidLine)
			{
				return renderLines(block, block.firstInvalidLine.previousLine, container);
			}
			
			return container;
		}
		
		protected function renderAllLines(block:TextBlock, container:ITextContainer):ITextContainer
		{
			return renderLines(block, null, container);
		}
		
		protected function renderLines(block:TextBlock, 
									   previousLine:TextLine, 
									   container:ITextContainer):ITextContainer
		{
			var containerIndex:int = containers.indexOf(container);
			var line:TextLine = container.layout(block, previousLine);
			
			while(line)
			{
				if(++containerIndex < containers.length)
					container = containers[containerIndex];
				else
					return null;
				
				line = container.layout(block, line);
			}
			
			return container;
		}
		
		protected function beginRender(startIndex:int):void
		{
			var a:ITextEngineAnalytics = engine.analytics;
			
			//Uncache the TextBlocks that exist before the startIndex
			for(var i:int = 0; i < startIndex; i += 1)
			{
				a.removeBlockAt(i);
			}
		}
		
		protected function cacheBlock(block:TextBlock, index:int):void
		{
			var lp:ILayoutProperties = block.userData;
			engine.analytics.addBlockAt(block, index, lp.height + lp.padding.height);
		}
		
		protected function endRender(lastIndex:int):void
		{
			var a:ITextEngineAnalytics = engine.analytics;
			
			//Uncache any blocks after the end index.
			for(var n:int = engine.blockFactory.numBlocks; lastIndex < n; lastIndex += 1)
			{
				a.removeBlockAt(lastIndex);
			}
		}
	}
}

