package forms;

import haxe.Resource;
import pdf_lib.PDFDocument;

class PDFForm {
	private var document:PDFDocument;

	public static function fromResource(resourceName:String) {
		var source = Resource.getBytes(resourceName).getData();
		return PDFDocument.load(source).then(document -> {
			return new PDFForm(document);
		});
	}

	private function new(document:PDFDocument) {
		this.document = document;
	}

	public function form() {
		return this.document.getForm();
	}

	public function fields() {
		return this.form().getFields();
	}

	public function getFieldWithName(name) {
		return this.form().getField(name);
	}
}
