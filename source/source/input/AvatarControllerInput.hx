package input;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import intersections.IntersectionNode;

/**
 * ...
 * @author 
 */
class AvatarControllerInput extends FlxBasic
{

	private var _player:Player;
	
	private static inline var INPUT_MAX_RELEASE_TIME:Int = 300;
	
	private var _currentIntersection:IntersectionNode = null;
	private var _currentDirection:Directions = Directions.NONE;
	
	private var _timeLastPressed:Map<Directions, Int>; 
	
	
	public var intersections:FlxTypedGroup<IntersectionNode>;
	
	private var _prevPassedThroughCenter:Bool = false;
	private var _intendedDirection:Directions = Directions.NONE;
	

	//private var ButtonInput
	
	public function new( p_player:Player ) 
	{
		super();
		
		_player = p_player;
		
		_timeLastPressed = [Directions.UP 		=> 0,
							Directions.DOWN 	=> 0,
							Directions.LEFT 	=> 0,
							Directions.RIGHT 	=> 0 ];
		
	}
	
	public function atIntersection():Void
	{
		_player.controllingAvatar.color = FlxColor.RED;
	}
	
	private function updateVelocity( p_direction:Directions )
	{
		if ( p_direction == null )
		{
			throw "direction should never be null";
		}
		
		_player.controllingAvatar.velocity.set(0, 0);
		if ( p_direction != Directions.NONE)
		{
			var l_directionVector = Reg.DIRECTION_VECTORS[ p_direction ];			
			Reflect.setProperty( _player.controllingAvatar.velocity,  l_directionVector.axis, Reflect.getProperty(_player.controllingAvatar.maxVelocity, l_directionVector.axis) * l_directionVector.magnitude );
		}
		_currentDirection = p_direction;
	}
	
	private function onIntersectionOverlap( p_player:Avatar, p_intersectionNode:IntersectionNode ):Void
	{
		if ( _currentIntersection == null || _currentIntersection != p_intersectionNode )
		{
			_currentIntersection = p_intersectionNode;
			_player.controllingAvatar.color = FlxRandom.color(100, 255);
			_prevPassedThroughCenter = false;
		}
	}
	
	private function passedThroughCenterTest():Bool
	{
		if ( _currentDirection != Directions.NONE && _currentIntersection != null )
		{
			var l_directionVector:DirectionVector = Reg.DIRECTION_VECTORS[_currentDirection];
			if ( l_directionVector.magnitude < 0 )
			{
				return Reflect.getProperty(_player.controllingAvatar, l_directionVector.axis) <= Reflect.getProperty(_currentIntersection, l_directionVector.axis);
			}
			else
			{
				return Reflect.getProperty(_player.controllingAvatar, l_directionVector.axis) >= Reflect.getProperty(_currentIntersection, l_directionVector.axis);
			}
		}
		
		return true;
	}
	
	override public function update():Void
	{
		super.update();
		
		if ( FlxMath.getDistance( _player.controllingAvatar.velocity, FlxPoint.weak() ) == 0 )
		{
			_currentDirection = Directions.NONE;
		}
		
		var l_directionVector:DirectionVector;
		
		for ( l_direction in Reg.DIRECTION_LIST )
		{
			if ( _player.inputMap.inputMap[l_direction]() )
			{
				_timeLastPressed[ l_direction ] = FlxG.game.ticks;
			}
		}
		
		FlxG.overlap( _player.controllingAvatar, intersections, onIntersectionOverlap );
		
		if( _currentIntersection != null)
		{
			
			
			var l_passedThoughCenterTest:Bool = passedThroughCenterTest();
			var l_amountPassedCenter:Int = FlxMath.distanceBetween(_player.controllingAvatar, _currentIntersection);
			if ( FlxMath.distanceBetween(_player.controllingAvatar, _currentIntersection) <= 4 )
			{
				var l_newDirection:Directions = Directions.NONE;
				var l_lowestDirectionTime:Int = 0;
				for (l_direction in _currentIntersection.validDirections)
				{
					if (_timeLastPressed[l_direction] > FlxG.game.ticks - INPUT_MAX_RELEASE_TIME && l_lowestDirectionTime < _timeLastPressed[ l_direction ])
					{
						l_newDirection  = l_direction;
						l_lowestDirectionTime = _timeLastPressed[ l_newDirection ];
					}
				}
				
				if (l_newDirection != Directions.NONE &&  l_passedThoughCenterTest)
				{
					if (  l_newDirection != _currentDirection)
					{
						if ( l_passedThoughCenterTest != _prevPassedThroughCenter ) // Just Passed thoug the center
						{
							if (l_newDirection != Reg.OPPOSITE_DIRECTION[ _currentDirection ] && l_newDirection != _currentDirection )
							{
								l_directionVector = Reg.DIRECTION_VECTORS[ l_newDirection ];
								_player.controllingAvatar.setPosition( _currentIntersection.x, _currentIntersection.y );
								
								updateVelocity( l_newDirection);
								//trace("map: " + _timeLastPressed.toString() + "   Direction: " + l_newDirection );
							}
						}
						else if(_currentDirection != Directions.NONE)
						{
							updateVelocity( Reg.OPPOSITE_DIRECTION[ _currentDirection ] );
						}
						else
						{
							_player.controllingAvatar.setPosition( _currentIntersection.x, _currentIntersection.y );
						}
					}
				}
				
			}
			
		}
		
		if ( _currentDirection == Directions.NONE)
		{
			var l_directionsList:Array<Directions> = (_currentIntersection != null) ? _currentIntersection.validDirections : Reg.DIRECTION_LIST;
			
			for ( l_direction in l_directionsList )
			{
				
				if ( _player.inputMap.inputMap[l_direction]() )
				{
					updateVelocity( l_direction );
				}
			}
		}
		else if (_player.inputMap.inputMap[ Reg.OPPOSITE_DIRECTION[_currentDirection] ]() )
		{
			updateVelocity( Reg.OPPOSITE_DIRECTION[_currentDirection] );
		}
		
		if ( _currentIntersection != null && _player.controllingAvatar.overlaps(_currentIntersection) == false )
		{
			_currentIntersection = null;
			_player.controllingAvatar.color = FlxColor.WHITE;
		}
		
		if ( _currentIntersection != null )
		{
			_prevPassedThroughCenter = passedThroughCenterTest();
		}
		
	}
}