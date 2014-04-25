package org.easily.test.box2d
{
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
			
			var radius:Number = 30;
			var hradius:Number = radius / 2;
			var size:b2Vec2 = new b2Vec2(45, hradius);
			
			var legW:Number = 40;
			var legH:Number = 70;
			var legLen:Number = 50;
			
			var jointLen1:Number = 70;
			var jointLen2:Number = 82;
			
			var leftIndex:Number = -1;
			var rightIndex:Number = -2;
			
			var leftFilter:b2FilterData = new b2FilterData();
			leftFilter.groupIndex = leftIndex;
			
			var rightFilter:b2FilterData = new b2FilterData();
			rightFilter.groupIndex = rightIndex;
			
			//body
			var circle:b2Body = b2Utils.createCircle(world, b2Body.b2_dynamicBody, new b2Vec2, radius, density, friction, resititution);
			var rect:b2Body = b2Utils.createRect(world, b2Body.b2_dynamicBody, new b2Vec2, size, density, friction, resititution);
			b2Utils.revoluteJoint(world, circle, rect, new b2Vec2, new b2Vec2, true, 4, 1000);
			center = circle;
			bodies.push(rect);
			
			var anchor:b2Vec2 = new b2Vec2;
			
			anchor.Set(0, -hradius);
			leftLeg();
			rightLeg();
			
			anchor.Set(Math.cos(Math.PI / 6) * hradius, Math.sin(Math.PI / 6) * hradius);
			leftLeg();
			rightLeg();
			
			anchor.Set(-Math.cos(Math.PI / 6) * hradius, Math.sin(Math.PI / 6) * hradius);
			leftLeg();
			rightLeg();
			
			function leftLeg():void
			{
				var vertices1:Array = [new b2Vec2, new b2Vec2(-legW,0), new b2Vec2(0,-legW)];
				var triangle1:b2Body = b2Utils.createPolygon(world, b2Body.b2_dynamicBody, new b2Vec2(), vertices1, density, friction, resititution);
				triangle1.GetFixtureList().SetFilterData(leftFilter);
				
				var vertices2:Array = [new b2Vec2, new b2Vec2(0,legH), new b2Vec2(-legW,0)];
				var triangle2:b2Body = b2Utils.createPolygon(world, b2Body.b2_dynamicBody, new b2Vec2, vertices2, density, friction, resititution);
				triangle2.GetFixtureList().SetFilterData(leftFilter);
				
				bodies.push(triangle1, triangle2);
				
				//joint
				b2Utils.distanceJoint(world, triangle1, triangle2, new b2Vec2, new b2Vec2, legLen);
				b2Utils.distanceJoint(world, triangle1, triangle2, new b2Vec2(-legW, 0), new b2Vec2(-legW, 0), legLen);
				
				b2Utils.revoluteJoint(world, rect, triangle1, new b2Vec2(-size.x*3/2, 0), new b2Vec2); 
				
				b2Utils.distanceJoint(world, circle, triangle1, anchor, new b2Vec2(0, -legW), jointLen1);
				b2Utils.distanceJoint(world, circle, triangle2, anchor, new b2Vec2, jointLen2);
			}
			function rightLeg():void
			{
				var vertices1:Array = [new b2Vec2, new b2Vec2(0,-legW), new b2Vec2(legW,0)];
				var triangle1:b2Body = b2Utils.createPolygon(world, b2Body.b2_dynamicBody, new b2Vec2(), vertices1, density, friction, resititution);
				triangle1.GetFixtureList().SetFilterData(rightFilter);
				
				var vertices2:Array = [new b2Vec2, new b2Vec2(legW,0), new b2Vec2(0,legH)];
				var triangle2:b2Body = b2Utils.createPolygon(world, b2Body.b2_dynamicBody, new b2Vec2, vertices2, density, friction, resititution);
				triangle2.GetFixtureList().SetFilterData(rightFilter);
				
				bodies.push(triangle1, triangle2);
				
				//joint
				b2Utils.distanceJoint(world, triangle1, triangle2, new b2Vec2, new b2Vec2, legLen);
				b2Utils.distanceJoint(world, triangle1, triangle2, new b2Vec2(legW, 0), new b2Vec2(legW, 0), legLen);
				
				b2Utils.revoluteJoint(world, rect, triangle1, new b2Vec2(size.x*3/2, 0), new b2Vec2); 
				
				b2Utils.distanceJoint(world, circle, triangle1, anchor, new b2Vec2(0, -legW), jointLen1);
				b2Utils.distanceJoint(world, circle, triangle2, anchor, new b2Vec2, jointLen2);
			}
		}
	}
}