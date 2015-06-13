package src 
{
	import adobe.utils.CustomActions;
	import com.leonel.CustomEvent;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import com.facebook.graph.FacebookMobile;
	import flash.media.StageWebView;
	import flash.geom.Rectangle;
	import flash.filesystem.File;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FacebookConnect extends Sprite
	{
		protected static const APP_ID:String = "364374783742984"; //Your App Id
		protected static const APP_URL:String = "http://orderit.leonelserra.net/"; //Your App URL as specified in facebook.com/developers app settings
		
		private var _extendedPermissions:Array = ["publish_stream", "user_website", "user_status", "user_about_me"];
		
		private var facebookWebView:StageWebView = new StageWebView();
		private var session:String;
		
		private var mainStage:Stage;
		
		private var _screenWidth:Number;
		private var _screenHeight:Number;
		
		public function FacebookConnect(screenWidth:Number, screenHeight:Number, _stage:Stage):void
		{
			trace("FACEBOOK INIT");
			_screenWidth = screenWidth;
			_screenHeight = screenHeight;
			mainStage = _stage;
			
			facebookWebView.stage = _stage;
			
			initFbStageWebView();
		}
		
		private function initFbStageWebView():void 
		{
			var fPath:String = new File(new File("app:/load_user_fb_credentials.html").nativePath).url;
			
			facebookWebView.loadURL(fPath);
			//facebookWebView.stage = null;
			facebookWebView.assignFocus();
			facebookWebView.viewPort = new Rectangle(0, 0, _screenWidth, _screenHeight);
			
		}
	
		private function handleFacebookConnect(response:Object, fail:Object):void {
			trace("FACEBOOK CONNECT");
			if (response) {
				trace("FACEBOOK CONNECTED");
				var userAccessToken:String = JSON.stringify(response.accessToken);
				dispatchEvent(new CustomEvent(CustomEvent.FACEBOOK_READY_TO_POST));
			} else {
				trace("FACEBOOK LOGIN");
				loginUser();
			}
		}
		
		private function loginUser():void {
			facebookWebView.stage = mainStage;
			
			
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
			
			var method:String = "/me/feed";
			
			var data:Object = {};
			data.caption = "OrderIt!";
			data.description = "I got " + String(_scoreValue) + " points! Yeahh!!!\nHow much did you get?";

			FacebookMobile.api(method, handlePostResult, {caption:"OrderIt!", description:("I got " + String(_scoreValue) + " points! Yeahh!!!\nHow much did you get?")}, "POST");
		}
		
		protected function handlePostResult(response:Object, fail:Object):void {
			if (response) {
				trace("SCORE SUCCESSFULLY POSTED TO FACEBOOK!");
			}else {
				trace("SOMETHINg HAPPENED. YOUR SCORE WAS NOT POSTED!");
			}
		}
	}
}