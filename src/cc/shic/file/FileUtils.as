package cc.shic.file 
{
	import flash.filesystem.File;
	/**
	 * ...
	 * @author david@shic.fr
	 */
	public class FileUtils
	{
		
		public function FileUtils() 
		{
			
		}
		public static function isFlashImageReadable(file:File):Boolean {
			if (
			String(file.type).toLocaleLowerCase() == ".gif"
			||
			String(file.type).toLocaleLowerCase() == ".jpg"
			||
			String(file.type).toLocaleLowerCase() == ".jpeg"
			||
			String(file.type).toLocaleLowerCase() == ".png"
			) {
				return true;
			}else {
				return false;
			}
		}
		
	}

}