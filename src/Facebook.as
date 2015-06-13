package src 
{
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author ...
	 */
	public class Facebook extends Sprite
	{
		protected static const APP_ID:String = "364374783742984"; //Your App Id
		protected static const APP_URL:String = "http://your.app.url/"; //Your App URL as specified in facebook.com/developers app settings
		
		public function Facebook():void
		{
			ExternalInterface.addCallback("myFlashcall",myFlashcall);
			//stage.addEventListener(MouseEvent.CLICK, onClick); //Probably a Button
		}

		private function myFlashcall(str:String):void{
			trace("myFlashcall: "+str);
		}
		
		protected function onClick(event:MouseEvent):void{
			if(ExternalInterface.available){
				trace("onClick");
				ExternalInterface.call("myFBcall");
			}
		}
		
	}

}