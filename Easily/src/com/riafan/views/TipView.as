package com.riafan.views {
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;	

	/**
	 * 进度条类
	 * @author Flying
	 * @version 1.0
	 */
	public class TipView extends Sprite {

		public var tfTip : TextField;
		public var shpTip : Shape;

		/**
		 * 初始化进度条
		 * @param tfTip 动态提示文本
		 * @param shpTip 填充提示图形
		 */

		public function TipView(tfTip : TextField = null,shpTip : Shape= null) {
			
			this.tfTip = tfTip;
			this.shpTip = shpTip;
			//设置提示文本
			tfTip.autoSize = TextFieldAutoSize.CENTER;
			tfTip.selectable = false;
			tfTip.background = true;
			tfTip.backgroundColor = 0xFFFFCC;
			tfTip.textColor = 0x000000;
			//新建轮廓提示图形
			var os : Shape = new Shape();
			var g : Graphics = os.graphics;
			g.lineStyle(1, 0x009900);
			g.drawRect(0, 0, 100, 20);
			//新建填充提示图形
			g = shpTip.graphics;
			g.beginFill(0x99999);
			g.drawRect(1, 1, 98, 18);
			g.endFill();
			
			shpTip.y = tfTip.y + 30;
			os.y = tfTip.y + 30;
			
			addChild(tfTip);
			addChild(os);
			addChild(shpTip);
		}
	}
}
