package com.riafan.controllers {
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;

	import com.riafan.views.TipView;	

	/**
	 * 带有提示文本及进度条的加载类
	 * @author Flying
	 * @version 1.0
	 */

	public class LoaderTip extends Sprite {

		private var tfTip : TextField;
		private var shpTip : Shape;
		private var tipView : TipView;
		public static  const LOAD_COMPLETE : String = "loadcomplete";
		public var loader : Loader;

		public var openText : String = "开始下载";
		public var progressText : String = "已经下载";
		public var completeText : String = "下载完毕";
		public var completeTextColor : uint = 0x000000;

		/**
		 * @param loader 加载器
		 * @param owner 父级容器
		 */

		public function LoaderTip(loader : Loader, owner : DisplayObjectContainer) {
			this.loader = loader;
			tfTip = new TextField();
			tfTip.text = "开始下载";
			shpTip = new Shape();
			shpTip.scaleX = 0;
			tipView = new TipView(tfTip, shpTip);
			
			tipView.x = (owner.stage.stageWidth - tipView.width) / 2;
			tipView.y = (owner.stage.stageHeight - tipView.height) / 2;	
			addChild(tipView);
			
			//为LoaderInfo对象注册侦听器
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
		}

		
		/**
		 * 下载出错时执行
		 */

		private function errorHandler(err : IOErrorEvent) : void {
			tfTip.text = err.text;
			tfTip.textColor = 0x990000;
		}

		/**
		 * 正在下载时执行
		 */

		private function progressHandler(event : ProgressEvent) : void {
			var info : LoaderInfo = event.target as LoaderInfo;
			var percent : int = ((info.bytesLoaded) / (info.bytesTotal)) * 100;
			tfTip.text = progressText + percent.toString() + "%";
			tfTip.textColor = 0x009900;
			shpTip.scaleX = percent / 100;
		}

		/**
		 * 下载完毕后执行
		 */

		private function completeHandler(event : Event) : void {
			//新建timer对象
			var timer : Timer = new Timer(500, 1);
			//注册time侦听器
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			timer.start();
		}

		/**
		 * 0.5秒后提示加载完毕并广播TimerEvent对象事件
		 */

		private function timerCompleteHandler(event : TimerEvent) : void {
			tfTip.text = completeText;
			tfTip.textColor = completeTextColor;
			var timer : Timer = new Timer(500, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, dispatchHandler);
			timer.start();
		}

		/**
		 * 1.5秒后广播URLLoaderTip对象事件
		 */

		private function dispatchHandler(event : TimerEvent) : void {
			dispatchEvent(new Event(LOAD_COMPLETE, true));
			removeChild(tipView);
		}
	}
}
