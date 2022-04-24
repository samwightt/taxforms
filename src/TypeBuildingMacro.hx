import haxe.macro.MacroStringTools;
import haxe.macro.Type.ClassType;
import haxe.macro.Context;
import haxe.macro.Expr;

private class PdfMacroContext {
	public var getPos:() -> Position;
	public var docName:ExprOf<String>;
	public var className:ClassType;
	public var fields:Array<Field>;

	public function new(getPos, docName, className:ClassType, fields:Array<Field>) {
		this.getPos = getPos;
		this.docName = docName;
		this.className = className;
		this.fields = fields;
	}

	public function typePath():TypePath {
		return {
			pack: this.className.pack,
			name: this.className.name,
		};
	}
}

private class Builder {
	private var context:PdfMacroContext;

	public function new(context)
		this.context = context;
}

private class LoadPdfBuilder extends Builder {
	public function makePdfLoadField():Field {
		var pdfLoadFunction = this.makeLoadPdfFunction();

		return {
			name: "load",
			doc: null,
			meta: [],
			access: [AStatic, APublic],
			kind: FFun(pdfLoadFunction),
			pos: context.getPos()
		};
	}

	private function makeLoadPdfFunction():Function {
		var typePath = context.typePath();
		var docName = context.docName;
		var getHaxeResource = macro haxe.Resource.getBytes($docName).getData();
		var getDocument = macro pdf_lib.PDFDocument.load($getHaxeResource).then(document -> new $typePath(document));

		return {
			args: [],
			expr: macro return $getDocument
		};
	}
}

class CheckboxBuilder extends Builder {
	public function adjustCheckboxes() {
		var checkboxFields = this.checkboxFields();
		for (field in checkboxFields) {
			this.wrapCheckboxField(field);
		}
	}

	private function wrapCheckboxField(field:Field) {
		var meta = this.getCheckboxMeta(field);

		// We have checkbox fields!
		if (meta.length > 0) {
			trace(meta);
		}
	}

	private function getCheckboxName(meta:MetadataEntry) {
		var name = meta.params[0];
	}

	private function getCheckboxMeta(field:Field) {
		return field.meta.filter(x -> x.name == "checkbox");
	}

	private function checkboxFields() {
		this.context.fields.filter(x -> x.)
		return this.context.fields.filter(this.hasCheckboxMetadata);
	}

	private function hasCheckboxMetadata(field:Field) {
		return this.getCheckboxMeta(field).length > 0;
	}
}

class TypeBuildingMacro {
	macro static public function build(docName:ExprOf<String>):Array<Field> {
		var fields = Context.getBuildFields();
		var className:ClassType = cast Context.getLocalClass().get();

		var context = new PdfMacroContext(Context.currentPos, docName, className, fields);

		context.fields.push(new LoadPdfBuilder(context).makePdfLoadField());
		new CheckboxBuilder(context).adjustCheckboxes();

		return context.fields;
	}
}
