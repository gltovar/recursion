package avatar ;

import openfl.events.Event;

/**
 * ...
 * @author 
 */
class AvatarEvent extends Event
{
	static public inline var DIRECTION_CHANGE:String = "AvatarControllerEvent.DirectionChange";
	static public inline var BUMPED:String = "AvatarControllerEvent.Bumped";

	public function new( label:String, bubbles:Bool = false, cancelable:Bool = false )
	{
		super( label, bubbles, cancelable);
	}
	
}