package ;
import avatar.AvatarView;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxPoint;
import flixel.util.FlxVector;
import input.DirectionVector;
import player.Player;
/**
 * ...
 * @author 
 */
class Reg
{
	
	public static var DIRECTION_LIST:Array<Directions> = [Directions.UP, Directions.DOWN, Directions.LEFT, Directions.RIGHT];

	public static var DIRECTION_VECTORS:Map < Directions, DirectionVector > = [ 	Directions.UP		=> new DirectionVector("y", -1),
																					Directions.DOWN 	=> new DirectionVector("y",  1),
																					Directions.LEFT 	=> new DirectionVector("x", -1),
																					Directions.RIGHT 	=> new DirectionVector("x",  1) ];
	
	public static var OPPOSITE_DIRECTION:Map < Directions, Directions > = [ 	Directions.UP 		=> Directions.DOWN,
																				Directions.DOWN 	=> Directions.UP,
																				Directions.LEFT 	=> Directions.RIGHT,
																				Directions.RIGHT 	=> Directions.LEFT ];
																					
	public static var PLAYERS:Array<Player> = [];
	
	public static var AVATAR_VIEWS:FlxTypedGroup<AvatarView> = new FlxTypedGroup<AvatarView>();
	
	public static var ROCKS:FlxTypedGroup<AvatarView> = new FlxTypedGroup<AvatarView>();
	public static var PAPERS:FlxTypedGroup<AvatarView> = new FlxTypedGroup<AvatarView>();
	public static var SCISSORS:FlxTypedGroup<AvatarView> = new FlxTypedGroup<AvatarView>();
	
}