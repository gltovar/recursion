package replay;
import flixel.FlxBasic;
import flixel.util.FlxPoint;

/**
 * ...
 * @author 
 */
class AvatarRecording extends FlxBasic
{	
	private var _replayFrames:Array<ReplayFrame>;
	private var _currentFrameIndex:Int;
	
	public function new() 
	{
		super();
		
	}
	
	public function init( p_replayFrames:Array<ReplayFrame> = null )
	{
		
		if ( _replayFrames == null )
		{
			_replayFrames = new Array<ReplayFrame>();
		}
		
		_currentFrameIndex = 0;
	}
	
	public function clone():AvatarRecording
	{
		var l_replayFrames:Array<ReplayFrame> = new Array<ReplayFrame>();
		var l_index:Int = 0;
		while( l_index < _replayFrames.length )
		{
			l_replayFrames.push( _replayFrames[ l_index ].clone() );
			++l_index;
		}
		var l_clone:AvatarRecording = Reg.AVATAR_RECORDINGS.recycle( AvatarRecording );
		l_clone.init( l_replayFrames );
		return l_clone;
	}
	
	public function addFrame( p_timestamp:Float, p_position:FlxPoint = null, p_direction:Directions = null, p_alive:Bool = true, p_animationFrame:Int = 0 ):Void
	{
		if ( _currentFrameIndex < _replayFrames.length )
		{
			var l_replayFrame:ReplayFrame = currentFrame();
			l_replayFrame.timestamp = p_timestamp;
			
			l_replayFrame.position.copyFrom( p_position );
			p_position.put();
			
			l_replayFrame.direction = p_direction;
			l_replayFrame.alive = p_alive;
			l_replayFrame.animationFrame = p_animationFrame;
		}
		else
		{
			_replayFrames.push( ReplayFrame.get( p_timestamp, p_position, p_direction, p_alive, p_animationFrame ) );
		}
		
		++_currentFrameIndex;
	}
	
	public function cutExtraFrames():Void
	{
		if ( _currentFrameIndex < _replayFrames.length - 1 )
		{
			var l_framesToCut:Int = _replayFrames.length - 1 - _currentFrameIndex;
			var l_cutFrames:Array<ReplayFrame> = _replayFrames.splice(_currentFrameIndex, l_framesToCut);
			var l_cutIndex:Int = l_cutFrames.length - 1;
			while ( l_cutIndex >= 0 )
			{
				l_cutFrames[ l_cutIndex ].kill();
				--l_cutIndex;
			}	
		}
	}
	
	public function currentFrame():ReplayFrame
	{
		return _replayFrames[_currentFrameIndex];
	}
	
	public function nextFrame( p_adjustIndex:Bool = true ):ReplayFrame
	{
		
		if ( _replayFrames.length > _currentFrameIndex+1 )
		{
			if ( p_adjustIndex )
			{
				++_currentFrameIndex;
				return currentFrame();
			}
			return _replayFrames[ _currentFrameIndex + 1 ];
		}
		
		return null;
	}
	
	public function previousFrame( p_adjustIndex:Bool = true ):ReplayFrame
	{
		if ( _currentFrameIndex-1 >= 0 )
		{
			if ( p_adjustIndex )
			{
				--_currentFrameIndex;
				return currentFrame();
			}
			return _replayFrames[ _currentFrameIndex - 1 ];
		}
		
		return null;
	}
	
	public function getFrameFromDirection( p_direction:Int, p_adjustIndex:Bool = true ):ReplayFrame
	{
		if ( p_direction == 0)
		{
			return currentFrame();
		}
		else if ( p_direction < 0 )
		{
			return previousFrame();
		}
		
		return nextFrame();
	}
	
	public function skipToEnd():Void
	{
		_currentFrameIndex = _replayFrames.length - 1;
	}
	
	public function skipToBeginning():Void
	{
		_currentFrameIndex = 0;
	}
	
	public function atBeginning():Bool
	{
		return _currentFrameIndex == 0;
	}
	
	public function atEnd():Bool
	{
		return _currentFrameIndex == _replayFrames.length;
	}
	
	public function getTotalDurationInTime():Float
	{
		return _replayFrames[ _replayFrames.length - 1 ].timestamp;
	}
	
	private static function SortFramesByTimestamp( p_frameA:ReplayFrame, p_frameB:ReplayFrame ):Int
	{
		if ( p_frameA.timestamp > p_frameB.timestamp )
		{
			return 1;
		}
		else if ( p_frameA.timestamp < p_frameB.timestamp )
		{
			return -1;
		}
		
		return 0;
	}
	
	override public function kill():Void
	{
		if ( _replayFrames != null )
		{
			var l_frameIndex:Int = 0;
			while ( l_frameIndex < _replayFrames.length )
			{
				_replayFrames[ l_frameIndex ].kill();
				++l_frameIndex;
			}
			
			_replayFrames = null;
		}
		
		super.kill();
	}
	
	override public function destroy():Void
	{
		kill();
		super.destroy();
	}
	
}