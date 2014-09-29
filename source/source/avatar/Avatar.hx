package avatar;

import flixel.FlxBasic;
import input.AvatarControllerInput;
import input.IAvatarController;
import openfl.events.EventDispatcher;
import replay.AvatarRecorder;
import replay.AvatarRecording;

/**
 * ...
 * @author 
 */
class Avatar extends FlxBasic
{
	public var player:Player;
	public var dispatcher(default, null):EventDispatcher;
	public var view:AvatarView;
	public var controller:IAvatarController;
	public var recording:AvatarRecording;
	public var recorder:AvatarRecorder;
	public var avatarType:AvatarType;
	
	public function new( p_player:Player, p_avatarType:AvatarType, p_x:Float, p_y:Float ) 
	{
		super();
		
		player = p_player;
		dispatcher = new EventDispatcher();
		avatarType = p_avatarType;
		view = new AvatarView(p_x, p_y, this, player.intersections);
		controller = new AvatarControllerInput(this);
		
		view.updateAvatarController( controller );
	}
	
	override public function update():Void 
	{
		super.update();
		
		controller.update();
		
	}
	
}