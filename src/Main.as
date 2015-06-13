
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
	import flash.display.StageQuality;
	
	import com.greensock.*; 
	import com.greensock.easing.*;
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class Main extends MovieClip 
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
		
		//private var preventLoopCounter:Number = 0;
		
		private var overlayTimer:TimerOverlay;
		private var simpleOverlay:SimpleOverlay;
		private var scrambleTimer:Timer;
		
		private var background:Background = new Background();
		private var arrowsBackground:Arrows = new Arrows();
		
		private var splashScreen:InitSplashScreen;
		private var optionsScreen:OptionsScreen;
		private var rulesScreen:RulesScreen;
		private var continueScreen:ContinueGame;
		
		private var soundEffects:Boolean;
		private var soundBackgroundMusic:Boolean;
		private var showLevelsInfo:Boolean;
		
		private var lifeIndicator:LifeIndicator;
		private var continueGame:ContinueGame;
		private var infoRules:InfoScreen;
		private var levelsInfoDisplay:Boolean = true;
		
		private var saveOptionsAndScores:SaveOptions = new SaveOptions();
		private var checkConnection:CheckInternetConnection = new CheckInternetConnection();
		private var connectionFeedback:ConnectionFeedback;
		private var connectionAlreadyChecked:Boolean = false;
		private var timerToShowFeedback:Timer;
		private var dataSavedOnline:Boolean = false;
		private var gameOver:GameOver;
		private var newHighScore:Boolean = false;
		
		private var scaleFactor:Number;
		private var densityScale:Number;
		
		//SOUND
		private var soundControl:SoundControl = new SoundControl();
		
		//FACEBOOK
		private var facebook:FacebookConnect;
		//private var googlePlay:GoogleServices;
		
		//TIMER
		private var gameActionTimer:TimeManager;
		private var elapsedTime:int;
		private var playTimer:TimerArc;
		
		public function Main():void {
			stage.quality = StageQuality.LOW;
			
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
			
			addChild(soundControl);
			
			shouldIStarBackgroundMusic();
			shouldIhaveSFXSound();
			shouldISeeLevelsInfo();
			
			showSplashScreen();
		}
		
		/**
		 * Show INITIAL SCREEN
		 */
		private function showSplashScreen():void 
		{
			
			//splashScreen.scaleX = splashScreen.scaleY = ((456 * _stageWidth) / 480) / 456;
			splashScreen = new InitSplashScreen(_stageWidth, _stageHeight);
			addChild(splashScreen);
			addSplashScreenEvents();
			
			/*connectionFeedback = new ConnectionFeedback(_stageWidth, _stageHeight);
			connectionFeedback.setMessageType(0);
			addChild(connectionFeedback);*/
			
			//addCheckConnectionEvent();
			//checkConnection.start();
		}
		
		private function shouldIhaveSFXSound():void 
		{
			if (saveOptionsAndScores.readSoundFx()) {
				soundControl.enablePlaySFX();
			}else {
				soundControl.disablePlaySFX();
			}
		}
		
		private function shouldISeeLevelsInfo():void 
		{
			if (saveOptionsAndScores.readLevelsInfo()) {
				levelsInfoDisplay = true;
			}else {
				levelsInfoDisplay = false;
			}
		}
		
		private function shouldIStarBackgroundMusic():void 
		{
			if (saveOptionsAndScores.readBackgroundSound()) {
				soundControl.playBackgroundMusic();
			}
		}
		
		//-------------------------------------------------------------------------------------------------
		//
		//  CONNECTION CHECKS
		//
		//-------------------------------------------------------------------------------------------------
		private function addCheckConnectionEvent():void 
		{
			checkConnection.addEventListener(CustomEvent.CONNECTION_AVAILABLE, onConnectionAvailableHandler);
			checkConnection.addEventListener(CustomEvent.CONNECTION_NOT_AVAILABLE, onConnectionNotAvailableHandler);
			//checkConnection.addEventListener(CustomEvent.CONNECTION_VALUES_SAVED, onConnectionSaveValuesHandler);
		}
		
		/*private function onConnectionSaveValuesHandler(e:CustomEvent):void 
		{
			
			
		}*/
		
		private function onConnectionNotAvailableHandler(e:CustomEvent):void 
		{
			connectionFeedback.setMessageType(2);
			
			timerToShowFeedback = new Timer(2000, 1);
			timerToShowFeedback.addEventListener(TimerEvent.TIMER, onConnectionFeedbackTimerHandler);
			timerToShowFeedback.start();
		}
		
		private function onConnectionAvailableHandler(e:CustomEvent):void 
		{
			connectionFeedback.setMessageType(1);
			
			timerToShowFeedback = new Timer(2000, 1);
			timerToShowFeedback.addEventListener(TimerEvent.TIMER, onConnectionFeedbackTimerHandler);
			timerToShowFeedback.start();
		}
		
		private function onConnectionFeedbackTimerHandler(e:TimerEvent):void 
		{
			timerToShowFeedback.removeEventListener(TimerEvent.TIMER, onConnectionFeedbackTimerHandler);
			removeChild(connectionFeedback);
		}
		
		//-------------------------------------------------------------------------------------------------
		//
		//  GAME SPARKS
		//
		//-------------------------------------------------------------------------------------------------
		//Callback to handle when the SDK is available and ready to go
		/*private function gameSparksAvailabilityCallback(isAvailable : Boolean):void{
			trace("availabilityCallback " + isAvailable);
		 
			if(isAvailable){
			   GameSparksMethods.authenticationRequest("userName", "password", handleAuthenticationResponse);
			}
		}
		
		public function handleAuthenticationResponse(response:Object):void {
			trace("handleAuthenticationResponse:" + JSON.stringify(response));
		}
		
		public static function customLogEventRequest(eventKey:String, intAttr:int, stringAttr:String, jsonAttr:Object, callback:Function ) : void
		{
			var request:Object = new Object();
			request["@class"] = ".LogEventRequest";
			request["FIRST_EVENT"] = eventKey;
			request["NUMBER_ATTR"] = intAttr;
			request["STRING_ATTR"] = stringAttr;
			request["JSON_ATTR"] = jsonAttr;
			
			GameSparks.getInstance().sendRequest(request, callback);
		}*/
		
		//-------------------------------------------------------------------------------------------------
		//
		//  INITIAL SCREEN
		//
		//-------------------------------------------------------------------------------------------------
		
		/**
		 * Add events to splash screen
		 */
		private function addSplashScreenEvents():void {
			splashScreen.addEventListener(CustomEvent.SPLASH_PLAY, onStartGameFromSplashScreen);
			splashScreen.addEventListener(CustomEvent.SPLASH_OPTIONS, onOptionsFromSplashScreen);
			splashScreen.addEventListener(CustomEvent.SPLASH_RULES, onRulesFromSplashScreen);
		}
		
		/**
		 * Remove splash screen events
		 */
		private function removeSplashScreenEvents():void {
			splashScreen.removeEventListener(CustomEvent.SPLASH_PLAY, onStartGameFromSplashScreen);
			splashScreen.removeEventListener(CustomEvent.SPLASH_OPTIONS, onOptionsFromSplashScreen);
			splashScreen.removeEventListener(CustomEvent.SPLASH_RULES, onRulesFromSplashScreen);
		}
		
		/**
		 * Start game from splash screen
		 * @param	e
		 */
		private function onStartGameFromSplashScreen(e:CustomEvent):void 
		{
			removeSplashScreenEvents();
			removeSplashScreenToPlay();
		}
		
		/**
		 * Remove splash screen
		 */
		private function removeSplashScreenToPlay():void {
			removeChild(splashScreen);
			splashScreen = null;
			
			initGame();
		}
		
		//-------------------------------------------------------------------------------------------------
		//
		//  OPTIONS SCREEN
		//
		//-------------------------------------------------------------------------------------------------
		
		/**
		 * Start Options screen from splash screen
		 * @param	e
		 */
		private function onOptionsFromSplashScreen(e:CustomEvent):void 
		{	
			//trace("OPTIONS SCREEN Options... FX: " + saveOptionsAndScores.readSoundFx() + " MUSIC: " + saveOptionsAndScores.readBackgroundSound());
			soundEffects = saveOptionsAndScores.readSoundFx();
			soundBackgroundMusic = saveOptionsAndScores.readBackgroundSound();
			
			optionsScreen = new OptionsScreen(_stageWidth, _stageHeight, saveOptionsAndScores.readSoundFx(), saveOptionsAndScores.readBackgroundSound());
			addChild(optionsScreen);
			
			removeChild(splashScreen);
			splashScreen = null;
			
			addOptionsScreenEvents();
		}
		
		/**
		 * Add events to Options screen
		 */
		private function addOptionsScreenEvents():void 
		{
			optionsScreen.addEventListener(CustomEvent.OPTIONS_SOUNDFX_ON, function(evt:CustomEvent) { onOptionsSoundFxOnHandler(1); });
			optionsScreen.addEventListener(CustomEvent.OPTIONS_SOUNDFX_OFF, function(evt:CustomEvent) { onOptionsSoundFxOnHandler(0); });
			optionsScreen.addEventListener(CustomEvent.OPTIONS_BACKGROUND_MUSIC_ON, function(evt:CustomEvent) { onOptionsMusicBackgroundHandler(1); });
			optionsScreen.addEventListener(CustomEvent.OPTIONS_BACKGROUND_MUSIC_OFF, function(evt:CustomEvent) { onOptionsMusicBackgroundHandler(0); } );
			optionsScreen.addEventListener(CustomEvent.OPTIONS_LEVELS_INFO_ON, function(evt:CustomEvent) { onOptionsLevelsInfoHandler(1); } );
			optionsScreen.addEventListener(CustomEvent.OPTIONS_LEVELS_INFO_OFF, function(evt:CustomEvent) { onOptionsLevelsInfoHandler(0); } );
			optionsScreen.addEventListener(CustomEvent.OPTIONS_GO_BACK, onOptionsGoBackHandler);
		}
		
		/**
		 * Remove events from Options screen
		 */
		private function removeOptionsScreenEvents():void 
		{
			optionsScreen.removeEventListener(CustomEvent.OPTIONS_SOUNDFX_ON, function(evt:CustomEvent) { onOptionsSoundFxOnHandler(1); } );
			optionsScreen.removeEventListener(CustomEvent.OPTIONS_SOUNDFX_OFF, function(evt:CustomEvent) { onOptionsSoundFxOnHandler(0); });
			optionsScreen.removeEventListener(CustomEvent.OPTIONS_BACKGROUND_MUSIC_ON, function(evt:CustomEvent) { onOptionsMusicBackgroundHandler(1); });
			optionsScreen.removeEventListener(CustomEvent.OPTIONS_BACKGROUND_MUSIC_OFF, function(evt:CustomEvent) { onOptionsMusicBackgroundHandler(0); } );
			optionsScreen.removeEventListener(CustomEvent.OPTIONS_LEVELS_INFO_ON, function(evt:CustomEvent) { onOptionsLevelsInfoHandler(1); } );
			optionsScreen.removeEventListener(CustomEvent.OPTIONS_LEVELS_INFO_OFF, function(evt:CustomEvent) { onOptionsLevelsInfoHandler(0); } );
			optionsScreen.removeEventListener(CustomEvent.OPTIONS_GO_BACK, onOptionsGoBackHandler);
		}
		
		/**
		 * Background Sound Fx options handler
		 * @param	e
		 */
		private function onOptionsSoundFxOnHandler(value:Number):void 
		{
			if (value==1) {
				soundEffects = true;
				soundControl.enablePlaySFX();
			}else {
				soundEffects = false;
				soundControl.disablePlaySFX();
			}
			
			saveSoundOptions();
		}
		
		/**
		 * Background music options handler
		 * @param	e
		 */
		private function onOptionsMusicBackgroundHandler(value:Number):void 
		{
			if (value == 1) {
				soundBackgroundMusic = true;
				soundControl.playBackgroundMusic();
			}else {
				soundBackgroundMusic = false;
				soundControl.stopBackgroundMusic();
			}
			
			saveSoundOptions();
		}
		
		private function onOptionsLevelsInfoHandler(value:Number):void 
		{
			if (value==1) {
				levelsInfoDisplay = true;
			}else {
				levelsInfoDisplay = false;
			}
			
			saveLevelsInfoOptions();
		}
		
		/**
		 * Go back to Splash screen from Options
		 * @param	e
		 */
		private function onOptionsGoBackHandler(e:CustomEvent=null):void 
		{
			removeOptionsScreenEvents();
			
			removeChild(optionsScreen);
			optionsScreen = null;
			
			showSplashScreen();
		}
		
		/**
		 * Save sound options
		 */
		private function saveSoundOptions():void 
		{
			saveOptionsAndScores.saveOptions(soundEffects, soundBackgroundMusic);
		}
		
		private function saveLevelsInfoOptions():void 
		{
			saveOptionsAndScores.saveLevelsOptions(levelsInfoDisplay);
		}
		
		//-------------------------------------------------------------------------------------------------
		//
		//  RULES SCREEN
		//
		//-------------------------------------------------------------------------------------------------
		
		/**
		 * Show up Rules screen from splash screen
		 * @param	e
		 */
		private function onRulesFromSplashScreen(e:CustomEvent):void 
		{
			rulesScreen = new RulesScreen(_stageWidth, _stageHeight);
			addChild(rulesScreen);
			
			removeChild(splashScreen);
			splashScreen = null;
			
			addRulesScreenEvents();
		}
		
		/**
		 * Add events to rules screen
		 */
		private function addRulesScreenEvents():void 
		{
			rulesScreen.addEventListener(CustomEvent.RULES_GO_BACK, onRulesGoBackHandler);
		}
		
		/**
		 * Go back to splash screen from rules screen
		 * @param	e
		 */
		private function onRulesGoBackHandler(e:CustomEvent):void 
		{
			rulesScreen.removeEventListener(CustomEvent.RULES_GO_BACK, onRulesGoBackHandler);
				
			removeChild(rulesScreen);
			rulesScreen = null;
			
			showSplashScreen();
		}
		
		//-------------------------------------------------------------------------------------------------
		//
		//  INITIALIZE GAME
		//
		//-------------------------------------------------------------------------------------------------
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
			
			//LIFE INDICATOR
			lifeIndicator = new LifeIndicator(_stageWidth, _stageHeight);
			addChild(lifeIndicator);
			
			//INITIALIZE RECTANGLES FOR TAPPING
			rectangleManager = new ManageRectangles(_stageWidth, _stageHeight, score.scoreTxHeight);
			addChild(rectangleManager);
			rectangleManager.addEventListener(CustomEvent.TIMED_OVERLAY_START, startTimedOverlay);
			rectangleManager.addEventListener(CustomEvent.TIMED_OVERLAY_HIDE, removeOverlay);
			rectangleManager.addEventListener(CustomEvent.STATIC_OVERLAY_HIDE, onStaticOverlayHide);
			rectangleManager.addEventListener(CustomEvent.STATIC_OVERLAY_START, onStaticOverlayShow);
			rectangleManager.addEventListener(CustomEvent.ARROWS_BACKGROUND_HIDE, arrowsBackgroundHide);
			rectangleManager.addEventListener(CustomEvent.ARROWS_BACKGROUND_SHOW, arrowsBackgroundShow);
			rectangleManager.addEventListener(CustomEvent.ARROWS_BACKGROUND_FLIP, arrowsBackgroundFlip);
			rectangleManager.addEventListener(CustomEvent.GAMEOVER_SHOW, showGameOverOverlay);
			rectangleManager.addEventListener(CustomEvent.BACKGROUND_CHANGE_COLOR, onBackgroundColorChange);
			rectangleManager.addEventListener(CustomEvent.SCORE_ADD, onScoreAdd);
			rectangleManager.addEventListener(CustomEvent.SCORE_CHECK_HIGHSCORE, onCheckAndSaveHighScore);
			rectangleManager.addEventListener(CustomEvent.SCORE_SAVE_LAST_LEVEL_SCORE, onSaveLastLevelScore);
			rectangleManager.addEventListener(CustomEvent.LEVEL_CHECK_COLOR, onLevelCheckColor);
			rectangleManager.addEventListener(CustomEvent.SOUND_PLAY_SFX, onPlaySfxSoundHandler);
			rectangleManager.addEventListener(CustomEvent.LIFE_LOST, onLifeLostHandler);
			rectangleManager.addEventListener(CustomEvent.INFO_CHECK, onInfoCheckHandler);
			
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
		
		/**
		 * Saves the last score when user completes a screen
		 * @param	e
		 */
		private function onSaveLastLevelScore(e:CustomEvent):void 
		{
			removePlayTimer();
			levelsAndTimes.scoreBeforeNewScreen = score.getScore();
			
		}
		
		/**
		 * Player made wrong order. Loses a life
		 * @param	e
		 */
		private function onLifeLostHandler(e:CustomEvent=null):void 
		{
			levelsAndTimes.lifes--;
			
			if (levelsAndTimes.lifes == 0) {
				arrowsBackground.visible = false;
				rectangleManager.showGameOver();
			}else {
				lifeIndicator.decreaseLife();
			}
		}
		
		private function continueGameAfterTimerOut():void 
		{
			onLifeLostHandler();
			
			if (levelsAndTimes.lifes != 0) {
				continueGame = new ContinueGame(_stageWidth, _stageHeight, levelsAndTimes.lifes, levelsAndTimes.returnColorArray());
				continueGame.addEventListener(CustomEvent.CONTINUE_GAME, onContinueGamehandler);
				addChild(continueGame);
			}
		}
		
		/**
		 * If user still has lifes to spare, can continue play
		 * @param	e
		 */
		private function onContinueGamehandler(e:CustomEvent):void 
		{
			continueGame.removeEventListener(CustomEvent.CONTINUE_GAME, onContinueGamehandler);
			removeChild(continueGame);
			
			var rectsInScreen:Number = rectangleManager.rectangleArray.length;
			
			onLevelCheckColor();
			
			rectangleManager.rectangleGeneratorAuxCounter = 0; //Resets Rectangle counter
			rectangleManager.addTimerRecallGeneratorAndPause();
			
			rectangleManager.removeRectangles(rectsInScreen);
			
			simpleOverlay.visible = true;
			
			rectangleManager.repositionRectangles();
		}
		
		/**
		 * Sound Controller
		 * @param	e
		 */
		private function onPlaySfxSoundHandler(e:CustomEvent):void 
		{
			soundControl.playSFX();
		}
		
		/**
		 * Goto main screen from Game Over
		 * @param	e
		 */
		private function onGotoMainscreenHandler(e:CustomEvent):void 
		{
			gameOver.removeEventListener(CustomEvent.PLAY_AGAIN, onPlayAgainHandlers);
			gameOver.removeEventListener(CustomEvent.EXIT_APPLICATION, onExitHandlers);
			gameOver.removeEventListener(CustomEvent.GAMEOVER_GOTO_MAINSCREEN, onGotoMainscreenHandler);
			gameOver.removeEventListener(CustomEvent.GAMEOVER_FACEBOOK_SHARE, onFacebookShare);
			
			levelsAndTimes.lifes = 3;
			lifeIndicator.reset();
			rectangleManager.lifes = 3;
			
			score.resetScore();
			onLevelCheckColor();
			
			setLevelValues();
			
			newHighScore = false;
			removeChild(gameOver);
			lifeIndicator.hide();
			score.visible = false;
			
			showSplashScreen();
		}
		
		/**
		 * Play again from Game Over
		 * @param	e
		 */
		private function onPlayAgainHandlers(e:CustomEvent):void 
		{
			gameOver.removeEventListener(CustomEvent.PLAY_AGAIN, onPlayAgainHandlers);
			gameOver.removeEventListener(CustomEvent.EXIT_APPLICATION, onExitHandlers);
			gameOver.removeEventListener(CustomEvent.GAMEOVER_GOTO_MAINSCREEN, onGotoMainscreenHandler);
			
			simpleOverlay.visible = true;
			
			var rectsInScreen:Number = rectangleManager.rectangleArray.length;
			
			levelsAndTimes.lifes = 3;
			lifeIndicator.reset();
			score.resetScore();
			onLevelCheckColor();
			setLevelValues();
			
			
			newHighScore = false;
			removeChild(gameOver);
			score.visible = true;
			lifeIndicator.show();
			
			rectangleManager.rectangleGeneratorAuxCounter = 0; //Resets Rectangle counter
			rectangleManager.lifes = 3;
			rectangleManager.addTimerRecallGeneratorAndPause();
			
			rectangleManager.removeRectangles(rectsInScreen);
			
			simpleOverlay.visible = true;
			
			rectangleManager.repositionRectangles();
		}
		
		//-------------------------------------------------------------------------------------------------
		//
		//  INFO SCREEN
		//
		//-------------------------------------------------------------------------------------------------
		private function onInfoCheckHandler(e:CustomEvent):void 
		{
			var returnInfoAux:Number = levelsAndTimes.returnInfo();
			
			if (returnInfoAux != 0) { //Check if there is a screen for this level
				if (levelsAndTimes.returnIfPositionWasUsed(returnInfoAux) || !levelsInfoDisplay) { //Check if the screen was used already. E.g. lost a life in first screen for the level, or going to the 2nd screen
					//Also checks if the global options to show the level info is ON or OFF
					simpleOverlay.visible = true;
					rectangleManager.repositionRectangles();
				}else {
					levelsAndTimes.setUsedScreen(returnInfoAux);
					onInfoRulesScreen();
				}
			}else {
				simpleOverlay.visible = true;
				rectangleManager.repositionRectangles();
			}
		}
		
		private function onInfoRulesScreen():void {
			infoRules = new InfoScreen(_stageWidth, _stageHeight, levelsAndTimes.returnInfo(), levelsAndTimes.returnColorArray());
			infoRules.addEventListener(CustomEvent.INFO_OK, onInfoRulesOkHandler);
			addChild(infoRules);
		}
		
		private function onInfoRulesOkHandler(e:CustomEvent):void 
		{
			infoRules.removeEventListener(CustomEvent.INFO_OK, onInfoRulesOkHandler);
			removeChild(infoRules);
			infoRules = null;
			
			simpleOverlay.visible = true;
			
			rectangleManager.repositionRectangles();
		}
		
		/**
		 * Level initilaization
		 * @param	e
		 */
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
		
		/**
		 * Static Overlay. Prevents the user from tapping rectangles while these show in screen
		 * @param	e
		 */
		private function onStaticOverlayShow(e:CustomEvent):void 
		{	
			simpleOverlay.visible = true;
		}
		
		private function addBonusElapsedTimer():void 
		{
			score.addToScore(score.getScore() * levelsAndTimes.returnMultiplierForBonus());
			onPlayEndByUser();
			
		}
		/**
		 * Hides the static overlay
		 * @param	e
		 */
		private function onStaticOverlayHide(e:CustomEvent):void 
		{
			simpleOverlay.visible = false;
		}
		
		/**
		 * Adds to score if it is a correct tap
		 * @param	e
		 */
		private function onScoreAdd(e:CustomEvent):void 
		{
			score.addToScore(10);
		}
		
		/**
		 * Changes the level color in the background
		 * @param	e
		 */
		private function onBackgroundColorChange(e:CustomEvent):void 
		{
			background.changeBackgroundColor(levelsAndTimes.returnBackgroundColor(score.getScore()));
		}
		
		/**
		 * Flips the arrows animation in background
		 * @param	e
		 */
		private function arrowsBackgroundFlip(e:CustomEvent):void 
		{
			arrowsBackground.flipArrows(rectangleManager.randomAscOrDesc);
		}
		
		/**
		 * Shows the arrows animation in background
		 * @param	e
		 */
		private function arrowsBackgroundShow(e:CustomEvent):void 
		{
			arrowsBackground.enableParallax();
			arrowsBackground.visible = true;
		}
		
		/**
		 * Hides the arrows animation in background
		 * @param	e
		 */
		private function arrowsBackgroundHide(e:CustomEvent):void 
		{	
			arrowsBackground.visible = false;
			arrowsBackground.disableParallax();
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
		
		/**
		 * Checks if there's a new highscore and saves it locally
		 * @param	evt
		 */
		private function onCheckAndSaveHighScore(evt:CustomEvent=null):void 
		{
			//levelsAndTimes.scoreBeforeNewScreen = score.score;
			
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
		
		/**
		 * Hides the timed overlay
		 * @param	e
		 */
		private function removeOverlay(e:CustomEvent):void 
		{
			overlayTimer.removeEventListener(CustomEvent.TIMER_OFF, removeOverlay);
			
			for (var i:Number = 0; i < rectangleManager.numberRectangles; i++) {
				rectangleManager.rectangleArray[i].changeRectangleColor();
			}
			
			overlayTimer.visible = false;
			
			addAndStartPlayerTimer();
		}
		
		private function addAndStartPlayerTimer():void {
			//PLAY TIMER
			playTimer = new TimerArc(levelsAndTimes.returnTimeToTap(), levelsAndTimes.returnTimeToBonus(), levelsAndTimes.returnColorArray()[3]);
			playTimer.scaleX = playTimer.scaleY = ((30 * _stageWidth) / 480) / 30;
			playTimer.x = _stageWidth + 100 * ((10 * _stageWidth) / 480) / 10;
			playTimer.y = 30 * ((10 * _stageWidth) / 480) / 10;
			addChild(playTimer);
			
			playTimer.addEventListener(CustomEvent.TIMERARC_COUNTDOWN_END, onPlayTimeOverHandler);
			playTimer.addEventListener(CustomEvent.TIMERARC_TIMER_HIDE, onPlayEndByUser);
			
			
			TweenNano.to(playTimer, 0.5, { x:_stageWidth - 30 * ((10 * _stageWidth) / 480) / 10, ease:Bounce.easeOut } );
			playTimer.startTimer();
		}
		
		private function onPlayTimeOverHandler(e:CustomEvent):void 
		{
			TweenNano.to(playTimer, 0.5, { x:_stageWidth + 100 * ((10 * _stageWidth) / 480) / 10, ease:Bounce.easeOut, onComplete:removePlayTimer } );
			continueGameAfterTimerOut();
		}
		
		private function onPlayEndByUser(evt:CustomEvent=null):void 
		{
			TweenNano.to(playTimer, 0.5, { x:_stageWidth + 100 * ((10 * _stageWidth) / 480) / 10, ease:Bounce.easeOut, onComplete:removePlayTimer } );
		}
		
		private function removePlayTimer():void {
			
			if (playTimer) { //Prevents a 2nd call when the object was already removed. Happens when the timer goes out and when the Game Over screen needs to appear
				
				if (playTimer.isThereBonus() && levelsAndTimes.lifes!=0) {
					score.changeScore(Math.round(score.getScore() + (score.getScore() * levelsAndTimes.returnMultiplierForBonus())));
					onCheckAndSaveHighScore();
					
					//LIVE UP BONUS CALCULATION
					levelsAndTimes.completeUnderBonusTime++;
					
					if ((levelsAndTimes.completeUnderBonusTime % 10)==0 && rectangleManager.lifes<3 && levelsAndTimes.lifes<3) {
						lifeIndicator.increaseLife();
						rectangleManager.lifes++;
						levelsAndTimes.lifes++;
						levelsAndTimes.completeUnderBonusTime = 0;
					}
				}
				
				playTimer.removeEventListener(CustomEvent.TIMERARC_COUNTDOWN_END, onPlayTimeOverHandler);
				playTimer.removeEventListener(CustomEvent.TIMERARC_TIMER_HIDE, onPlayEndByUser);
				removeChild(playTimer);
				playTimer = null;
			}
			
		}
		
		/**
		 * Shows the Game Over screen
		 * @param	evt
		 */
		private function showGameOverOverlay(evt:CustomEvent=null):void 
		{
			if (newHighScore) {
				score.changeHiScore(score.getScore());//saveOptionsAndScores.readHighScore()
			}
			
			removePlayTimer();
			lifeIndicator.hide();
			score.visible = false;
			
			gameOver = new GameOver(_stageWidth, _stageHeight, levelsAndTimes.returnColorArray() , newHighScore, score.getScore(), scaleFactor);
			addChild(gameOver);
			
			gameOver.addEventListener(CustomEvent.PLAY_AGAIN, onPlayAgainHandlers);
			gameOver.addEventListener(CustomEvent.EXIT_APPLICATION, onExitHandlers);
			gameOver.addEventListener(CustomEvent.GAMEOVER_GOTO_MAINSCREEN, onGotoMainscreenHandler);
			gameOver.addEventListener(CustomEvent.GAMEOVER_FACEBOOK_SHARE, onFacebookShare);
		}
		
		//-------------------------------------------------------------------------------------------------
		//
		//  SOCIAL FACEBOOK AND GOOGLE PLAY
		//
		//-------------------------------------------------------------------------------------------------
		/**
		 * Shows the connection for social share
		 * @param	e
		 */
		private function onFacebookShare(e:CustomEvent):void 
		{
			trace("OPEN FACEBOOK LOGIN");
			facebook = new FacebookConnect(_stageWidth, _stageHeight, this.stage);
			facebook.addEventListener(CustomEvent.FACEBOOK_READY_TO_POST, onFacebookReadyToPostoHandler);
		}
		
		/**
		 * Facebook is ready to post. Send score
		 * @param	e
		 */
		private function onFacebookReadyToPostoHandler(e:CustomEvent):void 
		{
			facebook.postToFacebook(score.getScore());
		}
		
		/**
		 * Remove all the rectangles from screen by hiding and reposition
		 * @param	reposition
		 */
		private function removeRectangles(reposition:Boolean=true):void 
		{
			var rectsInScreen:Number = rectangleManager.rectangleArray.length;
			
			rectangleManager.removeRectangles(rectsInScreen);
			
			if (reposition) {
				simpleOverlay.visible = true;
				rectangleManager.addTimerRecallGeneratorAndPause();
				rectangleManager.repositionRectangles();
			}
		}
		
		/**
		 * On app exit handler
		 * @param	evt
		 */
		private function onExitHandlers(evt:CustomEvent):void {
			NativeApplication.nativeApplication.exit();
		}
		
		/**
		 * Handle app keep awake
		 * @param	event
		 */
		private function handleActivate(event:Event):void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			//soundControl.playBackgroundMusic();
		}
		 
		/**
		 * Handle app deactivation. Phone call?
		 * @param	event
		 */
		private function handleDeactivate(event:Event):void
		{
			soundControl.stopBackgroundMusic();
			soundControl.stopSfx();
			NativeApplication.nativeApplication.exit();
		}
		 
		/**
		 * Handle phone hardware keys or screen keys
		 * @param	event
		 */
		private function handleKeys(event:KeyboardEvent):void
		{
			NativeApplication.nativeApplication.exit();
		}
		
		/**
		 * Exit app function
		 * @param	event
		 */
		function exitHandler(event:Event):void
		{
			event.preventDefault();
		}
	}
}