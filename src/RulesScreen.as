package src 
{
	import adobe.utils.CustomActions;
	import flash.display.MovieClip;
	import com.leonel.CustomEvent;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.events.TransformGestureEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import com.greensock.*; 
	import com.greensock.easing.*;
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class RulesScreen extends MovieClip 
	{
		private var _screenWidth:Number;
		private var _screenHeight:Number;
		
		private var overlay:Shape = new Shape();
		
		private var rulesText:RulesText = new RulesText();
		
		private var goBackBt:GoBack = new GoBack();
		private var currentPosition:Number = 0;
		
		public function RulesScreen(screenWidth:Number, screenHeight:Number):void
		{
			super();
			
			_screenWidth = screenWidth;
			_screenHeight = screenHeight;
			
			generateOverlay();
			
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			
			addSwipeEvent();
			
		}
		
		private function addSwipeEvent():void 
		{
			this.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
		}
		
		private function generateOverlay():void 
		{
			overlay.graphics.beginFill(0xE74C3C, 1);
			overlay.graphics.drawRect(0, 0, _screenWidth, _screenHeight);
			overlay.graphics.endFill();
			overlay.cacheAsBitmap = true;
			addChild(overlay);
			
			rulesText.x = _screenWidth / 2;
			rulesText.indicator.gotoAndStop(1);
			rulesText.scaleX = rulesText.scaleY = ((324 * _screenWidth) / 480) / 324;
			addChild(rulesText);
			
			goBackBt.x = _screenWidth / 2;
			goBackBt.y = _screenHeight - (2 * goBackBt.height);
			goBackBt.scaleX = goBackBt.scaleY = ((200 * _screenWidth) / 480) / 200;
			addChild(goBackBt);
			
			goBackBt.addEventListener(MouseEvent.CLICK, onGoBackClickHandler);
		}
		
		private function onSwipe(e:TransformGestureEvent):void 
		{
			var swipeScale:Number = ((156 * _screenWidth) / 480) / 156;
			if (e.offsetX == 1) { 
				//GO RIGHT
				if (checkRightSwipePosition()) {
					stage.removeEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
					TweenNano.to(rulesText.rulesScroll, 0.5, { x: (rulesText.rulesScroll.x + 478), onComplete:addSwipeEvent } );
				}
			 }
			 else if (e.offsetX == -1) { 
				//GO LEFT
				if (checkLeftSwipePosition()) {
					stage.removeEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
					TweenNano.to(rulesText.rulesScroll, 0.5, { x: (rulesText.rulesScroll.x - 478), onComplete:addSwipeEvent } );
				}	
			 }
			 
			 rulesText.indicator.gotoAndStop(currentPosition+1);
			 
		}
		
		private function checkRightSwipePosition():Boolean 
		{
			var returnResult:Boolean = true;
			
			if ((currentPosition - 1) >= 0) {
				currentPosition--;
				returnResult = true;
			}else {
				returnResult = false;
			}
			
			return returnResult;
		}
		
		private function checkLeftSwipePosition():Boolean 
		{
			var returnResult:Boolean = true;
			
			if ((currentPosition + 1) < 3) {
				currentPosition++;
				returnResult = true;
			}else {
				returnResult = false;
			}
			
			return returnResult;
		}
		
		private function onGoBackClickHandler(e:MouseEvent):void 
		{
			stage.removeEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
			dispatchEvent(new CustomEvent(CustomEvent.RULES_GO_BACK));
		}
	}

}