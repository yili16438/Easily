package org.easily.test.box2d
{
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Math;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2World;
	
	import org.easily.box2d.b2Utils;

	public class JansenWalker
	{
		private var world:b2World;
		private var center:b2Body;
		private var bodies:Array = [];
		
		public function JansenWalker(world_:b2World)
		{
			world = world_;
			createWalker();
		}
		
		public function setPosition(pos:b2Vec2):void
		{
			pos = pos.Copy();
			pos.x /= b2Utils.worldScale;
			pos.y /= b2Utils.worldScale;
			
			var offset:b2Vec2 = center.GetPosition().Copy();
			offset.Subtract(pos);
			
			center.SetPosition(pos);
			for each (var body:b2Body in bodies)
			{
				var old:b2Vec2 = body.GetPosition().Copy();
				old.Subtract(offset);
				body.SetPosition(old);
			}
		}
		
		private function createWalker():void
		{
			var density:Number = 2;
			var friction:Number = 0.5;
			var resititution:Number = 0.3;
			
			var radius:Number = 28;
			var size:b2Vec2 = new b2Vec2(45, radius / 2);
			
			var legNum:Number = 3;
			
			var legW:Number = 50;
			var legH:Number = 75;
			var legLen1:Number = 55;
			var legLen2:Number = 55;
			
			var jointLen1:Number = 88;
			var jointLen2:Number = 85;
			
			var bodyIndex:int = -1;
			var legIndex:int = -2;
			
			//motor
			var circle:b2Body = b2Utils.createCircle(world, b2Body.b2_dynamicBody, new b2Vec2, radius, density, friction, resititution, bodyIndex);
			var rect:b2Body = b2Utils.createRect(world, b2Body.b2_dynamicBody, new b2Vec2, size, density, friction, resititution, bodyIndex);
			b2Utils.revoluteJoint(world, circle, rect, new b2Vec2, new b2Vec2, true, -3, 1000);
			center = circle;
			bodies.push(rect);
			
			//legs
			var average:Number = 2 * Math.PI / legNum;
			var anchor:b2Vec2, oriAnchor:b2Vec2 = new b2Vec2(radius * 2 / 3, 0);
			var mat22:b2Mat22 = new b2Mat22();
			for (var i:int = 0; i < legNum; i++)
			{
				mat22.Set(i * average);
				anchor = b2Math.MulMV(mat22, oriAnchor);
				leftLeg();
				rightLeg();
			}
			
			function leftLeg():void
			{
				//up triangle
				var vertices1:Array = [new b2Vec2, new b2Vec2(-legW,0), new b2Vec2(0,-legW)];
				var triangle1:b2Body = b2Utils.createPolygon(world, b2Body.b2_dynamicBody, new b2Vec2(), vertices1, density, friction, resititution, legIndex);
				
				//down triangle
				var vertices2:Array = [new b2Vec2, new b2Vec2(0,legH), new b2Vec2(-legW,0)];
				var triangle2:b2Body = b2Utils.createPolygon(world, b2Body.b2_dynamicBody, new b2Vec2, vertices2, density, friction, resititution, legIndex);
				
				bodies.push(triangle1, triangle2);
				
				//connect triangles
				b2Utils.distanceJoint(world, triangle1, triangle2, new b2Vec2, new b2Vec2, legLen1);
				b2Utils.distanceJoint(world, triangle1, triangle2, new b2Vec2(-legW, 0), new b2Vec2(-legW, 0), legLen2);
				
				//fixed the up
				b2Utils.revoluteJoint(world, rect, triangle1, new b2Vec2(-size.x*3/2, 0), new b2Vec2); 
				
				//join motor
				b2Utils.distanceJoint(world, circle, triangle1, anchor, new b2Vec2(0, -legW), jointLen1);
				b2Utils.distanceJoint(world, circle, triangle2, anchor, new b2Vec2, jointLen2);
			}
			function rightLeg():void
			{
				//up triangle
				var vertices1:Array = [new b2Vec2, new b2Vec2(0,-legW), new b2Vec2(legW,0)];
				var triangle1:b2Body = b2Utils.createPolygon(world, b2Body.b2_dynamicBody, new b2Vec2(), vertices1, density, friction, resititution, legIndex);
				
				//down triangle
				var vertices2:Array = [new b2Vec2, new b2Vec2(legW,0), new b2Vec2(0,legH)];
				var triangle2:b2Body = b2Utils.createPolygon(world, b2Body.b2_dynamicBody, new b2Vec2, vertices2, density, friction, resititution, legIndex);
				
				bodies.push(triangle1, triangle2);
				
				//connect triangles
				b2Utils.distanceJoint(world, triangle1, triangle2, new b2Vec2, new b2Vec2, legLen1);
				b2Utils.distanceJoint(world, triangle1, triangle2, new b2Vec2(legW, 0), new b2Vec2(legW, 0), legLen2);
				
				//fixed the up
				b2Utils.revoluteJoint(world, rect, triangle1, new b2Vec2(size.x*3/2, 0), new b2Vec2); 
				
				//join motor
				b2Utils.distanceJoint(world, circle, triangle1, anchor, new b2Vec2(0, -legW), jointLen1);
				b2Utils.distanceJoint(world, circle, triangle2, anchor, new b2Vec2, jointLen2);
			}
		}
	}
}