package input;
import flixel.FlxBasic;
import openfl.events.EventDispatcher;
import avatar.Avatar;
import replay.AvatarRecording;
import replay.ReplayFrame;

/**
 * ...
 * @author 
 */
class AvatarControllerReplay extends FlxBasic implements IAvatarController
{
	public var avatar(default, null):Avatar;
	public var dispatcher(default, null):EventDispatcher;
	public var currentDirection(default, null):Directions;
	
	
	private var _recording:AvatarRecording;
	
	public function new( p_avatar:Avatar, p_recording:AvatarRecording ) 
	{
		super();
		
		avatar = p_avatar;
		_recording = p_recording;
		
		_recording.skipToEnd();
		currentDirection = Directions.NONE;
	}
	
	override public function update():Void 
	{
		super.update();
		
		var l_replayFrame:ReplayFrame = _recording.previousFrame();
		if ( l_replayFrame != null )
		{
			avatar.view.setPosition( l_replayFrame.position.x, l_replayFrame.position.y );
			currentDirection = l_replayFrame.direction;
		}
		
	}
	
}