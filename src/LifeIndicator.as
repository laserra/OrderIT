package src 
{
	import flash.display.MovieClip;
	
	import com.greensock.*;
	import com.greensock.events.*;
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class LifeIndicator extends MovieClip 
	{
		private var _screenWidth:Number;
		private var _screenHeight:Number;
		
		private var heartsIndicator:OneUp = new OneUp();
		private var hearts:Number = 4;
		
		public function LifeIndicator(screenWidth:Number, screenHeight:Number):void
		{
			super();
			
			_screenWidth = screenWidth;
			_screenHeight = screenHeight;
			
			heartsIndicator.scaleX = heartsIndicator.scaleY = ((104 * _screenWidth) / 480) / 104;
			heartsIndicator.x = _screenWidth / 2;
			heartsIndicator.y = 8 * heartsIndicator.scaleY;
			heartsIndicator.gotoAndStop(hearts);
			addChild(heartsIndicator);
		}
		
		public function decreaseLife():void {
			hearts--;
			
			if (hearts >= 0) {
				heartsIndicator.gotoAndStop(hearts);
			}else {
				hearts = 0;
			}
		}
		
		public function increaseLife():void {
			hearts++;
			if (hearts <= 4) {
				heartsIndicator.gotoAndStop(hearts);
				TweenMax.fromTo(heartsIndicator, .2, { colorMatrixFilter: { amount:0 }}, { colorMatrixFilter: { colorize:0xff0000, amount:1 }, repeat:3, yoyo:true } );
			}else {
				hearts = 4;
			}
		}
		
		public function reset():void {
			hearts = 4;
			heartsIndicator.gotoAndStop(hearts);
		}
		
		public function hide():void {
			heartsIndicator.visible = false;
		}
		
		public function show():void {
			heartsIndicator.visible = true;
		}
		
	}

}