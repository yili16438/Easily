package org.easily.loader2
{
	import flash.utils.Dictionary;

	public class LoaderType
	{
		//empty
		public static const EMPTY:String = "empty";
		
		//普通资源:jpg,png,swf
		public static const RES:String = "res";			
		
		//文本资源:txt,xml
		public static const TEXT:String = "text";		
		
		//二进制数据
		public static const BINARY:String = "binary";
		
		//解密资源
		public static const CRES:String = "cres";
		
		//字节流
		public static const BYTES:String = "bytes";		
		
		//加载到应用程序域
		public static const DOMAIN:String = "domain";	
		
		//同CRES
		public static const CDOMAIN:String = "cdomain";
		
		//加载到新的域
		public static const APP:String = "app";
		
		//同CRES
		public static const CAPP:String = "capp";
	}
}