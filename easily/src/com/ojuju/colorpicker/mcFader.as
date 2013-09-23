/**
* ...
* @author terry52nn@live.cn
* @version 0.1
*/

package com.ojuju.colorpicker {

	import flash.events.*;
	import flash.text.*;
	import flash.display.*;
	import flash.geom.*;
	import flash.geom.ColorTransform

	public class mcFader extends MovieClip{
		
		private var tfLabel:TextField;
		private var _limit:uint;
		private var _flag:String;
		public var mcBorder:Sprite = new Sprite();
		public var tfValue:TextField;
		public var mcBox:Sprite = new Sprite();
		public var mcDown:Sprite = new Sprite();
		public var mcUp:Sprite = new Sprite();
		public var mcBg:Sprite = new Sprite();
		private var _Fvalue:String = "0";
		public var mcColor:Sprite = new Sprite();
		private var b:Number = 0;
		private var k:Boolean = false;
		private var d:Boolean;
		public var mcBegin:Sprite 
		public var mcEnd:Sprite 
		public var mcHue:Sprite;
		public var mcBg1:Sprite;
		public function mcFader(str:String) 
		{
			
			mcBorder.x=14;
			Ulit.drawRect(mcBorder, 100, 12, 0, 2);
			Ulit.drawRect(mcBorder, 25, 12, 106, 2);
			tfLabel = new TextField();
			with(tfLabel){
				width=15
				x=-2
				height=20
				selectable = false;
				text = str+":";
				setTextFormat(Ulit.TF);
			}
			addChild(tfLabel);
			addChild(mcBorder);
			tfValue = new TextField();
			 
				tfValue.width=25;
				tfValue.x=120;
				tfValue.height=20
				tfValue.y=-1
				
				tfValue.type = TextFieldType.INPUT;
				tfValue.text = Fvalue;
				tfValue.restrict = "0-9";
				tfValue.maxChars = 3;
			 
			addChild(tfValue);
			tfValue.addEventListener(Event.CHANGE,onChange);
			
			with(mcBox)
			{
				x =14;
				graphics.beginFill(0x000000);
				Ulit.drawRect(mcBox, 4, 12, 0, 2, 0, 0x000000, 0x000000);
				graphics.endFill();
				graphics.beginFill(0xFFFFFF);
				Ulit.drawRect(mcBox, 2, 12, 1, 2, 0, 0xFFFFFF, 0xFFFFFF);
				graphics.endFill();
			}
			
			addChild(mcBox);
			
			with (mcDown) {
				x = 145;
				y = 8;
				graphics.beginFill(Ulit.bgColor);
				Ulit.drawRect(mcDown, 7, 6, 0, 0, .5, Ulit.darkColor, Ulit.lightColor);
				graphics.beginFill(0x000000);
				graphics.moveTo(3.5, 5.5);
				graphics.lineTo(0.5, .5);
				graphics.lineTo(6.5, .5);
				graphics.lineTo(3.5, 5.5);
				graphics.endFill();
			}
			addChild(mcDown);
			mcDown.addEventListener(MouseEvent.MOUSE_DOWN,ArrowDown,false,0,true);
			with (mcUp) {
				x = 145;
				y = 1.5;
				graphics.beginFill(Ulit.bgColor);
				Ulit.drawRect(mcUp, 7, 6, 0, 0, .5, Ulit.darkColor, Ulit.lightColor);
				graphics.beginFill(0x000000);
				graphics.moveTo(3.5, .5);
				graphics.lineTo(0.5, 5.5);
				graphics.lineTo(6.5, 5.5);
				graphics.lineTo(3.5, .5);
				graphics.endFill();
			}
			addChild(mcUp);
			mcUp.addEventListener(MouseEvent.MOUSE_DOWN,ArrowUp,false,0,true);
			with (mcBg) {
				graphics.beginFill(0xFFFFFF);
				Ulit.drawRect(mcBg, 100, 12,0,2);
				graphics.endFill();
			}
			mcBorder.addChild(mcBg);
			//mcBg.addEventListener(MouseEvent.MOUSE_DOWN,onBoxMouseDown,false,0,true);
			mcBorder.addEventListener(MouseEvent.MOUSE_DOWN,onBoxMouseDown,false,0,true);
			mcBox.mouseEnabled=false
			
			
			
			var bod:Sprite =new Sprite();
				Ulit.drawRect(bod, 100, 12, 14, 2);
			Ulit.drawRect(bod, 25, 12, 120, 2);

		addChild(bod)
 			bod.mouseEnabled=false
			
			
			
			
			
		}
		
		public function SetTop(){
			mcBorder.setChildIndex(mcBg,mcBorder.numChildren-1)
			
			}
		public function SetButtom(){
			mcBorder.setChildIndex(mcBg,0)
			
			}
			
			
		private function ArrowDown(evt:MouseEvent)
		{
			k = true,d = false;
			Ulit.drawRect(mcDown, 7, 6, 0, 0, .5, Ulit.lightColor, Ulit.darkColor);
			stage.addEventListener(MouseEvent.MOUSE_UP,ArrowDownFalse);
			addEventListener(Event.ENTER_FRAME,onEnterUp);
		}
		private function ArrowDownFalse(evt:MouseEvent)
		{
			k = false;
			Ulit.drawRect(mcDown, 7, 6, 0, 0, .5, Ulit.darkColor, Ulit.lightColor);
			stage.removeEventListener(MouseEvent.MOUSE_UP,ArrowDownFalse);
		}
		private function ArrowUp(evt:MouseEvent)
		{
			k = true,d = true;
			Ulit.drawRect(mcUp, 7, 6, 0, 0, .5, Ulit.lightColor, Ulit.darkColor);
			stage.addEventListener(MouseEvent.MOUSE_UP,ArrowUpFalse);
			addEventListener(Event.ENTER_FRAME,onEnterUp);
		}
		private function ArrowUpFalse(evt:MouseEvent)
		{
			k = false;
			Ulit.drawRect(mcUp, 7, 6, 0, 0, .5, Ulit.darkColor, Ulit.lightColor);
			stage.removeEventListener(MouseEvent.MOUSE_UP,ArrowUpFalse);
		}
		private function onEnterUp(evt:Event = null)
		{
			
			b = Number(Fvalue);
			if(k&&d&&b<limit)b++;
			if(k&&!d&&b>0)b--;
			Fvalue = String(b);
			if(!k)removeEventListener(Event.ENTER_FRAME,onEnterUp);
			dispatchEvent(new Event("Change"));
		}
		public function CreateMatir(colors:Array = null,alphas:Array =null,ratios:Array = null,matrix:Matrix = null):Sprite
		{
			var sp:Sprite = new Sprite();
			with(sp){
				graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
				Ulit.drawRect(sp, 100, 12,0,2);
				graphics.endFill();
			}
			return sp;
		}
		public function onChange(evt:Event)
		{
			//Fvalue = tfValue.text;
			dispatchEvent(new Event("Change"));
		}
		public function onBoxMouseDown(evt:MouseEvent)
		{
			onBoxMouseMove();
			//mcBox.x = this.mouseX>13 && this.mouseX<110 ? this.mouseX : (this.mouseX<=13 ? 14 : 110);
			//Fvalue =  String(int(Math.round(mcBox.x - 14)*limit/(100-4)));
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onBoxMouseMove,false,0,true);
			stage.addEventListener(MouseEvent.MOUSE_UP,onBoxMouseUp,false,1002,true);
		}
		public function onBoxMouseMove(evt:MouseEvent = null)
		{
			mcBox.x = this.mouseX>13 && this.mouseX<110 ? this.mouseX : (this.mouseX<=13 ? 14 : 110);
			Fvalue =  String(int(Math.round(mcBox.x - 14)*limit/(100-4)));
			dispatchEvent(new Event(Event.CHANGE));
			if(evt)evt.updateAfterEvent();
		}
		public function onBoxMouseUp(evt:MouseEvent)
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onBoxMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onBoxMouseUp);
		}
		public function get limit():uint{ return _limit;}
		public function set limit(value:uint){ _limit = value;}
		public function get flag():String{ return _flag;}
		public function set flag(value:String){ 
			_flag = value;
			
		}
		public function get Fvalue():String
		{
			return _Fvalue;
		}
		public function set ColorValue(value:String){}
		public function set Fvalue(value:String)
		{
			_Fvalue = value;
			tfValue.text = value;
			mcBox.x = (100-4)*Number(value)/limit+14
		}
	}
	
}
