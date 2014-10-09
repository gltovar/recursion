package player ;

import avatar.Avatar;
import avatar.AvatarType;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.U;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxPoint;
import input.AvatarControllerReplay;
import input.InputMap;
import intersections.IntersectionNode;
import openfl.events.EventDispatcher;

/**
 * ...
 * @author 
 */
class Player extends FlxBasic
{
	static private var CHOICE_MAP:Map < Directions, AvatarType > = [ 	Directions.LEFT 	=> AvatarType.ROCK,
																		Directions.RIGHT 	=> AvatarType.SCISSORS,
																		Directions.UP 		=> AvatarType.PAPER ];
	
	public var dispatcher:EventDispatcher;
	
	public var controllingAvatar:Avatar;
	public  var inputMap:InputMap;
	public var intersections:FlxTypedGroup<IntersectionNode>;
	public var state(default, null):PlayerState;
	public var ui:PlayerUIManager;
	public var uiPoint:FlxPoint;
	
	private var _spawningPoint:FlxPoint;
	
	private var _avatarMap:Map<AvatarType, Avatar>;
	
	
	public function new(p_intersections:FlxTypedGroup<IntersectionNode>, p_inputMap:InputMap, p_spawnPoint:FlxPoint, p_uiPoint:FlxPoint) 
	{
		super();
		
		
		
		dispatcher = new EventDispatcher();
		_avatarMap = new Map<AvatarType, Avatar>();
		
		Reg.PLAYERS.push( this );
		inputMap = p_inputMap;
		intersections = p_intersections;	
		_spawningPoint = p_spawnPoint;
		uiPoint = p_uiPoint;
		
		ui = new PlayerUIManager(this);
		init();
		
		//add( new FlxUI( U.xml("player_ui") ) );
	}
	
	override public function update():Void 
	{
		super.update();
		
		switch( state )
		{
			case PlayerState.NOT_JOINED:
				notJoined();
			case PlayerState.CHOOSING:
				choosing();
			case PlayerState.WAITING:
				waiting();
			case PlayerState.PLAYING:
				playing();
			case PlayerState.REWINDING:
				rewinding();
		}
	}
	
	public function hasChosen():Bool
	{
		return state == PlayerState.WAITING;
	}
	
	public function hasJoined():Bool
	{
		return state != PlayerState.NOT_JOINED;
	}
	
	public function startPlaying():Void
	{
		ui.showChoices();
		updateControls();
		switchState( PlayerState.PLAYING );
	}
	
	public function wait():Void
	{
		ui.showWait();
	}
	
	private function switchState( p_newState:PlayerState ):Void
	{
		state = p_newState;
	}
	
	public function init():Void
	{
		ui.showJoin();
		switchState(PlayerState.NOT_JOINED);
	}
	
	private function choosing():Void
	{
		for ( l_key in CHOICE_MAP.keys() )
		{
			if ( inputMap.inputMap[ l_key ]() )
			{
				var l_avatarType:AvatarType = CHOICE_MAP[l_key];
				var l_prevControllingAvatar:Avatar = controllingAvatar;
				
				controllingAvatar = _avatarMap[l_avatarType];
				if ( controllingAvatar == null )
				{
					controllingAvatar = new Avatar(this, CHOICE_MAP[l_key] , _spawningPoint.x, _spawningPoint.y);
					_avatarMap[l_avatarType] = controllingAvatar;
					Reg.AVATAR_VIEWS.add( controllingAvatar.view );
					Reg.AVATAR_TYPES_MAP[l_avatarType].add( controllingAvatar.view );
				}
				
				ui.showReady();
				switchState( PlayerState.WAITING );
				break;
			}
		}
	}
	
	private function updateControls():Void
	{
		for ( l_avatar in _avatarMap )
		{
			if ( l_avatar != controllingAvatar )
			{
				l_avatar.play(false);
			}
			else
			{
				l_avatar.play(true);
			}
			
			l_avatar.view.color = Reg.PLAYER_COLORS[ Reg.PLAYERS.indexOf(this) ];
		}	
	}
	
	private function notJoined():Void
	{
		if ( Reg.PLAYER_MANAGER.state == GameState.CHOOSING )
		{
			// press down to join
			if ( inputMap.inputMap[ Directions.DOWN ]() )
			{
				ui.showChoices();
				switchState( PlayerState.CHOOSING );
			}
		}
	}
	
	private function waiting():Void
	{
		
	}
	
	private function playing():Void
	{
		updateAvatars();
		
		/*if ( FlxG.keys.justPressed.SPACE )
		{
			startRewinding();
		}*/
	}
	
	public function startRewinding():Void
	{
		switchState( PlayerState.REWINDING );
		
		for ( l_avatar in _avatarMap )
		{
			l_avatar.rewind();
		}
	}
	
	private function rewinding():Void
	{
		updateAvatars();
		
		for ( l_avatar in _avatarMap )
		{
			if ( cast(l_avatar.controller, AvatarControllerReplay).recording.atBeginning() == false )
			{
				return;
			}
		}
		
		ui.showChoices();
		// if every previous frame is null then we are finished
		switchState(PlayerState.CHOOSING);
	}
	
	private function updateAvatars():Void
	{
		for ( l_avatar in _avatarMap )
		{
			l_avatar.update();
		}
	}
	
}