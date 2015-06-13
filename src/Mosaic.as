package src 
{
	import flash.display.MovieClip;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class Mosaic extends MovieClip 
	{
		
		public function Mosaic() 
		{
			super();
			
			makeGrid();
		}
		
		private function makeGrid():void 
		{
			var auxCounter:Number = 0;
			
			for (var i:Number = 0; i < 3; i++) {//coluna
				for (var j:Number = 0; j < 9; j++) {
					var animate:MosaicRectangle = new MosaicRectangle();
					animate.name = "mosaic" + auxCounter;
					animate.x = -122 + ((j - 1) * 34);
					animate.y = 10+(i*27);
					animate.scaleX = animate.scaleY = 0;
					addChild(animate);
					
					auxCounter++;
					
				}
			}
			
			animateRectangles();
		}
		
		private function animateRectangles():void 
		{
			for (var l:Number = 0; l < 26; l++) {
				
				var randomNumber:Number = Math.random() * 1;
				var randomSize:Number = Math.random() * 2 + 1;
				
				TweenNano.to(this.getChildByName("mosaic" + l), randomNumber, { scaleX:randomSize, scaleY:randomSize, alpha:Math.random()*1+0.2, delay:Math.random() * 1, ease:Bounce.easeOut } );
			}
		}
		
	}

}