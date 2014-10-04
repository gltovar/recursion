package input;
import avatar.Avatar;
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
	
	
	public function new( p_avatar:Avatar, p_recording:AvatarRecording, p_timeModifier:Float = 1 ) 
	{
		super();
		
		dispatcher = new EventDispatcher();
		
		avatar = p_avatar;
		recording = p_recording;
		_timeModifier = p_timeModifier;
		
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
			_runTime += FlxG.elapsed * _timeModifier;
			
			determinNextPosition();
			
			var l_replayFrame:ReplayFrame = recording.currentFrame();
			if ( l_replayFrame != null )
			{
				avatar.view.setPosition( l_replayFrame.position.x, l_replayFrame.position.y );
				
				if ( currentDirection != l_replayFrame.direction )
				{
					dispatcher.dispatchEvent( new AvatarControllerEvent(AvatarControllerEvent.DIRECTION_CHANGE) );
					currentDirection = l_replayFrame.direction;
				}
			}
		}	
	}
	
	override public function destroy():Void 
	{
		recording.destroy();
		super.destroy();
	}
	
}