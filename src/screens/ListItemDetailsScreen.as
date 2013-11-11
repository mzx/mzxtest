/**
 * Created with IntelliJ IDEA.
 * User: mzx
 * Date: 10/8/13
 * Time: 11:11 PM
 * To change this template use File | Settings | File Templates.
 */
package screens
{
    import components.ColorPicker;
    import components.FormItem;
    import components.SButton;

    import feathers.controls.Header;
    import feathers.controls.Label;
    import feathers.controls.NumericStepper;
    import feathers.controls.PanelScreen;
    import feathers.controls.PickerList;
    import feathers.controls.TextInput;
    import feathers.controls.popups.VerticalCenteredPopUpContentManager;
    import feathers.core.FeathersControl;
    import feathers.data.ListCollection;
    import feathers.layout.TiledRowsLayout;
    import feathers.layout.VerticalLayout;

    import model.Model;

    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.events.Event;

    import util.Atlas1;
    import util.CBW;

    public class ListItemDetailsScreen extends PanelScreen
    {
        public static const NAME:String = "ListItemDetailsScreen";
        private var _backButton:SButton = new SButton(Atlas1.back);
        private var _okButton:SButton = new SButton(Atlas1.ok);
        private var _textInput:TextInput = new TextInput();
        private var _colorPicker:ColorPicker = new ColorPicker();
        private var _qtyInput:NumericStepper;
        private var _priceInput:TextInput;

        override protected function initialize():void
        {
            super.initialize();

            changeLayout();

            addHeader();

            addForm();

            addCagegoryInput();
            addColorPicker();


        }

        private function addForm():void
        {
            var formItem:FormItem = new FormItem();
            formItem.text = "Item Name"

            _textInput.text = Model.selectedListItem.label;
            _textInput.setFocus();

            formItem.component =_textInput
            addChild(formItem)

            var fi2:FormItem = new FormItem();
            fi2.text = "Quantity";
            fi2.component = addQtyInput();
            addChild(fi2)

            var fi3:FormItem = new FormItem();
            fi3.text = "Price";
            fi3.component = addPriceInput();
            addChild(fi3)
        }

        private function addPriceInput():FeathersControl
        {
            _priceInput =  new TextInput();
            _priceInput.prompt = "enter price"
            _priceInput.text = Model.selectedListItem.price
            return _priceInput
        }

        private function addQtyInput():FeathersControl
        {
            _qtyInput = new NumericStepper();
            _qtyInput.minimum = 0;
            _qtyInput.maximum = 100;
            _qtyInput.step = 1;
            _qtyInput.value = Model.selectedListItem.qty;
            _qtyInput.addEventListener( Event.CHANGE, stepper_changeHandler );

            return _qtyInput
        }

        private function stepper_changeHandler(event:Event):void
        {

        }

        override protected function draw():void
        {

            _backButton.width = _backButton.height = CBW(64);
            _okButton.width = _okButton.height = CBW(64);
            super.draw();
        }

        private function changeLayout():void
        {
            var verticalLayout:VerticalLayout = new VerticalLayout();
            verticalLayout.paddingLeft = CBW(64);
            verticalLayout.paddingTop= CBW(64);
            verticalLayout.gap = 16;
//            verticalLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;

            layout = verticalLayout;
        }

        private function addColorPicker():void
        {
            _colorPicker.addEventListener(Event.CHANGE, colorChangedHandler)
            _colorPicker.selectedItem = Model.selectedListItem.color;
            addChild(_colorPicker)
        }

        private function addHeader():void
        {
            headerFactory = function ():Header
            {
                var header:Header = new Header();
                header.title = "Edit List Item";
                header.leftItems = new <DisplayObject>
                        [
                            _backButton
                        ];

                header.rightItems = new <DisplayObject>
                        [
                            _okButton
                        ];

                return header;
            };
            _backButton.addEventListener(Event.TRIGGERED, onBackButton);
            _okButton.addEventListener(Event.TRIGGERED, onDoneTriggered);

            backButtonHandler = this.onBackButton;
        }

        private function addCagegoryInput():void
        {
            var list:PickerList = new PickerList();
            this.addChild(list);

            var groceryList:ListCollection = new ListCollection(
                    [
                        { text: "Milk", thumbnail: new Image(Atlas1.camera) },
                        { text: "Eggs", thumbnail: new Image(Atlas1.camera)},
                        { text: "Bread", thumbnail: new Image(Atlas1.camera)},
                    ]);
            list.dataProvider = groceryList;

            list.listProperties.@itemRendererProperties.labelField = "text";
            list.listProperties.@itemRendererProperties.iconSourceField = "thumbnail";

            list.labelField = "text";
            list.prompt = "Select Category";
            list.selectedIndex = -1;

            var tiledRowsLayout:TiledRowsLayout = new TiledRowsLayout();
            tiledRowsLayout.gap = 2;
            tiledRowsLayout.useSquareTiles = true;

            tiledRowsLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_LEFT;
            tiledRowsLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_TOP;

            tiledRowsLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
            tiledRowsLayout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;

            list.listProperties.layout = tiledRowsLayout;

            var popUpContentManager:VerticalCenteredPopUpContentManager = new VerticalCenteredPopUpContentManager();
            popUpContentManager.marginTop = 32;
            popUpContentManager.marginRight = 32;
            popUpContentManager.marginBottom = 32;
            popUpContentManager.marginLeft = 32;

            list.popUpContentManager = popUpContentManager;
        }

        private function onBackButton():void
        {
            dispatchEventWith("back");
        }

        private function colorChangedHandler(event:Event):void
        {
        }

        private function onDoneTriggered(event:Event):void
        {
            Model.selectedListItem.label = _textInput.text;
            Model.selectedListItem.color = _colorPicker.selectedItem as uint;
            Model.selectedListItem.price = _priceInput.text;
            Model.selectedListItem.qty = _qtyInput.value;

            Model.savelists();

            onBackButton()
        }
    }
}
