package player;
import avatar.AvatarType;
import avatar.AvatarView;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.U;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import player.Player;

/**
 * ...
 * @author 
 */
class PlayerUIManager extends FlxBasic
{
	private static var AVATAR_BUTTON_NAME_MAP:Map<AvatarType, String> = [ 	AvatarType.ROCK => "button_rock",
																			AvatarType.PAPER => "button_paper",
																			AvatarType.SCISSORS => "button_scissors" ];
	
	public var player(default, null):Player;
	
	private var _ui:FlxUI;
	
	private var _avatarButtonMap:Map<AvatarType, FlxUIButton>;
	
	public function new( p_player:Player ) 
	{
		super();
		
		player = p_player;
		
		_ui = new FlxUI( U.xml("player_ui") );
		Reg.PLAYER_UI_LAYER.add( _ui );
		_ui.setPosition( player.uiPoint.x, player.uiPoint.y );
		
		cast(_ui.getAsset("back"), FlxSprite).color = Reg.PLAYER_COLORS[ Reg.PLAYERS.indexOf(player) ];
		
		_avatarButtonMap = new Map<AvatarType, FlxUIButton>();
		
		for ( l_type in AvatarType.TYPES )
		{
			_avatarButtonMap[ l_type ] = cast( _ui.getAsset( AVATAR_BUTTON_NAME_MAP[ l_type ] ), FlxUIButton );
		}
	}
	
	override public function update():Void 
	{
		super.update();	
	}
	
	public function showChoices():Void
	{
		_ui.setMode("mode_show_choices");
		
		for ( l_type in AvatarType.TYPES )
		{
			if ( player.isAvatarFrozen( l_type ) )
			{
				_avatarButtonMap[ l_type ].color = FlxColor.CRIMSON;
			}
			else
			{
				_avatarButtonMap[ l_type ].color = FlxColor.FOREST_GREEN;
			}
		}
	}
		
	public function showJoin():Void
	{
		_ui.setMode("mode_join");
	}
	
	public function showReady():Void
	{
		_ui.setMode("mode_ready");
	}
	
	public function showWait():Void
	{
		_ui.setMode("mode_wait");
	}
}