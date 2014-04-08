package org.easily.loader2
{
	import flash.utils.ByteArray;
	
	import org.easily.ds.QueuePriority;
	
	/**
	 * @author Easily
	 */
	public class LoaderItem
	{
		//加载id
		public var id:uint = LoaderUtils.genID();								
		//资源类型
		public var type:String = LoaderType.RES;								
		//资源地址
		public var url:String;													
		//是否地址转换
		public var transform:Boolean = true;									
		//字节流
		public var bytes:ByteArray;												
		//加载完成回调
		public var compFunc:Function;											
		//加载错误回调
		public var errorFunc:Function;
		//建立连接回调
		public var openFunc:Function;											
		//加载进度回调
		public var progFunc:Function;											
		//已尝试次数
		public var tries:int = 0;												
		//最大尝试次数
		public var maxTries:int = LoaderConsts.DEFAULT_MAX_TRIES;			
		//是否缓存
		public var cache:Boolean = false;										
		//最大超时值
		public var timeout:Number = LoaderConsts.TIME_OUT;						
		//优先级
		public var priority:int = QueuePriority.MID;								
		//加载说明
		public var tip:String = LoaderConsts.DEFAULT_TIP;						
		//空闲加载
		public var idle:Boolean = false;											
		//保存二进制
		public var save:Boolean = true;											
		//相同加载请求
		public var sames:Array = [];												
		//附加参数
		public var param:Object;													
		
		public function LoaderItem()
		{
		}
		
		public function onOpen():void
		{
			openFunc ||= LoaderUtils.empty;
			openFunc();
		}
		
		public function onError():void
		{
			errorFunc ||= LoaderUtils.empty;
			errorFunc();
		}
		
		public function onComplete(data:Object):void
		{
			compFunc ||= LoaderUtils.empty;
			
			if (LoaderUtils.debug)
			{
				compFunc(data);
				return;
			}
			
			try
			{
				compFunc(data);
			}
			catch(error:Error)
			{
				LoaderUtils.print("LoaderItem.onComplete error="+toString());
			}
		}
		
		public function clone():LoaderItem
		{
			var item:LoaderItem = new LoaderItem;
			item.parseObj(toObject());
			return item;
		}

		public function toObject():Object
		{
			var obj:Object = new Object;
			for each (var key:String in LoaderUtils.itemKeys)
			{
				obj[key] = this[key];	
			}
			return obj;
		}

		public function parseObj(obj:Object):void
		{
			for each (var key:String in LoaderUtils.itemKeys)
			{
				this[key] = obj[key];
			}
		}
		
		public function toString():String
		{
			return "loaderItem:id="+id+",type="+type+",url="+url+",cache="+cache;
		}
		
		public function dispose():void
		{
			for each (var key:String in LoaderUtils.itemKeys)
			{
				this[key] = null;
			}
		}
	}
}