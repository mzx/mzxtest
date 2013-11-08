/**
 * Created with IntelliJ IDEA.
 * User: mzx
 * Date: 10/27/13
 * Time: 4:20 AM
 * To change this template use File | Settings | File Templates.
 */
package components
{
    import components.renderers.BasicItemRenderer;
    import components.renderers.ColorPickerItemRenderer;

    import feathers.controls.Button;

    import feathers.controls.List;
    import feathers.controls.PickerList;
    import feathers.data.ListCollection;
    import feathers.layout.TiledColumnsLayout;
    import feathers.layout.TiledRowsLayout;

    import model.Version;

    import starling.display.Image;

    import starling.events.Event;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    import util.Atlas1;
    import util.ColorUtils;

    public class ColorPicker extends PickerList
    {
        public function ColorPicker()
        {
            super();

            dataProvider = new ListCollection(ColorUtils.ac);

            _listFactory = listFactoryFunction
        }

        private function listFactoryFunction():List
        {
            var result:List = new List()
            result.itemRendererType = ColorPickerItemRenderer;

            result.layout = new TiledRowsLayout();
            return result
        }


        override protected function refreshButtonLabel():void
        {

            _SButton.color = selectedItem as uint
        }

        private var _SButton:Image

        override protected function createButton():void
        {
            button = new Button()
            if(_SButton)
            {
                _SButton.removeFromParent(true);
                _SButton = null;
            }

            _SButton = new Image(Atlas1.ring);
            _SButton.addEventListener(TouchEvent.TOUCH, touchHandler);
            addChild(this._SButton);
        }

        private function touchHandler(event:TouchEvent):void
        {
            if (event.getTouch(_SButton) && event.getTouch(_SButton).phase == TouchPhase.ENDED)
            {
                button_triggeredHandler(event)
            }
        }
    }
}
