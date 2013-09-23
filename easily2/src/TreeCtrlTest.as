package 
{
	import org.easily.com.tips.ToolTip;
	import org.easily.com.treectrl.TreeCtrl;
	import org.easily.display.Container;

	public class TreeCtrlTest extends Container
	{
		public function TreeCtrlTest()
		{
			super();
			
			ToolTip.init(this);
			var root:TreeCtrl = new TreeCtrl();
			root.addSubItem(new Tree1(root));
			root.addSubItem(new Tree1(root));
			root.addSubItem(new Tree1(root));
			root.addSubItem(new Tree1(root));
			addChild(root);
		}
	}
}