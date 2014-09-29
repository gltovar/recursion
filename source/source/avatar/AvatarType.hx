package avatar;

/**
 * ...
 * @author 
 */
class AvatarType
{
	static public var ROCK:AvatarType = new AvatarType("assets/rock.png");
	static public var PAPER:AvatarType = new AvatarType("assets/paper.png");
	static public var SCISSORS:AvatarType = new AvatarType("assets/scissors.png");
	
	static public var WEAK_TO:Map < AvatarType, AvatarType > = [ 	ROCK => PAPER,
																	PAPER => SCISSORS,
																	SCISSORS => ROCK ];
	
	public var graphics(default, null):String;
	
	
	public function new(p_graphics:String) 
	{
		graphics = p_graphics;
	}
	
}