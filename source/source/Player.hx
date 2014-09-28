package ;

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
	public var controllingAvatar:AvatarView;
	public  var inputMap:InputMap;
	
	public var avatarControllerInput:AvatarControllerInput;
	
	
	public function new(p_intersections:FlxTypedGroup<IntersectionNode>, p_inputMap:InputMap) 
	{
		super();
		
		inputMap = p_inputMap;
									
		controllingAvatar = new AvatarView(32, 176, this, p_intersections);
		avatarControllerInput = new AvatarControllerInput(this);
		avatarControllerInput.intersections = p_intersections;
	}
	
	override public function update():Void 
	{
		super.update();
		
		avatarControllerInput.update();
		
		//controllingAvatar
	}
	
}