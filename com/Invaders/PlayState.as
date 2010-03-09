package com.Invaders
{
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxU;
	
	public class PlayState extends FlxState
	{
		[Embed(source="assets/march.mp3")] private var SndMarch:Class;		
		[Embed(source="assets/parts.png")] private var ImgGibs:Class;
		
		private var _killTxt:FlxText;
		
		private var _enemyArr:FlxGroup;
		private var _bulletArr:FlxGroup;
		private var _enemyBulletArr:FlxGroup;
		private var _playerBulletArr:FlxGroup;
		
		private var _shields:FlxGroup;
		private var _vsShields:FlxGroup;
		
		private var _player:Player;
		
		private var _gibs:FlxEmitter;
		
		private var _kills:int = 0;
		private var _level:int = 1;
		private var _prevLevel:int = 0;
		
		public function PlayState():void{
			var i:int;
			
			_gibs = new FlxEmitter();			
			_gibs.setSize(10,10);			
			_gibs.setYSpeed(-200,-20);
			_gibs.setRotation(-720,720);
			_gibs.gravity = -100;					
			_gibs.createSprites(ImgGibs,50,32);
			
			
			_killTxt = new FlxText(0,0,50, "Kills: 0");
			_killTxt.alignment = "left";
			_killTxt.size = 12;
			
			
			var s:Bullet;
			_playerBulletArr = new FlxGroup();//Initializing the array is very important and easy to forget!
			for(i = 0; i < 8; i++)			//Create 8 bullets for the player to recycle
			{
				s = new Bullet();	//Instantiate a new sprite offscreen
				s.createGraphic(2,8);			//Create a 2x8 white box
				s.exists = false;
				_playerBulletArr.add(s);			//Add it to the group of player bullets
			}
			add(_playerBulletArr);
			
			//Now that we have a list of bullets, we can initialize the player (and give them the bullets)
			_player = new Player(FlxG.width/2-6, FlxG.height-15,_playerBulletArr.members, _gibs);
			add(_player);	//Adds the player to the state
			
			//Then we kind of do the same thing for the enemy invaders; first we make their bullets...
			_enemyBulletArr = new FlxGroup();
			for(i = 0; i < 64; i++)
			{
				s = new Bullet();
				s.createGraphic(2,8);
				s.exists = false;
				_enemyBulletArr.add(s);
			}
			add(_enemyBulletArr);
			
			
			var a:Enemy;
			_enemyArr = new FlxGroup();
			var colors:Array = new Array(0xff0000ff, 0xff00ffff, 0xff00ff00, 0xffffff00, 0xffff0000);
			for(i = 0; i < 50; i++)
			{
				a = new Enemy(	8 + (i % 10) * 32,		//The X position of the alien
								24 + int(i / 10) * 32,	//The Y position of the alien
								colors[int(i / 10)], _enemyBulletArr.members, _gibs);
				_enemyArr.add(a);
			}
			add(_enemyArr);
			
			var shield:FlxSprite;
			_shields = new FlxGroup();
			for(i = 0; i < 256; i++)
			{
				shield = new FlxSprite(	32 + 80 * int(i / 64) + (i % 8) * 2,		//The X position of this bit
									FlxG.height - 32 + (int((i % 64) / 8) * 2));//The Y position of this bit
				shield.moves = false;
				shield.createGraphic(2,2);
				_shields.add(shield);
			}
			add(_shields);
			
			add(_gibs);
			add(_killTxt);
			//Store these things in meta-groups so they're easier to compare/overlap later
			_vsShields = new FlxGroup();
			_vsShields.add(_enemyBulletArr);
			_vsShields.add(_playerBulletArr);
			_vsShields.add(_enemyArr);
			
			FlxG.playMusic(SndMarch);
					
		}
		
		override public function update():void{
			if(FlxG.mouse.justPressed()){
				FlxG.mouse.hide();
			}
			
			FlxU.overlap(_shields,_vsShields,overlapped);
			FlxU.overlap(_playerBulletArr,_enemyArr, enemyKill);
			FlxU.overlap(_enemyBulletArr,_player);
			FlxU.overlap(_enemyArr, _player);
			
			_killTxt.text = "Kills: " + _kills;
			if(_kills % 50 == 0){
				_prevLevel = _kills / 50;
				FlxG.log("_prev: " + _prevLevel + ", _kills: " + _level);
				if(_prevLevel == _level){
					respawn();
					_level++;					
				}			
			}			
			
			super.update();
		}

		protected function enemyKill(Obj1:FlxObject, Obj2:FlxObject):void{
			Obj1.kill();
			Obj2.kill();
			_kills += 1;
		}

		//We want aliens to mow down shields when they touch them, not die
		protected function overlapped(Object1:FlxObject,Object2:FlxObject):void
		{
			Object1.kill()
			if(!(Object2 is Enemy))
				Object2.kill();
		}
		
		protected function respawn():void{
			var i:int = 0;
			for(i = 0; i < _enemyArr.members.length; i++){
				(_enemyArr.members[i] as Enemy).respawn();
			}
		}
	}
}