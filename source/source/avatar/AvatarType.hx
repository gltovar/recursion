package avatar;

/**
 * ...
 * @author 
 */
class AvatarType
{
	static public var ROCK:AvatarType = new AvatarType("rock");
	static public var PAPER:AvatarType = new AvatarType("paper");
	static public var SCISSORS:AvatarType = new AvatarType("scissors");
	
	static public var WEAK_TO:Map < AvatarType, AvatarType > = [ 	ROCK => PAPER,
																	PAPER => SCISSORS,
																	SCISSORS => ROCK ];
	
	public var graphics(default, null):String;
	
	
	public function new(p_graphics:String) 
	{
		graphics = p_graphics;
	}
	
}