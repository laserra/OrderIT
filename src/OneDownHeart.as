package src 
{
	import flash.display.MovieClip;
	
	import com.greensock.*; 
	import com.greensock.easing.*;
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class OneDownHeart extends MovieClip 
	{
		private var _screenWidth:Number;
		private var _screenHeight:Number;
		private var _rectWidth:Number;
		
		private var oneDownAnim:OneDownAnim = new OneDownAnim();
		
		public function OneDownHeart(screenWidth:Number, screenHeight:Number, rectWidth:Number) 
		{
			super();
			
			_screenWidth = screenWidth;
			_screenHeight = screenHeight;
			_rectWidth = rectWidth;
			
			addOneDownAnim();
		}
		
		private function addOneDownAnim():void 
		{
			//oneDownAnim.scaleX = oneDownAnim.scaleY = ((30 * _screenWidth) / 480) / 30;
			oneDownAnim.width = oneDownAnim.height = _rectWidth/2;
			oneDownAnim.alpha = 0;
			addChild(oneDownAnim);
		}
		
		public function playOneDownAnim():void {
			oneDownAnim.alpha = 1;
			TweenNano.to(oneDownAnim, 1, { scaleX:0, scaleY:0, y:oneDownAnim.y - (50 * oneDownAnim.scaleY), alpha:0, onComplete:resetYPos } );
		}
		
		private function resetYPos():void {
			oneDownAnim.y = 0;
			oneDownAnim.alpha = 0;
		}
	}

}