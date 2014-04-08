package org.easily.box2d
{
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class b2Utils
	{
		public static function p2m(p:Number):Number
		{
			return p / b2Consts.worldScale;
		}
		
		public static function m2p(m:Number):Number
		{
			return m * b2Consts.worldScale;
		}
		
		public static function createDebug(host:DisplayObjectContainer, world:b2World, worldScale:Number):void
		{
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			var debugSprite:Sprite = new Sprite();
			host.addChild(debugSprite);
			
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(worldScale);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit);
			debugDraw.SetFillAlpha(0.5);
			world.SetDebugDraw(debugDraw);
		}
	}
}