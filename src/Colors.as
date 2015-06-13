package src 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Colors 
	{
		private var red:Array = [0xE74C3C, 0xFF7364, 0xFF998E, 0xCA2918, 0xA01507];
		private var orange:Array = [0xE7923C, 0xFFB264, 0xFFC78E, 0xCA7218, 0xA05407];
		private var blue:Array = [0x287B8F, 0x418C9E, 0x6DB0C0, 0x12687D, 0x075163];
		private var green:Array = [0x5FC734, 0x7EDB56, 0x9FE881, 0x42AD15, 0x2D8906];
		private var yellow:Array = [0xE7D93C, 0xFFF264, 0xFFF68E, 0xCABB18, 0xA09407];
		private var purple:Array = [0xB9307E, 0xCC5096, 0xDE7BB3, 0xA21364, 0x80064B];
		private var darkblue:Array = [0x2D4471, 0x4E648E, 0x7788AA, 0x152B55, 0x061739];
		private var limegreen:Array = [0x96A537, 0xC0CF67, 0xECF8A5, 0x6E7C15, 0x475300];
		private var darkpink:Array = [0x983352, 0xBE5F7C, 0xE498AF, 0x721330, 0x4C0017];
		private var darkorange:Array = [0xAA7E39, 0xD4AB6A, 0xFFDEAA, 0x805615, 0x553400];
		
		
		public function Colors():void
		{
			
		}
		
		public function returnColorArray(color:String):Array {
			var auxArray:Array=new Array();
			
			switch(color) {
				case "red":
					auxArray = red;
					break;
				case "orange":
					auxArray = orange;
					break;
				case "blue":
					auxArray = blue;
					break;
				case "green":
					auxArray = green;
					break;
				case "yellow":
					auxArray = yellow;
					break;
				case "purple":
					auxArray = purple;
					break;
				case "darkblue":
					auxArray = darkblue;
					break;
				case "limegreen":
					auxArray = limegreen;
					break;
				case "darkpink":
					auxArray = darkpink;
					break;
				case "darkorange":
					auxArray = darkorange;
				default:
					break;
			}
			
			return auxArray;
		}
		
	}

}