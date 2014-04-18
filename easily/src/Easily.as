package
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import org.easily.test.EasilyTest;
	import org.easily.test.box2d.Box2dTest;

	/**
	 * @author Easily
	 */
	[SWF(width="640", height="480", backgroundColor="0x414647")]
	public class Easily extends Sprite
	{
		public function Easily()
		{
			super();
			
			addChild(new Box2dTest);
		}
	}
}