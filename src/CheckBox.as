package src 
{
	import com.leonel.CustomEvent;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class CheckBox extends MovieClip 
	{
		private var checkBox:CheckBoxMC = new CheckBoxMC();
		private var active:Boolean = false;
		
		public function CheckBox() 
		{
			super();
			
			checkBox.gotoAndStop(1);
			addChild(checkBox);
			checkBox.addEventListener(MouseEvent.CLICK, onCheckboxTapHandler);
		}
		
		private function onCheckboxTapHandler(e:MouseEvent):void 
		{
			if (active) {
				checkBox.gotoAndStop(1);
				active = false;
			}else {
				checkBox.gotoAndStop(2);
				active = true;
			}
			
			dispatchEvent(new CustomEvent(CustomEvent.CHECKBOX_TAP));
		}
		
	}

}