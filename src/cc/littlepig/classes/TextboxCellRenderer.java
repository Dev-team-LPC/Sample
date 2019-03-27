package cc.littlepig.classes;

import com.itextpdf.forms.PdfAcroForm;
import com.itextpdf.forms.fields.PdfFormField;
import com.itextpdf.forms.fields.PdfTextFormField;
import com.itextpdf.io.font.FontConstants;
import com.itextpdf.kernel.font.*;
import com.itextpdf.kernel.geom.Rectangle;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.renderer.CellRenderer;
import com.itextpdf.layout.renderer.DrawContext;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author cyprian
 */
public class TextboxCellRenderer extends CellRenderer {

    // The name of the check box field
    protected String name;
    protected String value;
    protected PdfFont font;
    protected float fontSize = 10;
    protected int i;

    public TextboxCellRenderer(Cell modelElement, String name, int i, String value, PdfFont font, float fontSize) {
        super(modelElement);
        this.name = name;
        this.i = i;
        this.value = value;
        this.font = font;
        this.fontSize = fontSize;
    }

    public TextboxCellRenderer(Cell modelElement, String name, String value, PdfFont font, float fontSize) {
        super(modelElement);
        this.name = name;
        this.value = value;
        this.font = font;
        this.fontSize = fontSize;
    }

    public TextboxCellRenderer(Cell modelElement, String name, int i, String value) {
        super(modelElement);
        this.name = name;
        this.i = i;
        this.value = value;
    }

    public TextboxCellRenderer(Cell modelElement, String name, String value) {
        super(modelElement);
        this.name = name;
        this.value = value;
    }

    @Override
    public void draw(DrawContext drawContext) {
        try {
            font = PdfFontFactory.createFont(FontConstants.HELVETICA);
        } catch (IOException ex) {
            Logger.getLogger(TextboxCellRenderer.class.getName()).log(Level.SEVERE, null, ex);
        }
        Rectangle position = getOccupiedAreaBBox();
        PdfTextFormField textBox = PdfFormField.createMultilineText(drawContext.getDocument(),
                new Rectangle(position.getX(), position.getY(), position.getWidth(), position.getHeight()), name, value, font, fontSize);
        PdfAcroForm.getAcroForm(drawContext.getDocument(), true).addField(textBox.setVisibility(PdfFormField.VISIBLE));
    }
}

