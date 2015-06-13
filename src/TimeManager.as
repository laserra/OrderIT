package src 
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import com.leonel.CustomEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class TimeManager extends EventDispatcher 
	{
		private var _time:Number;
		private var _type:String;
		
		private var elapsedTime:Number;
		
		private var initialTime:int;
		private var actionTimer:Timer;
		
		public function TimeManager(timeSeconds:Number, type:String) 
		{
			super();
			
			_time = timeSeconds;
			_type = type;
			
			createTimer();
		}
		
		private function createTimer():void 
		{
			actionTimer = new Timer((_time*1000), 0);
			actionTimer.addEventListener(TimerEvent.TIMER, onTimerTriggerHandler);
		}
		
		public function startTimer():void {
			actionTimer.start();
			
			keepStartTime();
		}
		
		public function stopTimer():void {
			actionTimer.stop();
			
			checkElapsedTimer();
		}
		
		private function keepStartTime():void 
		{
			initialTime = getTimer();
			trace("START TIME "+initialTime);
		}
		
		private function onTimerTriggerHandler(evt:TimerEvent):void 
		{
			stopTimer();
			
			switch(_type) {
				case "PLAY_TIME_OVER":
					dispatchEvent(new CustomEvent(CustomEvent.TIMER_PLAY_TIME_OVER));
					break;
				default:
					break;
			}
		}
		
		public function checkElapsedTimer():void 
		{
			elapsedTime = (getTimer() - initialTime) * 0.001;
		}
		
		public function getElapsedTime():int {
			return elapsedTime;
		}
		
		public function resetTimer():void {
			actionTimer.reset();
		}
	}

}