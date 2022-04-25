import haxe.macro.MacroStringTools;
import haxe.macro.Type.ClassType;
import haxe.macro.Context;
import haxe.macro.Expr;

private class BuildContext {
	public final getPos:() -> Position;

	public function new(getPos) {
		this.getPos = getPos;
	}
}

private class Builder {
	private var context:BuildContext;

	public function new(context)
		this.context = context;
}

private class CheckboxMetadata {
	public final name:String;
	public final fieldName:String;

	public function new(name, fieldName) {
		this.name = name;
		this.fieldName = fieldName;
	}

	public static function fromMetadata(meta:Metadata):Null<CheckboxMetadata> {
		for (entry in meta) {
			var created = CheckboxMetadata.fromMetadataEntry(entry);
			if (created != null)
				return created;
		}
		return null;
	}

	public static function fromMetadataEntry(entry:MetadataEntry):Null<CheckboxMetadata> {
		if (entry.name != "checkbox")
			return null;
		return switch (entry.params) {
			case [{expr: EConst(CString(str, _))}]:
				new CheckboxMetadata(entry.name, str);
			case _:
				null;
		}
	}
}

private class CheckboxField {
	public final metadata:CheckboxMetadata;
	public final field:Field;

	public function new(field:Field, metadata:CheckboxMetadata) {
		this.metadata = metadata;
		this.field = field;
	}

	public static function fromField(field:Field):Null<CheckboxField> {
		return switch (field.kind) {
			case FVar(TPath({name: "Bool"}), _):
				var meta = CheckboxMetadata.fromMetadata(field.meta);
				if (meta == null) {
					null;
				} else {
					new CheckboxField(field, meta);
				}
			case _:
				null;
		}
	}

	public function toFields():Array<Field> {
		trace(this.field);
		this.modifyField();
		return [];
	}

	private function setterField() {}

	private function modifyField() {
		this.field.kind = FProp("default", "set", this.fieldType(), this.fieldExpr());
	}

	private function setterFunction():Function {
		return {
			args: [
				{
					name: ""
				}
			]
		}
	}

	private function fieldExpr() {
		return switch (this.field.kind) {
			case FVar(_, expr):
				expr;
			case _:
				null;
		}
	}

	private function fieldType() {
		return switch (this.field.kind) {
			case FVar(type, _):
				type;
			case _:
				null;
		}
	}
}

private class BuildCheckboxFields extends Builder {
	public function build() {}
}

class PdfFormMacro {
	macro static public function build():Array<Field> {
		var fields = Context.getBuildFields();

		for (field in fields) {
			var checkbox = CheckboxField.fromField(field);
			if (checkbox != null)
				checkbox.toFields();
		}

		return fields;
	}
}
