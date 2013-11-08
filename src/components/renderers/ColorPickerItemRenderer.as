package components.renderers
{
    import feathers.controls.Label;
    import feathers.controls.List;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.core.FeathersControl;

    import flash.geom.Point;

    import starling.animation.Transitions;
    import starling.animation.Tween;
    import starling.core.Starling;
    import starling.display.Quad;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    import util.CBW;
    import util.ColorUtils;

    public class ColorPickerItemRenderer extends FeathersControl implements IListItemRenderer
    {

        private static const HELPER_POINT:Point = new Point();

        public function ColorPickerItemRenderer()
        {
            this.addEventListener(TouchEvent.TOUCH, touchHandler);
            this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);

            height = CBW(124);
            width= CBW(124);
        }

        protected var touchPointID:int = -1;

        protected var _index:int = -1;

        public function get index():int
        {
            return this._index;
        }

        public function set index(value:int):void
        {
            if (this._index == value)
            {
                return;
            }
            this._index = value;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        protected var _owner:List;

        public function get owner():List
        {
            return List(this._owner);
        }

        public function set owner(value:List):void
        {
            if (this._owner == value)
            {
                return;
            }
            if (this._owner)
            {
                this._owner.removeEventListener(Event.SCROLL, owner_scrollHandler);
            }
            this._owner = value;
            if (this._owner)
            {
                this._owner.addEventListener(Event.SCROLL, owner_scrollHandler);
            }
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        protected var _data:Object;

        public function get data():Object
        {
            return this._data;
        }

        public function set data(value:Object):void
        {
            if (this._data == value)
            {
                return;
            }
            this._data = value;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        protected var _isSelected:Boolean;
        private var bg:Quad;
        private var bg1:Quad;
        private var disableScroll:Boolean;

        public function get isSelected():Boolean
        {
            return this._isSelected;
        }

        public function set isSelected(value:Boolean):void
        {
            if (this._isSelected == value)
            {
                return;
            }
            this._isSelected = value;
            this.invalidate(INVALIDATION_FLAG_SELECTED);
            this.dispatchEventWith(Event.CHANGE);
        }

        override protected function initialize():void
        {
            bg = new Quad(10, 10, 0x332A2B)
            addChild(bg);

        }

        override protected function draw():void
        {
            const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
            const selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
            var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);


            if (dataInvalid || sizeInvalid)
            {
                bg.width = actualWidth
                bg.height = actualHeight
                bg.color = uint(data);
            }
        }

        protected function owner_scrollHandler(event:Event):void
        {
            this.touchPointID = -1;
        }

        protected function touchHandler(event:TouchEvent):void
        {
            const touches:Vector.<Touch> = event.getTouches(this);
            if (touches.length == 0)
            {
                //hover has ended
                return;
            }
            if (this.touchPointID >= 0)
            {
                var touch:Touch;
                for each(var currentTouch:Touch in touches)
                {
                    if (currentTouch.id == this.touchPointID)
                    {
                        touch = currentTouch;
                        break;
                    }
                }
                if (!touch)
                {
                    return;
                }
                if (touch.phase == TouchPhase.ENDED)
                {
                    this.touchPointID = -1;

                    touch.getLocation(this.stage, HELPER_POINT);
                    //check if the touch is still over the target
                    const isInBounds:Boolean = this.contains(this.stage.hitTest(HELPER_POINT, true));
                    if (isInBounds)
                    {
                        this.isSelected = true;
                        dispatchEventWith(Event.TRIGGERED)
                    }
                    return;
                }
            }
            else
            {
                for each(touch in touches)
                {
                    if (touch.phase == TouchPhase.BEGAN)
                    {
                        this.touchPointID = touch.id;
                        return;
                    }
                }
            }
        }

        protected function removedFromStageHandler(event:Event):void
        {
            this.touchPointID = -1;
        }
    }
}