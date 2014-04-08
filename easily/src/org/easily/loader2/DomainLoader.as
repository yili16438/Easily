package org.easily.loader2
{
	import flash.utils.ByteArray;

	//加载到应用程序域
	internal class DomainLoader extends BaseLoader
	{
		private var binLoader:BinaryLoader;
		private var bytesLoader:BytesLoader;
		
		public function DomainLoader()
		{
			super();
		}
		
		override public function load(item_:LoaderItem):void
		{
			// TODO Auto Generated method stub
			super.load(item_);

			item.save = false;			
			var compFunc_:Function = item.compFunc;
			compFunc_ ||= LoaderUtils.empty;
			item.compFunc = binLoaded;
			binLoader = new BinaryLoader();
			binLoader.load(item);
			
			function binLoaded(bytes:ByteArray):void
			{
				bytes = handleBytes(bytes);
				item_.compFunc = bytesLoaded;
				item_.progFunc = null;
				item_.bytes = bytes;
					
				item.save = true;
				bytesLoader = new BytesLoader();
				bytesLoader.load(item);
				function bytesLoaded(content:*):void
				{
					LoaderUtils.removeChildren(content);
					compFunc_(content);
				}
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