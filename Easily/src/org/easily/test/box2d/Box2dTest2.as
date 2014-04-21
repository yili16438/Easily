package org.easily.test.box2d
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[SWF(width="640", height="480", backgroundColor="0x414647")]
	public class Box2dTest2 extends Sprite
	{
		include "../../box2d/b2Common.as";
		
		public var world:b2World;
		
		public function Box2dTest2()
		{
			super();
			
			var sleep:Boolean = true;
			var gravity:b2Vec2 = new b2Vec2(0, 9.81);
			world = new b2World(gravity, sleep);
			
			createFace();
			createFloor();
			syncPosition();
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(Event.ENTER_FRAME, onUpdate);
		}

		private function onMouseDown(event:MouseEvent):void
		{
			world.QueryPoint(queryPoint, new b2Vec2(mouseX / worldScale, mouseY / worldScale));
		}
		
		private function queryPoint(fixture:b2Fixture):Boolean
		{
			return false;
		}
		
		private function createFloor():void
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_staticBody;
			bodyDef.userData = new PhysFloor;
			bodyDef.userData.width = 640;
			bodyDef.userData.height = 30;
			addChild(bodyDef.userData);
			
			var polygonShape:b2PolygonShape = new b2PolygonShape();
			polygonShape.SetAsBox(320 / worldScale, 15 / worldScale);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.density = 2;
			fixtureDef.friction = 0.4;
			fixtureDef.restitution = 0.3;
			fixtureDef.shape = polygonShape;
			
			var floor:b2Body = world.CreateBody(bodyDef);
			floor.CreateFixture(fixtureDef);
			floor.SetPosition(new b2Vec2(320 / worldScale, 465 / worldScale))
		}
		
		private function createFace():void
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.userData = new PhysCircle;
			bodyDef.userData.width = 60;
			bodyDef.userData.height = 60;
			addChild(bodyDef.userData);
			
			var circel:b2CircleShape = new b2CircleShape(30 / worldScale);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.density = 2;
			fixtureDef.friction = 0.4;
			fixtureDef.restitution = 0.5;
			fixtureDef.shape = circel;
			
			var face:b2Body = world.CreateBody(bodyDef);
			face.CreateFixture(fixtureDef);
			face.SetPosition(new b2Vec2(320 / worldScale, 50 / worldScale))
		}

		private function onUpdate(event:Event):void
		{
			world.Step(timeStep, velIterations, posIterations);
			world.ClearForces();
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