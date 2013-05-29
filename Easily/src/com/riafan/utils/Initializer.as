package com.riafan.utils {
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;	

	/**
	 * 初始化舞台、右键菜单及字体样式
	 * @author Flying
	 * @version 1.0
	 */

	
	public class Initializer {

		/**
		 * 设置舞台
		 * @param owner 初始化容器
		 */

		public static function initStage(owner : DisplayObjectContainer) : void {
			owner.stage.scaleMode = StageScaleMode.NO_SCALE;
		}

		/**
		 * 设置右键菜单
		 * @param owner 初始化容器
		 */

		public static function initContextMenu(owner : DisplayObjectContainer) : void {
			var cm : ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			var email_cmi : ContextMenuItem = new ContextMenuItem("Powered by Flying");
			email_cmi.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, getEmailHandler);
			var site_cmi : ContextMenuItem = new ContextMenuItem("Supported by riafan.com");
			site_cmi.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, getURLHandler);
			cm.customItems.push(email_cmi);
			cm.customItems.push(site_cmi);
			owner.contextMenu = cm;
		}

		/**
		 * 设置Email链接菜单项
		 */

		private static function getEmailHandler(event : ContextMenuEvent) : void {
			navigateToURL(new URLRequest("mailto:jimllf@163.com"), "_self");
		}

		/**
		 * 设置网站链接菜单项
		 */

		private static function getURLHandler(event : ContextMenuEvent) : void {
			navigateToURL(new URLRequest("http://www.riafan.com/"), "_blank");
		}
	}
}