package input;

import openfl.events.Event;

/**
 * ...
 * @author 
 */
class AvatarControllerEvent extends Event
{
	static public inline var DIRECTION_CHANGE:String = "AvatarControllerEvent.DirectionChange";

	public function new( label:String, bubbles:Bool = false, cancelable:Bool = false )
	{
		super( label, bubbles, cancelable);
	}
	
}