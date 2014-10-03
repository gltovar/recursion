package replay;
import avatar.AvatarView;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.util.FlxPoint;
import avatar.Avatar;

/**
 * ...
 * @author 
 */
class AvatarRecorder extends FlxBasic
{

	public var avatar:Avatar;
	public var currentTime:Float;
	public var recording:AvatarRecording;
	
	
	public function new( p_avatar:Avatar ) 
	{
		super();
		
		avatar = p_avatar;
		currentTime = 0;
		
		recording = new AvatarRecording();
	}
	
	override public function update():Void 
	{
		super.update();
		
		if ( avatar != null )
		{
			currentTime += FlxG.elapsed;
			recording.addFrame( ReplayFrame.get( currentTime, FlxPoint.get(avatar.view.x, avatar.view.y), avatar.controller.currentDirection, avatar.alive) );
			//trace(recording.currentFrame().toString());
		}
	}
	
	override public function destroy():Void 
	{
		recording = null;
		super.destroy();
	}
	
}