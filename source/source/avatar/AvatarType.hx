package avatar;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.loaders.TexturePackerData;

/**
 * ...
 * @author 
 */
class AvatarType
{
	static public var ROCK:AvatarType = new AvatarType([ 	new AnimationInfo(CharacterAnimation.WALK, "rock_walk_", 4, true),
															new AnimationInfo(CharacterAnimation.ATTACK, "rock_attack_", 15, false),
															new AnimationInfo(CharacterAnimation.DIE, "rock_dead_", 1, true) ],
															new FlxPoint(15,14));
															
	static public var PAPER:AvatarType = new AvatarType([ 	new AnimationInfo(CharacterAnimation.WALK, "paper_walk_", 4, true),
															new AnimationInfo(CharacterAnimation.ATTACK, "paper_attack_", 15, false),
															new AnimationInfo(CharacterAnimation.DIE, "paper_dead_", 1, true) ],
															new FlxPoint(10,17));
	
	static public var SCISSORS:AvatarType = new AvatarType([ 	new AnimationInfo(CharacterAnimation.WALK, "scissors_walk_", 4, true),
																new AnimationInfo(CharacterAnimation.ATTACK, "scissors_attack_", 15, false),
																new AnimationInfo(CharacterAnimation.DIE, "scissors_dead_", 1, true) ],
																new FlxPoint(7,6));
	
	public static var TYPES:Array<AvatarType> = [ROCK, PAPER, SCISSORS];
	
	static public var WEAK_TO:Map < AvatarType, AvatarType > = [ 	ROCK => PAPER,
																	PAPER => SCISSORS,
																	SCISSORS => ROCK ];
	
	public var texture(get, null):TexturePackerData;
	public var animations(default, null):Array<AnimationInfo>;
	public var offset(default, null):FlxPoint;
	
	public function new( p_animations:Array<AnimationInfo>, p_offset:FlxPoint ) 
	{
		animations = p_animations;
		offset = p_offset;
		
		/*var sprite:FlxSprite = new FlxSprite();
		sprite.loadGraphicFromTexture(test);
		sprite.animation.addByPrefix("walk", "rock_walk_"*/
	}
	
	public function get_texture():TexturePackerData
	{
		if ( this.texture == null )
		{
			texture = new TexturePackerData("assets/characters.json", "assets/characters.png");
		}
		
		return texture;
	}
	
}