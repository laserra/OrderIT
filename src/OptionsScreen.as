package src 
{
	import flash.display.MovieClip;
	import com.leonel.CustomEvent;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class OptionsScreen extends MovieClip 
	{
		private var _screenWidth:Number;
		private var _screenHeight:Number;
		
		private var overlay:Shape = new Shape();
		
		private var optionsText:OptionsText = new OptionsText();
		//private var soundFxCheck:CheckBoxMC = new CheckBoxMC();
		//private var backgroundMusic:CheckBoxMC = new CheckBoxMC();
		
		private var _fx:Boolean = true;
		private var _music:Boolean = true;
		private var _levelinfo:Boolean = true;
		
		private var goBackBt:GoBack = new GoBack();
		
		public function OptionsScreen(screenWidth:Number, screenHeight:Number, fx:Boolean, music:Boolean):void
		{
			super();
			
			_screenWidth = screenWidth;
			_screenHeight = screenHeight;
			
			_fx = fx;
			_music = music;
			
			generateOverlay();
		}
		
		private function checkTheBoxes():void 
		{
			trace("CHECK THE BOXES " + _fx + " // " + _music + " // " + _levelinfo);
			if (_fx) {
				optionsText.soundFxCheck.gotoAndStop(2);
			}else {
				optionsText.soundFxCheck.gotoAndStop(1);
			}
			
			
			if (_music) {
				optionsText.backgroundMusic.gotoAndStop(2);
			}else {
				optionsText.backgroundMusic.gotoAndStop(1);
			}
			
			if (_levelinfo) {
				optionsText.levelsInfo.gotoAndStop(2);
			}else {
				optionsText.levelsInfo.gotoAndStop(1);
			}
		}
		
		private function generateOverlay():void 
		{
			overlay.graphics.beginFill(0xE74C3C, 1);
			overlay.graphics.drawRect(0, 0, _screenWidth, _screenHeight);
			overlay.graphics.endFill();
			overlay.cacheAsBitmap = true;
			addChild(overlay);
			
			optionsText.x = _screenWidth / 2;
			optionsText.scaleX = optionsText.scaleY = ((324 * _screenWidth) / 480) / 324;
			addChild(optionsText);
			
			optionsText.soundFxCheck.addEventListener(MouseEvent.CLICK, onSoundFxTapHandler);
			optionsText.backgroundMusic.addEventListener(MouseEvent.CLICK, onBackgroundMusicHandler);
			optionsText.levelsInfo.addEventListener(MouseEvent.CLICK, onLevelsInfoHandler);
			
			goBackBt.x = _screenWidth / 2;
			goBackBt.y = _screenHeight - (2 * goBackBt.height);
			goBackBt.scaleX = goBackBt.scaleY = ((200 * _screenWidth) / 480) / 200;
			addChild(goBackBt);
			goBackBt.addEventListener(MouseEvent.CLICK, onGoBackClickHandler);
			
			checkTheBoxes();
		}
		
		private function onLevelsInfoHandler(e:MouseEvent):void 
		{
			_levelinfo = toggleBooleanValue(_levelinfo);
			toggleCheckBox(optionsText.levelsInfo, _levelinfo);
			
			if (_levelinfo) {
				dispatchEvent(new CustomEvent(CustomEvent.OPTIONS_LEVELS_INFO_ON));
			}else {
				dispatchEvent(new CustomEvent(CustomEvent.OPTIONS_LEVELS_INFO_OFF));
			}
		}
		
		private function onGoBackClickHandler(e:MouseEvent):void 
		{
			dispatchEvent(new CustomEvent(CustomEvent.OPTIONS_GO_BACK));
		}
		
		private function onBackgroundMusicHandler(e:MouseEvent):void 
		{
			trace("MUSIC TOGGLER");
			_music = toggleBooleanValue(_music);
			toggleCheckBox(optionsText.backgroundMusic, _music);
			
			if (_music) {
				dispatchEvent(new CustomEvent(CustomEvent.OPTIONS_BACKGROUND_MUSIC_ON));
			}else {
				dispatchEvent(new CustomEvent(CustomEvent.OPTIONS_BACKGROUND_MUSIC_OFF));
			}
		}
		
		private function onSoundFxTapHandler(e:MouseEvent):void 
		{
			_fx = toggleBooleanValue(_fx);
			toggleCheckBox(optionsText.soundFxCheck, _fx);
			
			if (_fx) {
				dispatchEvent(new CustomEvent(CustomEvent.OPTIONS_SOUNDFX_ON));
			}else {
				dispatchEvent(new CustomEvent(CustomEvent.OPTIONS_SOUNDFX_OFF));
			}
		}
		
		private function toggleCheckBox(_checkbox:CheckBoxMC, value:Boolean):void 
		{
			if (value) {
				_checkbox.gotoAndStop(2);
			}else {
				_checkbox.gotoAndStop(1);
			}
		}
		
		private function toggleBooleanValue(value:Boolean):Boolean 
		{
			return !value;
		}
		
	}

}