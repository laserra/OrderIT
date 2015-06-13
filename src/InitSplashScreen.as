package src 
{
	import flash.display.MovieClip;
	import com.leonel.CustomEvent;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class InitSplashScreen extends MovieClip
	{
		//private var splashScreen:SplashScreen = new SplashScreen();
		
		private var _screenWidth:Number;
		private var _screenHeight:Number;
		
		private var overlay:Shape = new Shape();
		private var bigArrows:BigArrows = new BigArrows();
		private var playBt:InitPlay = new InitPlay();
		private var optionsBt:OptionsBt = new OptionsBt();
		private var rulesBt:InstructionsBt = new InstructionsBt();
		
		public function InitSplashScreen(screenWidth:Number, screenHeight:Number):void
		{
			_screenWidth = screenWidth;
			_screenHeight = screenHeight;
			
			generateOverlay()
		}
		
		private function generateOverlay():void 
		{
			//trace("SIMPLE OVERLAY: "+_screenWidth+"//"+_screenHeight);
			overlay.graphics.beginFill(0xE74C3C, 1);
			overlay.graphics.drawRect(0, 0, _screenWidth, _screenHeight);
			overlay.graphics.endFill();
			overlay.cacheAsBitmap = true;
			addChild(overlay);
			
			//bigArrows.y = -40;
			bigArrows.x = _screenWidth / 2;
			bigArrows.scaleX = bigArrows.scaleY = ((387 * _screenWidth) / 480) / 387;
			addChild(bigArrows);
			
			playBt.x = _screenWidth / 2;
			playBt.scaleX = playBt.scaleY = ((200 * _screenWidth) / 480) / 200;
			playBt.y = _screenHeight / 2 + 100 * (((200 * _screenHeight) / 850) / 200); // - (2 * playBt.height + 20);
			addChild(playBt);
			
			optionsBt.x = _screenWidth / 2;
			optionsBt.scaleX = optionsBt.scaleY = ((200 * _screenWidth) / 480) / 200;
			optionsBt.y = playBt.y + playBt.height + 10;// _screenHeight - (optionsBt.height);
			addChild(optionsBt);
			
			rulesBt.x = _screenWidth / 2;
			rulesBt.scaleX = rulesBt.scaleY = ((200 * _screenWidth) / 480) / 200;
			rulesBt.y = optionsBt.y + optionsBt.height + 10;//_screenHeight - (optionsBt.height);
			addChild(rulesBt);
			
			
			addEvents();
		}
		
		private function addEvents():void 
		{
			playBt.addEventListener(MouseEvent.CLICK, onInitPlayClickHandler);
			optionsBt.addEventListener(MouseEvent.CLICK, onInitOptionsClickHandler);
			rulesBt.addEventListener(MouseEvent.CLICK, onInitRulesClickHandler);
		}
		
		
		
		private function removeEvents():void 
		{
			playBt.removeEventListener(MouseEvent.CLICK, onInitPlayClickHandler);
			optionsBt.removeEventListener(MouseEvent.CLICK, onInitOptionsClickHandler);
			rulesBt.removeEventListener(MouseEvent.CLICK, onInitRulesClickHandler);
		}
		
		private function onInitRulesClickHandler(e:MouseEvent):void 
		{
			removeEvents();
			dispatchEvent(new CustomEvent(CustomEvent.SPLASH_RULES));
		}
		
		private function onInitOptionsClickHandler(e:MouseEvent):void 
		{
			removeEvents();
			dispatchEvent(new CustomEvent(CustomEvent.SPLASH_OPTIONS));
		}
		
		private function onInitPlayClickHandler(e:MouseEvent):void 
		{
			removeEvents();
			dispatchEvent(new CustomEvent(CustomEvent.SPLASH_PLAY));
		}
		
	}

}