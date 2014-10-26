package input;
import flixel.FlxG;

/**
 * ...
 * @author 
 */
class InputMap
{	
	static public var ARROW_KEYS:InputMap = new InputMap( 	function():Bool { return FlxG.keys.pressed.UP; },
															function():Bool { return FlxG.keys.pressed.DOWN; },
															function():Bool { return FlxG.keys.pressed.LEFT; },
															function():Bool { return FlxG.keys.pressed.RIGHT; } );
															
	static public var WSAD:InputMap = new InputMap( 		function():Bool { return FlxG.keys.pressed.W; },
															function():Bool { return FlxG.keys.pressed.S; },
															function():Bool { return FlxG.keys.pressed.A; },
															function():Bool { return FlxG.keys.pressed.D; } );
															
	static public var IKJL:InputMap = new InputMap( 		function():Bool { return FlxG.keys.pressed.I; },
															function():Bool { return FlxG.keys.pressed.K; },
															function():Bool { return FlxG.keys.pressed.J; },
															function():Bool { return FlxG.keys.pressed.L; } );
															
	static public var NUM_KEYS:InputMap = new InputMap( 		function():Bool { return FlxG.keys.pressed.NUMPADFIVE; },
															function():Bool { return FlxG.keys.pressed.NUMPADTWO; },
															function():Bool { return FlxG.keys.pressed.NUMPADONE; },
															function():Bool { return FlxG.keys.pressed.NUMPADTHREE; } );
	
	
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