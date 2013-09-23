/**
* ...
* @author terry52nn@live.cn
* @version 0.1
*/
package com.ojuju.colorpicker{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField
	
 	public class MCSwatcheCell extends Sprite{
 		
	private 	var lightColor = 0xFFFFFF;
private var darkColor = 0x9D9DA1;
	
 		public function MCSwatcheCell(t,j){
			graphics.beginFill(parseInt(t, 16));
					Ulit.drawRect(this, (j == 19 ? 6 : 8), 8, 0, 0, .5, 0x0000000, 0x000000);
					graphics.endFill();
 					
					
					
		}
		
		
		
		
	}
 	
	}