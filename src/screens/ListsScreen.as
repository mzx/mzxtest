/**
 * Created with IntelliJ IDEA.
 * User: mzx
 * Date: 9/27/13
 * Time: 2:01 AM
 * To change this template use File | Settings | File Templates.
 */
package screens
{
    import components.renderers.BasicItemRenderer;

    import feathers.controls.Button;
    import feathers.controls.Header;
    import feathers.controls.List;
    import feathers.controls.PanelScreen;

    import model.BuyList;
    import model.Model;

    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.events.Event;

    import util.Atlas1;
    import util.CBW;
    import util.ColorUtils;

    public class ListsScreen extends PanelScreen
    {
        public static const NAME:String = "ListsScreen";

        public function ListsScreen()
        {
            super();
        }

        private var _groupedList:List = new List();

        override protected function initialize():void
        {
            super.initialize();

            addHeader();
            initList();
        }

        override protected function draw():void
        {
            super.draw();
            _groupedList.width = actualWidth;
            _groupedList.height = actualHeight - header.height
        }

        private function addHeader():void
        {
            headerFactory = function ():Header
            {
                var h:Header = new Header();

                var button:Button = new Button();
                button.label = "New List";
                button.addEventListener(Event.TRIGGERED, panelHeaderButton_triggeredHandler);

                var buttonIcon:Image = new Image(Atlas1.plus);
                buttonIcon.color = ColorUtils.BEIGE;

                button.defaultIcon = buttonIcon;


                button.defaultIcon.width = button.defaultIcon.height = CBW(32);
                h.rightItems = new <DisplayObject>[ button];

                return h;
            };
        }

        private function initList():void
        {

            _groupedList.addEventListener(Event.CHANGE, list_changeHandler);
            _groupedList.itemRendererType = BasicItemRenderer;
            _groupedList.itemRendererProperties.labelField = "label";
            _groupedList.itemRendererProperties.iconSourceField = "icon";
            _groupedList.itemRendererProperties.accessorySourceField = "accessoryTexture";

            addChild(_groupedList);
            _groupedList.dataProvider = Model.lists
        }

        private function list_changeHandler(event:Event):void
        {
            Model.selectedList = _groupedList.selectedItem as BuyList;
            owner.showScreen(ListsDetailsScreen.NAME);
        }

        private function panelHeaderButton_triggeredHandler(event:Event):void
        {
            var buyList:BuyList = new BuyList();
            buyList.label = new Date().toLocaleTimeString();
            Model.lists.addItem(buyList);
            Model.savelists();

            Model.selectedList = Model.lists.getItemAt(Model.lists.length - 1) as BuyList;
            owner.showScreen(ListsDetailsScreen.NAME)
        }
    }
}
