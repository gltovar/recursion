package replay;

/**
 * ...
 * @author 
 */
class AvatarRecording
{
	private var _replayFrames:Array<ReplayFrame>;
	private var _currentFrameIndex:Int;
	
	public function new( p_replayFrames:Array<ReplayFrame> = null ) 
	{
		if ( p_replayFrames != null )
		{
			_replayFrames = p_replayFrames;
		}
		else
		{
			_replayFrames = new Array<ReplayFrame>();
		}
		_currentFrameIndex = 0;
	}
	
	public function clone():AvatarRecording
	{
		return new AvatarRecording( _replayFrames );
	}
	
	public function addFrame( p_replayFrame:ReplayFrame, p_push:Bool = true )
	{
		_replayFrames.push( p_replayFrame );
		
		if ( p_push == false )
		{
			_replayFrames.sort(SortFramesByTimestamp);
			// skip to time;
		}
		else
		{
			skipToEnd();
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
	
	public function destroy():Void
	{
		if ( _replayFrames != null )
		{
			for ( l_replayFrame in _replayFrames )
			{
				if ( l_replayFrame.position != null )
				{
					l_replayFrame.position.put();
				}
				l_replayFrame.kill();
			}
		}
	}
	
}