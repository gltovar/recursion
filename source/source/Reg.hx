package ;
import avatar.AvatarType;
import avatar.AvatarView;
import flixel.addons.ui.FlxUI;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import input.AvatarControllerInput;
import input.AvatarControllerReplay;
import input.DirectionVector;
import player.Player;
import player.PlayerManager;
import replay.AvatarRecorder;
import replay.AvatarRecording;
import replay.PlayerPath;
import replay.ReplayFrame;
/**
 * ...
 * @author 
 */
class Reg
{
	public static var MIN_PLAYERS:Int = 2;
	public static var GAME_DURATION:Float = 15;
	public static var TILE_SIDE:Float = 32;
	
	public static var INPUT_BUMP_FREEZE:Float = .3;
	
	public static var DIRECTION_LIST:Array<Directions> = [Directions.UP, Directions.DOWN, Directions.LEFT, Directions.RIGHT];

	public static var AVATAR_PATH_MAP:Map< AvatarType, String> = [ 	AvatarType.ROCK		=> PlayerPath.PATH_TOP,
																	AvatarType.PAPER	=> PlayerPath.PATH_MID,
																	AvatarType.SCISSORS => PlayerPath.PATH_BOTTOM];
	
	public static var DIRECTION_VECTORS:Map < Directions, DirectionVector > = [ 	Directions.UP		=> new DirectionVector("y", -1),
																					Directions.DOWN 	=> new DirectionVector("y",  1),
																					Directions.LEFT 	=> new DirectionVector("x", -1),
																					Directions.RIGHT 	=> new DirectionVector("x",  1) ];
	
	public static var OPPOSITE_DIRECTION:Map < Directions, Directions > = [ 	Directions.UP 		=> Directions.DOWN,
																				Directions.DOWN 	=> Directions.UP,
																				Directions.LEFT 	=> Directions.RIGHT,
																				Directions.RIGHT 	=> Directions.LEFT ];
																					
	public static var AVATAR_TO_PATH:Map< AvatarType, String > = [ AvatarType.ROCK => PlayerPath.PATH_TOP,
																	AvatarType.PAPER => PlayerPath.PATH_MID,
																	AvatarType.SCISSORS => PlayerPath.PATH_BOTTOM ];
																				
																				
	public static var PLAYER_COLORS:Array<Int> = [FlxColor.SALMON, FlxColor.CHARTREUSE, FlxColor.AZURE, FlxColor.WHEAT];
																				
	public static var PLAYERS:Array<Player>; 
	
	public static var AVATAR_VIEWS:FlxTypedGroup<AvatarView>;
	
	public static var AVATAR_TYPES_MAP:Map < AvatarType, FlxTypedGroup<AvatarView> >;
	
	public static var PLAYER_UI_LAYER:FlxTypedGroup<FlxSprite>;
	
	public static var PLAYER_PATH_LAYER:FlxTypedGroup<PlayerPath>;
	
	public static var PLAYER_AVATAR_END_POINTS:FlxTypedGroup<AvatarView>;
	
	public static var PLAYER_MANAGER:PlayerManager;
	
	
	public static var MUSIC_CHOOSE:String = "assets/music/music_choose.wav";
	public static var MUSIC_PLAYING:String = "assets/music/music_playing.wav";
	public static var MUSIC_REWIND:String = "assets/music/music_rewind.wav";
	
	public static var SOUND_BUMP:String = "assets/sounds/bump.wav";
	public static var SOUND_ATTACK:Map<AvatarType, String> = [	AvatarType.ROCK 	=> "assets/sounds/attack_rock.wav",
																AvatarType.PAPER 	=> "assets/sounds/attack_paper.wav",
																AvatarType.SCISSORS	=> "assets/sounds/attack_scissors.wav"];
																
	public static var AVATAR_CONTROLLER_INPUTS:FlxTypedGroup<AvatarControllerInput>;
	public static var AVATAR_CONTROLLER_REPLAYS:FlxTypedGroup<AvatarControllerReplay>;
	
	public static var AVATAR_RECORDERS:FlxTypedGroup<AvatarRecorder>;
	public static var AVATAR_RECORDINGS:FlxTypedGroup<AvatarRecording>;
	public static var REPLAY_FRAMES:FlxTypedGroup<ReplayFrame>;
}