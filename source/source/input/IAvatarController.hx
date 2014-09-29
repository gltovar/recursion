package input;
import openfl.events.EventDispatcher;

/**
 * @author 
 */

interface IAvatarController 
{
	public var dispatcher(default, null):EventDispatcher;
	public var currentDirection(default, null):Directions;
	public function update():Void;
}