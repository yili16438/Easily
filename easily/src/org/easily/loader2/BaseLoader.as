package org.easily.loader2
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;

	//基础加载类
	internal class BaseLoader
	{
		public var item:LoaderItem;
		public var state:int;

		public function BaseLoader()
		{
			state = LoaderState.INIT;
		}
		
		//资源链接转换
		public function translate(url:String):String
		{
			if (item.transform)
			{
				return LoaderUtils.translate(url);
			}
			else
			{
				return url;
			}
		}
		
		//日志
		public function print(str:String):void
		{
			LoaderUtils.print(str);
		}

		//开始加载
		public function load(item_:LoaderItem):void
		{
			item = item_;
		}

		//加载error
		protected function onError(event:Event = null):void
		{
			// TODO Auto-generated method stub
			state = LoaderState.ERROR;
			if (item)
			{
				item.onError();
			}
		}

		//响应http请求
		protected function onOpen(event:Event):void
		{
			// TODO Auto-generated method stub
			state = LoaderState.OPEN;
			if (item)
			{
				item.onOpen();
			}
		}

		//加载进度
		protected function onProgress(event:ProgressEvent):void
		{
			// TODO Auto-generated method stub
			if (item && item.progFunc != null)
			{
				item.progFunc(event.bytesLoaded, event.bytesTotal);
			}
		}
		
		//预处理bytes
		protected function handleBytes(bytes:ByteArray):ByteArray
		{
			return bytes;
		}

		//加载完成
		protected function onComplete(event:Event=null):void
		{
			// TODO Auto-generated method stub
			state = LoaderState.COMPLETE;
		}

		//销毁
		public function dispose():void
		{
			state = LoaderState.DISPOSE;
			if (item)
			{
				item.dispose();
				item = null;
			}
		}
	}
}
