package org.easily.loader2
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.easily.ds.PriorityQueue;
	import org.easily.ds.Queue;
	import org.easily.utils.ArrayUtils;
	import org.easily.utils.FuncProxy;

	//加载管理器
	internal class LoaderManager
	{
		public var loaderMaximum:int = LoaderConsts.LOADER_MAXIMUM;			//最大加载个数
		public var waitingQueue:Queue = new PriorityQueue;					//等待队列项
		public var cacheMap:Dictionary = new Dictionary;					//缓存映射
		public var loaderList:Array = [];									//加载对象列表
		public var loaderNum:int = 0;										//当前加载个数
		
		public function LoaderManager()
		{
		}
		
		//是否存在
		public function hasCache(url_:String):Boolean
		{
			return getCache(url_) != null;
		}
		
		//获取缓存
		public function getCache(url_:String):Object
		{
			return cacheMap[url_];
		}
		
		//释放缓存
		public function releaseCache(url_:String):Object
		{
			var obj:Object = cacheMap[url_];
			delete cacheMap[url_];
			return obj;
		}
		
		//已经加载的资源
		public function applyCache(url_:String, compFunc_:Function):void
		{
			compFunc_ ||= LoaderUtils.empty;
			var obj:Object = getCache(url_);
			new FuncProxy(null, compFunc_, obj).delayCall();
		}
		
		//将item加入wait队列中
		public function pushItem(item:LoaderItem):void
		{
			waitingQueue.push(item);
		}
		
		//加入并且加载
		public function pushAndLoad(item:LoaderItem):void
		{
			pushItem(item);
			load();
		}
		
		//根据相关数据生成相应的加载项进行加载
		public function loadData(type_:String, url_:String, bytes_:ByteArray, compFunc_:Function, cache_:Boolean, progFunc_:Function, errorFunc_:Function):uint
		{
			if (!url_ && !bytes_)
			{
				return 0;
			}
			if (cache_ && hasCache(url_))
			{
				applyCache(url_, compFunc_);
				return 0;
			}
			else
			{
				var item:LoaderItem = new LoaderItem;
				item.type = type_;
				item.url = url_;
				item.bytes = bytes_;
				item.compFunc = compFunc_;
				item.errorFunc = errorFunc_;
				item.progFunc = progFunc_;
				item.cache = cache_;
				pushAndLoad(item);
				return item.id;
			}
		}
		
		//加载一个加载项
		public function loadItem(item:LoaderItem):uint
		{
			if (item.cache && cacheMap[item.url])
			{
				applyCache(item.url, item.compFunc);
				return 0;
			}
			else
			{
				pushAndLoad(item);
				return item.id;
			}
		}
		
		//开始加载
		public function load():void
		{
			if (!waitingQueue.empty() && loaderNum < loaderMaximum)
			{
				var item:LoaderItem = waitingQueue.pop();
				var loaderObj:LoaderObject = new LoaderObject(this);
				loaderObj.load(item);
			}
		}
		
		//添加加载对象
		public function addObj(loaderObj:LoaderObject):void
		{
			loaderList.push(loaderObj);
		}
		
		//移除加载对象
		public function removeObj(loaderObj:LoaderObject):void
		{
			ArrayUtils.remove(loaderList, loaderObj);
		}
		
		//是否正在加载
		public function isLoading(loaderObj:LoaderObject):Boolean
		{
			return ArrayUtils.findIf(loaderList, loaderObj.equals).length > 0;
		}
		
		//相同的加载
		public function sameLoading(loaderObj:LoaderObject):void
		{
			var list:Array = ArrayUtils.findIf(loaderList, loaderObj.equals);
			if (list.length > 0)
			{
				var loaderObj_:LoaderObject = list[0];
				loaderObj_.item.sames.push(loaderObj.item.clone());
			}
		}
		
		//加载完成，调用回调
		public function onComplete(item:LoaderItem, data:Object):void
		{
			if (item.url && item.cache)
			{
				if (!ArrayUtils.hasItem(LoaderUtils.cacheExcept, item.type))
				{
					cacheMap[item.url] = data;
				}
				else
				{
					cacheMap[item.url] = true;
				}
			}
			LoaderUtils.delayCall(load);
			var sames:Array = item.sames;
			item.onComplete(data);
			item.dispose();
			for each (item in sames)
			{
				pushItem(item);
			}
		}
		
		//加载失败
		public function onError(item:LoaderItem):void
		{
			LoaderUtils.delayCall(load);
			var sames:Array = item.sames;
			item.onError();
			item.dispose();
			for each (item in sames)
			{
				item.onError();
				item.dispose();
			}
		}
		
		//文件不存在
		public function fileNotExist(item:LoaderItem):void
		{
			LoaderUtils.print("loaderMgr.fileNotExist item="+item.toString());
			item.onError();
			item.dispose();
		}
		
		//取消加载对象
		public function cancelObj(loaderObj:LoaderObject, index:int, array:Array):void
		{
			loaderObj.cancel();
		}
		
		//取消
		public function cancelIf(func:Function):void
		{
			ArrayUtils.removeIf(waitingQueue.data, func);
			ArrayUtils.removeIf(loaderList, equals).forEach(cancelObj);
			function equals(loaderObj:LoaderObject):Boolean
			{
				return func(loaderObj.item);
			}
		}
		
		//取消加载
		public function cancel(id:uint):void
		{
			cancelIf(equals);
			function equals(item:LoaderItem):Boolean
			{
				return id == item.id;
			}
		}
		
		//取消加载
		public function cancelEx(url:String):void
		{
			cancelIf(equals);
			function equals(item:LoaderItem):Boolean
			{
				return url == item.url;
			}
		}
		
		//取消所有加载
		public function cancelAll():void
		{
			waitingQueue.clear();
			ArrayUtils.clone(loaderList).forEach(cancelObj);
			loaderList.length = 0;
			loaderNum = 0;
		}
		
		//停止加载
		public function stopObj(loaderObj:LoaderObject, index:int, array:Array):void
		{
			loaderObj.stop();
		}
		
		//停止
		public function stopIf(func:Function):void
		{
			ArrayUtils.removeIf(waitingQueue.data, func);
			ArrayUtils.removeIf(loaderList, equals).forEach(stopObj);
			function equals(loaderObj:LoaderObject):Boolean
			{
				return func(loaderObj.item);
			}
		}
		
		//停止加载
		public function stop(id:uint):void
		{
			stopIf(equals);
			function equals(item:LoaderItem):Boolean
			{
				return id == item.id;
			}
		}
		
		//停止url
		public function stopEx(url:String):void
		{
			stopIf(equals);
			function equals(item:LoaderItem):Boolean
			{
				return url == item.url;
			}
		}
		
		//停止所有加载
		public function stopAll():void
		{
			ArrayUtils.clone(loaderList).forEach(stopObj);
			loaderList.length = 0;
			loaderNum = 0;
		}
	}
}