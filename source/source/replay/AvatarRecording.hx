package replay;

/**
 * ...
 * @author 
 */
class AvatarRecording
{
	private var _replayFrames:Array<ReplayFrame>;
	private var _currentFrameIndex:Int;
	
	public function new() 
	{
		_replayFrames = new Array<ReplayFrame>();
		_currentFrameIndex = 0;
	}
	
	public function addFrame( p_replayFrame:ReplayFrame, p_push:Bool = true )
	{
		_replayFrames.push( p_replayFrame );
		
		if ( p_push == false )
		{
			_replayFrames.sort(SortFramesByTimestamp);
		}
	}
	
	public function currentFrame():ReplayFrame
	{
		return _replayFrames[_currentFrameIndex];
	}
	
	public function nextFrame():ReplayFrame
	{
		if ( _replayFrames.length > _currentFrameIndex+1 )
		{
			++_currentFrameIndex;
			return currentFrame();
		}
		
		return null;
	}
	
	public function previousFrame():ReplayFrame
	{
		if ( _currentFrameIndex-1 >= 0 )
		{
			--_currentFrameIndex;
			return currentFrame();
		}
		
		return null;
	}
	
	public function skipToEnd():Void
	{
		_currentFrameIndex = _replayFrames.length - 1;
	}
	
	public function skipToBeginning():Void
	{
		_currentFrameIndex = 0;
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