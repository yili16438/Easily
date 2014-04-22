import Box2D.Collision.Shapes.b2CircleShape;
import Box2D.Collision.Shapes.b2PolygonShape;
import Box2D.Common.Math.b2Vec2;
import Box2D.Dynamics.Joints.b2MouseJoint;
import Box2D.Dynamics.Joints.b2MouseJointDef;
import Box2D.Dynamics.Joints.b2RevoluteJoint;
import Box2D.Dynamics.b2Body;
import Box2D.Dynamics.b2BodyDef;
import Box2D.Dynamics.b2DebugDraw;
import Box2D.Dynamics.b2Fixture;
import Box2D.Dynamics.b2FixtureDef;
import Box2D.Dynamics.b2World;

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.MouseEvent;

public static const frameRate:Number = 30;
public static const timeStep:Number = 1.0 / frameRate;
public static const velIterations:int = 10;
public static const posIterations:int = 10;
public static const worldScale:Number = 30;

public static function createRect(world:b2World, type:uint, pos:b2Vec2, size:b2Vec2, density:Number, friction:Number, restitution:Number):b2Body
{
	var bodyDef:b2BodyDef = new b2BodyDef();
	bodyDef.position.Set(pos.x / worldScale, pos.y / worldScale);
	bodyDef.type = type;
	
	var rectDef:b2PolygonShape = new b2PolygonShape();
	rectDef.SetAsBox(size.x / worldScale, size.y / worldScale);
	
	var fixtureDef:b2FixtureDef = new b2FixtureDef();
	fixtureDef.density = density;
	fixtureDef.friction = friction;
	fixtureDef.restitution = restitution;
	fixtureDef.shape = rectDef;
	
	var rect:b2Body = world.CreateBody(bodyDef);
	rect.CreateFixture(fixtureDef);
	return rect;
}

public static function createRect2(world:b2World, type:uint, pos:b2Vec2, size:b2Vec2, offset:b2Vec2, angle:Number, density:Number, friction:Number, restitution:Number):b2Body
{
	var bodyDef:b2BodyDef = new b2BodyDef();
	bodyDef.position.Set(pos.x / worldScale, pos.y / worldScale);
	bodyDef.type = type;
	
	var rectDef:b2PolygonShape = new b2PolygonShape();
	rectDef.SetAsOrientedBox(size.x / worldScale, size.y / worldScale, offset, Math.PI / 180 * angle);
	
	var fixtureDef:b2FixtureDef = new b2FixtureDef();
	fixtureDef.density = density;
	fixtureDef.friction = friction;
	fixtureDef.restitution = restitution;
	fixtureDef.shape = rectDef;
	
	var rect:b2Body = world.CreateBody(bodyDef);
	rect.CreateFixture(fixtureDef);
	return rect;
}

public static function createCircle(world:b2World, type:uint, pos:b2Vec2, radius:Number, density:Number, friction:Number, restitution:Number):b2Body
{
	var bodyDef:b2BodyDef = new b2BodyDef();
	bodyDef.position.Set(pos.x / worldScale, pos.y / worldScale);
	bodyDef.type = type;
	
	var circleDef:b2CircleShape = new b2CircleShape(radius / worldScale);
	
	var fixtureDef:b2FixtureDef = new b2FixtureDef();
	fixtureDef.density = density;
	fixtureDef.friction = friction;
	fixtureDef.restitution = restitution;
	fixtureDef.shape = circleDef;
	
	var circle:b2Body = world.CreateBody(bodyDef);
	circle.CreateFixture(fixtureDef);
	return circle;
}

public static function createDebug(host:Sprite, world:b2World, flags:uint, alpha:Number):void
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

public static function mouseJoint(stage:Stage, world:b2World):void
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

public static function revoluteJoint(world:b2World, bodyA:b2Body, bodyB:b2Body, localAnchorA:b2Vec2, localAnchorB:b2Vec2, enableMotor:Boolean, motorSpeed:Number, maxMotorTorque:Number):b2RevoluteJoint
{
	var rJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
	rJointDef.bodyA = bodyA;
	rJointDef.bodyB = bodyB;
	rJointDef.localAnchorA = localAnchorA;
	rJointDef.localAnchorB = localAnchorB;
	
	if (enableMotor)
	{
		rJointDef.enableMotor = true;
		rJointDef.motorSpeed = motorSpeed;
		rJointDef.maxMotorTorque = maxMotorTorque;
	}
	
	var rJoint:b2RevoluteJoint = world.CreateJoint(rJointDef) as b2RevoluteJoint;
	return rJoint;
}
