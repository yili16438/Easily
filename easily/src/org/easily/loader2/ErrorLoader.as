package org.easily.loader2
{
	internal class ErrorLoader extends BaseLoader
	{
		public function ErrorLoader()
		{
			super();
		}
		
		override public function load(item_:LoaderItem):void
		{
			// TODO Auto Generated method stub
			super.load(item_);
			LoaderUtils.delayCall(onError);
		}
	}
}