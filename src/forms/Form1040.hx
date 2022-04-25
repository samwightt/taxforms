package forms;

import forms.NameField.NameFormFields;
import forms.FilingStatusField.FilingFormFields;
import macros.*;
import forms.*;

using forms.Checkbox;
using forms.TextField;

function filingStatusFields(doc:PDFForm):FilingFormFields {
	return {
		Single: doc.getCheckbox("topmostSubform[0].Page1[0].FilingStatus[0].c1_01[0]"),
		MarriedFilingJointly: doc.getCheckbox("topmostSubform[0].Page1[0].FilingStatus[0].c1_01[1]"),
		MarriedFilingSeparately: doc.getCheckbox("topmostSubform[0].Page1[0].FilingStatus[0].c1_01[2]"),
		HeadOfHousehold: doc.getCheckbox("topmostSubform[0].Page1[0].FilingStatus[0].c1_01[3]"),
		QualifyingWidow: doc.getCheckbox("topmostSubform[0].Page1[0].FilingStatus[0].c1_01[4]"),
		NameField: doc.getTextField("topmostSubform[0].Page1[0].FilingStatus[0].f1_01[0]"),
	}
}

function filerNameFields(doc:PDFForm):NameFormFields {
	return {
		FirstAndMiddleInitial: doc.getTextField("topmostSubform[0].Page1[0].f1_02[0]"),
		LastName: doc.getTextField("topmostSubform[0].Page1[0].f1_03[0]")
	}
}

function spouseNameFields(doc:PDFForm):NameFormFields {
	return {
		FirstAndMiddleInitial: doc.getTextField("topmostSubform[0].Page1[0].f1_05[0]"),
		LastName: doc.getTextField("topmostSubform[0].Page1[0].f1_06[0]")
	}
}

@:expose
@:build(PdfFormMacro.build())
class Form1040 {
	private var document:PDFForm;

	@checkbox("topmostSubform[0].Page1[0].FilingStatus[0].c1_01[0]")
	public var singleFilingStatus:Bool;
	public var filingStatus(default, default):FilingStatusField;
	public var filerName:NameField;
	public var spouseName:NameField;

	public static function main() {
		var doc = PDFForm.fromResource("1040").then(document -> {
			for (field in document.fields()) {
				trace(field.getName());
			}
		});
	}

	public static function fromResource() {
		var resourceName = "1040";
		return PDFForm.fromResource(resourceName).then(x -> new Form1040(x));
	}

	public function new(doc:PDFForm) {
		this.document = doc;
		this.filingStatus = new FilingStatusField(filingStatusFields(doc));
		this.filerName = new NameField(filerNameFields(doc));
		this.spouseName = new NameField(spouseNameFields(doc));
	}
}
