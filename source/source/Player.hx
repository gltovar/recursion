package ;

import avatar.Avatar;
import avatar.AvatarType;
import avatar.AvatarView;
import flixel.FlxBasic;
import flixel.group.FlxTypedGroup;
import input.AvatarControllerInput;
import input.InputMap;
import intersections.IntersectionNode;

/**
 * ...
 * @author 
 */
class Player extends FlxBasic
{
	
	public var avatars:Array<AvatarView>;
	public var controllingAvatar:Avatar;
	public  var inputMap:InputMap;
	public var intersections:FlxTypedGroup<IntersectionNode>;
	
	
	public function new(p_intersections:FlxTypedGroup<IntersectionNode>, p_inputMap:InputMap, p_x:Float, p_y:Float) 
	{
		super();
		
		inputMap = p_inputMap;
		intersections = p_intersections;
		controllingAvatar = new Avatar(this, AvatarType.PAPER, p_x, p_y);
	}
	
	override public function update():Void 
	{
		super.update();
		
		controllingAvatar.update();
		
		//controllingAvatar
	}
	
}