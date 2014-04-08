package org.easily.loader2
{
	import org.easily.utils.ArrayUtils;
	
	/**
	 * @author Easily
	 */
	internal class LoaderObject
	{
		public var loaderMgr:LoaderManager;
		public var item:LoaderItem;
		public var clone:LoaderItem;
		public var loader:BaseLoader
		public var openTimer:int;
		public var idleTimer:int;
		public var loaderNum:int = 0;

		public function LoaderObject(loaderMgr_:LoaderManager)
		{
			loaderMgr = loaderMgr_;
		}

		public function load(item_:LoaderItem):void
		{
			item = item_;

			//文件是否存在
			if (item.url && !LoaderUtils.checkFile(item.url))
			{
				LoaderUtils.delayCall(fileNotExist);
				return;
			}

			//是否缓存
			if (item.url && item.cache && loaderMgr.hasCache(item.url))
			{
				LoaderUtils.delayCall(fileCache);
				return;
			}

			//是否在加载队列
			if (item.url && loaderMgr.isLoading(this))
			{
				fileLoading();
				return;
			}

			//是否还有加载
			if (item.idle && checkLoading())
			{
				LoaderUtils.delayCall(stop);
				return;
			}

			loaderMgr.addObj(this);
			if (!ArrayUtils.hasItem(LoaderUtils.refExcept, item.type))
			{
				loaderNum++;
				loaderMgr.loaderNum += loaderNum;
			}

			//空闲加载
			if (item.idle)
			{
				LoaderUtils.clearInterval(idleTimer);
				idleTimer = LoaderUtils.setInterval(LoaderConsts.IDLE_TIME, checkIdle);
			}

			//开始计时
			LoaderUtils.clearTimeout(openTimer);
			openTimer = LoaderUtils.setTimeout(item.timeout, onError);

			//加载器
			clone = item.clone();
			clone.compFunc = onComplete;
			clone.openFunc = onOpen;
			clone.errorFunc = onError;
			var loaderCls:Class = LoaderUtils.getClass(clone.type);
			loader = new loaderCls;
			loader.load(clone);
			LoaderUtils.print("loading " + clone.toString());
		}

		//空闲加载
		public function checkIdle(...args):void
		{
			if (checkLoading())
			{
				stop();
			}
		}

		//当前是否有加载项
		public function checkLoading():Boolean
		{
			var arr1:Array = loaderMgr.waitingQueue.data;
			var arr2:Array = loaderMgr.loaderList;
			return (arr1.length > 0 && arr1.every(notIdleItem)) || (arr2.length > 0 && arr2.every(notIdleObj));
		}

		//是否是空闲项
		public function notIdleItem(item_:LoaderItem, index:int, arr:Array):Boolean
		{
            return !item_.idle;
        }

		//是否是空闲项
		public function notIdleObj(loaderObj_:LoaderObject, index:int, arr:Array):Boolean
		{
            return loaderObj_ != this && !loaderObj_.item.idle;
        }

		//是否是同一个url加载
		public function equals(loaderObj_:LoaderObject):Boolean
		{
			return loaderObj_.item.url == item.url;
		}

		//文件不存在
		public function fileNotExist(...args):void
		{
			var loaderMgr_:LoaderManager = loaderMgr;
			var item_:LoaderItem = item.clone();
			dispose();
			loaderMgr_.fileNotExist(item_);
			loaderMgr_.load();
		}

		//文件已缓存
		public function fileCache(...args):void
		{
			var loaderMgr_:LoaderManager = loaderMgr;
			var item_:LoaderItem = item.clone();
			dispose();
			loaderMgr_.applyCache(item_.url, item_.compFunc);
			loaderMgr_.load();
		}

		//文件正在加载
		public function fileLoading(...args):void
		{
			loaderMgr.sameLoading(this);
			dispose();
		}

		//建立连接，关闭计时器
		public function onOpen():void
		{
			LoaderUtils.clearTimeout(openTimer);
			item.onOpen();
		}

		//加载成功
		public function onComplete(data:Object):void
		{
			var loaderMgr_:LoaderManager = loaderMgr;
			var item_:LoaderItem = item.clone();
			dispose();
			loaderMgr_.removeObj(this);
			loaderMgr_.onComplete(item_, data);
		}

		//加载失败,重试
		public function onError():void
		{
			var loaderMgr_:LoaderManager = loaderMgr;
			var item_:LoaderItem = item.clone();
			dispose();
			++item_.tries;
			if (item_.tries < item_.maxTries)
			{
				loaderMgr_.pushAndLoad(item_);
			}
			else
			{
				loaderMgr_.removeObj(this);
				loaderMgr_.onError(item_);
			}
		}

		//取消加载
		public function cancel():void
		{
			loaderMgr.onError(item);
			dispose();
		}

		//停止加载
		public function stop():void
		{
			var loaderMgr_:LoaderManager = loaderMgr;
			var item_:LoaderItem = item.clone();
			dispose();
			item_.priority += LoaderConsts.MININUM_PRIORITY;
			loaderMgr_.pushAndLoad(item_);
		}

		//销毁
		public function dispose():void
		{
			LoaderUtils.clearInterval(idleTimer);
			LoaderUtils.clearTimeout(openTimer);
			if (loaderMgr)
			{
				loaderMgr.removeObj(this);
				loaderMgr.loaderNum -= loaderNum;
				loaderMgr = null;
			}
			if (loader)
			{
				loader.dispose();
				loader = null;
			}
			if (item)
			{
				item.dispose();
				item = null;
			}
			if (clone)
			{
				clone.dispose();
				clone = null;
			}
		}
	}
}