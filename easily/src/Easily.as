package
{
	import flash.display.Sprite;
	
	import org.easily.test.EasilyTest;

	/**
	 * @author Easily
	 */
	public class Easily extends Sprite
	{
		public function Easily()
		{
			super();
			
			addChild(new EasilyTest);
		}
	}
}