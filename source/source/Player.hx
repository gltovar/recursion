package ;

import flixel.FlxBasic;
import input.InputMap;

/**
 * ...
 * @author 
 */
class Player extends FlxBasic
{
	
	public var avatars:Array<Avatar>;
	public var controllingAvatar:Avatar;
	public  var inputMap:InputMap;
	
	
	public function new() 
	{
		super();
		
		inputMap = new InputMap( 	function():Bool { return FlxG.keys.pressed.UP; },
									function():Bool { return FlxG.keys.pressed.DOWN; },
									function():Bool { return FlxG.keys.pressed.LEFT; },
									function():Bool { return FlxG.keys.pressed.RIGHT; } );
		
	}
	
}