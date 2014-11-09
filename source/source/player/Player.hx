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
import replay.PlayerPath;

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
	public var id(default, null):String;
	public var path:PlayerPath;
	
	private var _spawningPoint:FlxPoint;
	
	private var _avatarMap:Map<AvatarType, Avatar>;
	private var _choice:AvatarType;
	
	
	public function new(p_intersections:FlxTypedGroup<IntersectionNode>, p_inputMap:InputMap, p_spawnPoint:FlxPoint, p_uiPoint:FlxPoint) 
	{
		super();
		
		id = "Player " + Reg.PLAYERS.length;
		
		dispatcher = new EventDispatcher();
		_avatarMap = new Map<AvatarType, Avatar>();
		path = new PlayerPath();
		path.reset(0, 0);
		
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
		var l_prevControllingAvatar:Avatar = controllingAvatar;
		
		if ( allAvatarsDead() == false )
		{
			controllingAvatar = _avatarMap[_choice];
			if ( controllingAvatar == null )
			{
				controllingAvatar = new Avatar(this, _choice, _spawningPoint.x, _spawningPoint.y);
				_avatarMap[_choice] = controllingAvatar;
				Reg.AVATAR_VIEWS.add( controllingAvatar.view );
				Reg.AVATAR_TYPES_MAP[_choice].add( controllingAvatar.view );
			}
		}
		else
		{
			controllingAvatar = null;
		}
		
		ui.showChoices();
		updateControls();
		Reg.PLAYER_UI_LAYER.remove( path );
		path.reset(0, 0);
		switchState( PlayerState.PLAYING );
	}
	
	public function wait():Void
	{
		ui.showWait();
		
		//this.path.drawPaths();
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
		if ( allAvatarsDead() )
		{
			_choice = null;
			ui.showReady();
			switchState( PlayerState.WAITING );
			return;
		}
		
		for ( l_key in CHOICE_MAP.keys() )
		{
			if ( inputMap.inputMap[ l_key ]() )
			{
				var l_choice:AvatarType = CHOICE_MAP[l_key];
				if ( _avatarMap[ l_choice ] == null || _avatarMap[ l_choice ].frozen == false )
				{
					_choice = l_choice;
					ui.showReady();
					switchState( PlayerState.WAITING );
					break;
				}
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
	}
	
	public function startRewinding():Void
	{
		switchState( PlayerState.REWINDING );
		
		for ( l_avatar in _avatarMap )
		{
			l_avatar.rewind();
		}
	}
	
	// check if a player has an avatar to play
	public function allAvatarsDead():Bool
	{
		if ( hasJoined() )
		{
			for ( l_avatarType in AvatarType.TYPES )
			{
				var l_avatar:Avatar = _avatarMap[ l_avatarType ];
				if ( l_avatar == null || l_avatar.frozen == false )
				{
					return false;
				}
			}
		}
		
		return true;
	}
	
	public function isAvatarFrozen( p_avatar:AvatarType ):Bool
	{
		if ( _avatarMap[ p_avatar ] == null )
		{
			return false;
		}
		
		return _avatarMap[ p_avatar ].frozen;
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
		path.drawPaths();
		Reg.PLAYER_UI_LAYER.add( path );
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