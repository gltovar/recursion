package replay;
import flixel.FlxBasic;
import flixel.group.FlxTypedGroup;
import flixel.interfaces.IFlxPooled;
import flixel.util.FlxPoint;

/**
 * ...
 * @author 
 */
class ReplayFrame extends FlxBasic
{
	public var timestamp:Float;
	public var position:FlxPoint;
	public var direction:Directions;
	public var animationFrame:Int;
	public var avatarAlive:Bool;
	
	public function new() 
	{
		super();
	}
	
	public function init(p_timestamp:Float, p_position:FlxPoint, p_direction:Directions, p_alive:Bool, p_animationFrame:Int):ReplayFrame
	{
		timestamp = p_timestamp;
		position = p_position;
		direction = p_direction;
		avatarAlive = p_alive;
		animationFrame = p_animationFrame;
		
		return this;
	}
	
	override public function kill():Void
	{
		timestamp = 0;
		if ( position != null )
		{
			position.put();
		}
		position = null;
		direction = null;
		avatarAlive = true;
		
		super.kill();
	}
	
	override public function destroy():Void
	{
		kill();
		super.destroy();
	}
	 
	
	static public function get( p_timestamp:Float, p_position:FlxPoint = null, p_direction:Directions = null, p_alive:Bool = true, p_animationFrame:Int = 0):ReplayFrame
	{
		return Reg.REPLAY_FRAMES.recycle( ReplayFrame ).init( p_timestamp,  p_position, p_direction, p_alive, p_animationFrame );
	}
	
	public function clone():ReplayFrame
	{
		return ReplayFrame.get( timestamp, position.copyTo(), direction, alive, animationFrame );
	}
	
	override public function toString():String 
	{
		return "ts: " + timestamp + ", pos: " + position.toString() + ", dir: " + direction + ", alive: " + avatarAlive;
	}
	
}