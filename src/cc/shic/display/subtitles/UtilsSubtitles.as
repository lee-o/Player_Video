package cc.shic.display.subtitles 
{
	import cc.shic.display.text.InternationalTextField;
	import cc.shic.Utils;
	import cc.shic.UtilsTime;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author david
	 */
	public class UtilsSubtitles 
	{
		/**
		 * Retourne une série de sous titres sous le format subrib (.srt)
		 * @param	subtitles
		 * @param	rtl si le sous titre est en arabe ou en hébreu, il est conseillé de mettre ce paramètre sur true.
		 * @return la chaine retournée ressemble à des items sous la forme suivante:
		 * 1
		 * 01:02:03,999 --> 01:02:05,999
		 * texte1
		 * 
		 * 2
		 * 01:02:06,999 --> 01:02:09,999
		 * texte2
		 */
		public static function getSrtFormat(subtitles:Vector.<SubtitleItem>,rtl:Boolean=false):String
		{

			var count:int = 1;
			var r:String = "";
			var t:String;
			for (var i:int = 0; i < subtitles.length; i++) {
				if (subtitles[i].type == "subtitle") {
					t = Utils.trim(subtitles[i].text);
					r +=String(count++)+"\n";
					r += (UtilsTime.msToSrtFormat(subtitles[i].start) + " --> " + UtilsTime.msToSrtFormat(subtitles[i].stop)) + "\n";
					if(rtl){
						switch (t.slice(t.length-1,t.length)) {
							case ".":
							case ":":
							case "?":
							case "!":
							case "،":
							t = t.slice(t.length - 1, t.length) + t.slice(0, t.length - 1);
							break;
							
							default:
							
						}
					}
					r += t+"\n";
					//r += tf.(subtitles[i].text, 3000, new TextFormat()) +"\n";
					r+="\n";
				}
			}
			return r;
		}
		
	}

}