package
{
	import flash.display.Sprite;

	import mx.binding.utils.BindingUtils;

	import org.easily.debug.Log;

	/**
	 * @author Easily
	 */
	public class BindTest extends Sprite
	{
		[Bindable]
		public var str:String = "";

		public function BindTest()
		{
			super();

			var obj:Object = {str:""};
			BindingUtils.bindProperty(obj, "str", this, "str");
			str = "test";
			Log.print(obj.str);
		}
	}
}
