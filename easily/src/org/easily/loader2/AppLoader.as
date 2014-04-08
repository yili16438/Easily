package org.easily.loader2
{
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	
	internal class AppLoader extends BaseLoader
	{
		private var binLoader:BinaryLoader;
		private var bytesLoader:BytesLoader;
		
		public function AppLoader()
		{
			super();
		}
		
		override public function load(item_:LoaderItem):void
		{
			// TODO Auto Generated method stub
			super.load(item_);
			
			item.save = false;
			var compFunc_:Function = item.compFunc;
			item.compFunc = binLoaded;
			binLoader = new BinaryLoader();
			binLoader.load(item);
			
			function binLoaded(bytes:ByteArray):void
			{
				bytes = handleBytes(bytes);
				item.compFunc = compFunc_;
				item.progFunc = null;
				item.bytes = bytes;
				
				item.save = true;
				bytesLoader = new BytesLoader(new ApplicationDomain);
				bytesLoader.load(item);
			}
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			if (binLoader)
			{
				binLoader.dispose();
				binLoader = null;
			}
			if (bytesLoader)
			{
				bytesLoader.dispose();
				bytesLoader = null;
			}
			super.dispose();
		}
	}
}