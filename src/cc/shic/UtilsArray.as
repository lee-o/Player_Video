package cc.shic 
{
	/**
	 * ...
	 * @author david
	 */
	public class UtilsArray 
	{
		/**
		 * Compare deux tableaux. Cette fonction put prendre des vecteurs ou des tableaux en paramètres.
		 * Si les deux sont null retourne true.
		 * Si un des deux est null mais pas l'autre, retourne false.
		 * Si les deux tableaux ne font pas la même longueur, retourne false.
		 * Si toutes les valeurs et l'ordre des valeurs sont identiques retourn true.
		 *
		 * @param	firstOne un Array ou un Vector
		 * @param	secondOne un Array ou un Vector
		 * @return
		 */
		public static function areEqual(firstOne:*, secondOne:*):Boolean {
			if ( (!firstOne && !secondOne) ) {
				return true;
			}
			if ( (!firstOne || !secondOne) ) {
				return false;
			}
			if (firstOne.length != secondOne.length) {
				return false;
			}
			var i:int;
			for (i = 0; i < firstOne.length; i++){
				if (firstOne[i] != secondOne[i]) {
					return false;
				}
			}
			return true;
			
		}
	
	/**
	 * déterminise si needle est dasn haystack
	 * @param	needle
	 * @param	haystack
	 * @param	caseSensitive
	 * @return
	 */
	public static function inArray(needle:*, haystack:Array, caseSensitive:Boolean = true):Boolean {	
		var need:*;
		var hayst:*;
		for (var i:int; i < haystack.length; i++ ) {
				if (caseSensitive==false && haystack[i] is String && needle is String) {
					need = (needle as String).toLowerCase();
					hayst = (haystack[i] as String).toLowerCase();
				}else {
					need = needle;
					hayst = haystack[i];
				}
				if (String(need)==String(hayst)) {
					return true;
				}
		}
		return false;
	}
	
	/**
	 * retourne un élément aléatoire dans le tableau.
	 * @param	ar
	 * @return
	 */
	public static function getRandomInArray(ar:Array,deleteElement:Boolean=false):*{
		if (ar && ar.length > 0) {
			var r:Number = Math.floor(Math.random() * ar.length);
			var ret:*= ar[r];
			if (deleteElement) {
				ar.splice(r, 1);
			}
			return ret;	
		}else {
			return false;
		}
		
	}
		
	}

}