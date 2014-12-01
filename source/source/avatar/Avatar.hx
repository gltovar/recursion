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
	
	private var _inputController:AvatarControllerInput;
	private var _replayController:AvatarControllerReplay;
	private var _rewindController:AvatarControllerReplay;
	
	private var _rewindRecording:AvatarRecording;
	private var _replayRecording:AvatarRecording;
	
	public function new( p_player:Player, p_avatarType:AvatarType, p_x:Float, p_y:Float ) 
	{
		super();
		
		revive();
		
		state = AvatarState.WAITING;
		player = p_player;
		dispatcher = new EventDispatcher();
		avatarType = p_avatarType;
		view = new AvatarView(p_x, p_y, this, player.intersections);
		
		_inputController = Reg.AVATAR_CONTROLLER_INPUTS.recycle( AvatarControllerInput );
		_replayController = Reg.AVATAR_CONTROLLER_REPLAYS.recycle( AvatarControllerReplay );
		_rewindController = Reg.AVATAR_CONTROLLER_REPLAYS.recycle( AvatarControllerReplay );
		
		_rewindRecording = Reg.AVATAR_RECORDINGS.recycle( AvatarRecording );
		_replayRecording = Reg.AVATAR_RECORDINGS.recycle( AvatarRecording );
		
		recorder = Reg.AVATAR_RECORDERS.recycle( AvatarRecorder );
		
		
		//FlxG.watch.add(this, "state", "avatar state: " );
	}
	
	override public function kill():Void 
	{
		state = null;
		player = null;
		dispatcher = null;
		avatarType = null;
		view.kill();
		
		_inputController.kill();
		_replayController.kill();
		_rewindController.kill();
		
		_rewindRecording.kill();
		_replayRecording.kill();
		
		recorder.kill();
		
		_inputController = null;
		_replayController = null;
		_rewindController = null;
		
		_rewindRecording = null;
		_replayRecording = null;
		
		recorder = null;
		
		super.kill();
	}
	
	override public function destroy():Void 
	{
		kill();
		super.destroy();
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
		convertToRewind();
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
	
	private function convertToRewind():Void
	{
		recorder.recording.cutExtraFrames();
		
		_replayRecording = _rewindRecording;
		_rewindRecording = recorder.recording;
		
		_rewindController.init(this, _rewindRecording, -3, true);
		controller = _rewindController;
		
		view.updateAvatarController( controller );
	}
	
	//private function convertToReplay( p_timeModifier:Float = 1, p_destroyRecording:Bool = true, p_manualFrames:Bool = false ):Void
	private function convertToReplay():Void
	{
		_replayController.init(this, _rewindRecording );
		controller = _replayController;
		
		recorder.init(this, _replayRecording);
		
		view.updateAvatarController( controller );
	}
	
	private function convertToUserControlled():Void
	{
		_inputController.init( this );
		controller = _inputController;
		
		view.updateAvatarController( controller );
		
		recorder.init( this, _replayRecording );
	}
	
	static private function tryAndKill( p_basic:FlxBasic ):Void
	{
		if ( p_basic != null )
		{
			p_basic.kill();
		}
	}
	
	public function isReplay():Bool
	{
		return Std.is(controller, AvatarControllerReplay);
	}
	
}