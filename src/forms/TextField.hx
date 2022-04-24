package forms;

import pdf_lib.PDFTextField;
import pdf_lib.PDFField;

class TextField {
	private var field:PDFTextField;

	public function new(field:PDFTextField) {
		this.field = field;
	}

	public static function getTextField(form:PDFForm, name:String) {
		var field = form.getFieldWithName(name);
		return TextField.fromField(field);
	}

	public static function fromField(box:PDFField):TextField {
		var converted:PDFTextField = cast(box, PDFTextField);
		return new TextField(converted);
	}

	public function setTo(value:String) {
		this.field.setText(value);
	}

	public function clear() {
		this.field.setText("");
	}
}
