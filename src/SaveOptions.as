package src {
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.events.NetStatusEvent;
	import com.leonel.CustomEvent;
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class SaveOptions extends EventDispatcher
	{
		private var gameData:SharedObject;
		
		public function SaveOptions():void {
			gameData = SharedObject.getLocal("OrderItOptions");
			
			initializeData();
		}
		
		public function initializeData():void 
		{
			if (!gameData.data.highscore) {
				gameData.data.soundfx = true;
				gameData.data.backgroundsound = true;
				gameData.data.levels = true;
				gameData.data.highscore = 0;
			}
		}
		
		
		public function readHighScore():Number {
			return gameData.data.highscore;
		}
		
		public function readSoundFx():Boolean {
			return gameData.data.soundfx;
		}
		
		public function readBackgroundSound():Boolean {
			return gameData.data.backgroundsound;
		}
		
		public function readLevelsInfo():Boolean {
			return gameData.data.levels;
		}
		
		public function saveOptions(_soundfx:Boolean, _backgroundsound:Boolean):void {
			gameData.data.soundfx = _soundfx;
			gameData.data.backgroundsound = _backgroundsound;
			
			saveData();
		}
		
		public function saveLevelsOptions(_levels:Boolean):void {
			gameData.data.levels = _levels;
			
			saveData();
		}
		
		public function saveHighScore(_highscore:Number):void {
			gameData.data.highscore = _highscore;
			
			saveData();
		}
		
		public function saveData():void {
			
			//trace("Saving Options and Score...\n");
			var flushStatus:String = null;
		
			try {
				flushStatus = gameData.flush();
			}catch (er:Error) {
				trace("Error... Could not write SharedObject to disk\n");
			}
			
			if (flushStatus != null) {
				switch(flushStatus) {
					case SharedObjectFlushStatus.PENDING:
						//trace("Requesting permission to save object...\n");
						gameData.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
						break;
					case SharedObjectFlushStatus.FLUSHED:
						//trace("Value flushed to disk\n");
						break;
				}
			}
			trace("\n");
		}
		
		public function clearValue():void {
			trace("Cleared saved value... Reload SWF and the value shoudl be \"undefined\".\n\n");
			gameData.clear();
		}
		
		private function onFlushStatus(event:NetStatusEvent):void {
           // trace("User closed permission dialog...\n");
            switch (event.info.code) {
                case "SharedObject.Flush.Success":
                    //trace("User granted permission -- value saved.\n");
					dispatchEvent(new CustomEvent(CustomEvent.SAVE_VALUES_SUCCESS));
                    break;
                case "SharedObject.Flush.Failed":
                    //trace("User denied permission -- value not saved.\n");
					dispatchEvent(new CustomEvent(CustomEvent.SAVE_VALUES_FAIL));
                    break;
            }
            trace("\n");

            gameData.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
        }
	}
	
}