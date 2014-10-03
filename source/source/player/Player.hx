package player ;

import avatar.Avatar;
import avatar.AvatarType;
import avatar.AvatarView;
import flixel.FlxBasic;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxPoint;
import input.AvatarControllerInput;
import input.InputMap;
import intersections.IntersectionNode;

/**
 * ...
 * @author 
 */
class Player extends FlxBasic
{
	static private var CHOICE_MAP:Map < Directions, AvatarType > = [ 	Directions.LEFT 	=> AvatarType.ROCK,
																		Directions.RIGHT 	=> AvatarType.SCISSORS,
																		Directions.UP 		=> AvatarType.PAPER ];
	
	//public var avatars:Array<AvatarView>;
	public var controllingAvatar:Avatar;
	public  var inputMap:InputMap;
	public var intersections:FlxTypedGroup<IntersectionNode>;
	
	private var _state:PlayerState = PlayerState.INIT;
	private var _spawningPoint:FlxPoint;
	
	
	public function new(p_intersections:FlxTypedGroup<IntersectionNode>, p_inputMap:InputMap, p_x:Float, p_y:Float) 
	{
		super();
		
		//Reg.PLAYERS.push( this );
		//avatars = new FlxTypedGroup<Avatar>();
		inputMap = p_inputMap;
		intersections = p_intersections;	
		_spawningPoint = FlxPoint.get( p_x, p_y );
		
		
	}
	
	override public function update():Void 
	{
		super.update();
		
		switch( _state )
		{
			case PlayerState.INIT:
				init();
			case PlayerState.CHOOSING:
				choosing();
			case PlayerState.WAITING:
				waiting();
			case PlayerState.PLAYING:
				playing();
			case PlayerState.REWINDING:
				rewinding();
		}
		
		//controllingAvatar
	}
	
	private function switchState( p_newState:PlayerState ):Void
	{
		_state = p_newState;
	}
	
	private function init():Void
	{
		switchState(PlayerState.CHOOSING);
	}
	
	private function choosing():Void
	{
		for ( l_key in CHOICE_MAP.keys() )
		{
			if ( inputMap.inputMap[ l_key ]() )
			{
				controllingAvatar = new Avatar(this, CHOICE_MAP[l_key] , _spawningPoint.x, _spawningPoint.y);
				Reg.AVATAR_VIEWS.add( controllingAvatar.view );
				switchState( PlayerState.WAITING );
			}
		}
	}
	
	private function waiting():Void
	{
		switchState( PlayerState.PLAYING );
	}
	
	private function playing():Void
	{
		controllingAvatar.update();
	}
	
	private function rewinding():Void
	{
		
	}
	
}