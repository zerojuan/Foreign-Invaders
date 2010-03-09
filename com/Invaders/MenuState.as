package com.Invaders
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class MenuState extends FlxState
	{
		[Embed(source="assets/foreign.png")] private var ImgForeign:Class;
		[Embed(source="assets/invaders.png")] private var ImgInvaders:Class;
		
		[Embed(source="assets/march.mp3")] private var SndMarch:Class;		
	
		private var foreignTxt:FlxSprite;
		private var invaderTxt:FlxSprite;
		
		private var _ok:Boolean;
		private var _ok2:Boolean;
	
		override public function create():void{
			this.foreignTxt = new FlxSprite(FlxG.width/2, -40, ImgForeign);
			
			this.invaderTxt = new FlxSprite(FlxG.width/2, FlxG.height, ImgInvaders);
			
			foreignTxt.x = FlxG.width/2 - foreignTxt.width/2;
			invaderTxt.x = FlxG.width/2 - invaderTxt.width/2;
			
			
			this.add(foreignTxt);
			this.add(invaderTxt);
			
			_ok = false;
			_ok2 = false;
			
			FlxG.mouse.show();
			FlxG.playMusic(SndMarch);
		}
		
		override public function update():void{
			
			if(FlxG.mouse.justPressed()){
				FlxG.mouse.hide();
			}
			
			var topEnd:uint = 30;
			var lowEnd:uint = 90;
			if(foreignTxt.y < topEnd){				
				foreignTxt.y += FlxG.elapsed * FlxG.height - 1;
				if(foreignTxt.y > topEnd) foreignTxt.y = topEnd;
			}
			if(invaderTxt.y > lowEnd){
				invaderTxt.y -= FlxG.elapsed * FlxG.height - 1;
				if(invaderTxt.y < lowEnd) invaderTxt.y = lowEnd;			
			}
			
			if(!_ok && (invaderTxt.y == lowEnd || foreignTxt.y == topEnd)){
				_ok = true;
				FlxG.log("True");
				var startTxt:FlxText = new FlxText(FlxG.width/2 - 45,FlxG.height/2+100,400, "Press Z+X to start");
				//startTxt.alignment = "center"; 
				//startTxt.y = 200;
				//startTxt.x = 200;
				add(startTxt);				
			}
			
			if(_ok && !_ok2 && FlxG.keys.Z && FlxG.keys.X){
				_ok2 = true;
				FlxG.flash.start(0xffd8eba2,0.5);
				FlxG.fade.start(0xff131c1b, 1, onFade);
			}
			
			super.update();
		}
		
		public function onFade():void{
			FlxG.state = new PlayState();
		}
	}
}