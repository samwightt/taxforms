package forms;

import pdf_lib.PDFField;
import pdf_lib.PDFCheckBox;

class Checkbox {
	private var box:PDFCheckBox;

	public function new(box:PDFCheckBox) {
		this.box = box;
	}

	public static function getCheckbox(form:PDFForm, name:String) {
		var field = form.getFieldWithName(name);
		return Checkbox.fromField(field);
	}

	public static function fromField(box:PDFField):Checkbox {
		var converted:PDFCheckBox = cast(box, PDFCheckBox);
		return new Checkbox(converted);
	}

	public function check() {
		this.box.check();
	}

	public function uncheck() {
		this.box.uncheck();
	}

	public function setTo(value:Bool) {
		switch (value) {
			case true:
				this.check();
			case false:
				this.uncheck();
		}
	}
}
