package player;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.U;
import flixel.FlxBasic;
import flixel.FlxSprite;
import player.Player;

/**
 * ...
 * @author 
 */
class PlayerUIManager extends FlxBasic
{
	public var player(default, null):Player;
	
	private var _ui:FlxUI;
	
	public function new( p_player:Player ) 
	{
		super();
		
		player = p_player;
		
		_ui = new FlxUI( U.xml("player_ui") );
		Reg.PLAYER_UI_LAYER.add( _ui );
		_ui.setPosition( player.uiPoint.x, player.uiPoint.y );
		
		cast(_ui.getAsset("back"), FlxSprite).color = Reg.PLAYER_COLORS[ Reg.PLAYERS.indexOf(player) ];
	}
	
	override public function update():Void 
	{
		super.update();	
	}
	
	public function showChoices():Void
	{
		_ui.setMode("mode_show_choices");
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