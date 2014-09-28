package input;
import flixel.FlxG;

/**
 * ...
 * @author 
 */
class InputMap
{	
	public var inputMap:Map < Directions, Void->Bool > ;
	
	private var _up:Void->Bool;
	private var _down:Void->Bool;
	private var _left:Void->Bool;
	private var _right:Void->Bool;
	

	public function new( p_up:Void->Bool, p_down:Void->Bool, p_left:Void->Bool, p_right:Void->Bool ) 
	{
		inputMap = new Map < Directions, Void->Bool > ();
		
		_up = p_up;
		_down = p_down;
		_left = p_left;
		_right = p_right;
		
		inputMap[Directions.UP] = function():Bool { return _up(); };
		inputMap[Directions.DOWN] = function():Bool { return _down(); };
		inputMap[Directions.LEFT] = function():Bool { return _left(); };
		inputMap[Directions.RIGHT] = function():Bool { return _right(); };
	}
	
}