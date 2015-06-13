package src {
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class SimpleOverlay extends Sprite 
	{
		private var _screenWidth:Number;
		private var _screenHeight:Number;
		
		private var overlay:Shape = new Shape();
		
		public function SimpleOverlay(screenWidth:Number, screenHeight:Number):void {
			_screenWidth = screenWidth;
			_screenHeight = screenHeight;
			
			generateOverlay();
		}
		
		private function generateOverlay():void 
		{
			//trace("SIMPLE OVERLAY: "+_screenWidth+"//"+_screenHeight);
			overlay.graphics.beginFill(0x000000, 0);
			overlay.graphics.drawRect(0, 0, _screenWidth, _screenHeight);
			overlay.graphics.endFill();
			overlay.cacheAsBitmap = true;
			addChild(overlay);
		}
	}
	
}