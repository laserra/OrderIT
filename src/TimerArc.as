package src 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.leonel.CustomEvent;
	import flash.text.TextFormat;
	
	import flash.utils.getTimer;
	
	import com.greensock.*; 
	import com.greensock.easing.*;
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class TimerArc extends MovieClip 
	{
		private var arcContainer:MovieClip = new MovieClip();
		private var tf:TextFormat = new TextFormat();
		private var arcTimer:Sprite;
		private var frontCircle:Sprite;
		
		/*private var anglesPerSecond:Number;*/
		/*private var timerArc:Timer;*/
		private var totalSteps:Number=720;
		private var timePerStep:Number;
		private var anglePerStep:Number = 0.5;
		/*private var startedCounting:Boolean = false;*/
		private var currentStepCount:Number = 0;
		
		private var frontTimer:SecFront;
		private var color:Number;
		private var bonusTime:Number;
		
		private var initTime:Number;
		/*private var previousTime:Number;*/
		private var totalSeconds:Number;
		private var endTime:Number;
		
		/*private var lastTick:Number;*/
		/*private var cumulativeDrift:Number;*/
		
		public function TimerArc(_seconds:Number=30, _bonustime:Number=5, _color:Number=0x000000) 
		{
			super();
			
			currentStepCount = 0;
			color = _color;
			
			totalSeconds = _seconds;
			bonusTime = _bonustime;
			
			tf.color = color;
			
			timePerStep = ((totalSeconds*1000) / totalSteps); //milliseconds/step
			
			addChild(arcContainer);
			
			addFrontCircle();
			addCountDownText();
			
		}
		
		public function startTimer():void {
			this.addEventListener(Event.ENTER_FRAME, onTimerTriggerPerStep);
			this.initTime = getTimer();
		}
		
		private function addFrontCircle():void 
		{	
			frontCircle = new Sprite();
			frontCircle.graphics.beginFill(0xFFFFFF, 1);
			frontCircle.graphics.drawCircle( 0, 0, 20);
			frontCircle.graphics.endFill();
			addChild(frontCircle);
		}
		
		private function addCountDownText():void {
			frontTimer = new SecFront();
			frontTimer.timerTx.defaultTextFormat = tf;
			frontTimer.x = 0; //stage.stageWidth / 2;
			frontTimer.y = 0; //stage.stageHeight / 2;
			addChild(frontTimer);
		}
		
		private function onTimerTriggerPerStep(e:Event):void 
		{
			var angleToDraw:Number;
			
			if (arcTimer) {
				arcContainer.removeChild(arcTimer);
			}
			
			endTime = getTimer() - this.initTime;
			
			if (endTime < (totalSeconds * 1000)) {
				angleToDraw = ((endTime / timePerStep) * anglePerStep) - 90;
			}else {
				angleToDraw = 360 - 90;
				this.removeEventListener(Event.ENTER_FRAME, onTimerTriggerPerStep);
				
				dispatchEvent(new CustomEvent(CustomEvent.TIMERARC_COUNTDOWN_END));
			}
			
			arcTimer = new Sprite;
			arcTimer.graphics.beginFill(color, 1);
			
			drawSegment(arcTimer, 0, 0, 30, -90, angleToDraw);
			
			arcTimer.graphics.endFill();
			arcTimer.x = 0;
			arcTimer.y = 0;
			
			arcContainer.addChild(arcTimer);
			
			frontTimer.timerTx.text = ":" + Math.floor(endTime * 0.001);
		}
		
		/**
		 * Draw a segment of a circle
		 * @param target	<Sprite> The object we want to draw into
		 * @param x			<Number> The x-coordinate of the origin of the segment
		 * @param y 		<Number> The y-coordinate of the origin of the segment
		 * @param r 		<Number> The radius of the segment
		 * @param aStart	<Number> The starting angle (degrees) of the segment (0 = East)
		 * @param aEnd		<Number> The ending angle (degrees) of the segment (0 = East)
		 * @param step		<Number=1> The number of degrees between each point on the segment's circumference
		 */
		public function drawSegment(target:Sprite, x:Number, y:Number, r:Number, aStart:Number, aEnd:Number, step:Number = 1):void {
				// More efficient to work in radians
				var degreesPerRadian:Number = Math.PI / 180;
				aStart *= degreesPerRadian;
				aEnd *= degreesPerRadian;
				step *= degreesPerRadian;
				
				// Draw the segment
				target.graphics.moveTo(x, y);
				for (var theta:Number = aStart; theta < aEnd; theta += Math.min(step, aEnd - theta)) {
					target.graphics.lineTo(x + r * Math.cos(theta), y + r * Math.sin(theta));
				}
				target.graphics.lineTo(x + r * Math.cos(aEnd), y + r * Math.sin(aEnd));
				target.graphics.lineTo(x, y);
		}
		
		public function changeColor(value:Number):void {
			color = value;
		}
		
		public function isThereBonus():Boolean {
			var bonusValid:Boolean = false;
			
			if (endTime <= (bonusTime * 1000)) {
				bonusValid = true;
			}else {
				bonusValid = false;
			}
			
			return bonusValid;
		}
	}
}