package com.Invaders
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	
	public class Bullet extends FlxSprite
	{			
		
		//TODO: Add sprites here
		public function Bullet()
		{
			super();
			
			exists = false;
			
			
			addAnimation("up", [0]);
			addAnimation("down", [1]);
			addAnimation("poof", [3,4]);
		}
		
		override public function update():void{
			if(dead && finished) exists = false;
			else super.update();
		}
		
		override public function render():void{
			super.render();
		}
		
		override public function hitLeft(Contact:FlxObject,Velocity:Number):void { kill(); }
		override public function hitBottom(Contact:FlxObject,Velocity:Number):void { kill(); }
		override public function hitTop(Contact:FlxObject,Velocity:Number):void { kill(); }
		
		override public function kill():void
		{
			if(dead) return;
			velocity.x = 0;
			velocity.y = 0;
			//if(onScreen()) FlxG.play(SndHit);
			dead = true;
			solid = false;
			play("poof");
		}
		
		public function shoot(X:int, Y:int, VelocityX:int, VelocityY:int):void
		{
			//FlxG.play(SndShoot);
			super.reset(X,Y);
			solid = true;
			velocity.x = VelocityX;
			velocity.y = VelocityY;
			if(velocity.y < 0)
				play("up");
			else if(velocity.y > 0)
				play("down");
			else if(velocity.x < 0)
				play("left");
			else if(velocity.x > 0)
				play("right");
		}

	}
}