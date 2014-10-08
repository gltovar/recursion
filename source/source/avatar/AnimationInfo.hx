package avatar;
import flixel.util.FlxPoint;

/**
 * ...
 * @author 
 */
class AnimationInfo
{
	
	public var name:CharacterAnimation;
	public var prefix:String;
	public var frameRate:Int;
	public var looped:Bool;
	
	
	public function new( p_name:CharacterAnimation, p_prefix:String, p_frameRate:Int, p_looped:Bool )
	{
		name = p_name;
		prefix = p_prefix;
		frameRate = p_frameRate;
		looped = p_looped;
	}
	
}