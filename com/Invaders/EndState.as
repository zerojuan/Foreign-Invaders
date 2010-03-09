package com.Invaders
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class EndState extends FlxState
	{
		[Embed(source="assets/flag.png")] private var ImgFlag:Class;
		[Embed(source="assets/lalala.mp3")] private var SndEnd:Class;
		
		private var flagSpr:FlxSprite;
		
		public function EndState(){
			flagSpr = new FlxSprite(FlxG.width/2, FlxG.height/2 - 100, ImgFlag);
			
			
			flagSpr.loadGraphic(ImgFlag, true, false, 125, 142, true);
			
			flagSpr.addAnimation("wave", [0,1], 2);
			
			flagSpr.play("wave");
			
			add(flagSpr);
			
			add(new FlxText(FlxG.width/2 - 45,FlxG.height/2+100,400, "Press Z to reset"));
			
			FlxG.playMusic(SndEnd);			
		}
		
		override public function update():void{
			if(FlxG.keys.Z){
				FlxG.state = new MenuState();
			}
			
			super.update();
			
		}
		
	
	}
}