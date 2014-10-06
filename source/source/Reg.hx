package ;
import avatar.AvatarType;
import avatar.AvatarView;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxColor;
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
	
	public static var PLAYER_COLORS:Array<Int> = [FlxColor.SALMON, FlxColor.CHARTREUSE, FlxColor.AZURE, FlxColor.WHEAT]; 
	
	public static var AVATAR_VIEWS:FlxTypedGroup<AvatarView> = new FlxTypedGroup<AvatarView>();
	
	public static var AVATAR_TYPES_MAP:Map < AvatarType, FlxTypedGroup<AvatarView> > = [AvatarType.ROCK => new FlxTypedGroup<AvatarView>(),
																						AvatarType.PAPER => new FlxTypedGroup<AvatarView>(),
																						AvatarType.SCISSORS => new FlxTypedGroup<AvatarView>()];
	
}