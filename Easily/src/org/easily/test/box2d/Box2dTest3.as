package org.easily.test.box2d
{
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import flash.display.*;
	import flash.events.Event;
	
	import org.easily.box2d.b2Utils;
	
	[SWF(width="640", height="480", backgroundColor="0x414647")]
	public class Box2dTest3 extends EasilyBox2D
	{
		private var walker:JansenWalker;
		
		public function Box2dTest3()
		{
			super();
		}
		
		
		protected override function initShapes():void
		{
			//TODO Auto-generated method stub
			super.initShapes();
			
			walker = new JansenWalker(world);
			walker.setPosition(new b2Vec2(150, 350));
		}
	}
}