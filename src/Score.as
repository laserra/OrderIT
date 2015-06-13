package src {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.leonel.MakeTextField;
	
	/**
	 * ...
	 * @author Leonel Serra
	 */
	public class Score extends Sprite 
	{
		private var scoreTx:ScoreTx=new ScoreTx();
		private var highScoreTx:HighScoreTx = new HighScoreTx();
		
		private var highScore:Number = 0;
		private var _score:Number = 0;
		
		private var bonusTimes:Number = 0;
		
		public function Score(_scaleFactor:Number, _stageWidth:Number):void {
			
			scoreTx.scaleX = scoreTx.scaleY = ((210 * _stageWidth) / 480) / 210;
			highScoreTx.scaleX = highScoreTx.scaleY = ((210 * _stageWidth) / 480) / 210;
			
			addChild(scoreTx);
			addChild(highScoreTx);
			highScoreTx.x = 0;
			highScoreTx.y = scoreTx.height;// + (10 * highScoreTx.scaleX);
			highScoreTx.alpha = 0.5;
		}
		
		public function changeScore(value:Number):void {
			trace("SCORE "+value);
			score = value;
			scoreTx.label.text = "SCORE: "+String(score);
		}
		
		public function addToScore(value:Number):void {
			score += value;
			scoreTx.label.text = "SCORE: "+String(score);
		}
		
		public function takeFromScore(value:Number):void {
			score -= value;
			scoreTx.label.text = "SCORE: "+String(score);
		}
		
		public function changeHiScore(value:Number):void {
			highScore = value;
			highScoreTx.label.text = "HIGH SCORE: "+String(value);
		}
		
		public function getScore():Number {
			return score;
		}
		
		public function resetScore():void {
			score = 0;
			scoreTx.label.text = "SCORE: 0";
		}
		
		public function get scoreTxHeight():Number {
			return scoreTx.height;
		}
		
		public function get score():Number 
		{
			return _score;
		}
		
		public function set score(value:Number):void 
		{
			_score = value;
		}
		
		public function bonusTime(value:String):void {
			//bonusTimes++;
			//highScoreTx.bonusTimesTx.text = value;
		}
	}
	
}