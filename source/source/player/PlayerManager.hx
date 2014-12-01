package player;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class PlayerManager extends FlxBasic
{	
	public var state(default, null):GameState;

	private var _runTime:Float;
	
	public function new() 
	{
		super();
		switchToChoosing();
	}
	
	override public function update():Void 
	{
		super.update();
		
		switch( state )
		{
			case GameState.CHOOSING:
				choosing();
			case GameState.PLAYING:
				playing();
			case GameState.REWINDING:
				rewinding();
			case GameState.SHOW_WINNER:
				showWinner();
		}
	}
	
	public function showWinner():Void
	{
		if ( FlxG.keys.justReleased.ENTER == true )
		{
			FlxG.switchState( new PlayState() );
		}
	}
	
	public function switchState( p_newStae:GameState )
	{
		state = p_newStae;
	}
	
	private function choosing():Void
	{
		var l_readyPlayers = 0;
		
		for ( l_player in Reg.PLAYERS )
		{
			if ( l_player.hasJoined())
			{
				if ( l_player.hasChosen() )
				{
					++l_readyPlayers;
				}
				else
				{
					return;
				}
			}
		}
		
		if ( l_readyPlayers >= Reg.MIN_PLAYERS )
		{
			startPlaying();
		}
	}
	
	private function startPlaying():Void
	{
		_runTime = 0;
		
		Reg.PLAYER_AVATAR_END_POINTS.callAll("destroy"); // destroy all the avatars that were showing where players ended.
		
		for ( l_player in Reg.PLAYERS ) // eitherr having players that are ready starting playing, or disable the ones that aren't
		{
			if ( l_player.hasJoined() )
			{
				l_player.startPlaying();
			}
			else
			{
				l_player.wait();
			}
		}
		
		FlxG.sound.playMusic( Reg.MUSIC_PLAYING, .75 );
		switchState( GameState.PLAYING );
	}
	
	private function playing():Void
	{
		_runTime += FlxG.elapsed;
		
		if ( _runTime >= Reg.GAME_DURATION )
		{
			startRewinding();
		}
	}
	
	private function startRewinding():Void
	{
		var l_playersLeft:Int = 0;
		for ( l_player in Reg.PLAYERS )
		{
			if ( l_player.allAvatarsDead() == false )
			{
				++l_playersLeft;
			}
		}
		
		if ( l_playersLeft < Reg.MIN_PLAYERS )
		{
			announceWinner();
			return;
		}
		
		for ( l_player in Reg.PLAYERS )
		{
			if ( l_player.hasJoined() )
			{
				l_player.startRewinding();
			}
		}
		
		FlxG.sound.playMusic( Reg.MUSIC_REWIND,.75 );
		switchState( GameState.REWINDING );
	}
	
	private function announceWinner():Void
	{
		for ( l_player in Reg.PLAYERS )
		{
			if ( l_player.allAvatarsDead() == false )
			{
				announcePlayerWinner( l_player );
				return;
			}
		}
		
		announceDraw();
	}
	
	private function announcePlayerWinner( p_player:Player ):Void
	{
		var l_winText:FlxText = new FlxText(0, FlxG.height *.5 - 50, FlxG.width, p_player.id + " Wins! [ENTER] to play again.", 32);
		l_winText.color = Reg.PLAYER_COLORS[ Reg.PLAYERS.indexOf( p_player ) ];
		Reg.PLAYER_UI_LAYER.add( l_winText );
		
		switchState( GameState.SHOW_WINNER );
	}
	
	private function announceDraw():Void
	{
		var l_winText:FlxText = new FlxText(0, FlxG.height * .5 - 50, FlxG.width, "DRAW! [ENTER] to play again.", 32);
		l_winText.color = FlxColor.SILVER;
		Reg.PLAYER_UI_LAYER.add( l_winText );
		
		switchState( GameState.SHOW_WINNER );
	}
	
	private function rewinding():Void
	{
		for ( l_player in Reg.PLAYERS )
		{
			if ( l_player.hasJoined() )
			{
				if ( l_player.state == PlayerState.REWINDING )
				{
					return;
				}
			}
		}
		
		for ( l_player in Reg.PLAYERS )
		{
			if ( l_player.hasJoined() == false )
			{
				l_player.init();
			}
		}
		
		switchToChoosing();
	}
	
	private function switchToChoosing():Void
	{
		FlxG.sound.playMusic( Reg.MUSIC_CHOOSE, .5 );
		switchState( GameState.CHOOSING );
	}
}