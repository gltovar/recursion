package;

import avatar.AvatarType;
import avatar.AvatarView;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxPath;
import flixel.util.FlxPoint;
import flixel.util.FlxStringUtil;
import input.InputMap;
import intersections.IntersectionNode;
import player.Player;

class PlayState extends FlxState
{
	private var _map:FlxTilemap;
	private var _mapCollisions:FlxTilemap;
	private var _intersections:FlxTypedGroup<IntersectionNode>;
	
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
		
		
		new Player(_intersections, InputMap.WSAD, 16, 176);	
		new Player(_intersections, InputMap.ARROW_KEYS, 330, 176);
		
		add( Reg.AVATAR_VIEWS );
	}
	
	override public function update():Void
	{
		super.update();
		
		FlxG.collide(Reg.AVATAR_VIEWS, _mapCollisions );
		
		for ( l_avatarType in AvatarType.TYPES )
		{
			FlxG.overlap( Reg.AVATAR_TYPES_MAP[ l_avatarType ], Reg.AVATAR_TYPES_MAP[ AvatarType.WEAK_TO[ l_avatarType]], onWeaknessOverlap );
		}
		
		if (FlxG.keys.justReleased.ENTER)
		{
			FlxG.switchState(new PlayState2());
		}
		
		for ( l_player in Reg.PLAYERS )
		{
			l_player.update();
		}
	}
	
	private function onWeaknessOverlap( p_weakView:AvatarView, p_view:AvatarView ):Void
	{
		if ( p_view.avatar.player != p_weakView.avatar.player )
		{
			p_weakView.color = FlxColor.BLACK;
		}
	}
}