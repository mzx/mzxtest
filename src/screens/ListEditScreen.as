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
    import components.SButton;

    import feathers.controls.Header;
    import feathers.controls.Label;
    import feathers.controls.PanelScreen;
    import feathers.controls.TextInput;
    import feathers.layout.VerticalLayout;

    import model.Model;

    import starling.display.DisplayObject;
    import starling.events.Event;

    import util.Atlas1;
    import util.CBW;

    public class ListEditScreen extends PanelScreen
    {
        public static const NAME:String = "ListEdit";
        private var _backButton:SButton = new SButton(Atlas1.back);
        private var _okButton:SButton = new SButton(Atlas1.ok);
        private var _textInput:TextInput = new TextInput();
        private var _colorPicker:ColorPicker = new ColorPicker();

        override protected function initialize():void
        {
            super.initialize();

            layout = new VerticalLayout();

            addHeader();
            addRenameField();
            addColorPicker()
        }

        override protected function draw():void
        {

            _backButton.width = _backButton.height = CBW(64);
            _okButton.width = _okButton.height = CBW(64);
            super.draw();
        }

        private function addHeader():void
        {
            headerFactory = function ():Header
            {
                var header:Header = new Header();
                header.title = "Edit List" + Model.selectedList.label;
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

            this._backButton.addEventListener(Event.TRIGGERED, onBackButton);
            this.backButtonHandler = this.onBackButton;

            _okButton.addEventListener(Event.TRIGGERED, onDoneTriggered);
        }

        private function addRenameField():void
        {

            var label:Label = new Label();
            label.text = "List Name";
            addChild(label);
            addChild(_textInput);
            _textInput.text = Model.selectedList.label;
            _textInput.setFocus();
        }

        private function addColorPicker():void
        {

            _colorPicker.selectedItem = Model.selectedList.color

            _colorPicker.addEventListener(Event.CHANGE, colorChangedHandler)
            addChild(_colorPicker)
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
            Model.selectedList.label = _textInput.text;
            Model.selectedList.color = _colorPicker.selectedItem as uint;

            Model.savelists();

            onBackButton()
        }
    }
}
