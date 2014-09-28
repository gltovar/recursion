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
import input.DirectionVector;
import input.InputMap;
import intersections.IntersectionNode;

class Avatar extends FlxSprite
{
	private static inline var INPUT_MAX_RELEASE_TIME:Int = 300;
	
	private var _currentIntersection:IntersectionNode = null;
	private var _currentDirection:Directions = Directions.NONE;
	
	private var _timeLastPressed:Map<Directions, Int>; 
	
	
	public var intersections:FlxTypedGroup<IntersectionNode>;
	
	
	private var _prevPassedThroughCenter:Bool = false;
	private var _intendedDirection:Directions = Directions.NONE;
	
	private var _inputMap:InputMap;
	
	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		
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
		
		_timeLastPressed = [Directions.UP 		=> 0,
							Directions.DOWN 	=> 0,
							Directions.LEFT 	=> 0,
							Directions.RIGHT 	=> 0 ];
							
		_inputMap = new InputMap( function():Bool { return FlxG.keys.pressed.UP; },
												function():Bool { return FlxG.keys.pressed.DOWN; },
												function():Bool { return FlxG.keys.pressed.LEFT; },
												function():Bool { return FlxG.keys.pressed.RIGHT; } );
		
		//FlxG.watch.add( this, "velocity" );
	}
	
	public function atIntersection():Void
	{
		color = FlxColor.RED;
	}
	
	override public function update():Void
	{
		super.update();
		
		if ( FlxMath.getDistance( velocity, FlxPoint.weak() ) == 0 )
		{
			_currentDirection = Directions.NONE;
		}
		
		var l_directionVector:DirectionVector;
		
		for ( l_direction in Reg.DIRECTION_LIST )
		{
			if ( _inputMap.inputMap[l_direction]() )
			{
				_timeLastPressed[ l_direction ] = FlxG.game.ticks;
			}
		}
		
		FlxG.overlap( this, intersections, onIntersectionOverlap );
		
		if( _currentIntersection != null)
		{
			
			
			var l_passedThoughCenterTest:Bool = passedThroughCenterTest();
			var l_amountPassedCenter:Int = FlxMath.distanceBetween(this, _currentIntersection);
			if ( FlxMath.distanceBetween(this, _currentIntersection) <= 4 )
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
								setPosition( _currentIntersection.x, _currentIntersection.y );
								
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
							setPosition( _currentIntersection.x, _currentIntersection.y );
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
				
				if ( _inputMap.inputMap[l_direction]() )
				{
					updateVelocity( l_direction );
				}
			}
		}
		else if (_inputMap.inputMap[ Reg.OPPOSITE_DIRECTION[_currentDirection] ]() )
		{
			updateVelocity( Reg.OPPOSITE_DIRECTION[_currentDirection] );
		}
		
		if ( _currentIntersection != null && overlaps(_currentIntersection) == false )
		{
			_currentIntersection = null;
			color = FlxColor.WHITE;
		}
		
		if ( _currentIntersection != null )
		{
			_prevPassedThroughCenter = passedThroughCenterTest();
		}
		
	}
	
	private function updateVelocity( p_direction:Directions )
	{
		if ( p_direction == null )
		{
			throw "direction should never be null";
		}
		
		velocity.set(0, 0);
		if ( p_direction != Directions.NONE)
		{
			var l_directionVector = Reg.DIRECTION_VECTORS[ p_direction ];			
			Reflect.setProperty( velocity,  l_directionVector.axis, Reflect.getProperty(maxVelocity, l_directionVector.axis) * l_directionVector.magnitude );
		}
		_currentDirection = p_direction;
	}
	
	private function onIntersectionOverlap( p_player:Avatar, p_intersectionNode:IntersectionNode ):Void
	{
		if ( _currentIntersection == null || _currentIntersection != p_intersectionNode )
		{
			_currentIntersection = p_intersectionNode;
			color = FlxRandom.color(100, 255);
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
				return Reflect.getProperty(this, l_directionVector.axis) <= Reflect.getProperty(_currentIntersection, l_directionVector.axis);
			}
			else
			{
				return Reflect.getProperty(this, l_directionVector.axis) >= Reflect.getProperty(_currentIntersection, l_directionVector.axis);
			}
		}
		
		return true;
	}
	
	
}