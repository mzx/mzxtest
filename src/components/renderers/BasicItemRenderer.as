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

    import tactile.Gesture;

    import util.CBW;
    import util.ColorUtils;

    public class BasicItemRenderer extends FeathersControl implements IListItemRenderer
    {

        public function BasicItemRenderer()
        {

            new Gesture(this).onTap(tapHandler).onSlide(slideHandler);

            height = CBW(124);
        }

        private function slideHandler(delta:Point):void
        {
            x = delta.x
            trace("renderer slide")
        }

        protected var itemLabel:Label;
        protected var bg:Quad;
        protected var bg1:Quad;
        protected var disableScroll:Boolean;

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

            if (!this.itemLabel)
            {
                this.itemLabel = new Label();
                this.addChild(this.itemLabel);
            }

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
                height = CBW(124);
                this.layout();
                bg.width = actualWidth
                bg.height = actualHeight - CBW(8);
                bg1.height = actualHeight - CBW(8);
                bg1.width = CBW(124);

                itemLabel.x = CBW(132)
                itemLabel.y = CBW(8)
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
                bg1.color = _data.color as uint;
            }
            else
            {
                this.itemLabel.text = "";
            }
        }

        protected function layout():void
        {
            this.itemLabel.width = this.actualWidth;
            this.itemLabel.height = this.actualHeight;
        }

        private function tapHandler():void
        {
            isSelected = true;
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
        }



    }
}