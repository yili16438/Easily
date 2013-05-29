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
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard
	public class ColorPickerUI extends MovieClip{
		private var mcBorder:Sprite = new Sprite();
		private var txt_Color:TextField;
		private var mcMixer:Sprite = new Sprite();
		private var mcPoint:Sprite;
		private var mcBoardHs:Sprite;
		private var colorBorder:Sprite = new Sprite();
		private var mcLighteness:Sprite = new Sprite();
		private var matrix:Matrix = new Matrix();
		private var colors:Array = new Array();
		private var alphas:Array = new Array();
		private var ratios:Array = new Array();
		private var mcArrow:Sprite = new Sprite();
		private var arrRGBHSL = ["R", "G", "B", "H", "S", "L"];
		private var _mcFader:Array = new Array();
		private var mcBg:Sprite = new Sprite();
		private var tfHex:TextField = new TextField();
		private var _hexColor:String = "";
		private var _mcNewColor:Sprite;
		private var OldColor:Number=0xcccccc
		private var MainStage:MovieClip = new MovieClip();
		private var mcMixerBorder:Sprite = new Sprite();
		private var mcNode:Sprite;
		private var mcMode:Sprite;
		private var Terry:MovieClip = new MovieClip();
		private var mcSwatches:MCSwatches;
		private var mcOldColor:Sprite;
		private var mode:Number = 1;
		private var btnReset:ColorButton;
		private var btnOk:ColorButton
		private var btnCancel:ColorButton;
		public function get value():Number{return parseInt("0x"+tfHex.text);}
		public function set value(value:Number)
		{
			tfHex.text = String(value);
			hexChg()
			}
		public function ColorPickerUI(color:Number,modes:Number) {
			OldColor=color
			this.graphics.beginFill(Ulit.bgColor);
			Ulit.drawRect(this, 288, 160, 0, 0, .5, Ulit.darkColor, Ulit.lightColor);
			this.graphics.endFill();
			
			Ulit.drawRect(mcBorder, 116, 15, 5, 5)
			addChild(mcBorder);
			mcOldColor = _mcOldColor()
			addChild(mcOldColor);
			
			_mcNewColor = mcNewColor()
			addChild(_mcNewColor);
			addChild(CreateText());
			addChild(MainStage);
			Ulit.drawRect(colorBorder, 62, 15, 158, 5);
			addChild(colorBorder);
			MainStage.addChild(mcMixer);
			MainStage.addChild(mcMixerBorder);
			mcBoardHs = _mcBoardHs()
			mcMixer.addChild(mcBoardHs);
			mcPoint = _mcPoint();
			mcBoardHs.addChild(mcPoint);
			mcLighteness=_mcLighteness()
			//亮度
			MainStage.addChild(mcLighteness);
			
			CreateArrow();
			mcLighteness.addChild(mcArrow);
			
			GetRight();
			tfHex.width=60;
			tfHex.height=20;
			tfHex.x=158,tfHex.y=3;
			tfHex.type = "input";
			tfHex.restrict = "0-9A-F";
			tfHex.maxChars = 6;
			tfHex.addEventListener(FocusEvent.FOCUS_OUT,hexChg);
			this.addEventListener(KeyboardEvent.KEY_UP,enterkeyup)
			
			addChild(tfHex);
			mcNode = _mcNode();
			addChild(mcNode);
			
				mcNode.addEventListener(MouseEvent.CLICK,Cancel);
			mcMode = _mcMode();
			
			if(mode==1){DrawMode1()}else{DrawMode2()}
			addChild(mcMode);
			
			
			//
			btnReset = new ColorButton("还原")
			btnReset.x=4,btnReset.y=130;
			addChild(btnReset);
			btnReset.CallBack=Reset;
			btnOk = new ColorButton("确定");
			btnOk.x=99,btnOk.y=130;
			addChild(btnOk);
			btnOk.CallBack=onClickOk;
			btnCancel = new ColorButton("取消");
			btnCancel.x=194,btnCancel.y=130;
		
			addChild(btnCancel);
			btnCancel.CallBack=Cancel;
			
			
			addChild(Terry);
			mcSwatches = new MCSwatches()
			Terry.addChild(mcSwatches);
			mcSwatches.addEventListener("RollOver",mcSwatchOver);
			mcSwatches.addEventListener("RollOut",mcSwatchOut);
			mcSwatches.addEventListener("Change",mcSwatchChange);
			init(color,modes)
		}
		
		private function enterkeyup(evt:KeyboardEvent){
			 
			if(evt.keyCode==Keyboard.ENTER){
				onClickOk()
				
				}
			}
		
			
			private function Cancel(e:*=null){
				dispatchEvent(new Event(Event.CANCEL));
				
				}
			private function Reset(){
 				tfHex.text=String(Ulit.toHex(OldColor))
				hexChg()
				
				}
		private function onClickOk(evt:MouseEvent=null)
		{
			dispatchEvent(new Event(Event.SELECT));
		}
		private function mcSwatchOver(evt:Event)
		{
			if(!mcSwatches.SelectedCell) return 
			mcSwatches.t=tfHex.text
			tfHex.text=mcSwatches.SelectedCell.name.substr(2, 6);
			hexChg();
		}
		private function mcSwatchChange(evt:Event)
		{
			mcSwatches.t=tfHex.text=mcSwatches.SelectedCell.name.substr(2, 6);
			
			hexChg();
			onClickOk()
			
			
		}
		private function mcSwatchOut(evt:Event)
		{
			tfHex.text=	mcSwatches.t
			hexChg();
		}
		public function DrawMode1()
		{
			with(mcMode){
				graphics.clear();
				Ulit.drawRect(mcMode, 15, 15, 0, 0, .5, Ulit.darkColor, Ulit.lightColor);
				colors = [0xFF0000, 0xFFFF00, 0x00FF00, 0x00FFFF, 0x0000FF, 0xFF00FF, 0xFF0000];
				alphas = [100, 100, 100, 100, 100, 100, 100];
				ratios = [0x00, 0x2A, 0x55, 0x7F, 0xAA, 0xD4, 0xFF];
				matrix.createGradientBox(9,9,0,3,3);
				graphics.beginGradientFill(GradientType.LINEAR,colors, alphas, ratios, matrix)
				Ulit.drawRect(mcMode, 9, 9, 3, 3);
				colors = [0x808080, 0x808080];
				alphas = [0, 100];
				ratios = [0x00, 0xFF];
				matrix.createGradientBox(9,9,0.5*Math.PI,3,3);
				graphics.beginGradientFill(GradientType.LINEAR,colors, alphas, ratios, matrix)
				Ulit.drawRect(mcMode, 9, 9, 3, 3, .5, 0x000000, 0x000000);
				graphics.endFill();
			}
		}
		public function DrawMode2()
		{
			with(mcMode){
					graphics.clear();
					Ulit.drawRect(mcMode, 15, 15, 0, 0, .5, Ulit.lightColor, Ulit.darkColor);
					graphics.beginFill(0xFF0000);
					Ulit.drawRect(mcMode, 4.5, 4.5, 3, 3, .5, 0x000000, 0x000000);
					graphics.beginFill(0x00FF00);
					Ulit.drawRect(mcMode, 4.5, 4.5, 7.5, 3, .5, 0x000000, 0x000000);
					graphics.beginFill(0x0000FF);
					Ulit.drawRect(mcMode, 4.5, 4.5, 3, 7.5, .5, 0x000000, 0x000000);
					graphics.beginFill(0xFFFF00);
					Ulit.drawRect(mcMode, 4.5, 4.5, 7.5, 7.5, .5, 0x000000, 0x000000);
					graphics.endFill();
			}
		}
		public function _mcMode():Sprite
		{
			
			var sp = new Sprite();
			with (sp) {
				x = 268;
				y = 5;
				
			}
			
			sp.addEventListener(MouseEvent.CLICK,onModeChange);
			return sp;
		}
		private function onModeChange(evt:MouseEvent)
		{
			if(mode==0){mode=1,DrawMode1()}else{mode=0,DrawMode2()}
			chgMode(mode);
		}
		function init(initColor:Number, mode=0) {
			tfHex.text =  String (Ulit.toHex(initColor));
			
			hexChg();
			mode = mode != null ? mode : 0;
			chgMode(mode);
			
			var myColor = new ColorTransform()
			myColor.color=initColor
			mcOldColor.transform.colorTransform = myColor;
			
		}
		private function chgMode(mode1)
		{
			mode = mode1
			if(mode){MainStage.visible = true;Terry.visible = false;}else{Terry.visible = true;MainStage.visible = false;}
		}
		public function _mcNode():Sprite
		{
			var sp:Sprite = new Sprite();
			with (sp) {
				x = 252;
				y = 5;
				graphics.beginFill(Ulit.bgColor);
				Ulit.drawRect(sp, 15, 15, 0, 0, .5, Ulit.darkColor, Ulit.lightColor);
				graphics.endFill();
				graphics.beginFill(0xFFFFFF);
				Ulit.drawRect(sp, 9, 9, 3, 3);
				graphics.endFill();
				graphics.lineStyle(2, 0xFF0000);
				graphics.moveTo(4, 11);
				graphics.lineTo(11, 4);
				Ulit.drawRect(sp, 9, 9, 3, 3, .5, 0x000000, 0x000000);
			}
			sp.addEventListener(MouseEvent.MOUSE_DOWN,onNodeDown,false,0,true);
			return sp;
		}
		private function onNodeDown(evt:MouseEvent)
		{
			Ulit.drawRect(mcNode, 15, 15, 0, 0, .5, Ulit.lightColor, Ulit.darkColor);
		}
		public function get hexColor():String{return _hexColor;}
		public function set hexColor(value:String){ _hexColor = value;tfHex.text = value;}
		public function hexChg(evt:Event=null) {
			
		
			tfHex.appendText("000000".substr(0, 6-tfHex.text.length))
			hexColor = tfHex.text;

			with (mcMixer) {
				_mcFader["R"].Fvalue= parseInt(tfHex.text.substr(0, 2), 16);
				_mcFader["G"].Fvalue = parseInt(tfHex.text.substr(2, 2), 16);
				_mcFader["B"].Fvalue = parseInt(tfHex.text.substr(4, 2), 16);
				
			}
			update(0);
		}
		public function onFaderChange(evt:Event)
		{
			var flag = evt.currentTarget.flag;
			update(flag == "R" || flag == "G" || flag == "B" ? 0 : 1)
		}
		public function GetRight()
		{
				var color:ColorTransform
			for(var i:int=0;i<arrRGBHSL.length;i++)
			{
				_mcFader[arrRGBHSL[i]] = new mcFader(arrRGBHSL[i]);
				_mcFader[arrRGBHSL[i]].x=128;
				_mcFader[arrRGBHSL[i]].y = 25+i*16.5+(i>2 ? 2 : 0);
				_mcFader[arrRGBHSL[i]].addEventListener(Event.CHANGE,onFaderChange);
				MainStage.addChild(_mcFader[arrRGBHSL[i]]);
				_mcFader[arrRGBHSL[i]].limit = arrRGBHSL[i] == "H" ? 359 : (arrRGBHSL[i] == "S" || arrRGBHSL[i] == "L" ? 100 : 255);
				_mcFader[arrRGBHSL[i]].flag = arrRGBHSL[i];
				_mcFader[arrRGBHSL[i]].addEventListener("Change",onChange);
				if (_mcFader[arrRGBHSL[i]].flag == "L") {
					
					colors = [0xFFFFFF, 0xFFFFFF, 0x000000, 0x000000];
					alphas = [100, 0, 0, 100];
					ratios = [0x00, 0x7F, 0x80, 0xFF];
					matrix.createGradientBox(96,12,-1*Math.PI,0,0)
					_mcFader[arrRGBHSL[i]].mcBg1=_mcFader[arrRGBHSL[i]].CreateMatir(colors,alphas,ratios,matrix)
					_mcFader[arrRGBHSL[i]].mcBorder.addChild(_mcFader[arrRGBHSL[i]].mcBg1);
					
					
					_mcFader["L"].Fvalue = "100";
					
				}
				else if (_mcFader[arrRGBHSL[i]].flag == "H") {
						colors = [0xFF0000, 0xFFFF00, 0x00FF00, 0x00FFFF, 0x0000FF, 0xFF00FF, 0xFF0000];
						alphas = [100, 100, 100, 100, 100, 100, 100];
						ratios = [0x00, 0x2A, 0x55, 0x7F, 0xAA, 0xD4, 0xFF];
						matrix.createGradientBox(100,10,0,0,0)
						_mcFader[arrRGBHSL[i]].mcHue =_mcFader[arrRGBHSL[i]].CreateMatir(colors,alphas,ratios,matrix)
						_mcFader[arrRGBHSL[i]].mcBorder.addChild(_mcFader[arrRGBHSL[i]].mcHue);
						
						}
					else if (_mcFader[arrRGBHSL[i]].flag == "R" || _mcFader[arrRGBHSL[i]].flag == "G" || _mcFader[arrRGBHSL[i]].flag == "B" || _mcFader[arrRGBHSL[i]].flag == "S") {
						colors = [_mcFader[arrRGBHSL[i]].flag == "S" ? 0x808080 : 0x000000, _mcFader[arrRGBHSL[i]].flag == "S" ? 0x808080 : 0x000000];
						alphas = [100, 0];
						ratios = [0x00, 0xFF];
						matrix.createGradientBox(100,12,0,0,0)
						_mcFader[arrRGBHSL[i]].mcBegin  = _mcFader[arrRGBHSL[i]].CreateMatir(colors,alphas,ratios,matrix)
						
						_mcFader[arrRGBHSL[i]].mcBorder.addChildAt(_mcFader[arrRGBHSL[i]].mcBegin,0);
						
						
						_mcFader[arrRGBHSL[i]].ColorValue=0xddccdd;
						
						
						colors = [0x000000, 0x000000];
						alphas = [0, 100];
						ratios = [0x00, 0xFF];
						matrix.createGradientBox(100,12,0,0,0)
					
						
					
							_mcFader[arrRGBHSL[i]].mcEnd =_mcFader[arrRGBHSL[i]].CreateMatir(colors,alphas,ratios,matrix)
								_mcFader[arrRGBHSL[i]].mcBorder.addChildAt(_mcFader[arrRGBHSL[i]].mcEnd,0);

				
					}	
					if (_mcFader[arrRGBHSL[i]].flag != "S") {
 					_mcFader[arrRGBHSL[i]].SetButtom()
 
					
					
					}
			}
		}
		
		
		public function onChange(evt:Event)
		{
			var target = evt.target;
			if (target.tfValue.text == "") {
				target.tfValue.text = 0;
			} else if (target.tfValue.text>target.limit) {
				target.tfValue.text = target.limit;
			} else {
				target.tfValue.text = parseInt(target.tfValue.text);
			}
			target.Fvalue = target.tfValue.text;
			update(target.flag == "R" || target.flag == "G" || target.flag == "B" ? 0 : 1);
		}
		//初始颜色
		public function _mcOldColor():Sprite
		{
			var sp = new Sprite();
			with (sp) {
				x = 5;
				y = 5;
				graphics.beginFill(0x000000);
				Ulit.drawRect(sp, 58, 15, 0, 0, .5, 0x000000, 0x000000);
				graphics.endFill();
			}
			return sp;
		}
		public function _mcPoint():Sprite
		{
			var sp = new Sprite();
			with (sp) {
					x = 1;
					y = 1;
					graphics.lineStyle(.5, 0xFFFFFF);
					graphics.moveTo(0, 1);
					graphics.lineTo(0, 5);
					graphics.moveTo(1, 0);
					graphics.lineTo(5, 0);
					graphics.moveTo(0, -1);
					graphics.lineTo(0, -5);
					graphics.moveTo(-1, 0);
					graphics.lineTo(-5, 0);
					//mask = mcMask
				}
			return sp;
		}
		public function _mcBoardHs():Sprite
		{
			Ulit.drawRect(mcMixerBorder, 96, 96, 5, 25);
			var sp:Sprite = new Sprite();
			with(sp){
				x=5,y=25;
				colors = [0xFF0000, 0xFFFF00, 0x00FF00, 0x00FFFF, 0x0000FF, 0xFF00FF, 0xFF0000];
				alphas = [100, 100, 100, 100, 100, 100, 100];
				ratios = [0x00, 0x2A, 0x55, 0x7F, 0xAA, 0xD4, 0xFF];
				matrix.createGradientBox(96,96,0,0,0);
				graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
				Ulit.drawRect(sp, 96, 96);
				graphics.endFill();
				colors = [0x808080, 0x808080];
				alphas = [0, 100];
				ratios = [0x00, 0xFF];
				matrix.createGradientBox(96,96,0.5*Math.PI,0,0);
				graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
				Ulit.drawRect(sp, 96, 96);
				graphics.endFill();
				
			}
			sp.addEventListener(MouseEvent.MOUSE_DOWN,MouseDown);
			
			
			
			return sp;
		}
		public function _mcLighteness():Sprite
		{
			var sp = new Sprite();
			with (sp) {
				x = 106;
				y = 25;
			with (mcBg) {
				graphics.beginFill(0x7F7F7F);
				Ulit.drawRect(mcBg, 15, 96, 0, 0, 0, 0x7F7F7F);
				graphics.endFill();
				}
				addChild(mcBg);
				
		  
			
						
				var mcLightenesses:Sprite = new Sprite();
				with (mcLightenesses) {
					colors = [0xFFFFFF, 0xFFFFFF, 0x000000, 0x000000];
					alphas = [100, 0, 0, 100];
					ratios = [0x00, 0x7F, 0x80, 0xFF];
					matrix.createGradientBox(15,96,.5*Math.PI,0,0);
					mcLightenesses.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
					Ulit.drawRect(mcLightenesses, 15, 96);
					graphics.endFill();
				}
				
				sp.addChild(mcLightenesses);	
				
			
			}
			
			sp.addEventListener(MouseEvent.MOUSE_DOWN,LightMouseDown,false,0,true);
			return sp;
		}
		public function CreateArrow()
		{
			with (mcArrow) {
				x = 16;
				y = 1;
				graphics.beginFill(0x000000);
				graphics.lineTo(5, -4.5);
				graphics.lineTo(5, 4.5);
				graphics.lineTo(0, 0);
				graphics.endFill();
				addEventListener(MouseEvent.MOUSE_DOWN,onArrowMouseDown,false,0,true);
			}
		}
		public function onArrowMouseDown(evt:MouseEvent)
		{
			mcArrow.y =mcLighteness.mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,LightMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,LightMouseUp);
			LightMouseMove()
		}
		public function LightMouseDown(evt:MouseEvent)
		{
			mcArrow.y =mcLighteness.mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,LightMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,LightMouseUp,false,1001);
			LightMouseMove()
		}
		
		public function LightMouseMove(evt:MouseEvent=null)
		{	
			
			mcArrow.y =mcLighteness.mouseY>0 && mcLighteness.mouseY<96 ? mcLighteness.mouseY : (mcLighteness.mouseY<=0 ? 1 : 95);
			getPickerColor()
			if(evt)evt.updateAfterEvent();
		}
		public function LightMouseUp(evt:MouseEvent)
		{
 			stage.removeEventListener(MouseEvent.MOUSE_MOVE,LightMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,LightMouseUp);
			
		}
		public function MouseDown(evt:MouseEvent)
		{
			MouseMove();
			stage.addEventListener(MouseEvent.MOUSE_MOVE,MouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,MouseUp,false,1000);
			
		}
		public function MouseMove(evt:MouseEvent = null)
		{
			mcPoint.x = mcBoardHs.mouseX>0 && mcBoardHs.mouseX<96 ? mcBoardHs.mouseX : (mcBoardHs.mouseX<=0 ? 1 : 95);
			mcPoint.y = mcBoardHs.mouseY>0 && mcBoardHs.mouseY<96 ? mcBoardHs.mouseY : (mcBoardHs.mouseY<=0 ? 1 : 95);
			getPickerColor();
			if(evt)evt.updateAfterEvent();
		}
		public function MouseUp(evt:MouseEvent)
		{
			if(!stage)return
		 	stage.removeEventListener(MouseEvent.MOUSE_MOVE,MouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,MouseUp);
		}
		public function getPickerColor()
		{
			with (mcMixer) {
			var h = (mcPoint.x-1)*359/94;
			var s = (95-mcPoint.y)*100/94;
			var v = (95-mcArrow.y)*100/94;
			_mcFader["H"].Fvalue = Math.round(h);
			_mcFader["S"].Fvalue = Math.round(s);
			_mcFader["L"].Fvalue = Math.round(v);
			}
			update(1);
		}
		public function update(mode:Number)
		{
			with (mcMixer) {
				switch (mode) {
				case 0 :
					var hsl = Ulit.rgbToHsl(parseInt(_mcFader["R"].Fvalue), parseInt(_mcFader["G"].Fvalue), parseInt(_mcFader["B"].Fvalue));
					_mcFader["H"].Fvalue = Math.round(hsl.h);
					_mcFader["S"].Fvalue = Math.round(hsl.s*100);
					_mcFader["L"].Fvalue = Math.round(hsl.l*100);
					break;
				case 1 :
					var rgb = Ulit.hslToRgb(parseInt(_mcFader["H"].Fvalue), parseInt(_mcFader["S"].Fvalue)/100, parseInt(_mcFader["L"].Fvalue)/100);
					_mcFader["R"].Fvalue = Math.round(rgb.r);
					_mcFader["G"].Fvalue = Math.round(rgb.g);
					_mcFader["B"].Fvalue = Math.round(rgb.b);
					break;
				}
				var R, G, B, H, S, L;
					R = parseInt(_mcFader["R"].Fvalue);
					G = parseInt(_mcFader["G"].Fvalue);
					B = parseInt(_mcFader["B"].Fvalue);
					H = parseInt(_mcFader["H"].Fvalue);
					S = parseInt(_mcFader["S"].Fvalue);
					L = parseInt(_mcFader["L"].Fvalue);
					
					hexColor= Ulit.toHex(R)+Ulit.toHex(G)+Ulit.toHex(B)
					
					for (var i = 0; i<arrRGBHSL.length; i++) 
					{
						with (_mcFader[arrRGBHSL[i]]) 
						{
							switch(_mcFader[arrRGBHSL[i]].flag)
							{
								case "R" :
								case "G" :
								case "B" :
									var beginColor:ColorTransform = new ColorTransform();
									var endColor:ColorTransform = new ColorTransform();
									var c0, c1;
									switch (_mcFader[arrRGBHSL[i]].flag) {
									case "R" :
										c0 = G*256+B;
										c1 = 255*256*256+G*256+B;
										break;
									case "G" :
										c0 = R*256*256+B;
										c1 = R*256*256+255*256+B;
										break;
									case "B" :
										c0 = R*256*256+G*256;
										c1 = R*256*256+G*256+255;
										break;
									}
									beginColor.color=c0;
									_mcFader[arrRGBHSL[i]].mcBegin.transform.colorTransform = beginColor;
									endColor.color=c1;
									_mcFader[arrRGBHSL[i]].mcEnd.transform.colorTransform = endColor;
									//beginColor.setRGB(c0);
									//endColor.setRGB(c1);
									break;
								case "H" :
									var myColorH:ColorTransform =new ColorTransform(S/100,S/100,S/100,1,(100-S)*1.275,(100-S)*1.275,(100-S)*1.275);
									
									 _mcFader["H"].mcHue.transform.colorTransform = myColorH;
									myColorH = new ColorTransform();
									myColorH.color = L<50 ? 0x000000 : 0xFFFFFF;
									_mcFader["H"].mcBg.transform.colorTransform = myColorH;
									_mcFader["H"].mcBg.alpha =(L<50 ? (50-L)*2 : (L-50)*2)/100;
									_mcFader["H"].SetTop();
									break;
								case "S" :
									var myColor:ColorTransform =new ColorTransform();
									rgb = Ulit.hslToRgb(H, 1, .5);
									myColor.color=Math.round(rgb.r)*256*256+Math.round(rgb.g)*256+Math.round(rgb.b);
									_mcFader["S"].mcEnd.transform.colorTransform = myColor;
								
									myColor = new ColorTransform()
									myColor.color=L<50 ? 0x000000 : 0xFFFFFF;
									_mcFader["S"].mcBg.transform.colorTransform = myColor;
									_mcFader["S"].mcBg.alpha = (L<50 ? (50-L)*2 : (L-50)*2)/100;
								
									break;
								case "L" :
									myColor = new ColorTransform()
									rgb = Ulit.hslToRgb(H, S/100, .5);
									myColor.color =Math.round(rgb.r)*256*256+Math.round(rgb.g)*256+Math.round(rgb.b);
									_mcFader["L"].mcBg.transform.colorTransform = myColor;
									_mcFader["L"].SetButtom();
									
								break;
							}
						}
					}
					
					
					var color:ColorTransform
					color=_mcNewColor.transform.colorTransform
					color.color="0x"+hexColor;
					
					 var color1:ColorTransform=mcBg.transform.colorTransform
					rgb = Ulit.hslToRgb(H, S/100, .5);
					color1.color="0x"+Ulit.toHex(rgb.r)+Ulit.toHex(rgb.g)+Ulit.toHex(rgb.b);
					mcBg.transform.colorTransform=color1;
					
					_mcNewColor.transform.colorTransform=color;
					
					
					mcPoint.x = Math.round(H*94/359)+1;
					mcPoint.y = 95-Math.round(S*94/100);
					mcArrow.y = 95-Math.round(L*94/100);
					
					
					
					
					//_mcNewColor
					
					
				}
		}
		private function mcNewColor():Sprite
		{
			var sp = new Sprite();
			with (sp) {
				x = 63;
				y = 5;
				graphics.beginFill(0xFF0000);
				Ulit.drawRect(sp, 58, 15, 0, 0, .5, 0xFF0000, 0xFF0000);
				graphics.endFill();
			}
			return sp;
		}
		public function CreateText():TextField
		{
			var t:TextField = new TextField();
				t.x = 131;
				t.y=3;
				t.selectable = false;
				t.text = "Hex:";
				//setTextFormat(Ulit.TF);
			return t;
		}
	}
	
}
