package replay;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxVector;
import flixel.util.loaders.TexturePackerData;
import intersections.IntersectionNode;

/**
 * ...
 * @author 
 */
class PlayerPath extends FlxSpriteGroup
{
	public static inline var PATH_TOP:String = "top_path";
	public static inline var PATH_MID:String = "mid_path";
	public static inline var PATH_BOTTOM:String = "low_path";
	public static var PATH_IDS:Array<String> = [PATH_TOP, PATH_MID, PATH_BOTTOM];
	
	public static inline var DIRECTION_TOP:String = "_top";
	public static inline var DIRECTION_LEFT:String = "_left";
	public static inline var DIRECTION_BOTTOM:String = "_bottom";
	public static inline var DIRECTION_RIGHT:String = "_right";
	public static inline var DIRECTION_LEFT_TOP:String = "_left_top";
	public static inline var DIRECTION_LEFT_BOTTOM:String = "_left_bottom";
	public static inline var DIRECTION_RIGHT_TOP:String = "_right_top";
	public static inline var DIRECTION_RIGHT_BOTTOM:String = "_right_bottom";
	public static inline var DIRECTION_HORIZONTAL:String = "_horz";
	public static inline var DIRECTION_VERTICAL:String = "_vert";
	public static var PATH_TYPES:Array<String> = [DIRECTION_TOP, DIRECTION_LEFT, DIRECTION_BOTTOM, DIRECTION_RIGHT, DIRECTION_LEFT_TOP, DIRECTION_LEFT_BOTTOM, DIRECTION_RIGHT_TOP, DIRECTION_RIGHT_BOTTOM, DIRECTION_HORIZONTAL, DIRECTION_VERTICAL];
	
	public static var DIRECTIONS_TO_PATH:Map<Directions, Map<Directions, String>> = [	
																						Directions.LEFT => 	[ 	Directions.UP 		=> PlayerPath.DIRECTION_LEFT_TOP,
																												Directions.DOWN 	=> PlayerPath.DIRECTION_LEFT_BOTTOM,
																												Directions.LEFT 	=> PlayerPath.DIRECTION_LEFT,
																												Directions.RIGHT 	=> PlayerPath.DIRECTION_HORIZONTAL],
																						
																						Directions.RIGHT => [	Directions.UP 		=> PlayerPath.DIRECTION_RIGHT_TOP,
																												Directions.DOWN		=> PlayerPath.DIRECTION_RIGHT_BOTTOM,
																												Directions.LEFT		=> PlayerPath.DIRECTION_HORIZONTAL,
																												Directions.RIGHT	=> PlayerPath.DIRECTION_RIGHT],
																						
																						Directions.UP => 	[	Directions.UP		=> PlayerPath.DIRECTION_TOP,
																												Directions.DOWN		=> PlayerPath.DIRECTION_VERTICAL,
																												Directions.LEFT		=> PlayerPath.DIRECTION_LEFT_TOP,
																												Directions.RIGHT	=> PlayerPath.DIRECTION_RIGHT_TOP],
																												
																						Directions.DOWN =>	[	Directions.UP		=> PlayerPath.DIRECTION_VERTICAL,
																												Directions.DOWN		=> PlayerPath.DIRECTION_BOTTOM,
																												Directions.LEFT		=> PlayerPath.DIRECTION_LEFT_BOTTOM,
																												Directions.RIGHT	=> PlayerPath.DIRECTION_RIGHT_BOTTOM]
																					];
	
	private var _lastPathNode:Map<String, Array<FlxPoint> >;
	private var _drawFirstNode:Map<String, Bool>;
	
	public var texture(get, null):TexturePackerData;

	public function new(X:Float=0, Y:Float=0, MaxSize:Int=0) 
	{
		super(X, Y, MaxSize);
		
		reset(X, Y);
		
	}
	
	public function get_texture():TexturePackerData
	{
		if ( this.texture == null )
		{
			texture = new TexturePackerData("assets/characters.json", "assets/characters.png");
		}
		
		return texture;
	}
	
	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
		_lastPathNode = [	PATH_BOTTOM => new Array<FlxPoint>(),
							PATH_MID 	=> new Array<FlxPoint>(),
							PATH_TOP 	=> new Array<FlxPoint>() ];
							
