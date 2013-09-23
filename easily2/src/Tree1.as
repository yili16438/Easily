package 
{
	import org.easily.com.treectrl.TreeCtrl;
	import org.easily.com.treectrl.TreeItem;
	import org.easily.display.Container;
	
	public class Tree1 extends TreeItem
	{
		public function Tree1(listener:TreeCtrl, hgap:Number=5)
		{
			super(listener, hgap);
			
			body = new Container();
			body.graphics.beginFill(0xff0000);
			body.graphics.drawRect(0, 0, 100, 20);
			body.graphics.endFill();
			addChild(body);
			subTree.y = body.height + hgap;
			
			addSubItem(new Tree2(subTree));
		}
	}
}