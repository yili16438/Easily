package org.easily.loader2
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.System;

	//加载字节流
	internal class BytesLoader extends BaseLoader
	{
		public var loader:Loader;
		public var appDomain:ApplicationDomain;
		
		public function BytesLoader(appDomain_:ApplicationDomain = null)
		{
			super();
			
			appDomain = appDomain_;
			appDomain ||= ApplicationDomain.currentDomain;
		}
		
		override public function load(item_:LoaderItem):void
		{
			// TODO Auto Generated method stub
			super.load(item_);
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			
			try
			{
				var context:LoaderContext = new LoaderContext(false, appDomain);
				loader.loadBytes(item.bytes, context);
			} 
			catch(error:Error)
			{
				LoaderUtils.delayCall(onError);
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
				LoaderUtils.saveFile(item, item.bytes);
				item.onComplete(loader.content);
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
					loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
					loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
					loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
					loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
					loader.close();
				}
				catch (e:Error)
				{
					print("BytesLoader dispose error !!! message="+e.message);
				}
			}
			appDomain = null;
			super.dispose();
		}
	}
}