		_drawFirstNode = [	PATH_BOTTOM => true,
							PATH_MID	=> true,
							PATH_TOP	=> true ];
	}
	
	public function addPathNode( p_pathId:String, p_x:Float, p_y:Float ):Void
	{
		//var l_newPoint:FlxPoint = FlxPoint.get( Math.floor((p_x-(Reg.TILE_SIDE*.5))/Reg.TILE_SIDE), Math.floor((p_y-(Reg.TILE_SIDE*.5))/Reg.TILE_SIDE) );
		
		var l_newPoint:FlxPoint = FlxPoint.get( Math.floor(  ( p_x - ( Reg.TILE_SIDE * .5 ) )  / Reg.TILE_SIDE ),
												Math.floor(  ( p_y - ( Reg.TILE_SIDE * .5 ) )  / Reg.TILE_SIDE ) );
												
		
		var l_targetArray:Array<FlxPoint> = _lastPathNode[ p_pathId ];
		
		if ( (l_targetArray.length > 0 && (l_targetArray[l_targetArray.length - 1].distanceTo( l_newPoint ) ) >= 1)
			 ||	(l_targetArray.length == 0 ) )
		{
			l_targetArray.push( l_newPoint );
			
			//FlxG.log.add( "new point: " + l_newPoint );
		}
	}
	
	public function drawPaths():Void
	{
		var l_pathIndex:Int = 0;
		var l_pathsToCheck:Array<String> = [ PATH_TOP, PATH_MID, PATH_BOTTOM ];
		var l_pathId:String;
		var l_pathIdIndex:Int;
		
		while ( l_pathsToCheck.length > 0 )
		{
			l_pathIdIndex = l_pathsToCheck.length - 1;
			while(l_pathIdIndex >= 0)
			{
				l_pathId = l_pathsToCheck[ l_pathIdIndex ];
				if ( _lastPathNode[ l_pathId ].length > l_pathIndex + 1 )
				{
					setAnimationOfPath( _lastPathNode[ l_pathId ], l_pathId, l_pathIndex );
				}
				else
				{
					l_pathsToCheck.splice( l_pathIdIndex, 1 );
				}
				--l_pathIdIndex;
			}
			
			++l_pathIndex;
		}
		
		
	}
	
	private function setAnimationOfPath(p_pathPoints:Array<FlxPoint>, p_pathId:String, p_pathIndex:Int):Void
	{
		var l_prevDirection:Directions = Directions.RIGHT;
		var l_nextDirection:Directions = Directions.RIGHT;
		var l_directionMagnitute:FlxPoint = null;
		var l_pointsToCheck:Array<FlxPoint>;
		var l_pointCurrentlyChecking:FlxPoint;
		
		var l_pathFrameId:String = "";
		
		if ( p_pathIndex != 0 && p_pathIndex+1 < p_pathPoints.length )
		{
			l_directionMagnitute = p_pathPoints[ p_pathIndex-1 ].copyTo();
			l_directionMagnitute.subtractPoint( p_pathPoints[ p_pathIndex ]);
			
			l_prevDirection = determineDirection( l_directionMagnitute );
			
			
			l_directionMagnitute = p_pathPoints[ p_pathIndex + 1 ].copyTo();
			l_directionMagnitute.subtractPoint( p_pathPoints[ p_pathIndex ]);
			
			l_nextDirection = determineDirection( l_directionMagnitute );
		}
		else if( p_pathPoints.length > 1 )
		{
			if ( p_pathIndex == 0 )
			{
				l_directionMagnitute = p_pathPoints[ p_pathIndex+1 ].copyTo();
				l_directionMagnitute.subtractPoint( p_pathPoints[ p_pathIndex ]);
				
				l_prevDirection = l_nextDirection = determineDirection( l_directionMagnitute );
			}
			else
			{
				l_directionMagnitute = p_pathPoints[ p_pathIndex-1 ].copyTo();
				l_directionMagnitute.subtractPoint( p_pathPoints[ p_pathIndex ]);
				
				l_prevDirection = l_nextDirection = determineDirection( l_directionMagnitute );
			}
		}
		
		if ( l_directionMagnitute != null )
		{
			l_directionMagnitute.put();
		}
		
		l_pathFrameId = p_pathId + DIRECTIONS_TO_PATH[ l_prevDirection ][ l_nextDirection ];
		
		var l_sprite:FlxSprite = cast( recycle(FlxSprite), FlxSprite );
		l_sprite.loadGraphicFromTexture( texture, false );
		l_sprite.animation.addByPrefix( l_pathFrameId, l_pathFrameId, 30, false);
		l_sprite.animation.play( l_pathFrameId );
		add(l_sprite);
		l_sprite.color = this.color;
		l_sprite.centerOffsets();
		l_sprite.setPosition( p_pathPoints[p_pathIndex].x * Reg.TILE_SIDE + Reg.TILE_SIDE , p_pathPoints[p_pathIndex].y * Reg.TILE_SIDE + Reg.TILE_SIDE );
		
	}
	
	private function determineDirection( p_magnitude:FlxPoint ):Directions
	{
		if ( p_magnitude.x != 0 )
		{
			if ( p_magnitude.x > 0 )
			{
				return Directions.RIGHT;
			}
			else
			{
				return Directions.LEFT;
			}
		}
		else
		{
			if ( p_magnitude.y > 0 )
			{
				return Directions.DOWN;
			}
			else
			{
				return Directions.UP;
			}
		}
		
		return null;
	}
}