package {
	import org.flixel.FlxGame;
	import com.Invaders.MenuState;

	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	public class Invaders extends FlxGame
	{
		public function Invaders():void
		{
			super(320, 240, MenuState);		
		}
	}
}
