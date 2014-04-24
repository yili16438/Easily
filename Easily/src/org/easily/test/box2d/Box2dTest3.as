package org.easily.test.box2d
{
	import flash.display.Sprite;
	
	[SWF(width="640", height="480", backgroundColor="0x414647")]
	public class Box2dTest3 extends Sprite
	{
		include "../../box2d/b2Utils.as";
		
		private var world:b2World;
		
		public function Box2dTest3()
		{
			super();
			
			var sleep:Boolean = true;
			var gravity:b2Vec2 = new b2Vec2(0, 9.81);
			world = new b2World(gravity, sleep);
			
			initShapes();
			createWall(world, 640, 480, 5, 2, 0.3, 0.5);
			mouseJoint(stage, world);
			createDebug(this, world, b2DebugDraw.e_jointBit | b2DebugDraw.e_shapeBit, 0.8);
			
			addEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		private function initShapes():void
		{
			var pos1:b2Vec2 = new b2Vec2(100,100);
			var vertices1:Array = [new b2Vec2(0,0), new b2Vec2(0,-30), new b2Vec2(-30,0)];
			var triangle1:b2Body = createPolygon(world, b2Body.b2_dynamicBody, pos1, vertices1, 2, 0.3, 0.4);
			
//			var pos2:b2Vec2 = new b2Vec2(300,300);
//			var vertices2:Array = [new b2Vec2(0,0), new b2Vec2(0,50), new b2Vec2(-30,0)];
//			var triangle2:b2Body = createPolygon(world, b2Body.b2_dynamicBody, pos2, vertices2, 2, 0.3, 0.4);
			
//			distanceJoint(world, triangle1, triangle2, new b2Vec2(), new b2Vec2(), 100);
//			distanceJoint(world, triangle1, triangle2, new b2Vec2(-30), new b2Vec2(-30), 100);
		}
		
		private function onUpdate(event:Event):void
		{
			world.Step(timeStep, velIterations, posIterations);
			world.ClearForces();
			world.DrawDebugData();
		}
	}
}