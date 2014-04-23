package org.easily.test.box2d
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[SWF(width="640", height="480", backgroundColor="0x414647")]
	public class Box2dTest2 extends Sprite
	{
		include "../../box2d/b2Utils.as";
		
		private var world:b2World;
		
		public function Box2dTest2()
		{
			super();
			
			var sleep:Boolean = true;
			var gravity:b2Vec2 = new b2Vec2(0, 9.81);
			world = new b2World(gravity, sleep);
			
			createMotor();
//			createFace();
			createWall();
			syncPosition();
			createDebug(this, world, b2DebugDraw.e_jointBit | b2DebugDraw.e_shapeBit, 0.8);		
			mouseJoint(stage, world);
			addEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		private function createMotor():void
		{
			var box1:b2Body = createRect(world, b2Body.b2_dynamicBody, new b2Vec2(100, 100), new b2Vec2(30, 30), 5, 0.5, 0.5);
			var box2:b2Body = createRect(world, b2Body.b2_dynamicBody, new b2Vec2(300, 100), new b2Vec2(30, 30), 5, 0.5, 0.5);
			var bridge:b2Body = createRect(world, b2Body.b2_dynamicBody, new b2Vec2(200, 100), new b2Vec2(110, 10), 5, 0.5, 0.5);
			
			revoluteJoint(world, box1, bridge, new b2Vec2(0 / worldScale, 0), new b2Vec2(-100 / worldScale, 0), true, 30, 3000);
			revoluteJoint(world, box2, bridge, new b2Vec2(0 / worldScale, 0), new b2Vec2(100 / worldScale, 0), true, -30, 3000);
		}
		
		private function createWall():void
		{
			var down:b2Body = createRect(world, b2Body.b2_staticBody, new b2Vec2(320, 475), new b2Vec2(1000, 5), 2, 0.4, 0.3);		
			var left:b2Body = createRect(world, b2Body.b2_staticBody, new b2Vec2(0, 240), new b2Vec2(5, 1000), 2, 0.4, 0.3);	
			var right:b2Body = createRect(world, b2Body.b2_staticBody, new b2Vec2(640, 240), new b2Vec2(5, 1000), 2, 0.4, 0.3);	
//			var mc:MovieClip = new PhysFloor;
//			mc.width = 640;
//			mc.height = 30;
//			addChild(mc);
//			floor.SetUserData(mc);
		}
		
		private function createFace():void
		{
			var face:b2Body = createCircle(world, b2Body.b2_dynamicBody, new b2Vec2(320, 50), 30, 2, 0.4, 0.5);
//			var mc:MovieClip = new PhysCircle;
//			mc.width = 60;
//			mc.height = 60;
//			addChild(mc);
//			face.SetUserData(mc);
		}

		private function onUpdate(event:Event):void
		{
			world.Step(timeStep, velIterations, posIterations);
			world.ClearForces();
			world.DrawDebugData();
			syncPosition();
		}
		
		private function syncPosition():void
		{
			for (var body:b2Body = world.GetBodyList(); body; body = body.GetNext())
			{
				if (body.GetUserData())
				{
					body.GetUserData().x = body.GetPosition().x * worldScale;
					body.GetUserData().y = body.GetPosition().y * worldScale;
				}
			}
		}
	}
}