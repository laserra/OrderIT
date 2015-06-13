package src 
{
	import com.leonel.CustomEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class ContinueGame extends MovieClip 
	{
		private var _screenWidth:Number;
		private var _screenHeight:Number;
		
		private var _lifes:Number;
		
		private var overlay:Sprite = new Sprite();
		private var lifeFeedback:LifeFeedback = new LifeFeedback();
		
		private var backgroundColorTransform:ColorTransform = new ColorTransform();
		
		public function ContinueGame(screenWidth:Number, screenHeight:Number, lifes:Number, color:Array) 
		{
			super();
			
			_screenWidth = screenWidth;
			_screenHeight = screenHeight;
			
			_lifes = lifes;
			
			backgroundColorTransform.color = color[3];
			
			generateOverlay();
			
		}
		
		private function generateOverlay():void 
		{
			overlay.graphics.beginFill(0xFFFFFF, 0.2);
			overlay.graphics.drawRect(0, 0, _screenWidth, _screenHeight);
			overlay.graphics.endFill();
			overlay.scaleX = overlay.scaleY = ((480 * _screenWidth) / 480) / 480;
			addChild(overlay);
			
			addBadge();
		}
		
		private function addBadge():void 
		{
			lifeFeedback.x = _screenWidth / 2;
			lifeFeedback.y = _screenHeight / 2;
			lifeFeedback.scaleX = lifeFeedback.scaleY = ((214 * _screenWidth) / 480) / 214;
			lifeFeedback.lifeMeter.gotoAndStop(_lifes + 1);
			lifeFeedback.continueBt.addEventListener(MouseEvent.CLICK, onContinuePressHandler);
			
			lifeFeedback.lifeBackground.transform.colorTransform = backgroundColorTransform;
			lifeFeedback.continueBt.background.transform.colorTransform = backgroundColorTransform;
			
			addChild(lifeFeedback);
		}
		
		private function onContinuePressHandler(e:MouseEvent):void 
		{
			dispatchEvent(new CustomEvent(CustomEvent.CONTINUE_GAME));
		}
		
	}

}