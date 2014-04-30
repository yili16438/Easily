package org.easily.test.box2d
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Math;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import org.easily.box2d.b2Utils;

	public class CircleBound
	{
		public var world:b2World;
		
		public function CircleBound(world_:b2World)
		{
			world = world_;
			createBound();
		}
		
		private function createBound():void
		{
			var center:b2Vec2 = new b2Vec2(300 / b2Utils.worldScale, 300 / b2Utils.worldScale);
			var radius:Number = 150 / b2Utils.worldScale;
			var num:int = 20;
			var average:Number = 2 * Math.PI / num;
			var recthw:Number = Math.sin(average / 2) * radius * 1.1;
			var recthh:Number = (radius - Math.cos(average / 2) * radius) / 2;
			var first:b2Vec2 = new b2Vec2(radius, 0);
			var matrix:b2Mat22 = new b2Mat22;
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.position.SetV(center);
			var body:b2Body = world.CreateBody(bodyDef);
			var shape:b2PolygonShape = new b2PolygonShape();
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.density = 2;
			fixtureDef.friction = 0.3;
			fixtureDef.restitution = 0.4;
			fixtureDef.shape = shape;
			
			for (var i:int = 0; i < num; i++)
			{
				var angle:Number = i * average;
				matrix.Set(angle);
				var spos:b2Vec2 = b2Math.MulMV(matrix, first);
				shape.SetAsOrientedBox(recthw, recthh, spos, angle + Math.PI / 2);
				body.CreateFixture(fixtureDef);
			}
		}
	}
}