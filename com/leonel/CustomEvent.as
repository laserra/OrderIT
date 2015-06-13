package com.leonel
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class CustomEvent extends Event 
	{
		public static const RECTANGLE_TAPPED:String = "Rectangle_tapped";
		public static const TIMER_OFF:String = "Timer_off";
		
		public static const STATIC_OVERLAY_START:String = "Static_Overlay_Start";
		public static const STATIC_OVERLAY_HIDE:String = "Static_Overlay_Hide";
		
		public static const TIMED_OVERLAY_START:String = "Timed_Overlay_Start";
		public static const TIMED_OVERLAY_HIDE:String = "Timed_Overlay_Hide";
		
		public static const ARROWS_BACKGROUND_SHOW:String = "Arrows_Background_Show";
		public static const ARROWS_BACKGROUND_HIDE:String = "Arrows_Background_Hide";
		public static const ARROWS_BACKGROUND_FLIP:String = "Arrows_Background_Flip";
		
		public static const GAMEOVER_SHOW:String = "GameOver_Show";
		public static const GAMEOVER_HIDE:String = "GameOver_Hide";
		public static const PLAY_AGAIN:String = "Play_Again";
		public static const EXIT_APPLICATION:String = "Exit_Application";
		public static const GAMEOVER_GOTO_MAINSCREEN:String = "Gameover_Goto_Mainscreen";
		public static const GAMEOVER_FACEBOOK_SHARE:String = "Gameover_Facebook_Share";
		
		public static const BACKGROUND_CHANGE_COLOR:String = "Background_Change_Color";
		
		public static const SCORE_ADD:String = "Score_Add";
		public static const SCORE_CHECK_HIGHSCORE:String = "Score_Check_Highscore";
		public static const SCORE_SAVE_LAST_LEVEL_SCORE:String = "Score_Save_Last_Level_Score";
		
		public static const LEVEL_CHECK_COLOR:String = "Level_Check_Color";
		
		public static const SPLASH_PLAY:String = "Splash_Play";
		public static const SPLASH_OPTIONS:String = "Splash_Options";
		public static const SPLASH_RULES:String = "Splash_Rules";
		
		public static const OPTIONS_SOUNDFX_ON:String = "Options_SoundFx_On";
		public static const OPTIONS_SOUNDFX_OFF:String = "Options_SoundFx_Off";
		public static const OPTIONS_BACKGROUND_MUSIC_ON:String = "Options_Background_Music_On";
		public static const OPTIONS_BACKGROUND_MUSIC_OFF:String = "Options_Background_Music_Off";
		public static const OPTIONS_LEVELS_INFO_ON:String = "Options_Levels_Info_On";
		public static const OPTIONS_LEVELS_INFO_OFF:String = "Options_Levels_Info_Off";
		public static const OPTIONS_GO_BACK:String = "Options_Go_Back";
		
		public static const RULES_GO_BACK:String = "Rules_Go_Back";
		
		public static const CHECKBOX_TAP:String = "Checkbox_Tap";
		
		public static const SOUND_PLAY_SFX:String = "Sound_Play_Sfx";
		
		public static const FACEBOOK_TIMEOUT:String = "Facebook_Timeout";
		public static const FACEBOOK_LOGIN_COMPLETE:String = "Facebook_Login_Complete";
		public static const FACEBOOK_LOGIN_ERROR:String = "Facebook_Login_Error";
		public static const FACEBOOK_RESET:String = "Facebook_Reset";
		public static const FACEBOOK_READY_TO_POST:String = "Facebook_Ready_To_Post";
		
		public static const TOAST_CLOSE:String = "Toast_Close";
		
		public static const CONNECTION_AVAILABLE:String = "Connection_Available";
		public static const CONNECTION_NOT_AVAILABLE:String = "Connection_Not_Available";
		public static const CONNECTION_VALUES_SAVED:String = "Connection_Values_Saved";
		
		public static const SAVE_VALUES_SUCCESS:String = "Save_Values_Success";
		public static const SAVE_VALUES_FAIL:String = "Save_Values_Fail";
		
		public static const LIFE_DECREASE_ONE:String = "Life_Decrease_One";
		public static const LIFE_INCREASE_ONE:String = "Life_Increase_One";
		public static const LIFE_LOST:String = "Life_Lost";
		
		public static const CONTINUE_GAME:String = "Continue_Game";
		
		public static const INFO_OK:String = "Info_Ok";
		public static const INFO_CHECK:String = "Info_Check";
		
		public static const TIMER_ALL_TAP_DONE_BY_USER:String = "Timer_All_Tap_Done_By_User";
		public static const TIMER_PLAY_TIME_OVER:String = "Timer_Play_Time_Over";
		public static const TIMER_RESTART_PLAY_TIME_OVER:String = "Timer_Restart_Play_Time_Over";
		
		public static const TIMERARC_COUNTDOWN_END:String = "Timerarc_Countdown_End";
		public static const TIMERARC_TIME_BONUS:String = "Timerarc_Time_Bonus";
		public static const TIMERARC_TIMER_HIDE:String = "Timerarc_Timer_Hide";
		
		
		public function CustomEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false):void {
			super(type, bubbles, cancelable);
        }
		
		public override function clone():Event {
			return new CustomEvent(type, bubbles, cancelable);
		}
	}
	
}