/**
* ...
* @author terry52nn@live.cn
* @version 0.1
*/

package com.ojuju.colorpicker {

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.geom.*;
	public class ColorButton extends MovieClip{
		private var sp = new Sprite();
		private var W:Number = 89;
		private var H:Number = 20;
				private var _callback:Function

		public function ColorButton(str:String,dw:Number=89,dh:Number=20)
		{
			W = dw;
			H = dh;
			with (sp) {
				graphics.beginFill(Ulit.bgColor);
				Ulit.drawRect(sp, dw, dh, 0, 0, .5, Ulit.darkColor, Ulit.lightColor);
				graphics.endFill();
				var tfLabel = new TextField();
				with (tfLabel) {
					width = dw;
					height=20;
					
					y=(dh-20)/2
					selectable = false;
					html = true;
					htmlText = "<p align=\"center\"><font face=\"Arial\">"+str+"</p>";
				}
				sp.addChild(tfLabel);
			}
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN,onReset);
					this.addEventListener(MouseEvent.CLICK,mouseclick)

		}
		public function mouseclick(e:MouseEvent){
				
				if(CallBack!=null){
					CallBack()
					}
				}
		public function get CallBack():Function { return _callback; }
						
						public function set CallBack(value:Function):void 
						{
							_callback = value;
						}
		private function onReset(evt:MouseEvent)
		{
			Ulit.drawRect(sp, W, H, 0, 0, .5, Ulit.lightColor,Ulit.darkColor);
			stage.addEventListener(MouseEvent.MOUSE_UP,onResetFalse);
		}
		public function onResetFalse(evt:MouseEvent)
		{
			Ulit.drawRect(sp, W, H, 0, 0, .5, Ulit.darkColor, Ulit.lightColor);
		}
	}
	
}
