package intersections;

import flixel.FlxSprite;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import input.DirectionVector;

/**
 * ...
 * @author 
 */
class IntersectionNode extends FlxSprite
{
	public var mapPoint:FlxPoint;
	
	//private var _validDirections:Map<Directions,Bool>;
	
	public var validDirections(default, null):Array<Directions>;
	
	public function new( p_mapPoint:FlxPoint, p_width:Int, p_height:Int, p_mapCollisions:FlxTilemap ) 
	{
		var l_mapPointToCheck:FlxPoint;
		var l_directionVector:DirectionVector;
		
		super();
		
		mapPoint = p_mapPoint;
		
		this.makeGraphic(p_width, p_height);
		color = FlxColor.CYAN;
		
		x = mapPoint.x * p_width;
		y = mapPoint.y * p_height;
		
		validDirections = new Array<Directions>();
		
		
		for ( l_direction in Reg.DIRECTION_LIST )
		{
			l_mapPointToCheck = FlxPoint.get(p_mapPoint.x, p_mapPoint.y);
			l_directionVector = Reg.DIRECTION_VECTORS[ l_direction ];
			
			Reflect.setProperty(l_mapPointToCheck, l_directionVector.axis, Reflect.getProperty( l_mapPointToCheck, l_directionVector.axis ) + l_directionVector.magnitude);
			
			if( isValidDirection( p_mapCollisions, Std.int(l_mapPointToCheck.x), Std.int(l_mapPointToCheck.y) ) )
			{
				validDirections.push( l_direction );
			}
			
			l_mapPointToCheck.put();
		}
	}
	
	private static function isValidDirection( p_mapCollsiions:FlxTilemap, p_x:Int, p_y:Int ):Bool
	{
		return p_mapCollsiions.getTile( p_x, p_y ) == 0;
	}
	
}