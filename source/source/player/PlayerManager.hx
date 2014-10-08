package player;

import flixel.FlxBasic;
import flixel.FlxG;

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
		state = GameState.CHOOSING;
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
		}
	}
	
	public function switchState( p_newStae:GameState )
	{
		state = p_newStae;
	}
	
	private function choosing():Void
	{
		if ( Reg.PLAYERS.length == 0 )
		{
			return;
		}
		
		for ( l_player in Reg.PLAYERS )
		{
			if ( l_player.hasChosen() == false )
			{
				return;
			}
		}
		
		startPlaying();
	}
	
	private function startPlaying():Void
	{
		_runTime = 0;
		
		for ( l_player in Reg.PLAYERS )
		{
			l_player.startPlaying();
		}
		
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
		for ( l_player in Reg.PLAYERS )
		{
			l_player.startRewinding();
		}
		
		switchState( GameState.REWINDING );
	}
	
	private function rewinding():Void
	{
		for ( l_player in Reg.PLAYERS )
		{
			if ( l_player.state == PlayerState.REWINDING )
			{
				return;
			}
		}
		
		switchState( GameState.CHOOSING );
	}
}