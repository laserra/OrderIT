package src {
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Background extends MovieClip 
	{
		
		private var background:BackgroundColor = new BackgroundColor();
		
		public function Background():void {
			//background.alpha = 0;
			addChild(background);
		}
		
		public function changeBackgroundColor(color:Number):void {
			var backgroundColorTransform:ColorTransform = new ColorTransform();
			backgroundColorTransform.color = color;
			background.transform.colorTransform = backgroundColorTransform;
		}
	}
	
}