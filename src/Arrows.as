package src 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import com.leonel.ParallaxField;
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class Arrows extends MovieClip
	{
		private var parallaxField:ParallaxField;
		
		public function Arrows():void
		{
			
			// create container for our parallax effect
			//mainContainer = new MovieClip();
			//addChild(mainContainer);
			
			parallaxField = new ParallaxField();
			parallaxField.createField(0, -100, 480, 1050, 10, 0, -1.5);
			this.addChild(parallaxField);
			
			parallaxField.disable();
		}
		
		public function flipArrows(value:Number = 0):void {
			
			if (value <= 5) { //ASCENDING ORDER
				parallaxField.rotation = 0;
				parallaxField.x = 0;
				parallaxField.y = 0;
				
			}else {
				parallaxField.rotation = 180;
				parallaxField.x = 480;
				parallaxField.y = 950;
				
			}
		}
		
		public function disableParallax():void {
			parallaxField.disable();
		}
		
		public function enableParallax():void {
			parallaxField.enable();
		}
		
	}

}