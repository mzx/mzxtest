/**
 * Created with IntelliJ IDEA.
 * User: mzx
 * Date: 9/26/13
 * Time: 6:35 PM
 * To change this template use File | Settings | File Templates.
 */
package
{
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.geom.Rectangle;

    import starling.core.Starling;

    [SWF(frameRate="60", backgroundColor='#336699')]
    public class Skeleton extends Sprite
    {

        public function Skeleton()
        {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;

            Starling.handleLostContext = true;
            Starling.multitouchEnabled = true;

            _starling = new Starling(Main, stage);
            //_starling.enableErrorChecking = true;
            _starling.antiAliasing = 16;
            _starling.showStats = true;
            _starling.simulateMultitouch = true;
            _starling.start();

            this.stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, int.MAX_VALUE, true);
        }

        private var _starling:Starling;

        protected function stage_resizeHandler(event:Event):void
        {
            this._starling.stage.stageWidth = this.stage.stageWidth;
            this._starling.stage.stageHeight = this.stage.stageHeight;

            const viewPort:Rectangle = this._starling.viewPort;
            viewPort.width = this.stage.stageWidth;
            viewPort.height = this.stage.stageHeight;

            try
            {
                this._starling.viewPort = viewPort;
            }
            catch (error:Error)
            {
                trace(error)
            }
        }
    }
}
