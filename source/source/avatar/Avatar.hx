package avatar;

import flixel.FlxBasic;
import flixel.FlxG;
import input.AvatarControllerInput;
import input.AvatarControllerReplay;
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
		
		revive();
		
		
		player = p_player;
		dispatcher = new EventDispatcher();
		avatarType = p_avatarType;
		view = new AvatarView(p_x, p_y, this, player.intersections);
		controller = new AvatarControllerInput(this);
		//recording = new AvatarRecording();
		
		recorder = new AvatarRecorder(this);
		
		view.updateAvatarController( controller );
	}
	
	override public function update():Void 
	{
		super.update();
		
		controller.update();
		recorder.update();
		
		if ( FlxG.keys.justPressed.SPACE )
		{
			if ( Std.is( controller, AvatarControllerInput ) )
			{
				tryAndDestroy( cast(controller) );
				controller = new AvatarControllerReplay(this, recorder.recording,-5);
				
				tryAndDestroy( recorder );
				recorder = new AvatarRecorder(this);
			}
			else
			{
				tryAndDestroy( cast(controller) );
				controller = new AvatarControllerInput(this);
				
				tryAndDestroy( recorder );
				recorder = new AvatarRecorder(this);
			}
		}
		
	}
	
	static private function tryAndDestroy( p_basic:FlxBasic ):Void
	{
		if ( p_basic != null )
		{
			p_basic.destroy;
		}
	}
	
}