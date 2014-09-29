package avatar; 

import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import input.AvatarControllerEvent;
import input.IAvatarController;
import intersections.IntersectionNode;

class AvatarView extends FlxSprite
{
	//public var player(default,null):Player;
	public var avatar(default, null):Avatar;
	
	private static inline var INPUT_MAX_RELEASE_TIME:Int = 300;
	
	private var _avatarController:IAvatarController;
	
	public function new(X:Float, Y:Float, p_avatar:Avatar, p_intersections:FlxTypedGroup<IntersectionNode>)
	{
		super(X, Y);
		
		avatar = p_avatar;
		
		loadGraphic(avatar.avatarType.graphics, true);
		maxVelocity.set( 100, 100 );
		width = 16;
		height = 16;
		centerOffsets();
		
	}
	
	override public function update():Void
	{
		super.update();
	}
	
	public function updateAvatarController( p_avatarController:IAvatarController ):Void
	{
		if ( _avatarController != null )
		{
			_avatarController.dispatcher.removeEventListener( AvatarControllerEvent.DIRECTION_CHANGE, onDirectionChange );
		}
		
		_avatarController = p_avatarController;
		_avatarController.dispatcher.addEventListener( AvatarControllerEvent.DIRECTION_CHANGE, onDirectionChange, false, 0, true );
	}
	
	private function onDirectionChange( e:AvatarControllerEvent ):Void
	{
		//currentDirection = _avatarController.currentDirection;
	}
}