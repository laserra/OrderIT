package src {
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.events.NetStatusEvent;
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class SaveLocal 
	{
		private var gameData:SharedObject;
		
		public function SaveLocal():void {
			gameData = SharedObject.getLocal("OrderitScore");
			trace("SharedObject loaded...\n");
			trace("Loaded value: " + gameData.data + "\n\n");
			
			initializeData();
		}
		
		private function initializeData():void 
		{
			if (!gameData.data.highscore) {
				gameData.data.highscore = 0;
			}
		}
		
		
		public function readData():Number {
			//trace("GAME DATA "+gameData.data.highscore)
			return gameData.data.highscore;
		}
		
		public function saveData(_highscore:Number):void {
			
			trace("Saving Score...\n");
			gameData.data.highscore = _highscore;
			var flushStatus:String = null;
		
			try {
				flushStatus = gameData.flush();
			}catch (er:Error) {
				trace("Error... Could not write SharedObject to disk\n");
			}
			
			if (flushStatus != null) {
				switch(flushStatus) {
					case SharedObjectFlushStatus.PENDING:
						trace("Requesting permission to save object...\n");
						gameData.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
						break;
					case SharedObjectFlushStatus.FLUSHED:
						trace("Value flushed to disk\n");
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
            trace("User closed permission dialog...\n");
            switch (event.info.code) {
                case "SharedObject.Flush.Success":
                    trace("User granted permission -- value saved.\n");
                    break;
                case "SharedObject.Flush.Failed":
                    trace("User denied permission -- value not saved.\n");
                    break;
            }
            trace("\n");

            gameData.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
        }
	}
	
}