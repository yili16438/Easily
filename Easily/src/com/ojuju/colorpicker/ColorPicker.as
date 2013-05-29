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
	public class ColorPicker extends MovieClip{
	private 	var ui:ColorPickerUI
	private 	var icon:Sprite
		private var InitColor:Number=0x808080
		private var _value:Number=0
		private var isShow:Boolean=false
		public function ColorPicker() {

			icon=drawIcon()
		addChild(icon)
		addChild(drawBorder())
		icon.addEventListener(MouseEvent.CLICK,showthis)
		this.addEventListener(Event.REMOVED,Hide)
	
			}
	
			private function showthis(e:MouseEvent) {
				if (IsShow) Hide(); else
				Show(InitColor);
				
				}
		public function Hide(e:Event=null){
			
			if(ui){
				ui.removeEventListener(Event.SELECT,onSelect);
			 ui.removeEventListener(Event.CANCEL,Hide);
 				parent.stage.removeChild(ui);
				parent.stage.removeEventListener(MouseEvent.MOUSE_UP,stageup)
				}
				
				ui=null
			}
		public function Show(color:Number=0,mode:Number=1){
		
			if(!parent) return 
				if(color==0) color=InitColor
		 Hide()
				 ui=new ColorPickerUI(color,mode)
			 
			 parent.stage.addChild(ui);
		 
			 
			 var p:Point=parent.localToGlobal(new Point(this.x,this.y))
			 
			 
			 if((p.y+ui.height)>parent.stage.stageHeight)
			 {
				 p.y = p.y - ui.height;
				 
				 }
				 		 if((p.x+ui.width)>parent.stage.stageWidth)
			 {
				 p.x =parent.stage.stageWidth-ui.width
				 
				 }
				 if (p.x < 0) p.x = 0
				 if(p.y<0) p.y=0
				 
				 
			 ui.x=p.x
			 ui.y=p.y
			  ui.addEventListener(Event.SELECT,onSelect);
			 ui.addEventListener(Event.CANCEL,Hide);
			parent.stage.addEventListener(MouseEvent.MOUSE_UP,stageup)
			}
			
			private function stageup(e:MouseEvent){
 				 
				if(ui.hitTestPoint(stage.mouseX,stage.mouseY)) return 
				Hide()
				}
				private function onSelect(evt:Event)
				{
					ChangeColor(ui.value)
				
				
				}
		public function drawIcon():Sprite {
			var d:Sprite=new Sprite
			
			d.graphics.beginFill(0xE0E0E0,1);
			Ulit.drawRect(d,20,20);
			d.graphics.endFill()
			return d
			}
			public function drawBorder():Sprite{
			var d:Sprite=new Sprite
			
 			Ulit.drawRect(d,20,20,0,0,2);
 			return d
			}	
			
			public function ChangeColor(value:Number){
				InitColor=value
				var color:ColorTransform=new ColorTransform()
				color.color=value
				icon.transform.colorTransform=color
				Hide();
				
				dispatchEvent(new Event(Event.SELECT))
				}
				public function get value():Number{
					return InitColor
					}
					
					public function set value(value:Number){
						
						InitColor=value
						var color:ColorTransform=new ColorTransform()
				color.color=value
				icon.transform.colorTransform=color
						}
						
						public function get IsShow():Boolean { return Boolean(ui); }
						
					 
		
		
	}
	
}
