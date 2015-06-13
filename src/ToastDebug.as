package src 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import com.leonel.CustomEvent;
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class ToastDebug extends MovieClip 
	{
		private var _screenWidth:Number;
		private var _screenHeight:Number;
		
		private var toast:Toast = new Toast();
		private var closeBt:ToastClose = new ToastClose();
		
		public function ToastDebug(screenWidth:Number, screenHeight:Number) 
		{
			super();
			
			_screenWidth = screenWidth;
			_screenHeight = screenHeight;
			
			addToast();
			addCloseBt();
		}
		
		private function addCloseBt():void 
		{
			toast.x = _screenWidth / 2;
			toast.y = _screenHeight / 2;
			toast.scaleX = toast.scaleY = ((460 * _screenWidth) / 480) / 460;
			addChild(toast);
			
		}
		
		private function addToast():void 
		{
			closeBt.x = _screenWidth / 2;
			closeBt.y = toast.height;
			addChild(closeBt);
			
			closeBt.addEventListener(MouseEvent.CLICK, onCloseToastButtonHandler);
		}
		
		private function onCloseToastButtonHandler(e:MouseEvent):void 
		{
			dispatchEvent(new CustomEvent(CustomEvent.TOAST_CLOSE));
		}
		
		public function addToTheMessage(_message:String):void {
			toast.toastMsg.appendText(_message + "\n");
		}
		
	}

}