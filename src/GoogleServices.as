package src 
{
	import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGames;
	import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGamesEvent;
	import com.leonel.CustomEvent;
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class GoogleServices 
	{
		
		public function GoogleServices() 
		{
			// Initialize
			AirGooglePlayGames.getInstance().addEventListener(AirGooglePlayGamesEvent.ON_SIGN_IN_SUCCESS, onSignInSuccess);
			AirGooglePlayGames.getInstance().addEventListener(AirGooglePlayGamesEvent.ON_SIGN_OUT_SUCCESS, onSignOutSuccess);
			AirGooglePlayGames.getInstance().addEventListener(AirGooglePlayGamesEvent.ON_SIGN_IN_FAIL, onSignInFail);
			AirGooglePlayGames.getInstance().startAtLaunch();
		}
		
		private function onSignInFail(e:AirGooglePlayGamesEvent):void 
		{
			
		}
		
		private function onSignOutSuccess(e:AirGooglePlayGamesEvent):void 
		{
			
		}
		
		private function onSignInSuccess(e:AirGooglePlayGamesEvent):void 
		{
			AirGooglePlayGames.getInstance().signIn();
			dispatchEvent(new CustomEvent(CustomEvent.FACEBOOK_READY_TO_POST));
		}
		
		public function updateHighScore(_value:Number):void {
			// Update HighScore
			AirGooglePlayGames.getInstance().reportScore(leaderboardId, _value);
		}
		
	}

}