package src {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import com.leonel.CustomEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class GameOver extends MovieClip
	{
		private var _screenWidth:Number;
		private var _screenHeight:Number;
		
		private var playAgainBt:PlayAgainBt = new PlayAgainBt();
		private var quitBt:ExitBt = new ExitBt();
		private var mainScreenBt:MainScreenBt = new MainScreenBt();
		private var facebookLogo:ShareFacebook = new ShareFacebook();
		
		private var overlay:Sprite = new Sprite();
		private var hiscorelabel:HiscoreLabel = new HiscoreLabel();
		private var scaleFactor:Number;
		private var _scoreValue:Number = 0;
		private var _colorArray:Array = new Array();
		private var buttonsbackgroundColorTransform:ColorTransform = new ColorTransform();
		private var tf:TextFormat = new TextFormat();
		private var mosaic:Mosaic;
		
		public function GameOver(screenWidth:Number, screenHeight:Number, color:Array, newHighScore:Boolean=false, scoreValue:Number=0, _scaleFactor:Number=1):void
		{
			_screenWidth = screenWidth;
			_screenHeight = screenHeight;
			scaleFactor = _scaleFactor;
			_scoreValue = scoreValue
			_colorArray = color;
			
			tf.color = _colorArray[0];
			
			generateOverlay(newHighScore);
		}
		
		private function generateOverlay(newHiScore:Boolean):void
		{
			overlay.graphics.beginFill(0x000000, 0);
			overlay.graphics.drawRect(0, 0, _screenWidth, _screenHeight);
			overlay.graphics.endFill();
			addChild(overlay);
			
			buttonsbackgroundColorTransform.color = _colorArray[3];
			
			generatePlayAgainButton();
			generateMainScreenButton();
			
			generateExitButton();
			
			hiscorelabel.achievement.defaultTextFormat = tf;
			if (newHiScore) {
				hiscorelabel.achievement.text = "NEW HIGH SCORE";
			}else {
				hiscorelabel.achievement.text = "YOUR SCORE";
			}
			
			hiscorelabel.scoreTx.defaultTextFormat = tf;
			hiscorelabel.scoreTx.text = String(_scoreValue);
			placeHiScoreGraphic();
		}
		
		private function generatePlayAgainButton():void 
		{
			playAgainBt.x = _screenWidth / 2;
			playAgainBt.y = _screenHeight / 2;
			playAgainBt.scaleX = playAgainBt.scaleY = ((200 * _screenWidth) / 480) / 200;// scaleFactor;
			
			playAgainBt.background.transform.colorTransform = buttonsbackgroundColorTransform;
			
			addChild(playAgainBt);
			
			playAgainBt.addEventListener(MouseEvent.CLICK, onPlayAgainClick);
		}
		
		private function generateMainScreenButton():void 
		{
			mainScreenBt.x = _screenWidth / 2;
			mainScreenBt.scaleX = mainScreenBt.scaleY = ((200 * _screenWidth) / 480) / 200;// scaleFactor;
			mainScreenBt.y = playAgainBt.y + playAgainBt.height + 20;
			
			mainScreenBt.background.transform.colorTransform = buttonsbackgroundColorTransform;
			
			addChild(mainScreenBt);
			
			mainScreenBt.addEventListener(MouseEvent.CLICK, onMainScreenClick);
		}
		
		private function generateExitButton():void 
		{
			quitBt.x = _screenWidth / 2;
			quitBt.scaleX = quitBt.scaleY = ((200 * _screenWidth) / 480) / 200;// scaleFactor;
			quitBt.y = mainScreenBt.y + mainScreenBt.height + 40;
			
			quitBt.background.transform.colorTransform = buttonsbackgroundColorTransform;
			
			addChild(quitBt);
			
			quitBt.addEventListener(MouseEvent.CLICK, onQuitClick);
		}
		
		private function placeHiScoreGraphic():void 
		{
			animateMosaicRectangles();
			hiscorelabel.x = _screenWidth / 2;
			hiscorelabel.scaleX = hiscorelabel.scaleY = ((231 * _screenWidth) / 480) / 231;// scaleFactor;
			hiscorelabel.y = playAgainBt.y - hiscorelabel.height - 100 * hiscorelabel.scaleX;
			
			//hiscorelabel.highScoreTx.text = String(_scoreValue);
			addChild(hiscorelabel);
			
			mosaic.y = hiscorelabel.y + mosaic.height / 2;
			mosaic.scaleX = mosaic.scaleY = hiscorelabel.scaleX;
			
			
			/*facebookLogo.x = _screenWidth / 2;
			facebookLogo.scaleX = facebookLogo.scaleY = ((232 * _screenWidth) / 480) / 232;// scaleFactor;
			facebookLogo.y = hiscorelabel.y -facebookLogo.height - 50 * facebookLogo.scaleX;
			addChild(facebookLogo);
			facebookLogo.addEventListener(MouseEvent.CLICK, onHiScoreClickToShare);*/
		}
		
		private function animateMosaicRectangles():void 
		{
			mosaic = new Mosaic();
			mosaic.x = _screenWidth / 2;
			//mosaic.y = playAgainBt.y - hiscorelabel.height;// - 100 * hiscorelabel.scaleX;
			//mosaic.y = hiscorelabel.y;
			//mosaic.scaleX = mosaic.scaleY = hiscorelabel.scaleX;// ((306 * _screenWidth) / 480) / 306;
			addChild(mosaic);
		}
		
		private function onHiScoreClickToShare(e:MouseEvent):void 
		{
			dispatchEvent(new CustomEvent(CustomEvent.GAMEOVER_FACEBOOK_SHARE));
		}
		
		private function onMainScreenClick(e:MouseEvent):void 
		{
			dispatchEvent(new CustomEvent(CustomEvent.GAMEOVER_GOTO_MAINSCREEN));
		}
		
		private function onQuitClick(e:MouseEvent):void 
		{
			dispatchEvent(new CustomEvent(CustomEvent.EXIT_APPLICATION));
		}
		
		
		private function onPlayAgainClick(e:MouseEvent):void 
		{
			dispatchEvent(new CustomEvent(CustomEvent.PLAY_AGAIN));
		}
	}

}