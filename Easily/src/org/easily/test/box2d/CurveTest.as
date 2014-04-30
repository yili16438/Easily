package org.easily.test.box2d
{
	import Box2D.Dynamics.b2World;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class CurveTest extends Sprite
	{
		public var world:b2World;
		
		public function CurveTest(world_:b2World)
		{
			world = world_;
			
			addEventListener(Event.ADDED_TO_STAGE, onInit);
		}

		private function onInit(event:Event):void
		{
			
		}
	}
}