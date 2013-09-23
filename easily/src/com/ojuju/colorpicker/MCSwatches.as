/**
* ...
* @author terry52nn@live.cn
* @version 0.1
*/


package com.ojuju.colorpicker{
	import flash.display.Sprite;
	import flash.text.TextField
	import flash.events.*;
 	public class MCSwatches extends Sprite{
		private var tfLabel:TextField
		private var Flag:String
		private var tfValue:TextField
 		private var mcSwatches:Sprite
		private var mcBorder:Sprite;
		public var SelectedCell:MCSwatcheCell
	    public var t:String;
	private 	var lightColor = 0xFFFFFF;
private var darkColor = 0x9D9DA1;



	public function Border():Sprite
	{
		var sp = new Sprite();
		with(sp){
			mouseEnabled = false;
			visible = false;
			Ulit.drawRect(sp, 8, 8, 0, 0, .5, 0xFFFFFF, 0xFFFFFF);
		}
		return sp;
	}
	private function mouseclick(evt:MouseEvent)
	{
		SelectedCell = evt.currentTarget as MCSwatcheCell
		dispatchEvent(new Event("Change"));
	}
	private function mouseover(evt:MouseEvent) {
			
		SelectedCell = evt.currentTarget as MCSwatcheCell
			mcBorder.visible = true
			mcBorder.x = SelectedCell.x;
			mcBorder.y= SelectedCell.y;
			mcBorder.width = SelectedCell.width;
			mcBorder.height = SelectedCell.height;
			
			dispatchEvent(new Event("RollOver"));
			
			}
			
			private function mouseout(e:MouseEvent) {
						SelectedCell = e.currentTarget as MCSwatcheCell

				mcBorder.visible = false;
				dispatchEvent(new Event("RollOut"));
				}
		public function MCSwatches(){
		
			
			
		mcSwatches = new Sprite()
		addChild(mcSwatches)
		
 	   mcBorder = Border();
	   addChild(mcBorder);
		mcSwatches.visible = true;
	
		
		var arrColor = new Array();
	
		
		var arrNum = new Array("00", "33", "66", "99", "CC", "FF");
	
		
		var arrBaseColor = new Array("000000", "333333", "666666", "999999", "CCCCCC", "FFFFFF", "FF0000", "00FF00", "0000FF", "FFFF00", "00FFFF", "FF00FF");
		var t
		
		var i:Number = 0
		var j:Number=0
		
		for (  i = 0; i<12; i++) {
			arrColor[arrColor.length] = arrBaseColor[i];
			for (  j = 0; j<18; j++) {
				arrColor[arrColor.length] = arrNum[Math.floor(i/6)*3+Math.floor(j/6)]+arrNum[j%6]+arrNum[i%6];
			}
			arrColor[arrColor.length] = "000000";
			for (  j = 0; j<15; j++) {
  t = (Math.round((1-(i*15+j)/179)*255)).toString(16);
				t = t.length>1 ? t : "0"+t;
				t = t.toUpperCase();
				arrColor[arrColor.length] = t+t+t;
			}
		}
		
		
		
		
		
		
		
		var cols = 35;
		
		
		
		for (  i = 0; i<Math.ceil(arrColor.length/cols); i++) {
			for (  j = 0; j<cols; j++) {
				  t = i*cols+j<arrColor.length ? arrColor[i*cols+j] : "000000";
				
				
				var mc:MCSwatcheCell = new MCSwatcheCell(t,j)
				mc.addEventListener(MouseEvent.MOUSE_OVER,mouseover)
				mc.addEventListener(MouseEvent.MOUSE_OUT,mouseout)
				mc.addEventListener(MouseEvent.CLICK,mouseclick)
				mcSwatches.addChild(mc)
				mc.name="mc"+t+i+j
 		
					mc.y = 25+i*8;
					mc.x = (j>19 ? 3 : 5)+j*8;
				
 				
			}
		
		
		
		
		}
	 
		
		
	}
	}
}
	
	