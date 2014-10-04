package avatar;

import flixel.FlxBasic;
import input.AvatarControllerInput;
import input.AvatarControllerReplay;
import input.IAvatarController;
import openfl.events.EventDispatcher;
import player.Player;
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
		
	}
	
	override public function update():Void 
	{
		super.update();
		
		controller.update();
		recorder.update();
	}
	
	public function convertToReplay( p_timeModifier:Float = 1 ):Void
	{
		if ( Std.is( controller, AvatarControllerReplay) == false )
		{
			tryAndDestroy( cast(controller) );
			controller = new AvatarControllerReplay(this, recorder.recording.clone(),p_timeModifier);
			
			view.updateAvatarController( controller );
		}
		else
		{
			var l_recording:AvatarRecording = cast( controller, AvatarControllerReplay).recording.clone();
			tryAndDestroy( cast(controller) );
			controller = new AvatarControllerReplay(this, l_recording,p_timeModifier);
		}
		
		tryAndDestroy( recorder );
		recorder = new AvatarRecorder(this);
	}
	
	public function convertToUserControlled():Void
	{
		tryAndDestroy( cast(controller) );
		controller = new AvatarControllerInput(this);
		
		tryAndDestroy( recorder );
		recorder = new AvatarRecorder(this);
		
		view.updateAvatarController( controller );
	}
	
	static private function tryAndDestroy( p_basic:FlxBasic ):Void
	{
		if ( p_basic != null )
		{
			p_basic.destroy;
		}
	}
	
}