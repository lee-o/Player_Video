package cc.shic.ui.contextMenu.item 
{
	import cc.shic.Utils;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenuItem;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author david
	 */
	public class CommonsContextMenuItem
	{
		private static var itemsUrl:Dictionary=new Dictionary(true);
		private static var itemsUrlTarget:Dictionary=new Dictionary(true);
		
		/**
		 * renvoie un ContextMenuItem qui permet de gérer un lien
		 * @param	caption cation sur le context menu
		 * @param	url à ouvrir
		 * @param	target nom de la fenetre html à ouvrir
		 * @return
		 */
		public static function getUrlItem(caption:String,url:String,target:String="_blank"):ContextMenuItem 
		{
			var item:ContextMenuItem = new ContextMenuItem(caption);
			itemsUrl[item] = url;
			itemsUrlTarget[item] = target;
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, getUrl);
			
			return item;
			
		}
		
		private static function getUrl(e:ContextMenuEvent):void 
		{
			Utils.getUrl(itemsUrl[e.target],itemsUrlTarget[e.target]);
		}
		
		
	}

}