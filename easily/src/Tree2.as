package 
{
	import org.easily.com.treectrl.TreeCtrl;
	import org.easily.com.treectrl.TreeItem;
	import org.easily.display.Container;
	
	public class Tree2 extends TreeItem
	{
		public function Tree2(listener:TreeCtrl, hgap:Number=5)
		{
			super(listener, hgap);
			
			body = new Container();
			body.graphics.beginFill(0x00ff00);
			body.graphics.drawRect(0, 0, 80, 20);
			body.graphics.endFill();
			addChild(body);
			subTree.y = body.height + hgap;
			
			addSubItem(new Tree3(subTree));
		}
	}
}