package replay;
import avatar.AvatarView;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.util.FlxPoint;

/**
 * ...
 * @author 
 */
class AvatarRecorder extends FlxBasic
{

	public var avatarView:AvatarView;
	public var currentTime:Float;
	public var recording:AvatarRecording;
	
	
	public function new() 
	{
		super();
		
		currentTime = 0;
		
		recording = new AvatarRecording();
	}
	
	override public function update():Void 
	{
		super.update();
		
		if ( avatarView != null )
		{
			currentTime += FlxG.elapsed;
			//recording.addFrame( ReplayFrame.get( FlxPoint.get(avatarView.x, avatarView.y), avatarView.player., 
		}
	}
	
}