package src 
{
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class ConnectionFeedback extends MovieClip 
	{
		
		private var _screenWidth:Number;
		private var _screenHeight:Number;
		private var _color:Number;
		
		private var buttonsbackgroundColorTransform:ColorTransform = new ColorTransform();
		private var overlay:Sprite = new Sprite();
		
		private var networkToast:NetworkFeedback = new NetworkFeedback();
		
		public function ConnectionFeedback(screenWidth:Number, screenHeight:Number) 
		{
			super();
			
			_screenWidth = screenWidth;
			_screenHeight = screenHeight;
			
			generateOverlay();
			
			
		}
		
		public function setMessageType(_type:Number = 0):void {
			switch(_type) {
				case 0: //CHECK INTENET CONNECTION
					networkToast.messageTx.text = "Verifying\nconnection...";
					break;
				case 1: //SEND VALUES ONLINE
					networkToast.messageTx.text = "You're\nconnected...";
					break;
				case 2: //NO CONNECTION
					networkToast.messageTx.text = "Please check\nyour connection";
					break;
				case 3: //CONNECTION ACTIVE
					networkToast.messageTx.text = "Connection\nactive...";
					break;
				default:
					break;
			}
			
			addToaster();
		}
		
		private function addToaster():void 
		{
			networkToast.scaleX = networkToast.scaleY = ((285 * _screenWidth) / 480) / 285;
			networkToast.x = _screenWidth / 2;
			networkToast.y = _screenHeight / 2;
			addChild(networkToast);
		}
		
		private function generateOverlay():void
		{
			overlay.graphics.beginFill(0xFFFFFF, 0.2);
			overlay.graphics.drawRect(0, 0, _screenWidth, _screenHeight);
			overlay.graphics.endFill();
			overlay.scaleX = overlay.scaleY = ((285 * _screenWidth) / 480) / 285;
			addChild(overlay);
			
			//buttonsbackgroundColorTransform.color = _color;
			
		}
	}

}