package replay;
import avatar.AvatarView;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.util.FlxPoint;
import avatar.Avatar;
import avatar.AvatarState;

/**
 * ...
 * @author 
 */
class AvatarRecorder extends FlxBasic
{

	public var avatar:Avatar;
	public var currentTime:Float;
	public var recording:AvatarRecording;
	
	
	public function new() 
	{
		super();
	}
	
	public function init( p_avatar:Avatar, p_recording:AvatarRecording )
	{
		avatar = p_avatar;
		currentTime = 0;
		
		recording = p_recording;
		recording.init();
	}
	
	override public function update():Void 
	{
		super.update();
		
		if ( avatar != null )
		{
			currentTime += FlxG.elapsed;
			//recording.addFrame( ReplayFrame.get( currentTime, FlxPoint.get(avatar.view.x, avatar.view.y), avatar.controller.currentDirection, avatar.state != AvatarState.DEAD, avatar.view.animation.curAnim.curIndex ) );
			recording.addFrame( currentTime, FlxPoint.get(avatar.view.x, avatar.view.y), avatar.controller.currentDirection, avatar.state != AvatarState.DEAD, avatar.view.animation.curAnim.curIndex );
			//trace(recording.currentFrame().toString());
		}
	}
	
	override public function kill():Void
	{
		if ( recording != null )
		{
			recording.kill();
			recording = null;
		}
		
		avatar = null;
		super.kill();
	}
	
	override public function destroy():Void 
	{
		kill();
		super.destroy();
	}
	
}