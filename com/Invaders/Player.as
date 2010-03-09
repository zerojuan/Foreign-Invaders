package com.Invaders
{
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class Player extends FlxSprite
	{
		[Embed(source="assets/hero.png")] private var ImgHero:Class;
		[Embed(source="assets/hifi-shot.mp3")] private var SndShot:Class;
		
		private var _bullets:Array;
		private var _currBullet:uint;
		private var _bulletVel:uint;
		
		private var _gibs:FlxEmitter;
		
		public function Player(X:uint, Y:uint, Bullets:Array, Gibs:FlxEmitter):void{
			super(X,Y);
			loadGraphic(ImgHero, true, false, 15, 19);
			
			var runSpeed:uint = 80;
			drag.x = runSpeed*8;
			maxVelocity.x = runSpeed;
			
			_bullets = Bullets;
			_currBullet = 0;
			_bulletVel = 360;
			
			_gibs = Gibs;
		}

		override public function update():void{
			if(dead){
				FlxG.fade.start(0xff131c1b, 1, onFade);
			}
			
			acceleration.x = 0;
			if(FlxG.keys.LEFT){
				acceleration.x -= drag.x;
			}
			
			if(FlxG.keys.RIGHT){
				acceleration.x += drag.x;
			}
			
			if(x > FlxG.width-width-4)
				x = FlxG.width-width-4; //Checking and setting the right side boundary
			if(x < 4)
				x = 4;	
			
			if(FlxG.keys.justPressed("X") || FlxG.keys.justPressed("Z")){				
				var bXVel:int = 0;
				var bYVel:int = 0;
				var bX:int = x;
				var bY:int = y;
				
				bYVel = -_bulletVel;
				if(FlxG.keys.justPressed("X")){
					_bullets[_currBullet].shoot(bX+12, bY, bXVel, bYVel);
				}else{
					_bullets[_currBullet].shoot(bX, bY, bXVel, bYVel);
				}
				
				if(++_currBullet >= _bullets.length)
					_currBullet = 0;
				FlxG.play(SndShot);
			}
			
			super.update();
		}
		
		public function onFade():void{
			FlxG.state = new EndState();
		}
		
		override public function kill():void
		{
			if(dead)
				return;
			solid = false;
			//FlxG.play(SndExplode);
			//FlxG.play(SndExplode2);
			super.kill();
			flicker(-1);
			exists = true;
			visible = false;
			FlxG.quake.start(0.005,0.35);
			FlxG.flash.start(0xffd8eba2,0.35);
			if(_gibs != null)
			{
				_gibs.at(this);
				_gibs.start(true,0,50);
			}
		}
		
	}
}