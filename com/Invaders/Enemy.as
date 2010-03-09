package com.Invaders
{
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	public class Enemy extends FlxSprite
	{
		[Embed(source="assets/enemy.png")] private var ImgEnemy:Class;
		[Embed(source="assets/parts.png")] private var ImgGibs:Class;
		[Embed(source="assets/death.mp3")] private var SndDeath:Class;	
		[Embed(source="assets/lofi-shot.mp3")] private var SndShot:Class;	
				
		
		private var bullets:Array;			//Reference to the bullets the enemies shoot at you
		static private var bulletIndex:uint;	//Tracker or marker for the bullet list
		private var shotClock:Number;			//A simple timer for deciding when to shoot
		private var originalX:int;				//Saves the starting horizontal position (for movement logic)
		private var originalY:int;
		
		private var _gibs:FlxEmitter;
		
		public function Enemy(X:uint, Y:uint, Color:uint, Bullets:Array, Gibs:FlxEmitter):void
		{
			super(X,Y);
			loadGraphic(ImgEnemy, true, false, 15, 19);
			
			_gibs = Gibs;
			originalX = X;
			originalY = Y;
			color = Color;
			bullets = Bullets;
			bulletIndex = 0;
			restart();
			
			velocity.x = 10;
			
			
		}
		
		override public function update():void{			
			if(x < originalX - 8){
				x = originalX - 8;
				velocity.x = 10;
				//y+=1;
				velocity.y++;
			}
			
			if(x > originalX + 8){
				x = originalX + 8;
				velocity.x = -10;
			}
			
			if(this.y > 0 && !this.onScreen()){
				this.y = originalY - 300;
			}
			
			shotClock -= FlxG.elapsed;
			
			if(shotClock <= 0){
				restart();
				var b:FlxSprite = bullets[bulletIndex];
				b.reset(x + width / 2 - b.width, y);
				b.velocity.y = 65;
				bulletIndex++;
				if(bulletIndex >= bullets.length)
					bulletIndex = 0;
				FlxG.play(SndShot);	
			}
			
			super.update();
		}
		
		
		override public function kill():void{
			super.kill();
			FlxG.play(SndDeath);
			_gibs.color = this.color;
			_gibs.at(this);
			_gibs.start(true,5);
		}
		
		private function restart():void{
			shotClock = 1 + FlxU.random()*20;
		}
		
		public function respawn():void{			
			this.reset(originalX, originalY);
			velocity.x = 10;
		}

	}
}