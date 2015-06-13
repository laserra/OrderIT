package src
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import com.leonel.CustomEvent;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class TimerOverlay extends MovieClip
	{
		private var _screenWidth:Number;
		private var _screenHeight:Number;
		private var _timeValue:Number;
		
		private var overlay:Sprite = new Sprite();
		private var timeBar:Sprite = new Sprite();
		private var goStripe:GoStripe = new GoStripe();
		private var goBall:GoBall = new GoBall();
		
		public function TimerOverlay(screenWidth:Number, screenHeight:Number, timeValue:Number):void
		{
			_screenWidth = screenWidth;
			_screenHeight = screenHeight;
			_timeValue = timeValue;
			
			generateOverlay();
		
		}
		
		private function generateOverlay():void
		{
			overlay.graphics.beginFill(0xFFFFFF, 0);
			overlay.graphics.drawRect(0, 0, _screenWidth, _screenHeight);
			overlay.graphics.endFill();
			overlay.scaleX = overlay.scaleY = ((480 * _screenWidth) / 480) / 480;
			addChild(overlay);
			
			generateTimeBar();
		}
		
		private function generateTimeBar():void
		{
			timeBar.alpha = 0;
			timeBar.graphics.beginFill(0xFFFFFF);
			timeBar.graphics.drawRect(0, 0, _screenWidth, 12);
			timeBar.graphics.endFill();
			
			timeBar.scaleX = timeBar.scaleY = ((12 * _screenWidth) / 480) / 12;
			timeBar.y = _screenHeight - (12 * timeBar.scaleX);
			addChild(timeBar);
			
			//animateTimer();
			goBall.x = _screenWidth / 2;
			goBall.y = _screenHeight;
			goBall.scaleX = goBall.scaleY = 0;
			goBall.alpha = 1;
			addChild(goBall);
		
		}
		
		private function animateTimer():void
		{
			timeBar.scaleX = 1;
			timeBar.alpha = 1;
			TweenNano.to(timeBar, _timeValue / 1000, {scaleX: 0, onComplete: showAnimatedGoBall});
		}
		
		private function showAndAnimateGoStripe():void
		{
			goStripe.scaleX = goStripe.scaleY = ((30 * _screenWidth) / 480) / 30;
			
			goStripe.x = -10;
			goStripe.y = _screenHeight - (30 * goStripe.scaleX);
			
			addChild(goStripe);
			
			TweenNano.to(goStripe, 1, {x: (goStripe.width * 2.5), onComplete: timerIsComplete});
		}
		
		private function showAnimatedGoBall():void
		{
			//goBall.scaleX = goBall.scaleY = ((73 * _screenWidth) / 480) / 73;
			
			goBall.scaleX = goBall.scaleY = 0;
			goBall.alpha = 1;
			
			TweenNano.to(goBall, 0.2, {scaleX: 12.5, scaleY: 12.5, onComplete: SecondPartGoBallAnimation});
		}
		
		private function SecondPartGoBallAnimation():void 
		{
			TweenNano.to(goBall, 0.1, {scaleX: 25, scaleY: 25, alpha: 0, onComplete: timerIsComplete});
		}
		
		private function timerIsComplete():void
		{
			dispatchEvent(new CustomEvent(CustomEvent.TIMER_OFF));
		}
		
		public function startTimer():void
		{
			animateTimer();
		}
		
		public function set timeValue(value:Number):void
		{
			_timeValue = value;
		}
	}

}