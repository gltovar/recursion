package avatar; 

import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import avatar.AvatarEvent;
import input.IAvatarController;
import intersections.IntersectionNode;

class AvatarView extends FlxSprite
{
	private static inline var INPUT_MAX_RELEASE_TIME:Int = 300;
	
	public var avatar(default, null):Avatar;	
	
	private var _avatarController:IAvatarController;
	
	public function new(X:Float, Y:Float, p_avatar:Avatar, p_intersections:FlxTypedGroup<IntersectionNode>)
	{
		super(X, Y);
		
		avatar = p_avatar;
		
		loadGraphic(avatar.avatarType.graphics, true);
		width = 16;
		height = 16;
		centerOffsets();
		
		revive();
	}
	
	override public function revive():Void 
	{
		super.revive();
		
		maxVelocity.set( 100, 100 );
	}
	
	override public function update():Void
	{
		super.update();
	}
	
	public function freeze():Void
	{
		alive = false;
		velocity.set(0, 0);
	}
	
	public function updateAvatarController( p_avatarController:IAvatarController ):Void
	{
		if ( _avatarController != null )
		{
			_avatarController.dispatcher.removeEventListener( AvatarEvent.DIRECTION_CHANGE, onDirectionChange );
		}
		
		_avatarController = p_avatarController;
		_avatarController.dispatcher.addEventListener( AvatarEvent.DIRECTION_CHANGE, onDirectionChange, false, 0, true );
	}
	
	private function onDirectionChange( e:AvatarEvent ):Void
	{
		//currentDirection = _avatarController.currentDirection;
	}
}