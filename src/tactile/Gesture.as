/**
 * Created with IntelliJ IDEA.
 * User: mzx
 * Date: 11/9/13
 * Time: 5:47 AM
 * To change this template use File | Settings | File Templates.
 */
package tactile
{
    import flash.geom.Point;

    import starling.display.DisplayObject;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    public class Gesture
    {

        //  One finger touches the screen and lifts up.
        public static const TAP:String = "TAP"
        //  One finger touches the screen and stays in place.
        public static const LONG_TOUCH:String = "LONGTOUCH"
        //  One or more fingers touch the screen and move in the same direction.
        public static const SLIDE:String = "SLIDE"
        //  One or more fingers touch the screen and move a short distance in the same direction.
        public static const SWIPE:String = "SWIPE"


        //  Two or more fingers touch the screen and move in a clockwise or counter-clockwise arc.
        public static const TURN:String = "TURN"
        //  Two or more fingers touch the screen and move closer together.
        public static const PINCH:String = "PINCH"
        //   Two or more fingers touch the screen and move farther apart.
        public static const STRETCH:String = "STRETCH"
        private static const touchQue:Vector.<Touch> = new <Touch>[];
        private static const touchQueTimeStamps:Vector.<Number> = new <Number>[];

        public function Gesture(target:DisplayObject)
        {
            this.target = target;
            target.addEventListener(TouchEvent.TOUCH, touchHandler)
        }


        //TODO should be dpi based
        private var tapTreshold = 30;
        private var target:DisplayObject;
        private var tapHandler:Function;
        private var totalMovement:Point;
        private var startTouch:Touch;
        private var maxTapDuration:Number = 0.5;

        public function onTap(handler:Function):Gesture
        {
            tapHandler = handler;
            return this;
        }

        private function touchHandler(event:TouchEvent):void
        {
            const touches:Vector.<Touch> = event.getTouches(target);
            event.getTouches(target,null,touchQue)
            var touch:Touch;

            for each(touch in touches)
            {

//                trace(touch.id)
                touchQueTimeStamps.length = touchQue.length;
                touchQueTimeStamps[touchQue.length-1] = touch.timestamp
                switch (touch.phase)
                {
                    case TouchPhase.BEGAN :
                        startTouch = touch;
                        resetRecognition()
                        break
                    case TouchPhase.MOVED:
                        var movement:Point = touch.getMovement(target);
                        totalMovement = totalMovement.add(movement);
                        trace(totalMovement)
                        break
                    case TouchPhase.STATIONARY:
                        trace(event)
                        break

                    case TouchPhase.ENDED :
                        touchEnded()
                        break
                }

            }
        }

        private function touchEnded():void
        {


            target.removeEventListener(Event.ENTER_FRAME, onTargetEnterFrame);

            var timeDelta:Number = touchQueTimeStamps[0] - touchQueTimeStamps[touchQueTimeStamps.length-1];
            //trace(timeDelta,' +-')
            if (timeDelta < maxTapDuration)
            {
                tap()
            }
        }

        private function tap():void
        {
            if(tapHandler) tapHandler();
        }



        private function resetRecognition():void
        {
            totalMovement = new Point();
            touchQue.length = 0;

            target.addEventListener(Event.ENTER_FRAME, onTargetEnterFrame);
        }

        private function onTargetEnterFrame(event:Event):void
        {
            if(touchQue.length==0) return
           trace(touchQue[touchQue.length-1].phase)
        }
    }
}
