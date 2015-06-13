package src {
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class LevelsAndTimes 
	{
		private var currentLevel:Number = 0;
		private var currentColor:String = "red";
		private var colorsDefinitionsAndArrays:Colors = new Colors();
		
		private var _lifes:Number = 3;
		private var _scoreBeforeNewScreen:Number = 0;

		private var levels:Array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
		private var info:Array =   [0, 1, 2, 3, 2, 3, 4, 4, 5, 0];
		/**
		 * level 1: 5 squares-> asc order
		 * level 2: 5 squares-> asc/desc order
		 * level 3: 6 squares-> asc order
		 * level 4: 6 squares-> asc/desc order
		 * level 5: 7 squares-> asc order
		 * level 6: 7 squares-> asc/desc order
		 * level 7: 8 squares-> asc/desc order
		 * level 8: 9 squares-> asc/desc order
		 * level 9: 10 squares-> asc/desc order and scramble
		 * level 10: 11 squares-> asc/desc order and scramble
		 */
		private var usedScreen:Array = [false, false, false, false, false, false, false, false, false, false];
		private var timeToTap:Array = [15, 15, 20, 20, 25, 25, 30, 30, 60, 60];
		//private var timeToTap:Array = [5, 40, 50, 60, 60, 60, 60, 60, 60, 60];
		private var timeToTapBonus:Array = [2, 2, 4, 4, 6, 6, 8, 8, 9, 9];
		//private var timeToTapBonus:Array = [20, 20, 20, 20, 20, 20];
		private var multiplierScoreForBonus:Array = [0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05];
		
		private var scores:Array = [0, 400, 1200, 2300, 3800, 5000, 7000, 9000, 11000, 13000];
		//private var scores:Array = [0, 100, 200, 300, 400, 500, 600, 700, 800, 900];
		private var numberOfRectangles:Array = [5, 5, 6, 6, 7, 7, 8, 8, 9, 9];
		private var descOrder:Array = [false, true, false, true, false, true, true, true, true, true];
		private var scrambleRectangles:Array = [false, false, false, false, false, false, false, false, true, true];
		private var timeBetweenRectangles:Array = [500, 500, 500, 500, 500, 500, 500, 500, 500, 500];
		private var timeToOverlay:Array = [2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000];
		private var timeToFinish:Array = [10000, 10000, 12000, 12000, 15000, 15000, 15000, 15000, 15000, 15000];
		
		private var _completeUnderBonusTime:Number = 0;
		
		public function LevelsAndTimes():void {
			
		}
		
		public function checkLevelFromScore(currentScore:Number):Number {
			if (currentScore >= scores[0] && currentScore < scores[1]) {
				currentLevel = 0;
			}else if (currentScore >= scores[1] && currentScore < scores[2]) {
				currentLevel = 1;
			}else if (currentScore >= scores[2] && currentScore < scores[3]) {
				currentLevel = 2;
			}else if (currentScore >= scores[3] && currentScore < scores[4]) {
				currentLevel = 3;
			}else if (currentScore >= scores[4] && currentScore < scores[5]) {
				currentLevel = 4;
			}else if (currentScore >= scores[5] && currentScore < scores[6]){
				currentLevel = 5;
			}else if (currentScore >= scores[6] && currentScore < scores[7]) {
				currentLevel = 6;
			}else if (currentScore >= scores[7] && currentScore < scores[8]) {
				currentLevel = 7;
			}else{
				currentLevel = 8;
			}
			
			return currentLevel;
		}
		
		public function numberOfRectanglesInLevel():Number {
			return numberOfRectangles[currentLevel];
		}
		
		public function timeBetweenRectanglesInLevel():Number {
			return timeBetweenRectangles[currentLevel];
		}
		
		public function timeToOverlayInLevel():Number {
			return timeToOverlay[currentLevel];
		}
		
		public function returnTimeToFinish():Number {
			return timeToFinish[currentLevel];
		}
		
		public function checkColorFromScore(currentScore:Number):String {
			if (currentScore >= scores[0] && currentScore < scores[1]) {
				currentColor = "red";
			}else if (currentScore >= scores[1] && currentScore < scores[2]) {
				currentColor = "orange";
			}else if (currentScore >= scores[2] && currentScore < scores[3]) {
				currentColor = "blue";
			}else if (currentScore >= scores[3] && currentScore < scores[4]) {
				currentColor = "green";
			}else if (currentScore >= scores[4] && currentScore < scores[5]) {
				currentColor = "yellow";
			}else if (currentScore >= scores[5] && currentScore < scores[6]){
				currentColor = "purple";
			}else if (currentScore >= scores[6] && currentScore < scores[7]) {
				currentColor = "darkblue";
			}else if (currentScore >= scores[7] && currentScore < scores[8]) {
				currentColor = "limegreen";
			}else if (currentScore >= scores[8] && currentScore < scores[9]) {
				currentColor = "darkpink";
			}else {
				currentColor = "darkorange";
			}
			
			return currentColor;
		}
		
		public function returnColorArray():Array {
			return colorsDefinitionsAndArrays.returnColorArray(currentColor);
		}
		
		public function returnBackgroundColor(currentScore:Number):Number {
			return colorsDefinitionsAndArrays.returnColorArray(currentColor)[0];
		}
		
		public function returnDescendingOrder():Boolean {
			return descOrder[currentLevel];
		}
		
		public function returnScrambleRectangle():Boolean {
			return scrambleRectangles[currentLevel];
		}
		
		public function get lifes():Number 
		{
			return _lifes;
		}
		
		public function set lifes(value:Number):void 
		{
			_lifes = value;
		}
		
		public function get scoreBeforeNewScreen():Number 
		{
			return _scoreBeforeNewScreen;
		}
		
		public function set scoreBeforeNewScreen(value:Number):void 
		{
			_scoreBeforeNewScreen = value;
		}
		
		public function get completeUnderBonusTime():Number 
		{
			return _completeUnderBonusTime;
		}
		
		public function set completeUnderBonusTime(value:Number):void 
		{
			_completeUnderBonusTime = value;
		}
		
		public function returnInfo():Number {
			return info[currentLevel];
		}
		
		public function setUsedScreen(position:Number):void {
			usedScreen[position - 1] = true;
		}
		
		public function returnIfPositionWasUsed(position:Number):Boolean {
			return usedScreen[position - 1];
		}
		
		public function returnTimeToTap():Number {
			return timeToTap[currentLevel];
		}
		
		public function returnTimeToBonus():Number {
			return timeToTapBonus[currentLevel];
		}
		
		public function returnMultiplierForBonus():Number {
			return multiplierScoreForBonus[currentLevel];
		}
	}
	
}