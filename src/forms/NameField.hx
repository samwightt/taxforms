package forms;

private typedef Typeable = {
	public function setTo(input:String):Void;
}

typedef NameFormFields = {
	FirstAndMiddleInitial:Typeable,
	LastName:Typeable
};

class NameField {
	private var fields:NameFormFields;

	public function new(fields:NameFormFields) {
		this.fields = fields;
	}

	public var firstName(default, set):String = "";
	public var lastName(default, set):String = "";
	public var middleInitial(default, set):String = "";

	private function set_firstName(value) {
		firstName = value;
		updateFirstNameField();
		return firstName;
	}

	private function set_middleInitial(value) {
		middleInitial = value;
		updateFirstNameField();
		return middleInitial;
	}

	private function updateFirstNameField() {
		var str = '$firstName $middleInitial';
		fields.FirstAndMiddleInitial.setTo('$firstName $middleInitial');
	}

	private function set_lastName(value) {
		lastName = value;
		updateLastNameField();
		return lastName;
	}

	private function updateLastNameField() {
		fields.LastName.setTo(lastName);
	}
}
