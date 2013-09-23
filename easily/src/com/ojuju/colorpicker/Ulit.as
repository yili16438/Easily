/**
* ...
* @author terry52nn@live.cn
* @version 0.1
*/

package com.ojuju.colorpicker {
	import flash.display.Sprite;
	import flash.text.*;
	public class Ulit {
		public static var lightColor = 0xFFFFFF;//
		public static var darkColor = 0x9D9DA1;
		public static var bgColor = 0xEEEEEE;	
		public static function drawRect(mc:Sprite, w:Number, h:Number, oX:* = null, oY:*=null, lW:Number=0, c0:*=null, c1:*=null)
		{
			oX = oX != null ? oX : 0;
			oY = oY != null ? oY : 0;
			c0 = c0 != null ? c0 : Ulit.lightColor;
			c1 = c1 != null ? c1 : Ulit.darkColor;
			with (mc) {
				graphics.moveTo(w+oX, oY);
				graphics.lineStyle(lW != null ? lW : .5, c0);
				graphics.lineTo(w+oX, h+oY);
				graphics.lineTo(oX, h+oY);
				graphics.lineStyle(lW != null ? lW : .5, c1);
				graphics.lineTo(oX, oY);
				graphics.lineTo(w+oX, oY);
			}
		}
		public static  function get TF():TextFormat
		{
			var mat:TextFormat = new TextFormat();
			mat.size = 12;
			mat.font = "Arial";
			return mat
		}
		public static function toHex(n) {
			n = Math.round(n);
			n = (n.toString(16).length<2 ? "0"+n.toString(16) : n.toString(16)).toUpperCase();
			return n;
		}
		public static function hslToRgb(H, S, L):Object {
			var p1, p2;
			var rgb = new Object()
			if (L<=0.5) {
				p2 = L*(1+S);
			} else {
				p2 = L+S-(L*S);
			}
			p1 = 2*L-p2;
			if (S == 0) {
				rgb.r = L;
				rgb.g = L;
				rgb.b = L;
			} else {
				rgb.r = toRgb(p1, p2, H+120);
				rgb.g = toRgb(p1, p2, H);
				rgb.b = toRgb(p1, p2, H-120);
			}
			rgb.r *= 255;
			rgb.g *= 255;
			rgb.b *= 255;
			return rgb;
		}
		public static function toRgb(q1, q2, hue) {
			if (hue>360) {
				hue = hue-360;
			}
			if (hue<0) {
				hue = hue+360;
			}
			if (hue<60) {
				return (q1+(q2-q1)*hue/60);
			} else if (hue<180) {
				return (q2);
			} else if (hue<240) {
				return (q1+(q2-q1)*(240-hue)/60);
			} else {
				return (q1);
			}
		}
		public static function rgbToHsl(R, G, B):Object {
			R /= 255;
			G /= 255;
			B /= 255;
			var max, min, diff, r_dist, g_dist, b_dist;
			var hsl = new Object()
			max = Math.max(Math.max(R, G), B);
			min = Math.min(Math.min(R, G), B);
			diff = max-min;
			hsl.l = (max+min)/2;
			if (diff == 0) {
				hsl.h = 0;
				hsl.s = 0;
			} else {
				if (hsl.l<0.5) {
					hsl.s = diff/(max+min);
				} else {
					hsl.s = diff/(2-max-min);
				}
				r_dist = (max-R)/diff;
				g_dist = (max-G)/diff;
				b_dist = (max-B)/diff;
				if (R == max) {
					hsl.h = b_dist-g_dist;
				} else if (G == max) {
					hsl.h = 2+r_dist-b_dist;
				} else if (B == max) {
					hsl.h = 4+g_dist-r_dist;
				}
				hsl.h *= 60;
				if (hsl.h<0) {
					hsl.h += 360;
				}
				if (hsl.h>=360) {
					hsl.h -= 360;
				}
			}
			return hsl;
		}

	}
	
}
