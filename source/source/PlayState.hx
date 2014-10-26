package;

import avatar.AvatarType;
import avatar.AvatarView;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.U;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxPath;
import flixel.util.FlxPoint;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import haxe.xml.Fast;
import input.InputMap;
import intersections.IntersectionNode;
import player.Player;
import player.PlayerManager;

class PlayState extends FlxUIState
{
	
	private var _map:FlxTilemap;
	private var _mapCollisions:FlxTilemap;
	private var _intersections:FlxTypedGroup<IntersectionNode>;
	private var _playerManager:PlayerManager;
	
	override public function create():Void
	{			
		
		// init statics
		Reg.PLAYERS = [];
		Reg.AVATAR_VIEWS = new FlxTypedGroup<AvatarView>();
		Reg.AVATAR_TYPES_MAP = [	AvatarType.ROCK => new FlxTypedGroup<AvatarView>(),
									AvatarType.PAPER => new FlxTypedGroup<AvatarView>(),
									AvatarType.SCISSORS => new FlxTypedGroup<AvatarView>() ];
		Reg.PLAYER_UI_LAYER = new FlxTypedGroup<FlxSprite>();
		
		
		
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
					l_intersectionNode = new IntersectionNode( new FlxPoint( l_indexColumn, l_indexRow ), 32, 32, _mapCollisions );
					_intersections.add( l_intersectionNode );
				}
				++l_indexColumn;
			}
			++l_indexRow;
		}
		add( _intersections );
		
		
		_playerManager = new PlayerManager();
		Reg.PLAYER_MANAGER = _playerManager;
		
		new Player(_intersections, InputMap.WSAD, FlxPoint.get(32, 352), FlxPoint.get(24, 264) );	
		new Player(_intersections, InputMap.ARROW_KEYS, FlxPoint.get(660, 352), FlxPoint.get(586, 264) );
		new Player(_intersections, InputMap.IKJL, FlxPoint.get(360, 738), FlxPoint.get(148, 678) );
		new Player(_intersections, InputMap.NUM_KEYS, FlxPoint.get(358, 130), FlxPoint.get(292, 168) );
		//new Player(_intersections, InputMap.IKJL, 175, 368);
		
		
		add( Reg.AVATAR_VIEWS );
		add( Reg.PLAYER_UI_LAYER);
		
		
	}
	
	override public function destroy():Void 
	{
		
		Reg.AVATAR_VIEWS.destroy();
		for ( l_type in AvatarType.TYPES )
		{
			Reg.AVATAR_TYPES_MAP[ l_type ].destroy();
		}
		
		Reg.PLAYER_UI_LAYER.destroy();
		
		Reg.PLAYER_MANAGER.destroy();
		
		super.destroy();
	}
	
	override public function update():Void
	{
		//FlxG.log.add( "mouse: " + FlxG.mouse.getScreenPosition() );
		
		super.update();
		
		for ( l_player in Reg.PLAYERS )
		{
			l_player.update();
		}
		
		_playerManager.update();
		
		FlxG.collide(Reg.AVATAR_VIEWS, _mapCollisions );
		
		for ( l_avatarType in AvatarType.TYPES )
		{
			FlxG.overlap( Reg.AVATAR_TYPES_MAP[ l_avatarType ], Reg.AVATAR_TYPES_MAP[ AvatarType.WEAK_TO[ l_avatarType]], onWeaknessOverlap );
			FlxG.overlap( Reg.AVATAR_TYPES_MAP[ l_avatarType], Reg.AVATAR_TYPES_MAP[ l_avatarType ], onSameOverlap );
		}
		
		
	}
	
	private function onWeaknessOverlap( p_weakView:AvatarView, p_view:AvatarView ):Void
	{
		if ( p_weakView.alive && p_view.alive && p_view.avatar.player != p_weakView.avatar.player )
		{
			p_weakView.freeze();
			p_view.attack();
			
			Reg.AVATAR_VIEWS.sort( byAlive );
		}
	}
	
	private function onSameOverlap( p_view1:AvatarView, p_view2:AvatarView ):Void
	{
		if ( p_view1.avatar.player != p_view2.avatar.player && p_view1.alive && p_view2.alive )
		{
			p_view1.bump();
			p_view2.bump();
			//FlxG.collide( p_view1, p_view2 );
		}
	}
	
	private static inline function byAlive( p_order:Int, p_obj1:FlxObject, p_obj2:FlxObject):Int
	{
		return FlxSort.byValues( p_order, cast(p_obj1.alive) , cast(p_obj2.alive) );
	}
}