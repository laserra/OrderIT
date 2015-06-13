
package src {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.Shape;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.display.Screen;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.leonel.CustomEvent;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	//import com.demonsters.debugger.MonsterDebugger;
	
	import com.greensock.*; 
	import com.greensock.easing.*;
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class ScreenSize extends MovieClip 
	{
		private static var _resizeEventFiredOnceAlready:Boolean;
		private static const _screenBounds:Rectangle = Screen.mainScreen.visibleBounds;
		private var _stageWidth:Number; //SHORTEST value, like in Portrait mode
		private var _stageHeight:Number; //LONGEST value
		private var systemDPI:Number;
		private var dpWide:Number;
		
		private var guiSize:MovieClip = new MovieClip();
		private var rectangleManager:ManageRectangles;// = new ManageRectangles();
		private var timeToOverlay:Number = 2000;
		private var timeToFinish = 15000;
		private var levelsAndTimes:LevelsAndTimes = new LevelsAndTimes();
		
		private var score:Score;
		
		private var iAmInMainScreen:Boolean = true;
		private var iAmInOptionsScreen:Boolean = false;
		private var iAmPlaying:Boolean = false;
		
		private var preventLoopCounter:Number = 0;
		
		private var overlayTimer:TimerOverlay;
		private var simpleOverlay:SimpleOverlay;
		private var scrambleTimer:Timer;
		private var background:Background = new Background();
		private var arrowsBackground:Arrows = new Arrows();
		
		private var splashScreen:InitSplashScreen;
		private var optionsScreen:OptionsScreen;
		private var rulesScreen:RulesScreen;
		
		private var soundEffects:Boolean;
		private var soundBackgroundMusic:Boolean;
		//private var randomAscOrDesc:int;
		
		private var saveOptionsAndScores:SaveOptions = new SaveOptions();
		private var gameOver:GameOver;
		private var newHighScore:Boolean = false;
		
		private var scaleFactor:Number;
		private var densityScale:Number;
		
		//SOUND
		private var soundControl:SoundControl = new SoundControl();
		
		//OPTIONS
		private var rectangleDisapper:Boolean = false;
		
		//FACEBOOK
		private var facebook:FacebookConnect;
		
		//TOAST
		private var toast:ToastDebug;
		
		public function ScreenSize():void {
			//MonsterDebugger.initialize(this);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			if(Capabilities.cpuArchitecture=="ARM")
			{
				NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate, false, 0, true);
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleDeactivate, false, 0, true);
				NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys, false, 0, true);
				NativeApplication.nativeApplication.addEventListener(Event.EXITING, exitHandler);
			}

			stage.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			initScreenSize();
			getStageSize();
		}
		
		private function initScreenSize():void{
			var thisScreen:Screen = Screen.mainScreen;
			var newScaleX:Number = thisScreen.visibleBounds.width / 480 * 0.98;
			var newScaleY:Number = thisScreen.visibleBounds.height / 850 * 0.98;
			scaleFactor = Math.min(newScaleX, newScaleY, 1);
			densityScale = 0.0065 * thisScreen.visibleBounds.width;
        }
		
		private function getStageSize(e:Event=null):void 
		{
			_resizeEventFiredOnceAlready = true;
			
			systemDPI = Capabilities.screenDPI;
			dpWide = stage.fullScreenWidth * 160 / systemDPI;
			
			_stageWidth = Math.min(stage.fullScreenWidth, _screenBounds.width); //, stage.stageWidth
			_stageHeight = Math.min(stage.fullScreenHeight, _screenBounds.height); //, stage.stageHeight
			
			var temp:Number = guiSize.width;
			_stageWidth =  Math.min(_stageWidth, _stageHeight);
			_stageHeight = Math.max(temp, _stageHeight);
			
			//DELETE==================================================================================
			//saveOptionsAndScores.clearValue();
			//saveOptionsAndScores.initializeData();
			//END DELETE==============================================================================
			
			showSplashScreen();
			
		}
		
		private function showSplashScreen():void 
		{
			//splashScreen.scaleX = splashScreen.scaleY = ((456 * _stageWidth) / 480) / 456;
			splashScreen = new InitSplashScreen(_stageWidth, _stageHeight);
			addChild(splashScreen);
			addSplashScreenEvents();
			
			addChild(soundControl);
		}
		
		private function addSplashScreenEvents():void {
			splashScreen.addEventListener(CustomEvent.SPLASH_PLAY, onStartGameFromSplashScreen);
			splashScreen.addEventListener(CustomEvent.SPLASH_OPTIONS, onOptionsFromSplashScreen);
			splashScreen.addEventListener(CustomEvent.SPLASH_RULES, onRulesFromSplashScreen);
		}
		
		private function removeSplashScreenEvents():void {
			splashScreen.removeEventListener(CustomEvent.SPLASH_PLAY, onStartGameFromSplashScreen);
			splashScreen.removeEventListener(CustomEvent.SPLASH_OPTIONS, onOptionsFromSplashScreen);
			splashScreen.removeEventListener(CustomEvent.SPLASH_RULES, onRulesFromSplashScreen);
		}
		
		private function onStartGameFromSplashScreen(e:CustomEvent):void 
		{
			removeSplashScreenEvents();
			removeSplashScreenToPlay();
		}
		
		private function removeSplashScreenToPlay():void {
			//splashScreen.visible = false;
			removeChild(splashScreen);
			splashScreen = null;
			
			initGame();
		}
		
		private function onOptionsFromSplashScreen(e:CustomEvent):void 
		{
			iAmInMainScreen = false;
			iAmInOptionsScreen = true;
			
			trace("OPTIONS SCREEN Options... FX: "+saveOptionsAndScores.readSoundFx()+" MUSIC: "+saveOptionsAndScores.readBackgroundSound());
			optionsScreen = new OptionsScreen(_stageWidth, _stageHeight, saveOptionsAndScores.readSoundFx(), saveOptionsAndScores.readBackgroundSound());
			addChild(optionsScreen);
			
			removeChild(splashScreen);
			splashScreen = null;
			
			addOptionsScreenEvents();
		}
		
		private function addOptionsScreenEvents():void 
		{
			optionsScreen.addEventListener(CustomEvent.OPTIONS_SOUNDFX, onOptionsSoundFxHandler);
			optionsScreen.addEventListener(CustomEvent.OPTIONS_BACKGROUND_MUSIC, onOptionsMusicBackgroundHandler);
			optionsScreen.addEventListener(CustomEvent.OPTIONS_GO_BACK, onOptionsGoBackHandler);
		}
		
		private function onOptionsGoBackHandler(e:CustomEvent=null):void 
		{
			removeOptionsScreenEvents();
				
			removeChild(optionsScreen);
			optionsScreen = null;
			
			showSplashScreen();
		}
		
		private function removeOptionsScreenEvents():void 
		{
			optionsScreen.removeEventListener(CustomEvent.OPTIONS_SOUNDFX, onOptionsSoundFxHandler);
			optionsScreen.removeEventListener(CustomEvent.OPTIONS_BACKGROUND_MUSIC, onOptionsMusicBackgroundHandler);
			optionsScreen.removeEventListener(CustomEvent.OPTIONS_GO_BACK, onOptionsGoBackHandler);
		}
		
		private function onOptionsMusicBackgroundHandler(e:CustomEvent):void 
		{
			if (soundBackgroundMusic) {
				//turnOnOffMusicBackground(false);
				soundBackgroundMusic = false;
			}else {
				//turnOnOffMusicBackground(true);
				soundBackgroundMusic = true;
			}
			
			saveSoundOptions();
		}
		
		private function onOptionsSoundFxHandler(e:CustomEvent):void 
		{
			if (soundEffects) {
				//turnOnOffFxSounds(false);
				soundEffects = false;
			}else {
				//turnOnOffFxSounds(true);
				soundEffects = true;
			}
			
			saveSoundOptions();
		}
		
		private function saveSoundOptions():void 
		{
			saveOptionsAndScores.saveOptions(soundEffects, soundBackgroundMusic);
		}
		
		private function onRulesFromSplashScreen(e:CustomEvent):void 
		{
			rulesScreen = new RulesScreen(_stageWidth, _stageHeight);
			addChild(rulesScreen);
			
			removeChild(splashScreen);
			splashScreen = null;
			
			addRulesScreenEvents();
		}
		
		private function addRulesScreenEvents():void 
		{
			rulesScreen.addEventListener(CustomEvent.RULES_GO_BACK, onRulesGoBackHandler);
		}
		
		private function onRulesGoBackHandler(e:CustomEvent):void 
		{
			rulesScreen.removeEventListener(CustomEvent.RULES_GO_BACK, onRulesGoBackHandler);
				
			removeChild(rulesScreen);
			rulesScreen = null;
			
			showSplashScreen();
		}
		
		private function initGame():void {
			
			iAmInMainScreen = false;
			iAmInOptionsScreen = false;
			iAmPlaying = true;
			
			//BACKGROUND
			background.scaleX = background.scaleY = ((456 * _stageWidth) / 480) / 456;
			addChild(background);
			
			//BACGROUND ARROWS
			arrowsBackground.x = 0;
			arrowsBackground.y = 0;
			arrowsBackground.scaleX = arrowsBackground.scaleY = ((480 * _stageWidth) / 480) / 480;
			arrowsBackground.visible = false;
			addChild(arrowsBackground);
			
			//SCORE
			score = new Score(scaleFactor, _stageWidth);
			initializeScoreAndHighScore();
			addChild(score);
			
			//INITIALIZE RECTANGLES FOR TAPPING
			rectangleManager = new ManageRectangles(_stageWidth, _stageHeight, score.scoreTxHeight);
			addChild(rectangleManager);
			rectangleManager.addEventListener(CustomEvent.TIMED_OVERLAY_START, startTimedOverlay);
			rectangleManager.addEventListener(CustomEvent.TIMED_OVERLAY_HIDE, removeOverlay);
			rectangleManager.addEventListener(CustomEvent.STATIC_OVERLAY_HIDE, onStaticOverlayHide);
			rectangleManager.addEventListener(CustomEvent.STATIC_OVERLAY_START, onStaticOverlayShow);
			rectangleManager.addEventListener(CustomEvent.ARROWS_BACKGROUND_HIDE, arrowsBacgroundHide);
			rectangleManager.addEventListener(CustomEvent.ARROWS_BACKGROUND_SHOW, arrowsBacgroundShow);
			rectangleManager.addEventListener(CustomEvent.ARROWS_BACKGROUND_FLIP, arrowsBacgroundFlip);
			rectangleManager.addEventListener(CustomEvent.GAMEOVER_SHOW, showGameOverOverlay);
			rectangleManager.addEventListener(CustomEvent.BACKGROUND_CHANGE_COLOR, onBackgroundColorChange);
			rectangleManager.addEventListener(CustomEvent.SCORE_ADD, onScoreAdd);
			rectangleManager.addEventListener(CustomEvent.SCORE_CHECK_HIGHSCORE, onCheckAndSaveHighScore);
			rectangleManager.addEventListener(CustomEvent.LEVEL_CHECK_COLOR, onLevelCheckColor);
			rectangleManager.addEventListener(CustomEvent.SOUND_PLAY_SFX, onPlaySfxSoundHandler);
			
			//Initializes levels and scores values
			setLevelValues();
			
			//Overlay prevents tapping while rectangles show up
			simpleOverlay = new SimpleOverlay(_stageWidth, _stageHeight);
			simpleOverlay.scaleY = stage.fullScreenHeight / stage.stageHeight;
			addChild(simpleOverlay);
			
			//Timed overlay. Prevents tapping while countdown so that user can have time to think
			overlayTimer = new TimerOverlay(_stageWidth, _stageHeight, timeToOverlay);
			overlayTimer.visible = false;
			addChild(overlayTimer);
			
			//Starts first rectangle round
			rectangleManager.repositionRectangles();
		}
		
		private function onPlaySfxSoundHandler(e:CustomEvent):void 
		{
			soundControl.playSFX();
		}
		
		private function onLevelCheckColor(e:CustomEvent=null):void 
		{
			levelsAndTimes.checkLevelFromScore(score.getScore());
			levelsAndTimes.checkColorFromScore(score.getScore());
			
			rectangleManager.colorsArray = levelsAndTimes.returnColorArray();
			rectangleManager.numberRectangles = levelsAndTimes.numberOfRectanglesInLevel();
			rectangleManager.changeOrder = levelsAndTimes.returnDescendingOrder();
			rectangleManager.scramble = levelsAndTimes.returnScrambleRectangle();
			
			background.changeBackgroundColor(levelsAndTimes.returnBackgroundColor(score.getScore()));
		}
		
		private function onStaticOverlayShow(e:CustomEvent):void 
		{
			simpleOverlay.visible = true;
		}
		
		private function onStaticOverlayHide(e:CustomEvent):void 
		{
			simpleOverlay.visible = false;
		}
		
		private function onScoreAdd(e:CustomEvent):void 
		{
			score.addToScore(10);
		}
		
		private function onBackgroundColorChange(e:CustomEvent):void 
		{
			background.changeBackgroundColor(levelsAndTimes.returnBackgroundColor(score.getScore()));
		}
		
		private function arrowsBacgroundFlip(e:CustomEvent):void 
		{
			arrowsBackground.flipArrows(rectangleManager.randomAscOrDesc);
		}
		
		private function arrowsBacgroundShow(e:CustomEvent):void 
		{
			arrowsBackground.visible = true;
		}
		
		private function arrowsBacgroundHide(e:CustomEvent):void 
		{
			arrowsBackground.visible = false;
		}
		
		/**
		 * Initailizes the Levels class
		 */
		private function setLevelValues():void {
			rectangleManager.timeBetweenRectanglesInSequence = levelsAndTimes.timeBetweenRectanglesInLevel();
			timeToOverlay = levelsAndTimes.timeToOverlayInLevel();
			timeToFinish = levelsAndTimes.returnTimeToFinish();
			rectangleManager.numberRectangles = levelsAndTimes.numberOfRectanglesInLevel();
			rectangleManager.changeOrder = levelsAndTimes.returnDescendingOrder();
		}
		
		/**
		 * Initialize Score and checks for HighScore value
		 */
		private function initializeScoreAndHighScore():void 
		{
			score.changeScore(0);
			score.changeHiScore(saveOptionsAndScores.readHighScore());
		}
		
		private function onCheckAndSaveHighScore(evt:CustomEvent):void 
		{
			if (saveOptionsAndScores.readHighScore() < score.getScore()) {
				saveOptionsAndScores.saveHighScore(score.getScore());
				newHighScore = true;
			}
		}
		
		/**
		 * Besides starting the timer to let the player tap, checks is the positions are to be scrambled.
		 * If yes starts a new timer that will triger 0.5s before the tap timer finishes.
		 * @param	evt
		 */
		private function startTimedOverlay(evt:CustomEvent):void 
		{
			if (levelsAndTimes.returnScrambleRectangle()) {
				var time:Number = timeToOverlay - 500;
				scrambleTimer = new Timer(time,1);
				scrambleTimer.addEventListener(TimerEvent.TIMER, onScrambleTimerHandler);
				scrambleTimer.start();
			}
			
			overlayTimer.timeValue = levelsAndTimes.timeToOverlayInLevel();
			overlayTimer.visible = true;
			overlayTimer.addEventListener(CustomEvent.TIMER_OFF, removeOverlay);
			overlayTimer.startTimer();
		}
		
		/**
		 * When the scramble timer triggers, order the rectamgle manager to scramble the positions
		 * @param	e
		 */
		private function onScrambleTimerHandler(e:TimerEvent):void 
		{
			scrambleTimer.stop();
			scrambleTimer.removeEventListener(TimerEvent.TIMER, onScrambleTimerHandler);
			
			rectangleManager.generateScramblePosition();
		}
		
		private function removeOverlay(e:CustomEvent):void 
		{
			overlayTimer.removeEventListener(CustomEvent.TIMER_OFF, removeOverlay);
			
			for (var i:Number = 0; i < rectangleManager.numberRectangles; i++) {
				rectangleManager.rectangleArray[i].changeRectangleColor();
			}
			
			overlayTimer.visible = false;
		}
		
		private function showGameOver():void 
		{
			removeRectangles(false);
			arrowsBackground.visible = false;
			score.visible = false;
			
			showGameOverOverlay();
		}
		
		private function showGameOverOverlay(evt:CustomEvent=null):void 
		{
			if (newHighScore) {
				score.changeHiScore(saveOptionsAndScores.readHighScore());
			}
			
			score.visible = false;
			
			gameOver = new GameOver(_stageWidth, _stageHeight, levelsAndTimes.returnColorArray() , newHighScore, score.getScore(), scaleFactor);
			addChild(gameOver);
			
			gameOver.addEventListener(CustomEvent.PLAY_AGAIN, onPlayAgainHandlers);
			gameOver.addEventListener(CustomEvent.EXIT_APPLICATION, onExitHandlers);
			gameOver.addEventListener(CustomEvent.GAMEOVER_GOTO_MAINSCREEN, onGotoMainscreenHandler);
			gameOver.addEventListener(CustomEvent.GAMEOVER_FACEBOOK_SHARE, onFacebookShare);
		}
		
		private function onFacebookShare(e:CustomEvent):void 
		{
			facebook = new FacebookConnect(_stageWidth, _stageHeight, this.stage);
			facebook.addEventListener(CustomEvent.FACEBOOK_READY_TO_POST, onFacebookReadyToPostoHandler);
		}
		
		private function onFacebookReadyToPostoHandler(e:CustomEvent):void 
		{
			facebook.postToFacebook(score.getScore());
		}
		
		private function onGotoMainscreenHandler(e:CustomEvent):void 
		{
			gameOver.removeEventListener(CustomEvent.PLAY_AGAIN, onPlayAgainHandlers);
			gameOver.removeEventListener(CustomEvent.EXIT_APPLICATION, onExitHandlers);
			gameOver.removeEventListener(CustomEvent.GAMEOVER_GOTO_MAINSCREEN, onGotoMainscreenHandler);
			gameOver.removeEventListener(CustomEvent.GAMEOVER_FACEBOOK_SHARE, onFacebookShare);
			
			score.resetScore();
			onLevelCheckColor();
			
			newHighScore = false;
			removeChild(gameOver);
			score.visible = false;
			
			showSplashScreen();
		}
		
		private function onPlayAgainHandlers(e:CustomEvent):void 
		{
			gameOver.removeEventListener(CustomEvent.PLAY_AGAIN, onPlayAgainHandlers);
			gameOver.removeEventListener(CustomEvent.EXIT_APPLICATION, onExitHandlers);
			gameOver.removeEventListener(CustomEvent.GAMEOVER_GOTO_MAINSCREEN, onGotoMainscreenHandler);
			
			var rectsInScreen:Number = rectangleManager.rectangleArray.length;
			
			score.resetScore();
			onLevelCheckColor();
			setLevelValues();
			
			
			newHighScore = false;
			removeChild(gameOver);
			score.visible = true;
			
			rectangleManager.rectangleGeneratorAuxCounter = 0; //Resets Rectangle counter
			rectangleManager.addTimerRecallGeneratorAndPause();
			
			rectangleManager.removeRectangles(rectsInScreen);
			
			rectangleManager.repositionRectangles();
		}
		
		private function removeRectangles(reposition:Boolean=true):void 
		{
			//MonsterDebugger.trace(this,"REMOVE RECTANGLES");
			var rectsInScreen:Number = rectangleManager.rectangleArray.length;
			
			rectangleManager.removeRectangles(rectsInScreen);
			
			if (reposition) {
				rectangleManager.addTimerRecallGeneratorAndPause();
				rectangleManager.repositionRectangles();
			}
		}
		
		private function onExitHandlers(evt:CustomEvent):void {
			NativeApplication.nativeApplication.exit();
		}
		
		private function handleActivate(event:Event):void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			soundControl.playBackgroundMusic();
		}
		 
		private function handleDeactivate(event:Event):void
		{
			//NativeApplication.nativeApplication.exit();
			soundControl.stopBackgroundMusic();
			soundControl.stopSfx();
		}
		 
		private function handleKeys(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.BACK) {
				if (iAmInMainScreen) {
					NativeApplication.nativeApplication.exit();
				}else if (iAmInOptionsScreen) {
					iAmInMainScreen = true;
					onOptionsGoBackHandler();
				}else if (iAmPlaying) {
					iAmInMainScreen = true;
					//NativeApplication.nativeApplication.exit();
				}
			}
		}
		
		function exitHandler(event:Event):void
		{
			event.preventDefault();
		}
	}
}