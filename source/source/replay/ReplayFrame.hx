package replay;
import flixel.FlxBasic;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxPoint;

/**
 * ...
 * @author 
 */
class ReplayFrame extends FlxBasic
{
	static private var REPLAY_FRAMES:FlxTypedGroup<ReplayFrame> = new FlxTypedGroup<ReplayFrame>();
	
	public var timestamp:Float;
	public var position:FlxPoint;
	public var direction:Directions;
	
	public function new() 
	{
		super();
	}
	
	public function init(p_timestamp:Float, p_position:FlxPoint, p_direction:Directions, p_alive:Bool):ReplayFrame
	{
		revive();
		
		timestamp = p_timestamp;
		position = p_position;
		direction = p_direction;
		alive = p_alive;
		
		return this;
	}
	
	override public function revive():Void
	{
		super.revive();
		
	}
	
	override public function kill():Void
	{
		timestamp = 0;
		position = null;
		direction = null;
		
		super.kill();
	}
	 
	
	static public function get( p_timestamp:Float, p_position:FlxPoint = null, p_direction:Directions = null, p_alive:Bool = null):ReplayFrame
	{
		return REPLAY_FRAMES.recycle( ReplayFrame ).init( p_timestamp,  p_position, p_direction, p_alive );
	}
	
	override public function toString():String 
	{
		return "ts: " + timestamp + ", pos: " + position.toString() + ", dir: " + direction;
	}
	
}