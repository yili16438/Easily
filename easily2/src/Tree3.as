package 
{
	import org.easily.com.tips.TextTip;
	import org.easily.com.treectrl.TreeCtrl;
	import org.easily.com.treectrl.TreeItem;
	import org.easily.display.Container;
	
	public class Tree3 extends TreeItem
	{
		public function Tree3(listener:TreeCtrl, hgap:Number=5)
		{
			super(listener, hgap);
			
			body = new Container();
			body.graphics.beginFill(0x0000ff);
			body.graphics.drawRect(0, 0, 60, 20);
			body.graphics.endFill();
			addChild(body);
			
			TextTip.getInstance().bind(this, "tree3");
		}
	}
}