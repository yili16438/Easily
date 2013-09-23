package org.easily.utils
{
	public class ArrayUtils
	{
		//将元素塞到集合当中，当此元素已经存在于集合则不做任何操作
		public static function push(array:Array, item:Object):void
		{
			if (!array || !item)
			{
				return;
			}
			if (array.indexOf(item) == -1)
			{
				array.push(item);
			}
		}

		//将元素从集合当中移除（不保证顺序）
		public static function remove(array:Array, item:Object, fast:Boolean = true):void
		{
			if (!array || !item)
			{
				return;
			}
			var index:int = array.indexOf(item);
			if (index != -1)
			{
				if (fast)
				{
					var last:int = array.length - 1;
					if (index != last)
					{
						array[index] = array[last];
					}
					array.pop();
				}
				else
				{
					array.splice(index, 1);
				}
			}
		}
		
		//是否有某个元素
		public static function hasItem(array:Array, item:Object):Boolean
		{
			if (!array || !item)
			{
				return false;
			}
			return array.indexOf(item) != -1;
		}
		
		//将多个元素从集合当中移除(不保证顺序)
		public static function removeList(array:Array, list:Array):Array
		{
			if (!array || !list)
			{
				return [];
			}
			for each (var item:Object in list)
			{
				remove(array, item);
			}
			return list;
		}
		
		/**
		 * 清空数组，将数组置为空数组 []; 
		 * @param array
		 * @param disposeFuncName  数组内元素的dispose方法名
		 * 
		 */		
		public static function emptyArray(array:Array, disposeFuncName:String = "dispose"):void
		{
			if (!array)
			{
				return;
			}
			for each (var item:Object in array)
			{
				if(item.hasOwnProperty(disposeFuncName))
				{
					var func:Function = item[disposeFuncName];
					func();
				}
			}
			array.length = 0;
		}
		
		//将元素从集合当中移除
		public static function removeIf(array:Array, func:Object):Array
		{
			return removeList(array, findIf(array, func));
		}

		//在指定位置插入元素
		public static function insert(array:Array, item:Object, index:int):void
		{
			if (!array || !item)
			{
				return;
			}
			if (array.indexOf(item) == -1)
			{
				array.splice(index, 0, item);
			}
		}

		//将数组切割成N个数组，每个数组num个元素
		public static function slice(array:Array, num:int):Array
		{
			if (!array)
			{
				return null;
			}
			if (num <= 0 || num > array.length)
			{
				return [array];
			}

			var arrayList:Array = [];
			var count:int = Math.ceil(array.length / num);
			for (var i:int = 0; i < count; ++i)
			{
				var start:int = i * num;
				var end:int = Math.min(start + num, array.length);
				arrayList.push(array.slice(start, end));
			}
			return arrayList;
		}
		
		//克隆
		public static function clone(array:Array):Array
		{
			if (!array || array.length == 0)
			{
				return [];
			}
			var len:int = array.length;
			var array_:Array = new Array(len);
			for (var i:int = 0; i < len; ++i)
			{
				array_[i] = array[i];
			}
			return array_;
		}
		
		//查找数组中等于某个属性的值
		public static function find(array:Array, prop:String, value:*):*
		{
			if (!array || array.length == 0)
			{
				return null;
			}
			for each (var obj:Object in array)
			{
				if (obj[prop] == value)
				{
					return obj;
				}
			}
			return null;
		}
		
		//查找数组中等于某个属性的值
		public static function findEx(array:Array, value:*):Boolean
		{
			if (!array || array.length <= 0)
			{
				return false;
			}
			for each (var obj:Object in array)
			{
				if (obj == value)
				{
					return true;
				}
			}
			return false;
		}
		
		//查找数组中符合条件的对象
		public static function findIf(array:Array, func:Object):Array
		{
			var list:Array = [];
			if (!array || !func)
			{
				return list;
			}
			for each (var item:Object in array)
			{
				if (func(item))
				{
					list.push(item);
				}
			}
			return list;
		}

		//以某个类的实例初始化数组
		public static function init(array:Array, clsRef:Class, len:int = -1):void
		{
			if (!array || !clsRef)
			{
				return;
			}
			if (len == -1)
			{
				len = array.length;
			}
			for (var i:int = 0; i < len; i++)
			{
				array[i] = new clsRef;
			}
		}
		
		//比较两个数组的元素是否一致
		public static function equals(array1:Array, array2:Array):Boolean
		{
			if (array1 == array2)
			{
				return true;
			}
			if (array1.length != array2.length)
			{
				return false;
			}
			for (var i:int = 0; i < array1.length; i++) 
			{
				if (array1[i] != array2[i])
				{
					return false;
				}
			}
			return true;
		}
		
		//去除重复的元素
		public static function unique(array:Array):Array
		{
			var array_:Array = [];
			for each (var item:Object in array)
			{
				if (array_.indexOf(item) == -1)
				{
					array_.push(item);
				}
			}
			return array_;			
		}
		
		//去除重复的元素
		public static function removeRepeatedEx(array:Array):Array
		{
			var array_:Array = [];
			for each (var item:Object in array)
			{
				if (!findEx(array, item))
				{
					array_.push(item);
				}
			}
			return array_;			
		}

		//快速排序
		public static function quickSort(array:Array, compFunc:Function):void
		{
			if (!array || compFunc == null)
			{
				return;
			}
			
			quickRun(array, 0, array.length - 1, compFunc);
		}

		private static function quickRun(array:Array, first:int, last:int, compFunc:Function):void
		{
			if (first >= last)
			{
				return;
			}

			swap(array, first, (first + last) / 2);
			var mid:int = first;
			for (var i:int = first + 1; i <= last; ++i)
			{
				if (compFunc(array[first], array[i]))
				{
					swap(array, i, ++mid);
				}
			}
			swap(array, first, mid);
			quickRun(array, first, mid, compFunc);
			quickRun(array, mid + 1, last, compFunc);
		}

		//插入排序
		public static function insertSort(array:Array, compFunc:Function):void
		{
			if (!array || compFunc == null)
			{
				return;
			}
			
			var len:int = array.length;
			for (var i:int = 1; i < len; ++i)
			{
				if (compFunc(array[i - 1], array[i]))
				{
					insertRun(array, compFunc, i);
				}
			}
		}

		private static function insertRun(array:Array, compFunc:Function, index:int):void
		{
			for (var i:int = index - 1; i >= 0; --i)
			{
				if (compFunc(array[i], array[i + 1]))
				{
					swap(array, i, i + 1);
				}
			}
		}

		//交换数组的元素
		public static function swap(array:Array, i1:int, i2:int):void
		{
			var t:Object = array[i1];
			array[i1] = array[i2];
			array[i2] = t;
		}
		
		//按索引删除元素
		public static function removeIndexs(array:Array, indexList:Array):Array
		{
			var original:Array = ArrayUtils.clone(array);
			if(indexList.length == 0)
			{
				return array;
			}
			indexList.sort(Array.NUMERIC);
			var index:int = indexList.shift();
			var resultArray:Array = [];
			
			
			for(var i:int = 0; i < array.length; i++)
			{
				if(i == index)
				{
					if(indexList.length > 0)
					{
						index = indexList.shift();
					}
					continue;
				}
				
				resultArray.push(original[i]);
			}
			
			return resultArray;
		}
		
		//获取平均值
		public static function average(arr:Array):Number
		{
			var result:Number = 0;
			if (arr)
			{
				for each (var value:Number in arr)
				{
					result += value;
				}
				result /= arr.length;
			}
			return result;
		}
		
		//循环
		public static function loop(count:int, func:Object):void
		{
			for (var i:int = 0; i < count; i++) 
			{
				func();
			}
		}
		
		//调用相应的方法
		public static function every(array:Array, func:String, ...args):void
		{
			for each (var item:Object in array)
			{
				if (item.hasOwnProperty(func))
				{
					var funcObj:Function = item[func];
					funcObj.apply(item, args);
				}
			}
		}
		
		//转成整数
		public static function toInt(array:Array):Array
		{
			var list:Array = [];
			for each (var item:Object in array)
			{
				list.push(int(item));
			}
			return list;
		}
	}
}