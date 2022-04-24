package forms;

using forms.Checkbox;

enum Type {
	Single;
	MarriedFilingJointly;
	MarriedFilingSeparately;
	HeadOfHousehold;
	QualifyingWidow;
}

private typedef Checkable = {
	public function check():Void;
	public function uncheck():Void;
}

private typedef Typeable = {
	public function setTo(value:String):Void;
	public function clear():Void;
}

typedef FilingFormFields = {
	Single:Checkable,
	MarriedFilingJointly:Checkable,
	MarriedFilingSeparately:Checkable,
	HeadOfHousehold:Checkable,
	QualifyingWidow:Checkable,
	NameField:Typeable,
}

class FilingStatusField {
	private var fields:FilingFormFields;

	public function new(fields) {
		this.fields = fields;
	}

	public var status(default, set):Null<Type> = null;

	private function set_status(value:Null<Type>) {
		updateFieldValue(value);
		return status = value;
	}

	public var name(default, set):Null<String> = null;

	private function set_name(value) {
		this.updateNameField(value);
		return name = value;
	}

	private function updateNameField(value:Null<String>) {
		this.clearNameField();
		switch (value) {
			case null:
				fields.NameField.clear();
			case value:
				fields.NameField.setTo(value);
		}
	}

	private function clearNameField() {
		if (this.name != null) {
			fields.NameField.clear();
			this.name = null;
		}
	}

	private function uncheckStatus() {
		if (this.status != null) {
			getStatusField(this.status).uncheck();
			this.status = null;
		}
	}

	private function updateFieldValue(kind:Null<Type>) {
		uncheckStatus();

		switch (kind) {
			case null:
				return;
			case _:
				this.getStatusField(kind).check();
		}
	}

	private function getStatusField(kind:Type) {
		return switch (kind) {
			case Single:
				return fields.Single;
			case MarriedFilingJointly:
				return fields.MarriedFilingJointly;
			case MarriedFilingSeparately:
				return fields.MarriedFilingSeparately;
			case HeadOfHousehold:
				return fields.HeadOfHousehold;
			case QualifyingWidow:
				return fields.QualifyingWidow;
		}
	}
}
