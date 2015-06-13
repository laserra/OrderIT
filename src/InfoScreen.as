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
	public class InfoScreen extends MovieClip 
	{
		private var _screenWidth:Number;
		private var _screenHeight:Number;
		
		private var infoScreen:InfoRulesScreen = new InfoRulesScreen();
		
		private var overlay:Sprite = new Sprite();
		private var backgroundColorTransform:ColorTransform = new ColorTransform();
		
		public function InfoScreen(screenWidth:Number, screenHeight:Number, info:Number, color:Array) 
		{
			super();
			
			_screenWidth = screenWidth;
			_screenHeight = screenHeight;
			
			backgroundColorTransform.color = color[3];
			
			generateOverlay(info);
		}
		
		private function generateOverlay(info:Number):void
		{
			overlay.graphics.beginFill(0xFFFFFF, 0.2);
			overlay.graphics.drawRect(0, 0, _screenWidth, _screenHeight);
			overlay.graphics.endFill();
			overlay.scaleX = overlay.scaleY = ((480 * _screenWidth) / 480) / 480;
			addChild(overlay);
			
			addRules(info);
		}
		
		public function addRules(info:Number):void 
		{
			infoScreen.x = _screenWidth / 2;
			infoScreen.y = _screenHeight / 2;
			infoScreen.scaleX = infoScreen.scaleY = ((275 * _screenWidth) / 480) / 275;
			infoScreen.gotoAndStop(info);
			infoScreen.okBt.addEventListener(MouseEvent.CLICK, onOkClickHandler);
			
			infoScreen.infoBackground.transform.colorTransform = backgroundColorTransform;
			infoScreen.okBt.background.transform.colorTransform = backgroundColorTransform;
			
			addChild(infoScreen);
			
		}
		
		private function onOkClickHandler(e:MouseEvent):void 
		{
			dispatchEvent(new CustomEvent(CustomEvent.INFO_OK));
		}
		
		
		
		
	}

}