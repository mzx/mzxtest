/**
 * Created with IntelliJ IDEA.
 * User: mzx
 * Date: 9/27/13
 * Time: 6:15 PM
 * To change this template use File | Settings | File Templates.
 */
package screens
{
    import components.SButton;
    import components.renderers.ListItemItemRenderer;

    import feathers.controls.Button;
    import feathers.controls.Header;
    import feathers.controls.List;
    import feathers.controls.PanelScreen;
    import feathers.controls.ScrollContainer;
    import feathers.data.ListCollection;

    import model.BuyList;
    import model.ListItem;
    import model.Model;

    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.events.Event;

    import util.Atlas1;
    import util.CBW;
    import util.ColorUtils;

    public class ListsDetailsScreen extends PanelScreen
    {

        public static const NAME:String = "ListsDetails";

        public function ListsDetailsScreen()
        {
        }

        private var _backButton:SButton;
        private var _groupedList:List = new List();
        private var _newButton:SButton = new SButton(Atlas1.plus);
        private var _editButton:Button = new Button();

        override protected function initialize():void
        {
            super.initialize();
            addHeader();
            addFooter();
            initList();

//            var image:Image = new Image(Atlas1.ok);
//            image.color = ColorUtils.themeColors[0];

            // addChild(image)
        }

        override protected function draw():void
        {
            _groupedList.width = actualWidth;
//            _groupedList.height = actualHeight - header.height;

            _backButton.width = _backButton.height = CBW(64);
            _newButton.width = _newButton.height = CBW(64);

            super.draw();
        }

        private function addFooter():void
        {
            footerFactory = function ():ScrollContainer
            {
                var container:ScrollContainer = new ScrollContainer();
                container.nameList.add(ScrollContainer.ALTERNATE_NAME_TOOLBAR);
                container.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
                container.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;

                container.addChild(_editButton)

                _editButton.label = "List Settings";

                var buttonIcon:Image = new Image(Atlas1.settings);
                buttonIcon.color = ColorUtils.BEIGE;
                buttonIcon.width = buttonIcon.height = CBW(32);
                _editButton.defaultIcon = buttonIcon
                return container;
            }

            _editButton.addEventListener(Event.TRIGGERED, onEditTriggered);
        }

        private function addHeader():void
        {
            headerFactory = function ():Header
            {
                var header:Header = new Header();
                header.title = Model.selectedList.label;
                header.leftItems = new <DisplayObject>
                        [
                            _backButton
                        ];

                header.rightItems = new <DisplayObject>
                        [
                            _newButton
                        ];

                return header;
            };

            this._backButton = new SButton(Atlas1.back);
            var number:Number = CBW(64);
            _backButton.width = _backButton.height = number;
            this._backButton.addEventListener(Event.TRIGGERED, onBackButton);
            this.backButtonHandler = this.onBackButton;
            _newButton.addEventListener(Event.TRIGGERED, onNewTriggered);
        }

        private function initList():void
        {

            _groupedList.addEventListener(Event.CHANGE, list_changeHandler);
            _groupedList.itemRendererType = ListItemItemRenderer;

            _groupedList.itemRendererProperties.labelField = "label";
            _groupedList.itemRendererProperties.iconSourceField = "icon";


            var selectedList:BuyList = Model.selectedList;
            var data:Vector.<ListItem> = selectedList.items;

            _groupedList.dataProvider = new ListCollection(data);

            addChild(_groupedList);
        }

        private function onBackButton():void
        {
            dispatchEventWith("back");
        }

        private function backButton_onRelease():void
        {
            this.onBackButton();
        }

        private function onEditTriggered(event:Event):void
        {
            owner.showScreen(ListEditScreen.NAME)
        }

        private function onNewTriggered(event:Event):void
        {
            var listItem:ListItem = new ListItem();
            listItem.label = new Date().getMilliseconds().toString();
            Model.selectedList.items.push(listItem);
            Model.savelists();

            _groupedList.dataProvider = new ListCollection(Model.selectedList.items);
            _groupedList.scrollToDisplayIndex(Model.selectedList.items.length - 1, 0.7);
        }

        private function list_changeHandler(event:Event):void
        {
            Model.selectedListItem = (_groupedList.selectedItem as ListItem);
        }

    }
}
