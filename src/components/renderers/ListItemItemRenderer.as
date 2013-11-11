package components.renderers
{
    import components.SButton;

    import feathers.controls.Label;
    import feathers.controls.List;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.core.FeathersControl;

    import flash.geom.Point;

    import screens.ListItemDetailsScreen;

    import starling.animation.Transitions;
    import starling.animation.Tween;
    import starling.core.Starling;
    import starling.display.Quad;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    import util.Atlas1;
    import util.CBW;
    import util.ColorUtils;

    public class ListItemItemRenderer extends FeathersControl implements IListItemRenderer
    {

        private static const HELPER_POINT:Point = new Point();

        public function ListItemItemRenderer()
        {
            this.addEventListener(TouchEvent.TOUCH, touchHandler);
            this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);

            height = CBW(80);
        }

        protected var touchPointID:int = -1;
        protected var itemLabel:Label;
        protected var itemSubLabel:Label;
        private var bg:Quad;
        private var bg1:Quad;
        private var disableScroll:Boolean;

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

            bg1 = new Quad(10, 10, ColorUtils.TUSCAN)
            addChild(bg1);

            this.itemLabel = new Label();
            this.addChild(this.itemLabel);

            this.itemSubLabel = new Label();
            this.addChild(this.itemSubLabel);

            addAccessory();

        }

        override protected function draw():void
        {
            const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
            const selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
            var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);

            if (dataInvalid)
            {
                this.commitData();
            }

            sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

            if (dataInvalid || sizeInvalid)
            {
                height = CBW(80);
                this.layout();
                bg.width = actualWidth
                bg.height = actualHeight - CBW(2);
                bg1.height = actualHeight - CBW(2);
                bg1.width = CBW(124);

                itemLabel.x = CBW(132)
                itemLabel.y = CBW(8)

                itemSubLabel.x = CBW(132)
                itemSubLabel.y = CBW(40)
            }
        }

        protected function autoSizeIfNeeded():Boolean
        {
            const needsWidth:Boolean = isNaN(this.explicitWidth);
            const needsHeight:Boolean = isNaN(this.explicitHeight);
            if (!needsWidth && !needsHeight)
            {
                return false;
            }
            this.itemLabel.width = NaN;
            this.itemLabel.height = NaN;
            this.itemLabel.validate();
            var newWidth:Number = this.explicitWidth;
            if (needsWidth)
            {
                newWidth = this.itemLabel.width;
            }
            var newHeight:Number = this.explicitHeight;
            if (needsHeight)
            {
                newHeight = this.itemLabel.height;
            }


            return this.setSizeInternal(newWidth, newHeight, false);
        }

        protected function commitData():void
        {
            if (this._data)
            {
                this.itemLabel.text = this._data[owner.itemRendererProperties.labelField].toString();
                this.itemSubLabel.text = "\t" + this._data.qty +" / "+_data.price;
                bg1.color = _data.color
            }
            else
            {
                this.itemLabel.text = "";
                this.itemSubLabel.text = "";
            }
        }

        protected function layout():void
        {
            this.itemLabel.width = this.actualWidth;
            this.itemLabel.height = this.actualHeight;
        }

        private function addAccessory():void
        {
            var button1:SButton = new SButton(Atlas1.forward);
            button1.width = button1.height = CBW(64)
            button1.x = CBW(560)
            button1.y = CBW(8)

            button1.alpha = 0.5

            button1.addEventListener(Event.TRIGGERED, onAccessoryTriggered)
            addChild(button1)
        }

        private function moveBackOrDelete():void
        {

            var newX:Number;
            if (width / 2 < Math.abs(x))
            {
                newX = x * 2
            }
            else
            {
                newX = 0
            }

            var tween:Tween = new Tween(this, 0.5, Transitions.EASE_IN);
            tween.delay = 0;
            tween.moveTo(newX, y);
            tween.onComplete = function ():void
            {
                if (x != 0) owner.dataProvider.removeItemAt(index)
            };


            bg.color = ColorUtils.DARK
            Starling.juggler.add(tween);

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


                var movement:Point = touch.getMovement(this);
                switch (touch.phase)
                {
                    case TouchPhase.BEGAN:
                        break
                    case TouchPhase.MOVED:
                        if (Math.abs(movement.x) > Math.abs(movement.y))
                        {
                            disableScroll = true;
                        }

                        if (width / 3 < Math.abs(x))
                        {
                            bg.color = 0xFF4444;
                        }
                        else
                        {
                            bg.color = ColorUtils.DARK;
                        }

                        this.x += touch.getMovement(this).x


                        if (disableScroll)
                        {
                            event.stopPropagation();
                        }
                        break
                    case TouchPhase.ENDED:
                        touchPointID = -1

                        if (!disableScroll)
                        {
                            isSelected = true;
                        }
                        disableScroll = false;
                        moveBackOrDelete();
                        break
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


            //isSelected = true;

        }

        protected function touchHandler2(event:TouchEvent):void
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

        private function onAccessoryTriggered(event:Event):void
        {
            trace("onAccessoryTriggered")
            isSelected = true;

            Main.navigator.showScreen(ListItemDetailsScreen.NAME)
        }
    }
}