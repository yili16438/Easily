package org.easily.display
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * @author Easily
	 */
	public class Container extends Sprite
	{
		public function Container()
		{
			super();
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			if (child)
			{
				return super.addChild(child);
			}
			return null;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			if (child && contains(child))
			{
				return super.removeChild(child);
			}
			return null;
		}
		
		public function removeAll():void
		{
			while (numChildren > 0)
			{
				removeChildAt(0);
			}
		}
		
		public function dispose():void
		{
			removeAll();
			if (parent)
			{
				parent.removeChild(this);
			}
		}
	}
}