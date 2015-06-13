package src 
{
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SoundControl extends MovieClip 
	{
		private var backgroundMusicRequest:URLRequest;
		private var tapFxRequest:URLRequest;
		
		private var backgroundMusicChannel:SoundChannel = new SoundChannel();
		private var sfxChannel:SoundChannel = new SoundChannel();
		
		private var backgroundMusicSound:Sound = new Sound();
		private var tapFxSound:Sound = new Sound();
		private var enablePlaySfx:Boolean = true;
		
		private var sndTransform:SoundTransform = new SoundTransform();
		
		public function SoundControl() 
		{
			super();
			
			loadAndInitializeBackgroundMusic();
			loadAndInitializeTapFx();
		}
		
		private function loadAndInitializeTapFx():void 
		{
			tapFxRequest = new URLRequest("/sounds/tapsq.mp3");
            tapFxSound.load(tapFxRequest);
		}
		
		 public function setBackgroundMusicVolume(volume:Number):void {
            trace("setVolume: " + volume.toFixed(2));
            
			var transformVolume:SoundTransform = backgroundMusicChannel.soundTransform;
            transformVolume.volume = volume;
            
        }
		
		public function loadAndInitializeBackgroundMusic():void 
		{
			backgroundMusicRequest = new URLRequest("/sounds/just-a-little-hope.mp3");
			
			backgroundMusicSound.addEventListener(Event.COMPLETE, completeHandler);
			
            backgroundMusicSound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            backgroundMusicSound.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			
            backgroundMusicSound.load(backgroundMusicRequest);
			
			//sndTransform.volume = 0.5;
			//backgroundMusicChannel.soundTransform = sndTransform;
			
		}
		
		private function onSoundCompleteHandler(e:Event):void 
		{
			backgroundMusicChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundCompleteHandler);
			playBackgroundMusic();
		}
		
		private function progressHandler(e:ProgressEvent):void 
		{
			//trace("BACKGROUND MUSIC PROGRESS ", ((e.bytesLoaded/e.bytesTotal)*100)+"%");
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void 
		{
			trace("BACKGROUND MUSIC ERROR");
		}
		
		private function completeHandler(e:Event):void 
		{
			//trace("BACKGROUND MUSIC COMPLETE");
			//playBackgroundMusic();
		}
		
		public function stopBackgroundMusic():void {
			backgroundMusicChannel.stop();
		}
		
		public function stopSfx():void {
			sfxChannel.stop();
		}
		
		public function playBackgroundMusic():void {
			backgroundMusicChannel = backgroundMusicSound.play();
			backgroundMusicChannel.addEventListener(Event.SOUND_COMPLETE, onSoundCompleteHandler);
		}
		
		public function playSFX():void {
			if (enablePlaySfx) {
				sfxChannel = tapFxSound.play();
			}
		}
		
		public function enablePlaySFX():void {
			enablePlaySfx = true;
		}
		
		public function disablePlaySFX():void {
			enablePlaySfx = false;
		}
		
	}

}