package;

import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.group.FlxTypedSpriteGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxPath;
import flixel.util.FlxPoint;
import flixel.util.FlxStringUtil;
import input.InputMap;
import intersections.IntersectionNode;

class PlayState extends FlxState
{
	private var _map:FlxTilemap;
	private var _mapCollisions:FlxTilemap;
	//private var _intersections:FlxTilemap;
	private var _intersections:FlxTypedGroup<IntersectionNode>;
	//private var _avatar:Avatar;
	private var _player:Player;
	private var _player2:Player;
	
	override public function create():Void
	{			
		FlxG.mouse.visible = false;
		
		// Background
		FlxG.state.bgColor = 0xffacbcd7;
		
		var path:FlxPath;
		var sprite:FlxSprite;
		var destination:FlxPoint;
		
		// Basic level structure
		_map = new FlxTilemap();
		_map.loadMap(FlxStringUtil.imageToCSV("assets/pacmap.png", false, 2), "assets/tiles.png", 0, 0, FlxTilemap.ALT);
		add(_map);
		
		_mapCollisions = new FlxTilemap();
		_mapCollisions.loadMap(FlxStringUtil.imageToCSV("assets/pacmap.png", false), "assets/basic_tiles.png");
		

		_intersections = new FlxTypedGroup<IntersectionNode>();
		
		var l_indexRow:Int = 0;
		var l_indexColumn:Int = 0;
		var l_intersectionNode:IntersectionNode = null;
		
		
		var l_intersectionData:String = FlxStringUtil.imageToCSV("assets/pacmap_intersections.png", false);
		var l_rows:Array<String> = l_intersectionData.split("\n");
		var l_columns:Array<String> = null;
		
		while ( l_indexRow < l_rows.length )
		{
			l_columns = l_rows[ l_indexRow ].split(", ");
			l_indexColumn = 0;
			while ( l_indexColumn < l_columns.length )
			{
				if ( l_columns[ l_indexColumn ] == "1" )
				{
					//trace("Found a node!");
					l_intersectionNode = new IntersectionNode( new FlxPoint( l_indexColumn, l_indexRow ), 16, 16, _mapCollisions );
					_intersections.add( l_intersectionNode );
				}
				++l_indexColumn;
			}
			++l_indexRow;
		}
		add( _intersections );
		
		
		_player = new Player(_intersections, InputMap.WSAD);
		add( _player.controllingAvatar);
		
		_player2 = new Player(_intersections, InputMap.ARROW_KEYS);
		add( _player2.controllingAvatar );
		
		
		//FlxArrayUtil.
		
		// Then add the player, its own class with its own logic
		
		/*_avatar = new Avatar(32, 176);
		add(_avatar);
		_avatar.intersections = _intersections;*/
		
	}
	
	override public function update():Void
	{
		super.update();
		
		
		
		FlxG.collide(_player.controllingAvatar, _mapCollisions);
		FlxG.collide(_player2.controllingAvatar, _mapCollisions);
		//FlxG.overlap(_player, _intersections, playerAtIntersection);
		
		if (FlxG.keys.justReleased.ENTER)
		{
			FlxG.switchState(new PlayState2());
		}
		
		_player.update();
		_player2.update();
	}
}