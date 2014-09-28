package ;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.group.FlxTypedGroup;
import input.InputMap;
import intersections.IntersectionNode;

/**
 * ...
 * @author 
 */
class Player extends FlxBasic
{
	
	public var avatars:Array<Avatar>;
	public var controllingAvatar:Avatar;
	public  var inputMap:InputMap;
	
	
	public function new(p_intersections:FlxTypedGroup<IntersectionNode>) 
	{
		super();
		
		inputMap = new InputMap( 	function():Bool { return FlxG.keys.pressed.UP; },
									function():Bool { return FlxG.keys.pressed.DOWN; },
									function():Bool { return FlxG.keys.pressed.LEFT; },
									function():Bool { return FlxG.keys.pressed.RIGHT; } );
									
		controllingAvatar = new Avatar(32, 176, this, p_intersections);
	}
	
	override public function update():Void 
	{
		super.update();
		
		//controllingAvatar
	}
	
}