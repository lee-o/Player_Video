package cc.shic 
{
	import cc.shic.display.text.TexfieldMultiline;
	import cc.shic.ui.Alert;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author david@shic.fr
	 */
	public class Utils
	{
		/**
		 * variable définissant stage, il convient avant d'uiliser cette classe de définir stage
		 */
		public static var stage:Stage;
		static private var flashVars:Dictionary=new Dictionary();
		static private var flashVarsComments:Dictionary=new Dictionary();
		static private var traceField:TexfieldMultiline;
		
		public function Utils() 
		{
			
		}
		public static function alert(message:String):void {
			var window:Alert = new Alert(message, stage.stageWidth, stage.stageHeight);
			stage.addChild(window);
		}
		
			/**
	 * renvoie le résultat d'un produit
	 * @param	valeur	valeur d'entrée
	 * @param	maxentree	valeur maximale de la valeur d'entrée
	 * @param	maxsortie	valeur maximale de la valeur de sortie
	 * @param	minentree	valeur minimale de la valeur d'entrée
	 * @param	minsortie	valeur minimale de la valeur de sortie
	 * @return	le résultat du produit
	 */
	public static function rapport (valeur:Number,maxentree:Number, maxsortie:Number, minentree:Number, minsortie:Number):Number {
		var produitentree:Number = (valeur-minentree)/(maxentree-minentree);
		var valeursortie:Number = ((maxsortie-minsortie)*produitentree)+minsortie;
		return valeursortie;
	}
	/**
	 * renvoie l'arrondi d'un nombre.<br>
	 * floorAt(5.684, 0.1) retournera 5.7
	 * @param	number
	 * @param	roundLevel
	 * @return
	 */
	public static function roundAt(number:Number, roundLevel:Number):Number {
		var divisor:Number = (1 / roundLevel)
		var multiplicated:int = Math.round(number * divisor)
		var result:Number = multiplicated * roundLevel;
		return debugDecimal(result);
	}
	/**
	 * renvoie le plancher d'un nombre.<br>
	 * floorAt(5.684, 0.1) retournera 5.6
	 * @param	number
	 * @param	roundLevel
	 * @return
	 */
	public static function floorAt(number:Number, roundLevel:Number):Number {
		var divisor:Number = (1 / roundLevel)
		var multiplicated:int = Math.floor(number * divisor)
		var result:Number = multiplicated * roundLevel;
		return debugDecimal(result);

	}
	/**
	 * Il peut arriver que flash génere des bugs dans ses opération de multiplication et divisions en produisant des valeurs de type 5.000000000000001 alors que 5 est attendu. Cette fonction renvoie la valeur à la 10ème décimale évitant ainsi ce bug.
	 * @param	num
	 */
	public static function debugDecimal(num:Number):Number {
		var tab:Array = String(num).split(".");
		if (!tab[0]) {
			return num;
		}
		if (!tab[1]) {
			return tab[0];
		}
		return  Number(tab[0]+"."+tab[1].substring(0,10));
	}
	/**
	 * si valeur > max, retournera max, <br/>
	 * si valeur < min, retournera min, <br/>
	 * sinon retournera valeur inchangé.
	 * @param	valeur valeur d'entrée qui sera vérifiée.
	 * @param	min	valeur minimale de sortie.
	 * @param	max	valeur maximale de sortie.
	 * @return	valeur où valeur >=min && valeur <=max
	 */
	public static function limites(valeur:Number,min:Number,max:Number):Number {
		if (valeur < min) {
			valeur = min;
		}else if (valeur>max) {
			valeur = max;
		}
		return valeur;
	}
	/**
	 * retourne un boléen à partir d'une chaine.<br/>
	 * Si str == "false" ou "FALSE" ou "" retourne le booléen false dans tous les autres cas, retourne true
	 * @param	str
	 * @return
	 */
	public static function getBool (str:String):Boolean {
		if (str=="FALSE" || str=="false" || str=="") {
			return false;
		} else {
			return true;
		}
	}
	/**
	 * retourne un number à partir d'une boolean.<br/>
	 * Si bool == true retourne le nombre 1 dans tous les autres cas
	 * @param	str
	 * @return
	 */
	public static function getNumber (bool:Boolean):uint {
		if (bool) {
			return 1;
		} else {
			return 0;
		}
	}
	/**
	 * dessine le contenu d'un DisplayObjectContainer sous la forme de bitmapData, attache l bitmap obtenu et vide le displayObject de tout ce qu'il contenait précedement.
	 * @param	display
	 */
	public static function sprite2Bmp (display:DisplayObjectContainer):void {
		var bmpd:BitmapData = new BitmapData(display.getBounds(display).width + display.getBounds(display).x, display.getBounds(display).height + display.getBounds(display).y, true, 0x00ff00);
		bmpd.draw (display);
		var bmp:Bitmap = new Bitmap(bmpd,"auto", true);
		removeAllChilds(display);
		display.addChild (bmp);
	}
	/**
	 * dans une chaine contenant des / retournera le dernier élément derière le dernier /
	 * @param	url
	 * @return
	 */
	public static function getNomFichier (url:String) :String{
		var url_array:Array=url.split("/");
		return url_array[url_array.length - 1];
	}
	

	/**
	 * Remplace needle par haystack dans le chaine str et retourne la chaine modifiée.
	 * @param	str
	 * @param	needle
	 * @param	haystack
	 * @return
	 */
	public static function strReplace(str:String, needle:String, haystack:String):String {
		return str.split(needle).join(haystack);
	};
	/**
	 * Remplace les balises BR par des sauts de ligne classiques.
	 * @param	str
	 * @return
	 */
	public static function br2nl(str:String):String {
		str = Utils.strReplace(str, "<br/>", "\n");
		str = Utils.strReplace(str, "<br>", "\n");
		return str;
	}
	
	/**
	 * Renvoie un texte non html.
	 * @param	str
	 * @return
	 */
	public static function html2Text(str:String):String {
		var temp:TextField = new TextField();
		temp.htmlText = str
		var str:String = temp.text
		temp = null;
		return str;
	}
	/**
	 * Retourne un bitmap data d'un display object aux positions et tailles indiquées par rectangle
	 * @param	clip
	 * @param	rectangle
	 * @param	transparent
	 * @param	color
	 * @return
	 */
	
	public static function getBitmapDataAtRect(clip:DisplayObject, rectangle:Rectangle,transparent:Boolean=false,color:uint=0xff0000):BitmapData {
		
		var BMPD:BitmapData = new BitmapData(rectangle.width, rectangle.height, transparent, color);
		
		var matrix:Matrix = new Matrix(1, 0, 0, 1, -rectangle.width, -rectangle.height);
		BMPD.draw(clip,matrix);
		matrix = null;		
		return BMPD;
	}
	/**
	 * definit interactiveObject sur mouseEnabled=true buttonMode=true MouseChildren=false
	 * @param	interactiveObject
	 */
	public static function setAsBouton(interactiveObject:InteractiveObject):void {
		interactiveObject.mouseEnabled = true;
		(interactiveObject as Sprite).buttonMode = true;
		if(interactiveObject is DisplayObjectContainer){
		(interactiveObject as DisplayObjectContainer).mouseChildren = false;
		}
	}
	/**
	 * applique la propriété smoothing a tous les bitmaps descendant de l'objet indiqué
	 * @param	container un displayObject sur le quel sera appliqué le smoothing (ou non) ainsi qu'à tous ces descendants
	 * @param	smooth si true les bitmaps sont smooth, si false, les bitmaps sont pixel
	 */
	public static function smoothRecursive(container:DisplayObject,smooth:Boolean=true):void {
		var i:uint = 0;
		if (container is Bitmap) {
			(container as Bitmap).smoothing = smooth;
		}else if (container is DisplayObjectContainer) {
			for (i = 0; i < (container as DisplayObjectContainer).numChildren; i++) {
				Utils.smoothRecursive((container as DisplayObjectContainer).getChildAt(i),smooth);
			}
		}
	}
	
	/**
	 * Ouvre url dans la fenêtre navigateur target
	 * @param	url 
	 * @param	target _blank, _self, _parent, ou un nom de fenêtre navigateur personalisé
	 */
	public static function getUrl(url:String, target:String = "_blank"):void {
		if (stage && stage.displayState == StageDisplayState.FULL_SCREEN) {
			stage.displayState = StageDisplayState.NORMAL;
		}
		navigateToURL(new URLRequest(url), target);
	}
	
	/**
	 * retourne la valeur d'une variable du LoaderInfo, ou la valeur par défaut spécifiée.
	 * @param	varName nom de la variable qui doit être passée au swf.
	 * @param	defaultValue valeur par défaut si la variable n'a pas été transmise au swf.
	 * @param	associatedComment commentaire que l'on peut associer à la flash var et qui sera réuitilisé lors de l'appel à requestedFlashVarsGet.
	 * @see		requestedFlashVarsGet.
	 * @return
	 */
	static public function flashVarsGet(varName:String, defaultValue:String = "",associatedComment:String=""):String
	{
		if ( stage == null ) defaultValue;
		
		var res:String = stage.loaderInfo.parameters[varName] as String;
		
		if ( res == "undefined" || res == "null" || res == null )
		{
			flashVars[varName] = defaultValue;
			flashVarsComments[varName] = associatedComment;
			return defaultValue;
		}
		else
		{
			if ( res == "" ) { 
				flashVars[varName] = defaultValue;
				flashVarsComments[varName] = associatedComment;
				return defaultValue;	
			}
			else {
				flashVars[varName] = res;
				flashVarsComments[varName] = associatedComment;
				return res;	
			}
		}
	}
	/**
	 * Pour une bonne entente entre développeurs HTML et Flash...
	 * Retourne la liste une représentation texte des flash vars qui ont été réclamées par la méthode flashVarsGet ansi que la valeur qui a été retournée.
	 * @return
	 */
	static public function  get requestedFlashVarsGet():String {
		
		
		var retour:String = "\n/*---flash vars---*/\n";
		for (var i:String in flashVars) {
			retour+= i + " = '" + flashVars[i] + "';"+(flashVarsComments[i]!=""?" //"+flashVarsComments[i]:"")+" \n";
		}
		retour+= "/*----------------*/\n";
		return retour;
	}
	
	
	/**
	 * retourne 09 si on lui fournit 9, retourne 0009 si on lui fournit 9,4
	 * @param	n	le nombre auquel il faut rajouter des zéros initiaux
	 * @param	length le nombre de caractères attendus
	 * @return
	 */
	public static function withZero(n:int, length:Number = 2):String {
		var r:String = String(n);
		while (r.length < length) {
			r = "0" + r;
		}
		return r;
	}
	
	public static function random2(min:Number, max:Number):Number {
		return Math.round(Math.random()*(max-min)+min);
	}


	/**
	 * Enlève tous les enfants contenus dans le container c
	 * @param	c le container qui se verra retirer tous ses enfants.
	 */
	public static function removeAllChilds(c:DisplayObjectContainer):void {
		while (c.numChildren > 0) {
			c.removeChildAt(0);
		}
	}
	
	public static function trim(str:String):String {
		while (str.slice(0, 1) == " ") {
			str=str.slice(1, str.length)
		}
		while (str.slice(str.length-1, str.length) == " ") {
			str=str.slice(0, str.length-1)
		}
		return str;
	}
	public static function traceDebug(text:String):void {
		if(ShicConfig.debug){
			trace(text);
			if (stage) {
				if (!traceField) {
					traceField = new TexfieldMultiline();
					traceField.blendMode = BlendMode.INVERT;
					traceField.mouseEnabled = false;
					traceField.x = 0;
					traceField.y = 0;
					
				}
				stage.addChild(traceField);
				traceField.width = stage.stageWidth;
				traceField.text = "\n"+traceField.text;
				traceField.text = text+traceField.text;	
			}
		}
	}

}
}