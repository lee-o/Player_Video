package cc.shic 
{
	/**
	 * Collection de méthodes statiques permettant d'effectuer des opération sur des valeurs temporelles
	 * @author david
	 */
	public class UtilsTime
	{
		/**
		 * à partir de seconde retourne une chaine ressemblant à 01:02 où 01 représente des minutes et 02 des secondes.
		 * @param	sec
		 * @return
		 */
		public static function secondsToHumanMinutes(sec:Number):String {
			var d:Date = new Date();
			d.setHours(0);
			d.setMinutes(0);
			d.setSeconds(sec);
			return Utils.withZero(d.minutes) + ":" + Utils.withZero(d.seconds);
		}
		/**
		 * à partir de secondes retourne une chaine ressemblant à 01:59:59
		 * @param	sec
		 * @return
		 */
		public static function secondsToHMS(sec:Number):String {
			var d:Date = new Date();
			d.setHours(0);
			d.setMinutes(0);
			d.setSeconds(sec);
			return Utils.withZero(d.hours) + ":"+Utils.withZero(d.minutes) + ":" + Utils.withZero(d.seconds);
		}
		/**
		 * à partir de millisecondes retourne une chaine ressemblant à 01:02:03,4 où 01 represente des heures, 02 des minutes, 03 des secondes et 4 des millisecondes.
		 * @param	ms
		 * @return
		 */
		public static function msToSrtFormat(ms:Number):String {
			var d:Date = new Date();
			d.setHours(0);
			d.setMinutes(0);
			d.setSeconds(0);
			d.setMilliseconds(ms);
			
			return Utils.withZero(d.hours)+":"+Utils.withZero(d.minutes) + ":" + Utils.withZero(d.seconds)+","+d.milliseconds;
		}
		/**
		 * Transforme 00:00:07,507 en 7507
		 * @param	timeCode 00:00:07,507
		 * @return le temps en millisecondes
		 */
		public static function timeCodeToMs(timeCode:String):int {
				timeCode = Utils.strReplace(timeCode, ",", ":");
				timeCode = Utils.strReplace(timeCode, ".", ":");
				var s:Array = timeCode.split(":");
				
				var ms:int = (Number(s[0]) * 60 * 60 * 1000) + (Number(s[1]) * 60 * 1000) + (Number(s[2]) * 1000) + (Number(s[3]));
				//trace(timeCode+"--->"+ms);
				return ms;
		
		}
		/**
		 * retourne quelque chose qui ressemble à 2011-12-31-23-59-59
		 * @param	d la date à formater
		 * @return	yyyy-mm-dd-hh-MM-SS
		 */
		public static function dateToYYYYMMDDHHMMSS(d:Date):String {
			return d.getFullYear() + "-" + Utils.withZero(d.getMonth() + 1) + "-" + Utils.withZero(d.getDate()) + "-" + Utils.withZero(d.getHours()) + "-" +Utils.withZero(d.getMinutes()) + Utils.withZero(d.getSeconds());
		}
		
		
	}

}