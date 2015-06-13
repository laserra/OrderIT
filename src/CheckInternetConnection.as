package src 
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.net.URLRequest;
	import air.net.URLMonitor;
	import com.leonel.CustomEvent;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class CheckInternetConnection extends EventDispatcher
	{
		private var monitor:URLMonitor = new URLMonitor(new URLRequest('http://www.google.com'));
		
		public function CheckInternetConnection() 
		{
			monitor.addEventListener(StatusEvent.STATUS, checkHTTP);
		}
		
		public function start():void {
			monitor.start();
		}
		
		private function checkHTTP(e:StatusEvent):void 
		{
			if (monitor.available) {
				dispatchEvent(new CustomEvent(CustomEvent.CONNECTION_AVAILABLE));
			}else {
				dispatchEvent(new CustomEvent(CustomEvent.CONNECTION_NOT_AVAILABLE));
			}
			monitor.removeEventListener(StatusEvent.STATUS, checkHTTP);
		}
		
	}

}