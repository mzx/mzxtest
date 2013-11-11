/**
 * Created with IntelliJ IDEA.
 * User: mzx
 * Date: 11/5/13
 * Time: 3:22 AM
 * To change this template use File | Settings | File Templates.
 */
package components
{
    import feathers.controls.Label;
    import feathers.core.FeathersControl;

    import flash.events.GestureEvent;

    import tactile.Gesture;

    import util.CBW;

    public class FormItem extends FeathersControl
    {
        private var _component:FeathersControl;

        public function FormItem()
        {
            super();
        }


        private var _label:Label = new Label();

        private var _text:String;

        override protected function initialize():void
        {
            super.initialize();
            addChild(_label)

            new Gesture(_label).onTap(testFunction);

            if (numChildren == 1 && _component != null)
            {
                addChild(_component)
                _component.x = CBW(256);
            }

            setSizeInternal(CBW(512), CBW(80), true)
        }

        private function testFunction():void
        {
            trace(arguments.callee)
        }


        override protected function draw():void
        {
            super.draw();
            //TODO
            if (1)
            {
                _label.text = text;
            }

//            setSizeInternal(_label.width + _component.width,Math.max(_label.height,_component.height),true);
        }

        public function get component():FeathersControl
        {
            return _component;
        }

        public function set component(value:FeathersControl):void
        {
            _component = value;
        }

        public function get text():String
        {
            return _text;
        }

        public function set text(value:String):void
        {
            _text = value;
        }
    }
}
