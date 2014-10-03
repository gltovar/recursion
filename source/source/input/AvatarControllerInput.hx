package input;

import avatar.AvatarView;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import intersections.IntersectionNode;
import openfl.events.EventDispatcher;
import avatar.Avatar;

/**
 * ...
 * @author 
 */
class AvatarControllerInput extends FlxBasic implements IAvatarController
{
	public var dispatcher(default, null):EventDispatcher;
	public var intersections:FlxTypedGroup<IntersectionNode>;

	private var avatar:Avatar;
	private static inline var INPUT_MAX_RELEASE_TIME:Int = 300;
	private var _currentIntersection:IntersectionNode = null;
	public var currentDirection(default, null):Directions;
	private var _timeLastPressed:Map<Directions, Int>; 
	
	
	private var _prevPassedThroughCenter:Bool = false;
	private var _intendedDirection:Directions = Directions.NONE;
	

	
	public function new( p_avatar:Avatar ) 
	{
		super();
		
		currentDirection = Directions.NONE;
		
		dispatcher = new EventDispatcher();
		
		avatar = p_avatar;
		
		_timeLastPressed = [Directions.UP 		=> 0,
							Directions.DOWN 	=> 0,
							Directions.LEFT 	=> 0,
							Directions.RIGHT 	=> 0 ];
							
		intersections = avatar.player.intersections;
		
	}
	
	public function atIntersection():Void
	{
		avatar.view.color = FlxColor.RED;
	}
	
	private function updateVelocity( p_direction:Directions )
	{
		if ( p_direction == null )
		{
			throw "direction should never be null";
		}
		
		avatar.view.velocity.set(0, 0);
		if ( p_direction != Directions.NONE)
		{
			var l_directionVector = Reg.DIRECTION_VECTORS[ p_direction ];			
			Reflect.setProperty( avatar.view.velocity,  l_directionVector.axis, Reflect.getProperty(avatar.view.maxVelocity, l_directionVector.axis) * l_directionVector.magnitude );
		}
		
		
		currentDirection = p_direction;
		dispatcher.dispatchEvent(new AvatarControllerEvent( AvatarControllerEvent.DIRECTION_CHANGE ) );
	}
	
	private function onIntersectionOverlap( p_player:AvatarView, p_intersectionNode:IntersectionNode ):Void
	{
		if ( _currentIntersection == null || _currentIntersection != p_intersectionNode )
		{
			_currentIntersection = p_intersectionNode;
			avatar.view.color = FlxRandom.color(100, 255);
			_prevPassedThroughCenter = false;
		}
	}
	
	private function passedThroughCenterTest():Bool
	{
		if ( currentDirection != Directions.NONE && _currentIntersection != null )
		{
			var l_directionVector:DirectionVector = Reg.DIRECTION_VECTORS[currentDirection];
			if ( l_directionVector.magnitude < 0 )
			{
				return Reflect.getProperty(avatar.view, l_directionVector.axis) <= Reflect.getProperty(_currentIntersection, l_directionVector.axis);
			}
			else
			{
				return Reflect.getProperty(avatar.view, l_directionVector.axis) >= Reflect.getProperty(_currentIntersection, l_directionVector.axis);
			}
		}
		
		return true;
	}
	
	override public function update():Void
	{
		super.update();
		
		if ( FlxMath.getDistance( avatar.view.velocity, FlxPoint.weak() ) == 0 )
		{
			currentDirection = Directions.NONE;
		}
		
		var l_directionVector:DirectionVector;
		
		for ( l_direction in Reg.DIRECTION_LIST )
		{
			if ( avatar.player.inputMap.inputMap[l_direction]() )
			{
				_timeLastPressed[ l_direction ] = FlxG.game.ticks;
			}
		}
		
		FlxG.overlap( avatar.view, intersections, onIntersectionOverlap );
		
		if( _currentIntersection != null)
		{
			
			
			var l_passedThoughCenterTest:Bool = passedThroughCenterTest();
			var l_amountPassedCenter:Int = FlxMath.distanceBetween(avatar.view, _currentIntersection);
			if ( FlxMath.distanceBetween(avatar.view, _currentIntersection) <= 4 )
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
					if (  l_newDirection != currentDirection)
					{
						if ( l_passedThoughCenterTest != _prevPassedThroughCenter ) // Just Passed thoug the center
						{
							if (l_newDirection != Reg.OPPOSITE_DIRECTION[ currentDirection ] && l_newDirection != currentDirection )
							{
								l_directionVector = Reg.DIRECTION_VECTORS[ l_newDirection ];
								avatar.view.setPosition( _currentIntersection.x, _currentIntersection.y );
								
								updateVelocity( l_newDirection);
								//trace("map: " + _timeLastPressed.toString() + "   Direction: " + l_newDirection );
							}
						}
						else if(currentDirection != Directions.NONE)
						{
							updateVelocity( Reg.OPPOSITE_DIRECTION[ currentDirection ] );
						}
						else
						{
							avatar.view.setPosition( _currentIntersection.x, _currentIntersection.y );
						}
					}
				}
				
			}
			
		}
		
		if ( currentDirection == Directions.NONE)
		{
			var l_directionsList:Array<Directions> = (_currentIntersection != null) ? _currentIntersection.validDirections : Reg.DIRECTION_LIST;
			
			for ( l_direction in l_directionsList )
			{
				
				if ( avatar.player.inputMap.inputMap[l_direction]() )
				{
					updateVelocity( l_direction );
				}
			}
		}
		else if (avatar.player.inputMap.inputMap[ Reg.OPPOSITE_DIRECTION[currentDirection] ]() )
		{
			updateVelocity( Reg.OPPOSITE_DIRECTION[currentDirection] );
		}
		
		if ( _currentIntersection != null && avatar.view.overlaps(_currentIntersection) == false )
		{
			_currentIntersection = null;
			avatar.view.color = FlxColor.WHITE;
		}
		
		if ( _currentIntersection != null )
		{
			_prevPassedThroughCenter = passedThroughCenterTest();
		}
		
	}
	
	override public function destroy():Void 
	{
		dispatcher = null;
		
		super.destroy();
	}
}