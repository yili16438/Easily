package org.easily.test.box2d
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.easily.box2d.b2Consts;
	import org.easily.box2d.b2Utils;
	
	public class PolygonShapeTest extends Sprite
	{
		include "../../box2d/b2Common.as";
		
		public var world:b2World;
		
		public function PolygonShapeTest()
		{
			super();
			
			var sleep:Boolean = true;
			var gravity:b2Vec2 = new b2Vec2(0, 9.81);
			world = new b2World(gravity, sleep);
			
			b2Utils.createDebug(this, world, b2Consts.worldScale);
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_staticBody;
			bodyDef.position.Set(p2m(320), p2m(100));
			
			var polygonShape:b2PolygonShape = new b2PolygonShape();
			polygonShape.SetAsBox(p2m(20), p2m(80));
			
			var fixture:b2FixtureDef = new b2FixtureDef();
			fixture.shape = polygonShape;
			
			var body:b2Body = world.CreateBody(bodyDef);
			body.CreateFixture(fixture);
			
			polygonShape.SetAsOrientedBox(p2m(20), p2m(80), new b2Vec2(p2m(0), p2m(30)), Math.PI / 4);
			fixture.shape = polygonShape;
			body.CreateFixture(fixture);
			
			addEventListener(Event.ENTER_FRAME, onUpdate);
		}

		private function onUpdate(event:Event):void
		{
			world.Step(b2Consts.timeStep, b2Consts.velIterations, b2Consts.posIterations);
			world.ClearForces();
			world.DrawDebugData();
		}
	}
}