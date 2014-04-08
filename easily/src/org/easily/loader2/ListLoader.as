package org.easily.loader2
{
	/**
	 * @author Easily
	 */
	internal class ListLoader
	{
		public var list:Array;
		public var cloneList:Array = [];
		public var immediateList:Array = [];
		public var compFunc:Function;
		public var progFunc:Function;
		public var errorFunc:Function;
		public var len:int = 0;
		public var count:int = 0;
		public var errorList:Array = [];
		
		public function ListLoader(list_:Array, compFunc_:Function = null, progFunc_:Function = null, errorFunc_:Function = null)
		{
			list = list_;
			compFunc = compFunc_;
			progFunc = progFunc_;
			errorFunc = errorFunc_;
			list ||= [];
			len = list.length;
		}

		public function load():void
		{
			if (len > 0)
			{
				for each (var item:LoaderItem in list)
				{
					var clone:LoaderItem = item.clone();
					cloneList.push(clone);
					clone.progFunc = onProgress;
					clone.errorFunc = onError(item);
					clone.compFunc = onComplete(item);
					LoaderUtils.loadItem(clone);
				}
			}
			else
			{
				LoaderUtils.delayCall(allComplete);
			}
		}
		
		public function onProgress(bytesLoaded:int, bytesTotal:int):void
		{
			if (progFunc != null)
			{
				progFunc(bytesLoaded, bytesTotal, count, len);
			}
		}
		
		public function onError(item_:LoaderItem):Function
		{
			return function():void
			{
				errorList.push(item_);
				if (item_.errorFunc != null)
				{
					item_.errorFunc();
				}
				checkCount();
			}
		}
		
		public function onComplete(item_:LoaderItem):Function
		{
			return function(data_:Object):void
			{
				if (item_.compFunc != null)
				{
					item_.compFunc(data_);
				}
				checkCount();
			}
		}
		
		public function checkCount():void
		{
			if (++count == len)
			{
				if (errorFunc != null && errorList.length > 0)
				{
					errorFunc(errorList);
				}
				allComplete();
			}
		}
		
		public function allComplete():void
		{
			var compFunc_:Function = compFunc;
			dispose();
			if (compFunc_ != null)
			{
				compFunc_();
			}
		}
		
		public function dispose():void
		{
			for each (var clone:LoaderItem in cloneList)
			{
				clone.dispose();
			}
			list.length = cloneList.length = 0;
			compFunc = null;
			progFunc = null;
			errorFunc = null;
		}
	}
}