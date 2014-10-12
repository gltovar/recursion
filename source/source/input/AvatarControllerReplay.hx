package input;
import avatar.Avatar;
import avatar.AvatarEvent;
import flixel.FlxBasic;
import flixel.FlxG;
import openfl.events.EventDispatcher;
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
	public var recording(default,null):AvatarRecording;
	
	private var _runTime:Float;
	private var _timeModifier:Float;
	private var _stepDirection:Int;
	private var _manualFrames:Bool;
	
	private var _skipAFrame:Int;
	
	
	public function new( p_avatar:Avatar, p_recording:AvatarRecording, p_timeModifier:Float = 1, p_manualFrames:Bool = false ) 
	{
		super();
		
		dispatcher = new EventDispatcher();
		
		avatar = p_avatar;
		recording = p_recording;
		_timeModifier = p_timeModifier;
		_manualFrames = p_manualFrames;
		
		if ( _timeModifier < 0 )
		{
			recording.skipToEnd();
			_stepDirection = -1;
		}
		else
		{
			recording.skipToBeginning();
			_stepDirection = 1;
		}
		
		_runTime = p_recording.currentFrame().timestamp;
		currentDirection = Directions.NONE;
		
		avatar.dispatcher.addEventListener( AvatarEvent.BUMPED, onAvatarBump );
	}
	
	private function determinNextPosition():Void
	{
		var l_nextFrameIsValid:Bool;
		
		while ( recording.getFrameFromDirection( _stepDirection ) != null )
		{
			l_nextFrameIsValid = (_stepDirection > 0)  ? recording.currentFrame().timestamp >= _runTime : recording.currentFrame().timestamp < _runTime;
			
			if ( l_nextFrameIsValid )
			{
				return;
			}
		}
	}
	
	override public function update():Void 
	{
		super.update();
		if ( recording != null )
		{
			if ( _skipAFrame > 0 )
			{
				--_skipAFrame;
				return;
			}
			_runTime += FlxG.elapsed * _timeModifier;
			
			determinNextPosition();
			
			var l_replayFrame:ReplayFrame = recording.currentFrame();
			if ( l_replayFrame != null )
			{
				avatar.view.setPosition( l_replayFrame.position.x, l_replayFrame.position.y );
				if ( _manualFrames )
				{
					avatar.view.animation.frameIndex = l_replayFrame.animationFrame;
				}
				
				if ( currentDirection != l_replayFrame.direction )
				{
					dispatcher.dispatchEvent( new AvatarEvent(AvatarEvent.DIRECTION_CHANGE) );
					currentDirection = l_replayFrame.direction;
				}
			}
		}	
	}
	
	private function onAvatarBump(e:AvatarEvent):Void
	{
		//FlxG.log.add("bump detected");
		if ( avatar.player.state == player.PlayerState.PLAYING )
		{
			_skipAFrame = 1;
		}
		
	}
	
	override public function destroy():Void 
	{
		avatar.dispatcher.removeEventListener( AvatarEvent.BUMPED, onAvatarBump );
		recording.destroy();
		super.destroy();
	}
	
}