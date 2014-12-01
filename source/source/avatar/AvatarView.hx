package avatar; 

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import avatar.AvatarEvent;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;
import input.IAvatarController;
import intersections.IntersectionNode;

class AvatarView extends FlxSprite
{
	private static inline var INPUT_MAX_RELEASE_TIME:Int = 300;
	
	public var dummy:Bool = false;
	
	public var avatar(default, null):Avatar;	
	
	private var _avatarController:IAvatarController;
	
	public function new(X:Float, Y:Float, p_avatar:Avatar, p_intersections:FlxTypedGroup<IntersectionNode>)
	{
		super(X, Y);
		
		avatar = p_avatar;
		
		//loadGraphic(avatar.avatarType.graphics, true);
		
		loadGraphicFromTexture( avatar.avatarType.texture );
		
		for ( l_characterAnimation in avatar.avatarType.animations )
		{
			animation.addByPrefix( 	l_characterAnimation.name.getName(),
									l_characterAnimation.prefix, 
									l_characterAnimation.frameRate,
									l_characterAnimation.looped );
		}
		
		//FlxG.watch.add(animation, "name");
		setSize(32, 32);
		offset.set( avatar.avatarType.offset.x, avatar.avatarType.offset.y );
		
		revive();
	}
	
	override public function revive():Void 
	{
		super.revive();
		maxVelocity.set( 150, 150 );
	}
	
	override public function update():Void
	{
		
		
		super.update();
		
		if ( dummy )
		{
			return;
		}
		
		switch( avatar.state )
		{
			case AvatarState.ALIVE:
				updateAnimation( CharacterAnimation.WALK.getName() );
				//avatar.player.path.addPathNode( Reg.AVATAR_PATH_MAP[avatar.avatarType], x, y );
				
			case AvatarState.DEAD:
				velocity.set(0, 0);
				updateAnimation( CharacterAnimation.DIE.getName() );
				
			case AvatarState.REWINDING:
				updateAnimation( CharacterAnimation.WALK.getName() );
			
			case AvatarState.WAITING:
				updateAnimation( CharacterAnimation.WALK.getName() );
				
		}
	}
	
	public function updateAnimation( p_animationName:String ):Void
	{
		if (animation.name == CharacterAnimation.ATTACK.getName() && !animation.finished )
		{
			return;
		}
		
		if ( animation.name != p_animationName )
		{	
			animation.play( p_animationName );
		}
	}
	
	public function freeze():Void
	{
		color = FlxColor.CHARCOAL;
		alive = false;
		velocity.set(0, 0);
	}
	
	public function bump():Void
	{
		//velocity.set(0, 0);
		FlxSpriteUtil.flicker( this, Reg.INPUT_BUMP_FREEZE );
		avatar.dispatcher.dispatchEvent(new AvatarEvent( AvatarEvent.BUMPED));
	}
	
	public function attack():Void
	{
		animation.play(CharacterAnimation.ATTACK.getName());
		FlxG.sound.play( Reg.SOUND_ATTACK[avatar.avatarType] );
	}
	
	public function updateAvatarController( p_avatarController:IAvatarController ):Void
	{
		if ( _avatarController != null )
		{
			if ( _avatarController.dispatcher != null )
			{
				_avatarController.dispatcher.removeEventListener( AvatarEvent.DIRECTION_CHANGE, onDirectionChange );
			}
			
			_avatarController = null;
		}
		
		_avatarController = p_avatarController;
		_avatarController.dispatcher.addEventListener( AvatarEvent.DIRECTION_CHANGE, onDirectionChange, false, 0, true );
	}
	
	private function onDirectionChange( e:AvatarEvent ):Void
	{
		//currentDirection = _avatarController.currentDirection;
	}
	
	override public function kill():Void 
	{
		if ( _avatarController != null )
		{
			_avatarController.dispatcher.removeEventListener( AvatarEvent.DIRECTION_CHANGE, onDirectionChange );
			_avatarController = null;
		}
		
		super.kill();
	}
	
	override public function destroy():Void 
	{
		kill();
		super.destroy();
	}
}