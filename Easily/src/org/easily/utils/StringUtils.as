package org.easily.utils
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	/**
	 * @author Easily
	 */
	public class StringUtils 
	{
		public static function substitute(string:String, ...args):String
		{
			var len:int = args.length;
			for (var i:int = 0; i < len; ++i)
			{
				string = string.replace("{" + i + "}", args[i]);
			}
			return string;
		}
		
		public static function isSpace(string:String):Boolean
		{
			for (var i:int = 0; i < string.length; i++) 
			{
				if (string.charAt(i) != " ")
				{
					return false;					
				}
			}
			return true;
		}
	}
}
