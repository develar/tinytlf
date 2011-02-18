package org.tinytlf.interaction.gestures
{
	import flash.events.KeyboardEvent;
	
	import org.tinytlf.util.TinytlfUtil;
	
	[Event("keyDown")]
	public class CommandBGesture extends Gesture
	{
		public function CommandBGesture()
		{
			super();
			
			hsm.appendChild(<b/>);
		}
		
		public function b(event:KeyboardEvent):Boolean
		{
			var char:String = String.fromCharCode(event.charCode);
			var result:Boolean = (char == 'b' || char == 'B') && event.charCode && event.ctrlKey;
			return result;
		}
	}
}