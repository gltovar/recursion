package input;
import openfl.events.EventDispatcher;

/**
 * ...
 * @author 
 */
class AvatarControllerReplay extends FlxBasic implements IAvatarController
{

	public function new() 
	{
		
	}
	
	/* INTERFACE input.IAvatarController */
	
	function get_dispatcher():EventDispatcher 
	{
		return _dispatcher;
	}
	
	function get_currentDirection():Directions 
	{
		return _currentDirection;
	}
	
}