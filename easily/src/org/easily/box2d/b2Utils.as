package org.easily.box2d
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2World;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;

	public class b2Utils
	{
		public static function createDebug(host:DisplayObjectContainer, world:b2World, worldScale:Number, flags:uint, alpha:Number):void
		{
			var debug:b2DebugDraw = new b2DebugDraw();
			var sprite:Sprite = new Sprite();
			host.addChild(sprite);
			debug.SetSprite(sprite);
			debug.SetDrawScale(worldScale);
			debug.SetFlags(flags);
			debug.SetFillAlpha(alpha);
			world.SetDebugDraw(debug);
		}
		
		public static function mouseJoint(stage:Stage, world:b2World, worldScale:Number):void
		{
			var mouseJoint:b2MouseJoint;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, createJoint);
			
			function mouseToWorld():b2Vec2
			{
				return new b2Vec2(stage.mouseX / worldScale, stage.mouseY / worldScale);
			}
			
			function createJoint(event:MouseEvent):void
			{
				world.QueryPoint(queryPoint, mouseToWorld());
			}
			
			function queryPoint(fixture:b2Fixture):Boolean
			{
				var clickBody:b2Body = fixture.GetBody();
				if (clickBody.GetType() == b2Body.b2_dynamicBody)
				{
					var jointDef:b2MouseJointDef = new b2MouseJointDef();
					jointDef.bodyA = world.GetGroundBody();
					jointDef.bodyB = clickBody;
					jointDef.target = mouseToWorld();
					jointDef.maxForce = 1000 * clickBody.GetMass();
					mouseJoint = world.CreateJoint(jointDef) as b2MouseJoint;
					stage.addEventListener(MouseEvent.MOUSE_MOVE, moveJoint);
					stage.addEventListener(MouseEvent.MOUSE_UP, killJoint);	
				}
				return false;
			}
			
			function moveJoint(event:MouseEvent):void
			{
				mouseJoint.SetTarget(mouseToWorld());
			}
			
			function killJoint(event:MouseEvent):void
			{
				world.DestroyJoint(mouseJoint);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveJoint);
				stage.removeEventListener(MouseEvent.MOUSE_UP, killJoint);
			}
		}
	}
}