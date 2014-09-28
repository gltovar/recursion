package; 

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxVector;
import input.AvatarControllerInput;
import input.DirectionVector;
import input.InputMap;
import intersections.IntersectionNode;

class Avatar extends FlxSprite
{
	private var _player:Player;
	
	private static inline var INPUT_MAX_RELEASE_TIME:Int = 300;
	
	private var _currentIntersection:IntersectionNode = null;
	private var _currentDirection:Directions = Directions.NONE;
	
	private var _timeLastPressed:Map<Directions, Int>; 
	
	
	public var intersections:FlxTypedGroup<IntersectionNode>;
	
	
	private var _prevPassedThroughCenter:Bool = false;
	private var _intendedDirection:Directions = Directions.NONE;
	
	private var _inputMap:InputMap;
	
	private var _controls:AvatarControllerInput;
	
	public function new(X:Float, Y:Float, p_player:Player, p_intersections:FlxTypedGroup<IntersectionNode>)
	{
		super(X, Y);
		
		_player = p_player;
		
		loadGraphic("assets/player.png", true);
		maxVelocity.set( 100, 100 );
		width = 16;
		height = 16;
		centerOffsets();
		
		animation.add("idle", [0], 0, false);
		animation.add("walk", [1, 2, 3, 0], 10, true);
		animation.add("walk_back", [3, 2, 1, 0], 10, true);
		animation.add("flail", [1, 2, 3, 0], 18, true);
		animation.add("jump", [4], 0, false);
		
		_controls = new AvatarControllerInput( _player );
		_controls.intersections = p_intersections;
		
	}
	
	public function atIntersection():Void
	{
		color = FlxColor.RED;
	}
	
	override public function update():Void
	{
		super.update();
		_controls.update();
		
	}
	
}