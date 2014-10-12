package avatar;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.util.FlxColor;
import input.AvatarControllerInput;
import input.AvatarControllerReplay;
import input.IAvatarController;
import openfl.events.EventDispatcher;
import player.Player;
import player.PlayerState;
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
	public var state(default, null):AvatarState;
	public var frozen(default, null):Bool;
	
	
	public function new( p_player:Player, p_avatarType:AvatarType, p_x:Float, p_y:Float ) 
	{
		super();
		
		revive();
		
		state = AvatarState.WAITING;
		player = p_player;
		dispatcher = new EventDispatcher();
		avatarType = p_avatarType;
		view = new AvatarView(p_x, p_y, this, player.intersections);
		
		//FlxG.watch.add(this, "state", "avatar state: " );
	}
	
	override public function update():Void 
	{
		super.update();
		
		switch(state)
		{
			case AvatarState.WAITING:
				waiting();
			case AvatarState.ALIVE:
				stateAlive();
			case AvatarState.DEAD:
				dead();
			case AvatarState.REWINDING:
				rewinding();
		}
		
		frozen = !view.alive;
	}
	
	private function switchState( p_state:AvatarState ):Void
	{
		state = p_state;
	}
	
	private function waiting():Void
	{
		
	}
	
	private function stateAlive():Void
	{
		controller.update();
		recorder.update();
		
		if ( view.alive == false )
		{
			killAvatar();
		}
		
		if ( isReplay() )
		{
			var l_avatarReplay:AvatarControllerReplay = cast(controller, AvatarControllerReplay);
			
			if (  l_avatarReplay.recording.atEnd() || l_avatarReplay.recording.currentFrame().alive == false )
			{
				killAvatar();
			}
		}
	}
	
	private function killAvatar():Void
	{
		switchState( AvatarState.DEAD );
	}
	
	private function dead():Void
	{
		recorder.update();
	}
	
	private function rewinding():Void
	{
		controller.update();
		
		if ( cast(controller, AvatarControllerReplay).recording.atBeginning() )
		{
			switchState( AvatarState.WAITING );
		}
	}
	
	public function rewind():Void
	{
		convertToReplay( -3, false, true);
		switchState( AvatarState.REWINDING );
	}
	
	public function play( p_userControlled:Bool ):Void
	{
		view.revive();
		if ( p_userControlled )
		{
			convertToUserControlled();
		}
		else
		{
			convertToReplay();
		}
		
		switchState( AvatarState.ALIVE );
	}
	
	private function convertToReplay( p_timeModifier:Float = 1, p_destroyRecording:Bool = true, p_manualFrames:Bool = false ):Void
	{
		tryAndDestroy( cast(controller) );
		controller = new AvatarControllerReplay(this, recorder.recording.clone(),p_timeModifier, p_manualFrames);		
		
		if ( p_destroyRecording )
		{
			tryAndDestroy( recorder );
			recorder = new AvatarRecorder(this);
		}
	}
	
	private function convertToUserControlled():Void
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
	
	public function isReplay():Bool
	{
		return Std.is(controller, AvatarControllerReplay);
	}
	
}