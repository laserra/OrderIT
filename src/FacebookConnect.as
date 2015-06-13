package src 
{
	import adobe.utils.CustomActions;
	import com.facebook.graph.data.FacebookSession;
	import com.leonel.CustomEvent;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import com.facebook.graph.FacebookMobile;
	import flash.media.StageWebView;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FacebookConnect extends Sprite
	{
		protected static const APP_ID:String = "453652251465376"; //Your App Id
		protected static const APP_URL:String = "http://orderit.leonelserra.net/"; //Your App URL as specified in facebook.com/developers app settings
		
		private var _extendedPermissions:Array = ["publish_actions"];
		
		private var facebookWebView:StageWebView = new StageWebView();
		private var session:FacebookSession;
		
		private var mainStage:Stage;
		
		private var _screenWidth:Number;
		private var _screenHeight:Number;
		private var overlay:Sprite = new Sprite();
		private var facebookMessagePost:FacebookMessagePost;
		private var facebookShareOK:FacebookMessageFeedback;
		
		public function FacebookConnect(screenWidth:Number, screenHeight:Number, _stage:Stage):void
		{
			trace("FACEBOOK INIT");
			_screenWidth = screenWidth;
			_screenHeight = screenHeight;
			mainStage = _stage;
			
			
			FacebookMobile.init(APP_ID, handleFacebookConnect,null);
		}
	
		private function handleFacebookConnect(response:Object, fail:Object):void {
			trace("FACEBOOK CONNECT");
			if (response) {
				trace("FACEBOOK IS ALREADY LOGGED");
				dispatchEvent(new CustomEvent(CustomEvent.FACEBOOK_READY_TO_POST));
			} else {
				trace("FACEBOOK WILL LOGIN");
				loginUser();
			}
			loginUser();
		}
		
		private function loginUser():void {
			facebookWebView.stage = mainStage;
			facebookWebView.assignFocus();
			facebookWebView.viewPort = new Rectangle(0, 0, _screenWidth, _screenHeight);
			
			trace("LOGIN USER");
			FacebookMobile.login(handleLogin, mainStage, _extendedPermissions, facebookWebView);
		}
		
		protected function handleLogin(response:Object, fail:Object):void {
			trace("HANDLE LOGIN");
			FacebookMobile.api('/me', handleUserInfo);
		}
		
		protected function handleUserInfo(response:Object, fail:Object):void {
			trace("HANDLEUSERINFO");
			if (response) {
				trace("HANDLEUSERINFO RESPONSE ID ");
				dispatchEvent(new CustomEvent(CustomEvent.FACEBOOK_READY_TO_POST));
			}
		}
		
		
		public function postToFacebook(_scoreValue:Number):void {
			trace("POST TO FACEBOOK " + _scoreValue);
			
			overlay.graphics.beginFill(0x000000, 0);
			overlay.graphics.drawRect(0, 0, _screenWidth, _screenHeight);
			overlay.graphics.endFill();
			addChild(overlay);
			
			facebookMessagePost = new FacebookMessagePost();
			facebookMessagePost.x = _screenWidth / 2;
			facebookMessagePost.y = _screenHeight / 2;
			facebookMessagePost.scaleX = facebookMessagePost.scaleY = ((286 * _screenWidth) / 480) / 286;
			facebookMessagePost.facebookShareMsg.text = "I got " + String(_scoreValue) + " points! Yeahh!!!\nHow much did you get?";
			facebookMessagePost.sharePost.addEventListener(MouseEvent.CLICK, postMessage);
			facebookMessagePost.cancelPost.addEventListener(MouseEvent.CLICK, cancelMessage);
			addChild(facebookMessagePost);
			
			
			
			/*var data:Object = {};
			data.caption = "OrderIt!";
			data.description = "I got " + String(_scoreValue) + " points! Yeahh!!!\nHow much did you get?";*/

			
		}
		
		private function cancelMessage(e:MouseEvent):void 
		{
			facebookMessagePost.sharePost.removeEventListener(MouseEvent.CLICK, postMessage);
			facebookMessagePost.cancelPost.removeEventListener(MouseEvent.CLICK, cancelMessage);
			removeChild(facebookMessagePost);
		}
		
		private function postMessage(e:MouseEvent):void 
		{
			var method:String = "/me/feed";
			
			FacebookMobile.api(method, handlePostResult, {caption: "OrderIt!", message:facebookMessagePost.facebookShareMsg.text}, "POST");//("I got " + String(_scoreValue) + " points! Yeahh!!!\nHow much did you get?")
		}
		
		protected function handlePostResult(response:Object, fail:Object):void {
			trace("POS POST RESULT "+response+" OR FAIL "+fail);
			if (response) {
				trace("SCORE SUCCESSFULLY POSTED TO FACEBOOK!");
				removeChild(facebookMessagePost);
				
				facebookShareOK = new FacebookMessageFeedback();
				facebookShareOK.x = _screenWidth / 2;
				facebookShareOK.y = _screenHeight / 2;
				facebookShareOK.facebookShareMsg.text = "YOUR SCORE WAS SUCCESSFULY SHARED";
				facebookShareOK.scaleX = facebookShareOK.scaleY = ((214 * _screenWidth) / 480) / 214;
				facebookShareOK.okButton.addEventListener(MouseEvent.CLICK, onSuccessOK);
				addChild(facebookShareOK);
			}else {
				trace("SOMETHING HAPPENED. YOUR SCORE WAS NOT POSTED!");
				removeChild(facebookMessagePost);
				
				facebookShareOK = new FacebookMessageFeedback();
				facebookShareOK.x = _screenWidth / 2;
				facebookShareOK.y = _screenHeight / 2;
				facebookShareOK.facebookShareMsg.text = "SOMETHING HAPPENED :(\nCHECK YOUR CONNECTION!";
				facebookShareOK.scaleX = facebookShareOK.scaleY = ((214 * _screenWidth) / 480) / 214;
				facebookShareOK.okButton.addEventListener(MouseEvent.CLICK, onFailureOK);
				addChild(facebookShareOK);
			}
		}
		
		private function onFailureOK(e:MouseEvent):void 
		{
			facebookShareOK.okButton.removeEventListener(MouseEvent.CLICK, onFailureOK);
			removeChild(facebookShareOK);
		}
		
		private function onSuccessOK(e:MouseEvent):void 
		{
			facebookShareOK.okButton.removeEventListener(MouseEvent.CLICK, onSuccessOK);
			removeChild(facebookShareOK);
		}
	}
}