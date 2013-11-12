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
        private static const MAX_TAP_DURATION:Number = 0.5;


        //TODO should be dpi based
        private static const MAX_TAP_MOVEMENT:Number = 20;

        public function Gesture(target:DisplayObject)
        {
            this.target = target;
            target.addEventListener(TouchEvent.TOUCH, touchHandler)
        }

        private var target:DisplayObject;
        private var tapHandler:Function;
        private var totalMovement:Point;
        private var startTouch:Touch;
        private var slideHandler:Function;

        private function get gestureDuration():Number
        {
            return (touchQueTimeStamps.length < 2) ? 0 : Math.abs(touchQueTimeStamps[0] - touchQueTimeStamps[touchQueTimeStamps.length - 1]);
        }

        public function onTap(handler:Function):Gesture
        {
            tapHandler = handler;
            return this;
        }

        public function onSlide(handler:Function):Gesture
        {
            slideHandler = handler
            return this
        }

        private function touchMove():void
        {
            slide();
        }

        private function slide():void
        {
            trace("slide")
            slideHandler(totalMovement);
        }

        private function touchEnded():void
        {
            //target.removeEventListener(Event.ENTER_FRAME, onTargetEnterFrame);

            if (gestureDuration < MAX_TAP_DURATION && totalMovement.length < MAX_TAP_MOVEMENT)
            {
                tap()
            }
        }

        private function tap():void
        {

            trace("recognized TAP")
            if (tapHandler) tapHandler();
        }

        private function resetRecognition():void
        {
            totalMovement = new Point();
            touchQue.length = 1;
            touchQue[0] = startTouch;
            touchQueTimeStamps.length = 1
            touchQueTimeStamps[0] = startTouch.timestamp;

            //target.addEventListener(Event.ENTER_FRAME, onTargetEnterFrame);
        }

        private function touchHandler(event:TouchEvent):void
        {
            const touches:Vector.<Touch> = event.getTouches(target);
            event.getTouches(target, null, touchQue)
            var touch:Touch;

            for each(touch in touches)
            {

//                trace(touch.id)
                touchQueTimeStamps.length = touchQue.length;
                touchQueTimeStamps[touchQue.length - 1] = touch.timestamp
                switch (touch.phase)
                {
                    case TouchPhase.BEGAN :
                        startTouch = touch;
                        resetRecognition()
                        break
                    case TouchPhase.MOVED:
                        var movement:Point = touch.getMovement(target);
                        totalMovement = totalMovement.add(movement);
                        touchMove();

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

//        private function onTargetEnterFrame(event:Event):void
//        {
//            if(touchQue.length==0) return
//
//            trace(touchQue.length)
//        }
    }
}
