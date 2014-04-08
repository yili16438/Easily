package org.easily.loader2
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	//加载二进制数据
	internal class BinaryLoader extends BaseLoader
	{
		public var loader:URLLoader;
		
		public function BinaryLoader()
		{
			super();
		}
		
		override public function load(item_:LoaderItem):void
		{
			// TODO Auto Generated method stub
			super.load(item_);
			
			var bytes:ByteArray = LoaderUtils.getBytes(item);
			if (bytes)
			{
				localFile(bytes);
				return;
			}
			
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.OPEN, onOpen);
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			
			try
			{
				loader.load(new URLRequest(translate(item_.url)));
			}
			catch(error:Error) 
			{
				LoaderUtils.delayCall(onError);
			}
		}
		
		public function localFile(bytes:ByteArray):void
		{
			var compFunc:Function = item.onComplete;
			LoaderUtils.delayCall(onDelay);
			function onDelay():void
			{
				compFunc(bytes);
			}
		}

		protected override function onError(event:Event=null):void
		{
			//TODO Auto-generated method stub
			if (item)
			{
				LoaderUtils.removeFile(item);
			}
			super.onError(event);
		}
		
		override protected function onComplete(event:Event=null):void
		{
			// TODO Auto Generated method stub
			if (item)
			{
				LoaderUtils.saveFile(item, loader.data);
				item.onComplete(loader.data);
			}
			super.onComplete(event);
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			if (loader)
			{
				try
				{
					loader.removeEventListener(Event.OPEN, onOpen);
					loader.removeEventListener(Event.COMPLETE, onComplete);
					loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
					loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
					loader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
					loader.close();
				}
				catch (e:Error)
				{
					print("BinaryLoader dispose error !!! message="+e.message);
				}
				loader = null;
			}
			super.dispose();
		}
	}
}