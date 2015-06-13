package src
{
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.leonel.CustomEvent;
	import flash.events.MouseEvent;
	
	import com.greensock.*;
	import com.greensock.events.*;
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class ManageRectangles extends MovieClip 
	{
		private var _stageWidth:Number;
		private var _stageHeight:Number;
		private var _scoreTxHeight:Number;
		
		private var _timeBetweenRectanglesInSequence:uint = 500;
		private var _randomAscOrDesc:int;
		private var _isAscOrDescRandom:Boolean = false;
		private var _scramble:Boolean = false;
		private var timeToFinish = 15000;
		private var _numberRectangles:uint = 5;
		private var _rectangleGeneratorAuxCounter:Number = 0;
		private var _screensMade:Number = 0;
		
		private var rectangleClickOrderAux:Number = 0;
		private var rectangleGeneratorAuxScrambleCounter:Number = 0;
		
		public var timerPauseReactangleGenerator:Timer;
		private var timerForUserPlay:Timer;
		private var levelsAndTimes:LevelsAndTimes = new LevelsAndTimes();
		private var _colorsArray:Array=new Array();
		
		public var rectangleArray:Vector.<RectangleTap> = new Vector.<RectangleTap>(15);
		private var tempScramblePos:Array = new Array();
		
		private var looserHeart:OneDownHeart;
		
		private var _lifes:Number = 3;
		
		public function ManageRectangles(stageWidth:Number, stageHeight:Number, scoreTxHeight:Number):void {
			_stageHeight = stageHeight;
			_stageWidth = stageWidth;
			_scoreTxHeight = scoreTxHeight;
			
			//INITIALIZE RECTANGLE COUNTER
			rectangleGeneratorAuxCounter = 0;
			rectangleGeneratorAuxScrambleCounter = 0;
			timerPauseReactangleGenerator = new Timer(_timeBetweenRectanglesInSequence);
			timerPauseReactangleGenerator.addEventListener(TimerEvent.TIMER, recallRectangleGeneratorAndPause);
			
			//Pre Populates the rectangle array
			populateRectangleVector();
		}
		
		public function repositionRectangles():void 
		{
			
			if (rectangleGeneratorAuxCounter < numberRectangles) {
				var size:Number = (120 * stage.fullScreenWidth)/480;// Math.round(Math.random() * 10 + 100)  ;//* scaleFactor    variable size from 50 to 60
				var xPos:Number = Math.round(Math.random() * _stageWidth);
				var yPos:Number = Math.round(Math.random() * (_stageHeight-_scoreTxHeight))+_scoreTxHeight;
				
				if (checkSpaceAvailable(size, xPos, yPos, rectangleGeneratorAuxCounter)) {
					rectangleArray[rectangleGeneratorAuxCounter].x = xPos;
					rectangleArray[rectangleGeneratorAuxCounter].rectXPos = xPos;
					rectangleArray[rectangleGeneratorAuxCounter].y = yPos;
					rectangleArray[rectangleGeneratorAuxCounter].rectYPos = yPos;
										
					rectangleArray[rectangleGeneratorAuxCounter].resize(size, _stageWidth); //Changes rectangle size and redraws it
					
					rectangleArray[rectangleGeneratorAuxCounter].visible = true;
					rectangleArray[rectangleGeneratorAuxCounter].addEventListener(MouseEvent.CLICK, tapHandler);
					
					timerPauseReactangleGenerator.start();
				}else {
					repositionRectangles();
				}
			}else {
				//Order tapping setting
				if (_isAscOrDescRandom) {
					_randomAscOrDesc = Math.floor(Math.random() * (1 + 10 - 0)) + 0;
				}else {
					_randomAscOrDesc = 1;
				}
				
				dispatchEvent(new CustomEvent(CustomEvent.ARROWS_BACKGROUND_FLIP));
				dispatchEvent(new CustomEvent(CustomEvent.ARROWS_BACKGROUND_SHOW));
				dispatchEvent(new CustomEvent(CustomEvent.BACKGROUND_CHANGE_COLOR));
				
				if (_randomAscOrDesc <= 5) {
					rectangleClickOrderAux=0;
				}else {
					rectangleClickOrderAux = numberRectangles - 1;
				}
				
				timerPauseReactangleGenerator.stop();
				dispatchEvent(new CustomEvent(CustomEvent.STATIC_OVERLAY_HIDE));
				dispatchEvent(new CustomEvent(CustomEvent.TIMED_OVERLAY_START));
			}
		}
		
		/**
		 * Generates new positions that will scrmable the already existing rectangles
		 */
		public function generateScramblePosition():void 
		{
			if (rectangleGeneratorAuxScrambleCounter < numberRectangles) {
				var size:Number = (120 * stage.fullScreenWidth)/480;// Math.round(Math.random() * 10 + 100)  ;//* scaleFactor    variable size from 50 to 60
				var xPos:Number = Math.round(Math.random() * _stageWidth);
				var yPos:Number = Math.round(Math.random() * (_stageHeight-_scoreTxHeight))+_scoreTxHeight;
				
				if (checkSpaceAvailableScramble(size, xPos, yPos, rectangleGeneratorAuxScrambleCounter)) {
					var newPos:Point = new Point(xPos, yPos);
					tempScramblePos.push(newPos);
					
					rectangleGeneratorAuxScrambleCounter++;
					generateScramblePosition();
				}else {
					generateScramblePosition();
				}
			}else {
				repositionScrambleRectangles();
			}
		}
		
		/**
		 * Animates the rectangle to the new scrambled position
		 */
		private function repositionScrambleRectangles():void 
		{
			for (var i:Number = 0; i < tempScramblePos.length; i++) {
				TweenNano.to(rectangleArray[i], 0.2,{x:tempScramblePos[i].x, y:tempScramblePos[i].y});
			}
			tempScramblePos = [];
			rectangleGeneratorAuxScrambleCounter = 0;
		}
		
		private function recallRectangleGeneratorAndPause(evt:TimerEvent=null):void {
			rectangleGeneratorAuxCounter++;
			
			repositionRectangles();
		}
		
		/**
		 * Receives the tap of the Rectangle
		 * @param	e
		 */
		private function tapHandler(e:MouseEvent):void 
		{
			
			dispatchEvent(new CustomEvent(CustomEvent.SOUND_PLAY_SFX));
			
			checkOrder(e);
		}
		
		private function checkOrder(e:MouseEvent):void 
		{
			if (e.currentTarget.order == rectangleClickOrderAux ) {
				e.currentTarget.removeEventListener(MouseEvent.CLICK, tapHandler);
				RectangleTap(e.currentTarget).changeTapColor(); //Change rectangle Color
				RectangleTap(e.currentTarget).showOrderNum();
				dispatchEvent(new CustomEvent(CustomEvent.SCORE_ADD)); //Add Score event
				dispatchEvent(new CustomEvent(CustomEvent.SCORE_CHECK_HIGHSCORE)); //Check if this score is a new High Score
				checkNewSetOfRectangles(); //Calls function to check if the tap is valid
			}else {
				dispatchEvent(new CustomEvent(CustomEvent.SCORE_CHECK_HIGHSCORE));
				blinkRectangle(e);
			}
		}
		
		private function blinkRectangle(e:MouseEvent):void 
		{
			if ((_lifes - 1) != 0) {
				_lifes--;
				looserHeart = new OneDownHeart(_stageWidth, _stageHeight, e.currentTarget.width);
				looserHeart.x = e.currentTarget.x;
				looserHeart.y = e.currentTarget.y;
				looserHeart.playOneDownAnim();
				addChild(looserHeart); 
				
				TweenMax.fromTo(e.currentTarget, .2, { colorMatrixFilter: { amount:0 }}, { colorMatrixFilter: { colorize:0xff0000, amount:1 }, repeat:3, yoyo:true } );
			}
			
			dispatchEvent(new CustomEvent(CustomEvent.LIFE_LOST));
		}
		
		private function checkNewSetOfRectangles():void {
			
			
			if (_randomAscOrDesc <= 5) { //ASCENDING
				if ((rectangleClickOrderAux + 1) >= numberRectangles) {
					generateNewRectangles(); //If incorrect order generates a new set o rectangles
					dispatchEvent(new CustomEvent(CustomEvent.TIMERARC_TIMER_HIDE));
				}else {
					rectangleClickOrderAux++;
				}
			}else { //DESCENDING
				if ((rectangleClickOrderAux - 1) < 0) {
					generateNewRectangles();
					dispatchEvent(new CustomEvent(CustomEvent.TIMERARC_TIMER_HIDE));
				}else {
					rectangleClickOrderAux--;
				}
			}
			
		}
		
		private function generateNewRectangles():void {
			_screensMade++;
			_rectangleGeneratorAuxCounter = 0;
			
			dispatchEvent(new CustomEvent(CustomEvent.ARROWS_BACKGROUND_HIDE));
			dispatchEvent(new CustomEvent(CustomEvent.LEVEL_CHECK_COLOR));
			dispatchEvent(new CustomEvent(CustomEvent.SCORE_SAVE_LAST_LEVEL_SCORE));
			
			removeRectangles(rectangleArray.length);
			dispatchEvent(new CustomEvent(CustomEvent.INFO_CHECK));
			
			//dispatchEvent(new CustomEvent(CustomEvent.LEVEL_CHECK_COLOR));
			//repositionRectangles();
		}
		
		private function checkLifeMeter():void {
			dispatchEvent(new CustomEvent(CustomEvent.LIFE_LOST));
		}
		
		public function showGameOver():void 
		{
			removeRectangles(rectangleArray.length);
			
			dispatchEvent(new CustomEvent(CustomEvent.ARROWS_BACKGROUND_HIDE));
			dispatchEvent(new CustomEvent(CustomEvent.GAMEOVER_SHOW));
		}
		
		public function set rectangleGeneratorAuxCounter(value:Number):void 
		{
			_rectangleGeneratorAuxCounter = value;
		}
		
		public function get rectangleGeneratorAuxCounter():Number 
		{
			return _rectangleGeneratorAuxCounter;
		}
		
		public function set timeBetweenRectanglesInSequence(value:uint):void 
		{
			_timeBetweenRectanglesInSequence = value;
		}
		
		public function get numberRectangles():uint 
		{
			return _numberRectangles;
		}
		
		public function set numberRectangles(value:uint):void 
		{
			_numberRectangles = value;
		}
		
		public function get randomAscOrDesc():int 
		{
			return _randomAscOrDesc;
		}
		
		public function set colorsArray(value:Array):void 
		{
			_colorsArray = value;
		}
		
		/**
		 * Will say if the tap order can be normal or reversed
		 */
		public function set changeOrder(value:Boolean):void 
		{
			_isAscOrDescRandom = value;
		}
		
		/**
		 * Will say if the rectangles are to be scrambled
		 */
		public function set scramble(value:Boolean):void 
		{
			_scramble = value;
		}
		
		public function get lifes():Number 
		{
			return _lifes;
		}
		
		public function set lifes(value:Number):void 
		{
			_lifes = value;
		}
		
		public function get screensMade():Number 
		{
			return _screensMade;
		}
		
		public function set screensMade(value:Number):void 
		{
			_screensMade = value;
		}
		
		public function removeRectangles(rectanglesInScreen:Number):void {
			
			for (var i:Number = 0; i < rectanglesInScreen; i++) {
				rectangleArray[i].visible = false;
				rectangleArray[i].setColorArray(_colorsArray);
				rectangleArray[i].x = 0;
				rectangleArray[i].y = 0;
				rectangleArray[i].resetRectangle();
				
				TweenMax.to(rectangleArray[i], 0, { colorMatrixFilter: { remove:true }} );
			}
		}
		
		private function checkSpaceAvailable(size:Number, xPos:Number, yPos:Number, arrayPos:Number):Boolean
		{
			var goodSpace:Boolean=true;
			
			
			if (arrayPos == 0) { //Array is empty
				if (rectangleWithinScreen(size, xPos, yPos)) { //Check if the rectangle DOES fit inside the screen
					goodSpace = true;
				}else {
					goodSpace = false;
					return false;
				}
			}else { //Array not empty
				for (var i:Number = 0; i < numberRectangles; i++) { //Go for all rectangles in the array and...
					if ((Math.abs(xPos - rectangleArray[i].rectXPos) > size || Math.abs(yPos - rectangleArray[i].rectYPos) > size) && rectangleWithinScreen(size, xPos, yPos)) {
						goodSpace = true;
					}else {
						goodSpace = false;
						return false;
					}
				}
			}
			
			return goodSpace;
		}
		
		
		/**
		 * Check available space for new scrambled positions
		 * @param	size
		 * @param	xPos
		 * @param	yPos
		 * @param	arrayPos
		 * @return
		 */
		private function checkSpaceAvailableScramble(size:Number, xPos:Number, yPos:Number, arrayPos:Number):Boolean
		{
			var goodSpace:Boolean=true;
			
			
			if (arrayPos == 0) { //Array is empty
				if (rectangleWithinScreen(size, xPos, yPos)) { //Check if the rectangle DOES fit inside the screen
					goodSpace = true;
				}else {
					goodSpace = false;
					return false;
				}
			}else { //Array not empty
				for (var i:Number = 0; i < tempScramblePos.length; i++) { //Go for all rectangles in the array and...
					if ((Math.abs(xPos - tempScramblePos[i].x) > size || Math.abs(yPos - tempScramblePos[i].y) > size) && rectangleWithinScreen(size, xPos, yPos)) {
						goodSpace = true;
					}else {
						goodSpace = false;
						return false;
					}
				}
			}
			
			return goodSpace;
		}
		
		/**
		 * Checks if rectangle fits in the screen
		 * @param	size
		 * @param	xPos
		 * @param	yPos
		 */
		private function rectangleWithinScreen(size:Number, xPos:Number, yPos:Number):Boolean 
		{
			if (xPos >= 0 && (xPos + size) < _stageWidth && yPos >= 0 && (yPos + size) < _stageHeight) {
				return true;
			}else {
				return false;
			}
		}
		
		public function addTimerRecallGeneratorAndPause():void {
			timerPauseReactangleGenerator.addEventListener(TimerEvent.TIMER, recallRectangleGeneratorAndPause);
		}
		
		private function populateRectangleVector():void {
			for (var i:Number = 0; i < rectangleArray.length; i++) {
				var tapRectangle:RectangleTap = new RectangleTap(0, 0, 50, 50, i);
				tapRectangle.setColorArray(levelsAndTimes.returnColorArray());// levelsAndTimes.returnColorArray();
				
				tapRectangle.x = 0;
				tapRectangle.y = 0;
				tapRectangle.visible = false;
				
				addChild(tapRectangle);
				rectangleArray[i] = tapRectangle;
			}
		}
		
	}
	
}